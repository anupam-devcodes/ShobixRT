TARGET := build/shobixrt
CC := arm-none-eabi-gcc
OBJDUMP := arm-none-eabi-objdump
SIZE := arm-none-eabi-size
QEMU := qemu-system-arm

CFLAGS := -mcpu=cortex-m4 -mthumb -O0 -g3 \
           -ffreestanding -fno-builtin -ffunction-sections \
           -fdata-sections -Wall -Wextra
CPPFLAGS := -Idrivers -Iplatform/qemu -Iarch/cortex_m
LDFLAGS := -T linker/qemu.ld -nostdlib \
           -Wl,--gc-sections -Wl,--build-id=none \
           -Wl,-Map=$(TARGET).map

C_SOURCES := apps/main.c \
             arch/cortex_m/systick.c \
             drivers/console.c \
             platform/qemu/uart.c
ASM_SOURCES := arch/cortex_m/startup.s
C_OBJECTS := $(C_SOURCES:%.c=build/%.o)
ASM_OBJECTS := $(ASM_SOURCES:%.s=build/%.o)
OBJECTS := $(C_OBJECTS) $(ASM_OBJECTS)

.PHONY: all run debug clean disassemble smoke

all: $(TARGET).elf

$(TARGET).elf: $(OBJECTS) linker/qemu.ld
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@
	$(SIZE) $@

build/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

build/%.o: %.s
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

run: $(TARGET).elf
	$(QEMU) -M mps2-an386 -cpu cortex-m4 -display none -monitor none -serial stdio -kernel $<

debug: $(TARGET).elf
	$(QEMU) -M mps2-an386 -cpu cortex-m4 -display none -monitor none -serial stdio -S -gdb tcp::1234 -kernel $<

# Linux/WSL smoke check: it kills only the QEMU process it starts because the
# firmware deliberately remains in its idle loop after its finite boot output.
smoke: $(TARGET).elf
	@rm -f build/uart-output.log
	@$(QEMU) -M mps2-an386 -cpu cortex-m4 -display none -monitor none -serial file:build/uart-output.log -kernel $< & qemu_pid=$$!; sleep 1; kill $$qemu_pid; wait $$qemu_pid 2>/dev/null || true; grep -Fx 'ShobixRT booting...' build/uart-output.log; grep -Fx 'UART initialized.' build/uart-output.log; grep -Fx 'Stage 2: UART output working.' build/uart-output.log

disassemble: $(TARGET).elf
	$(OBJDUMP) -d -S $<

clean:
	rm -rf build
