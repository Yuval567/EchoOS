#pragma once

#include <stdint.h>
#include <stddef.h>

/**
 * @brief The prompt string displayed at the start of each terminal line.
 */
#define TERMINAL_PROMPT "> "

/**
 * @brief The length of the terminal prompt string.
 */
#define TERMINAL_PROMPT_LENGTH 2

/**
 * @brief Moves the cursor to a new line and prints the terminal prompt.
 */
void terminal_new_line();

/**
 * @brief Deletes the character before the cursor, but not past the prompt.
 */
void terminal_backspace();

/**
 * @brief Prints an echo message with the user's input from the current line.
 */
void terminal_print_echo();