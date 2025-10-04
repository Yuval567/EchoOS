#pragma once

#include <stdint.h>
#include "vga.h"
#include "io_ports.h"

/**
 * @brief Keyboard interrupt service routine (assembly linkage).
 */
extern void isr_keyboard();

/**
 * @brief Handles keyboard input from the hardware.
 * 
 * Reads the scancode from the keyboard port, translates it to an ASCII character,
 * and processes it (prints to screen, handles backspace, newlines, etc.).
 * 
 * @note Should be called by the keyboard interrupt handler.
 */
void keyboard_handler();