#include "drivers/vga.h"
#include "drivers/idt.h"
#include "drivers/keyboard.h"
#include "terminal/terminal_logic.h"

void main() 
{
    clear_screen();

    kprint("Echo OS: Starting Kernel...\n");

    initialize_idt();

    kprint("Echo OS: IDT Initialized.\n");

    terminal_new_line();

    asm volatile ("sti"); // enable interrupts

    while (1) 
    {
        asm volatile ("hlt");
    }
}