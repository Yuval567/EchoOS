# Switching to Protected Mode

## Overview
After loading the kernel into high memory, **EchoOS** switches the CPU into **Protected Mode**.  
Protected Mode unlocks 32-bit addressing, hardware level memory protection, and access to the full 4 GiB address space — all essential for loading paging structures and eventually transitioning into long mode.

## How the Switch Happens
Transitioning to protected mode is a carefully ordered sequence, one mistake here causes an instant triple fault.  
The steps below reflect how **EchoOS** performs this transition.

### Flow
1. **Load the GDT**  
   The loader executes `LGDT [gdt_descriptor]` to install the global descriptor table prepared earlier.  
   This defines the 32-bit code and data segments that will be used once the PE bit is set.

2. **Enable the PE Bit (Protected Mode Enable)**  
   The CPU enters protected mode by setting bit 0 of control register `CR0`.  

3. **Perform a Far Jump**  
   Immediately after enabling protected mode, a **far jump** is executed to reload the code segment and flush the CPU’s instruction pipeline:  
   ```asm
   jmp CODE_SEG32:protected_mode_entry
   ```
   Without this step, the CPU would still interpret instructions as 16-bit real mode code, causing undefined behavior.

4. **Reload Segment Registers**  
   Thel loader reloads all segment registers (`DS`, `ES`, `FS`, `GS`, `SS`) with the 32-bit data selector:  

5. **Set Up the 32-bit Stack**  
   The loader sets up a stack at a safe 32-bit address
   From this point on, the CPU executes fully in 32-bit mode.

## The Role of the Far Jump
The far jump (`jmp selector:offset`) is critical because it forces the CPU to reload the **CS register** from the new GDT.  
When the PE bit is set, the current instruction pointer still references a 16-bit segment.  
Without a far jump, instructions would continue being decoded incorrectly leading to immediate crashes.  
By jumping into a 32-bit code segment, the CPU correctly switches to 32-bit instruction decoding.

## After Entering Protected Mode
Once EchoOS is in protected mode:
- BIOS interrupts are no longer accessible.  
- Memory can be addressed anywhere in the 4 GiB space defined by the GDT.  

## Summary
- Protected mode unlocks 32-bit instructions and flat 4 GiB memory access.  
- The loader switches to protected mode after finishing all BIOS work.