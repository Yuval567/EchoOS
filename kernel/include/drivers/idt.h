#pragma once

#include <stdint.h>
#include <stddef.h>

#define IDT_SIZE 256
#define IDT_TYPE_ATTR 0x8E
#define IDT_CODE_SEGMENT 0x18

struct __attribute__((packed)) idt_entry 
{
    uint16_t offset_low;
    uint16_t selector;
    uint8_t ist;
    uint8_t type_attr;
    uint16_t offset_mid;
    uint32_t offset_high;
    uint32_t zero;
};

struct __attribute__((packed)) idt_ptr 
{
    uint16_t limit;
    uint64_t base;
};

extern void isr_stub();

void set_idt_entry(size_t n, uint64_t handler);
void initialize_idt();