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

/**
 * @brief Remaps the Programmable Interrupt Controller (PIC) to avoid conflicts with CPU exceptions.
 *
 * By default, the PIC maps IRQs 0-15 to interrupt vectors 0x08-0x0F and 0x70-0x77,
 * which overlap with CPU exception vectors. This function remaps the PIC so that
 * IRQs 0-15 are mapped to vectors 0x20-0x2F (32-47), avoiding conflicts.
 *
 * The remapping process involves sending initialization and configuration commands
 * to both the master and slave PICs via their I/O ports.
 */
void pic_remap(void) 
{
    // Start initialization sequence (cascade mode)
    port_byte_out(0x20, 0x11); // Master PIC command port
    port_byte_out(0xA0, 0x11); // Slave PIC command port

    // Set vector offset for master and slave PICs
    port_byte_out(0x21, 0x20); // Master PIC data port: IRQs start at 0x20 (32)
    port_byte_out(0xA1, 0x28); // Slave PIC data port: IRQs start at 0x28 (40)

    // Tell Master PIC there is a slave PIC at IRQ2 (0000 0100)
    port_byte_out(0x21, 0x04);

    // Tell Slave PIC its cascade identity (0000 0010)
    port_byte_out(0xA1, 0x02);

    // Set both PICs to 8086/88 (MCS-80/85) mode
    port_byte_out(0x21, 0x01);
    port_byte_out(0xA1, 0x01);

    // Restore saved masks (here, unmask all IRQs)
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