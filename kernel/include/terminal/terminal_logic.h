#pragma once

#include <stdint.h>
#include <stddef.h>

#define TERMINAL_PROMPT "> "
#define TERMINAL_PROMPT_LENGTH 2

void terminal_new_line();
void terminal_backspace();
void terminal_print_echo();