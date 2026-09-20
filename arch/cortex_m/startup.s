.syntax unified
.cpu cortex-m4
.thumb

.global vector_table
.global Reset_Handler
.global Default_Handler
.extern _estack
.extern _sidata
.extern _sdata
.extern _edata
.extern _sbss
.extern _ebss
.extern main

.section .isr_vector,"a",%progbits
.align 7
vector_table:
    .word _estack
    .word Reset_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word Default_Handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word Default_Handler
    .word Default_Handler
    .word 0
    .word Default_Handler
    .word Default_Handler

.section .text.Reset_Handler,"ax",%progbits
.thumb_func
Reset_Handler:
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata

copy_data:
    cmp r1, r2
    bcs clear_bss
    ldr r3, [r0], #4
    str r3, [r1], #4
    b copy_data

clear_bss:
    ldr r1, =_sbss
    ldr r2, =_ebss
    movs r3, #0

clear_bss_loop:
    cmp r1, r2
    bcs call_main
    str r3, [r1], #4
    b clear_bss_loop

call_main:
    bl main

halt:
    b halt

.section .text.Default_Handler,"ax",%progbits
.thumb_func
Default_Handler:
    b Default_Handler
