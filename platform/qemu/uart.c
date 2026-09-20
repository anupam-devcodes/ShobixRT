#include "uart.h"

#include <stdint.h>

#define UART0_BASE_ADDRESS       (0x40004000u)
#define UART_DATA_OFFSET         (0x000u)
#define UART_STATE_OFFSET        (0x004u)
#define UART_CTRL_OFFSET         (0x008u)
#define UART_BAUDDIV_OFFSET      (0x010u)

#define UART_STATE_TXFULL        (1u << 0)
#define UART_CTRL_TX_ENABLE      (1u << 0)

#define UART_BAUDDIV_115200      (217u)

#define UART_REGISTER(offset) \
    (*(volatile uint32_t *)(uintptr_t)(UART0_BASE_ADDRESS + (offset)))

void uart_init(void)
{
    UART_REGISTER(UART_BAUDDIV_OFFSET) = UART_BAUDDIV_115200;
    UART_REGISTER(UART_CTRL_OFFSET) = UART_CTRL_TX_ENABLE;
}

void uart_putc(char character)
{
    while ((UART_REGISTER(UART_STATE_OFFSET) & UART_STATE_TXFULL) != 0u)
    {
    }

    UART_REGISTER(UART_DATA_OFFSET) = (uint32_t)(uint8_t)character;
}
