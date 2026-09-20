#include "console.h"
#include "uart.h"

int main(void)
{
    uart_init();

    console_write("ShobixRT booting...\n");
    console_write("UART initialized.\n");
    console_write("Stage 2: UART output working.\n");

    while (1)
    {
        __asm volatile ("wfi");
    }
}
