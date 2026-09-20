#ifndef SHOBIXRT_ARCH_CORTEX_M_SYSTICK_H
#define SHOBIXRT_ARCH_CORTEX_M_SYSTICK_H

#include <stdint.h>

void systick_init(void);
uint32_t systick_get_ticks(void);
void SysTick_Handler(void);

#endif
