#pragma once

#include <stdint.h>
#include <stddef.h>

#define IDT_SIZE 256
#define IDT_TYPE_ATTR 0x8E
#define IDT_CODE_SEGMENT 0x18

/**
 * @note This structure is packed to match the hardware-defined layout.
 */
struct __attribute__((packed)) idt_entry 
{
    uint16_t offset_low;   // Lower 16 bits of handler function address
    uint16_t selector;     // Code segment selector in GDT
    uint8_t  ist;          // Interrupt Stack Table offset (usually 0)
    uint8_t  type_attr;    // Type and attributes (e.g., interrupt gate)
    uint16_t offset_mid;   // Middle 16 bits of handler function address
    uint32_t offset_high;  // Higher 32 bits of handler function address
    uint32_t zero;         // Reserved, set to 0
};

/**
 * @note This structure is packed to match the hardware-defined layout.
 */
struct __attribute__((packed)) idt_ptr 
{
    uint16_t limit;   // Size of the IDT in bytes - 1
    uint64_t base;    // Address of the first element in the IDT
};

/**
 * @brief Sets an entry in the IDT.
 * 
 * @param n Index of the IDT entry to set.
 * @param handler Address of the interrupt handler function.
 */
void set_idt_entry(size_t n, uint64_t handler);

/**
 * @brief Initializes the IDT, remaps the PIC, and loads the IDT.
 * 
 * Installs default handlers and the keyboard handler.
 */
void initialize_idt();