#pragma once

#include <stdint.h>
#include <stddef.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_COLOR 0x0f
#define VIDEO_ADDRESS 0xb8000

void put_char(char c, uint8_t color);
void delete_char(size_t min_col);

void kprint(char* string);
void clear_screen();
void get_current_row_string(char* buffer);