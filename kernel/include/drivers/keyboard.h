#pragma once

#include <stdint.h>

#include "vga.h"
#include "io_ports.h"

extern void isr_keyboard();

void keyboard_handler();