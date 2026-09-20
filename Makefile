TARGET := build/shobixrt
CC := arm-none-eabi-gcc
OBJDUMP := arm-none-eabi-objdump
SIZE := arm-none-eabi-size
QEMU := qemu-system-arm

CFLAGS := -mcpu=cortex-m4 -mthumb -O0 -g3 \
           -ffreestanding -fno-builtin -ffunction-sections \
           -fdata-sections -Wall -Wextra
LDFLAGS := -T linker/qemu.ld -nostdlib \
           -Wl,--gc-sections -Wl,--build-id=none \
           -Wl,-Map=$(TARGET).map

C_SOURCES := apps/main.c
ASM_SOURCES := arch/cortex_m/startup.s
C_OBJECTS := $(C_SOURCES:%.c=build/%.o)
ASM_OBJECTS := $(ASM_SOURCES:%.s=build/%.o)
OBJECTS := $(C_OBJECTS) $(ASM_OBJECTS)

.PHONY: all run debug clean disassemble

all: $(TARGET).elf

$(TARGET).elf: $(OBJECTS) linker/qemu.ld
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@
	$(SIZE) $@

build/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

build/%.o: %.s
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET).elf
	$(QEMU) -M mps2-an386 -cpu cortex-m4 -nographic -monitor none -serial none -kernel $<

debug: $(TARGET).elf
	$(QEMU) -M mps2-an386 -cpu cortex-m4 -nographic -monitor none -serial none -S -gdb tcp::1234 -kernel $<

disassemble: $(TARGET).elf
	$(OBJDUMP) -d -S $<

clean:
	rm -rf build
