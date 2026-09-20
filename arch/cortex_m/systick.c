#include "systick.h"

#define SYSTICK_CTRL_ADDRESS       (0xE000E010u)
#define SYSTICK_LOAD_ADDRESS       (0xE000E014u)
#define SYSTICK_VAL_ADDRESS        (0xE000E018u)

#define SYSTICK_CTRL_ENABLE        (1u << 0)
#define SYSTICK_CTRL_TICKINT       (1u << 1)
#define SYSTICK_CTRL_CLKSOURCE     (1u << 2)

#define SYSTICK_CLOCK_HZ           (25000000u)
#define SYSTICK_TICK_HZ            (1000u)
#define SYSTICK_RELOAD_VALUE       ((SYSTICK_CLOCK_HZ / SYSTICK_TICK_HZ) - 1u)

#define SYSTICK_REGISTER(address) \
    (*(volatile uint32_t *)(uintptr_t)(address))

static volatile uint32_t systick_ticks;

void systick_init(void)
{
    SYSTICK_REGISTER(SYSTICK_CTRL_ADDRESS) = 0u;
    SYSTICK_REGISTER(SYSTICK_LOAD_ADDRESS) = SYSTICK_RELOAD_VALUE;
    SYSTICK_REGISTER(SYSTICK_VAL_ADDRESS) = 0u;
    SYSTICK_REGISTER(SYSTICK_CTRL_ADDRESS) = SYSTICK_CTRL_ENABLE |
                                             SYSTICK_CTRL_TICKINT |
                                             SYSTICK_CTRL_CLKSOURCE;
}

uint32_t systick_get_ticks(void)
{
    return systick_ticks;
}

void SysTick_Handler(void)
{
    ++systick_ticks;
}
