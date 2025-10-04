#pragma once

#include <stdint.h>

/**
 * @brief Reads a byte from the specified IO port.
 * 
 * @param port The IO port address to read from.
 * @return The byte read from the port.
 */
uint8_t port_byte_in(uint16_t port);

/**
 * @brief Writes a byte to the specified IO port.
 * 
 * @param port The IO port address to write to.
 * @param data The byte to write to the port.
 */
void port_byte_out(uint16_t port, uint8_t data);