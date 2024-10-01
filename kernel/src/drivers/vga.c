#include "drivers/vga.h"

void set_char_at_video_memory(char character, int offset) 
{
    unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;
    vidmem[offset] = character;
    vidmem[offset + 1] = WHITE_ON_BLACK;
}

void clear_screen()
{
    for (int i = 0; i < MAX_COLS * MAX_ROWS; ++i) 
    {
        set_char_at_video_memory('\0', i * 2);
    }
}

void print_string(char* string)
{
    int i = 0;
    while (string[i] != 0)
    {
        set_char_at_video_memory(string[i], i * 2);
        i++;
    }
}
