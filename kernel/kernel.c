#include "drivers/vga.h"

void main() 
{
    clear_screen();

    for (size_t i = 0; i < 25; i++)
    {
        print("Hello Kernel!\n");
    }
    
    print("Kernel Initialized.\n");
}