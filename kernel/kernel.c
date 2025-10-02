#include "drivers/vga.h"
#include "drivers/idt.h"
#include "drivers/keyboard.h"

void main() 
{
    clear_screen();

    print("Kernel Initialized.\n");

    initialize_idt();

    asm volatile ("sti"); // enable interrupts

    while (1) 
    {
        asm volatile ("hlt");
    }
}