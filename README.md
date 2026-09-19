# MiniRTOS

MiniRTOS is an educational preemptive real-time operating system for ARM Cortex-M.
The project is being built from first principles to understand startup code, linker
scripts, exceptions, task management, scheduling, context switching, synchronization,
memory management, fault diagnosis, and profiling.

## Project goal

The first target is a bare-metal Cortex-M system running under QEMU on Windows 11
through WSL2 Ubuntu. The same hardware-independent kernel will later be ported to an
STM32 Cortex-M microcontroller.

This project does not use FreeRTOS, Zephyr, or another existing RTOS implementation.
External documentation is used only to understand the ARM architecture, toolchain,
QEMU behavior, and STM32 hardware.

## Architecture

```text
                 +----------------------+
                 |      MiniRTOS         |
                 | hardware-independent |
                 +----------+-----------+
                            |
              +-------------+-------------+
              |                           |
        +-----v------+              +-----v------+
        | platform/  |              | platform/  |
        | qemu       |              | stm32      |
        +------------+              +------------+
              virtual MCU                 real MCU

                 arch/cortex_m
          ARM Cortex-M-specific support
```

The `kernel/` directory must not directly depend on STM32-specific registers.
Platform-specific drivers belong below `platform/`, while Cortex-M exception and
context-switching mechanisms belong below `arch/cortex_m/`.

## Planned stages

0. Environment setup and project skeleton
1. Bare-metal ARM hello world in QEMU
2. UART output driver
3. Vector table, exceptions, and SysTick
4. Task abstraction and TCB
5. Separate task stacks
6. Cooperative round-robin scheduler
7. Cortex-M context switching
8. Preemptive scheduling
9. Task states
10. Delay and software timers
11. Semaphores
12. Mutexes
13. Message queues / IPC
14. Memory management
15. Fault diagnostics
16. Runtime profiler
17. Python monitor
18. Cleanup, tests, and documentation
19. STM32 port

## Current status

- [x] Stage 0: repository skeleton and documentation
- [ ] Stage 1: bare-metal ARM hello world

Do not begin Stage 1 until explicitly instructed with: `Start Stage 1.`

## Documentation

- `docs/architecture.md` - system boundaries and planned module responsibilities
- `docs/design-decisions.md` - decisions and alternatives considered
- `docs/stages/` - repository-local notes for each development stage
- Obsidian vault - detailed learning notes and interview preparation

## Stage 1 preview

Stage 1 will add only the minimum bare-metal program needed to boot a Cortex-M image
in QEMU: a vector table, reset handler, linker script, minimal `main.c`, and Makefile
commands for building and running it. UART, SysTick, tasks, scheduling, and context
switching are intentionally out of scope for Stage 1.
