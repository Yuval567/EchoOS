#include "drivers/vga.h"

void main() 
{
    clear_screen();
    char message[] = "Hello Kernel!";
    print_string(message);
}