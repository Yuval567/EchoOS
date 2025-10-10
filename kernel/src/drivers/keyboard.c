#include "drivers/keyboard.h"
#include "terminal/terminal_logic.h"

static const char keymap[128] = {
    0, 27, '1','2','3','4','5','6','7','8','9','0','-','=','\b',
    '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n', 0,
    'a','s','d','f','g','h','j','k','l',';','\'','`', 0, '\\',
    'z','x','c','v','b','n','m',',','.','/', 0,'*',0,' ',
};

void keyboard_handler() 
{
    uint8_t scancode = port_byte_in(0x60);

    // only on key press (not release)
    if (!(scancode & 0x80))
    {
        char ch = keymap[scancode];
    
        switch (ch)
        {
            case 0:
            case '\t':
                return;

            case '\b':
                terminal_backspace();
                break;

            case '\n':
                terminal_print_echo();
                terminal_new_line();
                break;

            default:
                put_char(ch, VGA_COLOR);
                break;
        }
    }
}
