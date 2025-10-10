# Stage 1 Bootloader

## Overview

The **Stage 1 bootloader** is the first code executed by the BIOS from the Master Boot Record (MBR) at boot time. Its main job is to set up a minimal environment and load the Stage 2 bootloader into memory, then transfer control to it. This stage is limited to 512 bytes, including the MBR signature.

## Key Responsibilities

- **Segment Initialization:** Sets up the `ds` and `es` segment registers for correct memory access in real mode.
- **Status Logging:** Uses simple routines to print status and error messages to the screen.
- **Stage 2 Loading:** Initiates the process of loading the Stage 2 bootloader from disk (details documented separately).
- **Control Transfer:** Jumps to the loaded Stage 2 bootloader code.
- **Error Handling:** If loading or execution fails, prints an error message and halts the system.

## Implementation Details

- **Entry Point:** The bootloader starts at address `0x7c00`, as required by the BIOS.
- **Logging:** Uses macros and log strings to display status and error messages.
- **MBR Signature:** The last two bytes are `0xAA55`, marking the sector as bootable.
- **Padding:** The code is padded with zeros to ensure it is exactly 512 bytes.

## Constraints

- **Size:** Must fit within 512 bytes, including the boot signature.
- **Environment:** Runs in 16-bit real mode, with BIOS services available.
