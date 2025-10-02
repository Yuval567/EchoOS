#include "drivers/idt.h"
#include "drivers/io_ports.h"
#include "drivers/keyboard.h"

extern void isr_stub();

struct idt_entry idt_vector[IDT_SIZE];

void set_idt_entry(size_t n, uint64_t handler) 
{
    idt_vector[n].offset_low  = handler & 0xFFFF;
    idt_vector[n].selector    = IDT_CODE_SEGMENT;   // code segment
    idt_vector[n].ist         = 0;
    idt_vector[n].type_attr   = IDT_TYPE_ATTR;      // interrupt gate
    idt_vector[n].offset_mid  = (handler >> 16) & 0xFFFF;
    idt_vector[n].offset_high = (handler >> 32) & 0xFFFFFFFF;
    idt_vector[n].zero        = 0;
}

void load_idt() 
{
    struct idt_ptr idtp;
    idtp.limit = sizeof(idt_vector) - 1;
    idtp.base  = (uint64_t) idt_vector;
    
    asm volatile ("lidt %0" : : "m"(idtp));
}

void pic_remap(void) 
{
    port_byte_out(0x20, 0x11);
    port_byte_out(0xA0, 0x11);
    port_byte_out(0x21, 0x20); // Master PIC vector offset
    port_byte_out(0xA1, 0x28); // Slave PIC vector offset
    port_byte_out(0x21, 0x04);
    port_byte_out(0xA1, 0x02);
    port_byte_out(0x21, 0x01);
    port_byte_out(0xA1, 0x01);
    port_byte_out(0x21, 0x0);
    port_byte_out(0xA1, 0x0);
}

void initialize_idt() 
{
    pic_remap();

    // install same stub for other IRQs so enabling STI is safe
    for (size_t i = 0x20; i < 0x30; i++) 
    {
        set_idt_entry(i, (uint64_t) isr_stub);
    }
    
    set_idt_entry(0x21, (uint64_t) isr_keyboard);

    load_idt();
}