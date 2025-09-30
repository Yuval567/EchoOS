#include "drivers/vga.h"

static size_t cursor_row = 0;
static size_t cursor_col = 0;
static volatile uint16_t* const vga_buffer = (uint16_t*) VIDEO_ADDRESS;


static inline uint16_t vga_entry(char ch, uint8_t color) 
{
    return (uint16_t) ch | ((uint16_t) color << 8);
}

void put_char(char ch, uint8_t color)
{
    if (ch == '\n') 
    {
        cursor_col = 0;
        cursor_row++;
        return;
    }

    if (cursor_row >= VGA_HEIGHT) 
    {
        // scroll (move everything up by one line)
        for (size_t y = 1; y < VGA_HEIGHT; y++) 
        {
            for (size_t x = 0; x < VGA_WIDTH; x++) 
            {
                vga_buffer[(y - 1) * VGA_WIDTH + x] = vga_buffer[y * VGA_WIDTH + x];
            }
        }

        // clear last row
        for (size_t x = 0; x < VGA_WIDTH; x++) 
        {
            vga_buffer[(VGA_HEIGHT - 1) * VGA_WIDTH + x] = vga_entry(' ', color);
        }

        cursor_col = 0;
        cursor_row = VGA_HEIGHT - 1;
    }

    const size_t index = cursor_row * VGA_WIDTH + cursor_col;

    vga_buffer[index] = vga_entry(ch, color);
    cursor_col++;

    if (cursor_col >= VGA_WIDTH) 
    {
        cursor_col = 0;
        cursor_row++;
    }
}

void clear_screen() 
{
    for (size_t i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) 
    {
        vga_buffer[i] = vga_entry(' ', VGA_COLOR);
    }

    cursor_row = 0;
    cursor_col = 0;
}

void print(char* string)
{
    size_t i = 0;
    while (string[i] != '\0') 
    {
        put_char(string[i], VGA_COLOR);
        i++;
    }
}
