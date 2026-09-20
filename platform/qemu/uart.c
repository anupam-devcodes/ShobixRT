#include "uart.h"

#include <stdint.h>

/*
 * QEMU mps2-an386 UART0 is an Arm CMSDK APB UART. QEMU maps serial backend 0
 * to this peripheral, so -serial stdio exposes these writes in the host terminal.
 */
#define UART0_BASE_ADDRESS       (0x40004000u)
#define UART_DATA_OFFSET         (0x000u)
#define UART_STATE_OFFSET        (0x004u)
#define UART_CTRL_OFFSET         (0x008u)
#define UART_BAUDDIV_OFFSET      (0x010u)

#define UART_STATE_TXFULL        (1u << 0)
#define UART_CTRL_TX_ENABLE      (1u << 0)

/* QEMU fixes SYSCLK/PCLK at 25 MHz. 25,000,000 / 217 = 115,207 baud. */
#define UART_BAUDDIV_115200      (217u)

#define UART_REGISTER(offset) \
    (*(volatile uint32_t *)(uintptr_t)(UART0_BASE_ADDRESS + (offset)))

void uart_init(void)
{
    /* BAUDDIV must be valid before TX is enabled; QEMU requires at least 16. */
    UART_REGISTER(UART_BAUDDIV_OFFSET) = UART_BAUDDIV_115200;
    UART_REGISTER(UART_CTRL_OFFSET) = UART_CTRL_TX_ENABLE;
}

void uart_putc(char character)
{
    /* STATE.TXFULL means the one-byte transmit holding register is occupied. */
    while ((UART_REGISTER(UART_STATE_OFFSET) & UART_STATE_TXFULL) != 0u)
    {
        /* Polling intentionally has no timeout before a system timer exists. */
    }

    /* DATA is a 32-bit MMIO register; only the low eight bits carry the byte. */
    UART_REGISTER(UART_DATA_OFFSET) = (uint32_t)(uint8_t)character;
}
