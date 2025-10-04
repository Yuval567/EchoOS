#pragma once

#include <stdint.h>
#include <stddef.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_COLOR 0x0f
#define VGA_VIDEO_ADDRESS 0xb8000

/**
 * @brief Writes a character at the current cursor position with the given color.
 *  Handles newlines and scrolling.
 * 
 * @param c Character to write.
 * @param color VGA color attribute.
 */
void put_char(char c, uint8_t color);

/**
 * @brief Deletes the character before the cursor, unless at min_col.
 * 
 * @param min_col Minimum column to stop deleting at.
 */
void delete_char(size_t min_col);

/**
 * @brief Prints a null-terminated string to the VGA text buffer.
 * 
 * @param string The string to print.
 */
void kprint(char* string);

/**
 * @brief Clears the entire VGA text buffer and resets the cursor.
 */
void clear_screen();

/**
 * @brief Copies the characters from the current row into the provided buffer.
 * 
 * @param buffer Buffer to store the row string. Must be at least VGA_WIDTH+1 bytes.
 */
void get_current_row_string(char* buffer);