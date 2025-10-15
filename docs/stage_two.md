# Stage 2 Loader

## Overview
The **Stage 2 Loader** bridges the gap between the 16-bit BIOS world of Stage 1 and the 64-bit kernel of EchoOS.

It transforms the machine from **real mode** into a fully modern **long mode environment**, setting up the minimal structures required for the kernel to take over.


## High Level Flow

1. **Initialization** – Set up stack and memory workspace.  
2. **A20 Gate** – Ensure memory above 1 MB is accessible.  
3. **GDT Load** – Define flat 32-bit segments to enable protected mode.  
4. **Protected Mode Entry** – CPU now runs in linear 32-bit mode.  
5. **Kernel Load** – BIOS routines read sectors to a low buffer; Unreal Mode copies them into high memory.  
6. **Paging Setup** – Create simple page tables using 2 MiB huge pages.  
7. **Long Mode Switch** – Paging and long-mode are enabled; control jumps to kernel.


## Handoff to the Kernel

After preparation:  
- Paging and long mode are active.  
- Stack and segment registers are valid.  
- Interrupts remain disabled for safety.  
- A **far jump** transfers execution to the 64-bit kernel entry symbol.

From here, the kernel configures its own IDT, drivers, and user I/O logic.

## Summary

The Stage 2 Loader is the core of EchoOS.  
It carries the system from a BIOS controlled 16-bit world into a 64-bit kernel environment by:

- Initializing memory segmentation and paging.  
- Managing CPU mode transitions.
- Delivering a clean, predictable environment to the kernel.  
