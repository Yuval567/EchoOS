# EchoOS

![License](https://img.shields.io/badge/license-MIT-green.svg)
![Architecture](https://img.shields.io/badge/arch-x86__64-blue.svg)
![Stage](https://img.shields.io/badge/stage-Bootloader_&_Kernel-lightgrey.svg)


## Overview
**EchoOS** is a 64-bit hobby operating system developed from scratch.  
It features a fully custom **multi-stage bootloader** that transitions from 16-bit real mode → 32-bit protected mode → 64-bit long mode, and a minimal kernel that handles **keyboard input** and **echoes it back** to the VGA screen.

## Boot Process Summary

| Stage | Mode | Purpose |
|--------|------|----------|
| **Stage 1 (MBR)** | 16-bit real mode | Loads the second-stage loader. and . |
| **Stage 2 (Loader)** | 16/32-bit/64-bit (real -> protected -> long) | Enables the A20 gate, initializes GDT, loads the kernel into memory, switches to protected mode, builds paging tables, and enables long mode. |
| **Kernel** | 64-bit long mode | Sets up interrupts, VGA output, and keyboard I/O. Runs the echo loop. |


## Table of Contents

- [Stage One Bootloader](./docs/stage_one.md)
- [Stage Two Bootloader](./docs/stage_two.md)
- [A20 Gate](./docs/A20_gate.md)
- [Disk Operations](./docs/disk.md)  
- [Global Descriptor Table (GDT)](./docs/gdt.md)  
- [Unreal Mode](./docs/unreal_mode.md)  
- [Loading Kernel Into Memory](./docs/kernel_loading.md)
- [Protected Mode](./docs/protected_mode.md)
- [Paging](./docs/paging.md)
- [Long Mode](./docs/long_mode.md)
- [IO Communication](./docs/io.md)  
- [Interrupts](./docs/interrupts.md)
- [Memory Layout](./docs/memory_layout.md)


## Features
- Custom MBR bootloader - no GRUB dependency  
- A20 gate control
- Flat memory model via custom GDT  
- Transition through Unreal, Protected, and Long modes  
- Paging with 2 MiB huge pages  
- VGA text buffer output (MMIO at 0xB8000)  
- Keyboard input via I/O ports (0x60)  
- Full interrupt setup: IDT, ISRs, PIC remapping  
- Works under **QEMU** or real BIOS hardware  


## Build Instructions

### Requirements
- NASM  
- GCC cross-compiler (`x86_64-elf`)  
- Binutils (LD)  
- Make  
- QEMU  

### Build
```bash
make all
```

### Run
```bash
make run
```

## Future Work
- Switch from PIC → APIC/IOAPIC  
- Add timer driver and multitasking  
- Implement heap and paging-based memory manager  
- Introduce filesystem and shell  

## License
Released under the **MIT License**.  
See `LICENSE` for full terms.
