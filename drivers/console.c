#include "console.h"

#include "uart.h"

void console_write(const char *text)
{
    if (text == 0)
    {
        return;
    }

    while (*text != '\0')
    {
        /* Newline conversion belongs here, so callers always use '\n'. */
        if (*text == '\n')
        {
            uart_putc('\r');
        }

        uart_putc(*text);
        ++text;
    }
}
