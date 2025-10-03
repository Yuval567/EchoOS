#include "terminal/terminal_logic.h"
#include "drivers/vga.h"

void terminal_new_line() 
{
    kprint("\n");
    kprint(TERMINAL_PROMPT);
}

void terminal_backspace() 
{
    delete_char(TERMINAL_PROMPT_LENGTH);
}

void terminal_print_echo()
{
    char current_row_string[VGA_WIDTH + 1];
    get_current_row_string(current_row_string);

    kprint("\n");

    char* skip_prompt = current_row_string + TERMINAL_PROMPT_LENGTH;

    kprint("You typed: ");
    kprint(skip_prompt);
}