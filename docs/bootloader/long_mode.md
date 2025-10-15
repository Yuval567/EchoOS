# Transition to Long Mode

## Overview
**Long Mode** is the 64-bit operating mode of modern x86-64 processors. It expands the processor’s registers and address space while simplifying segmentation.  
For **EchoOS**, entering long mode is the final step in the bootloader — transferring control to the 64-bit kernel with full access to memory and hardware.


## What Is Long Mode?
Long Mode enables 64-bit instruction decoding and addressing. It consists of two internal sub‑modes:
- **64-bit mode** – where 64-bit programs execute using 64-bit registers and flat addressing.  
- **Compatibility mode** – allows execution of legacy 16-bit or 32-bit protected‑mode programs within a 64-bit kernel.

When active, segmentation is mostly disabled and all memory access happens through paging, using a 4‑level hierarchy.


## Prerequisites for Entering Long Mode

Before enabling long mode, the CPU and memory must be fully prepared. EchoOS ensures all of the following conditions are met:

| Step | Description |
|------|--------------|
| **A20 Gate Enabled** | Allows addressing above 1 MB. |
| **GDT Loaded** | Contains 64-bit code and data segment descriptors. |
| **Paging Structures Built** | PML4, PDPT, PD tables created (with 2 MiB huge pages). |
| **CR3 Loaded** | Points to the PML4 base address. |
| **CR4.PAE = 1** | Enables PAE paging format. |
| **IA32_EFER.LME = 1** | Enables long mode capability (via MSR 0xC0000080). |
| **CR0.PG = 1** | Globally enables paging and activates long mode. |

Once these steps are complete, the CPU is ready to execute 64‑bit code.


## Control Bits Overview

| Register | Bit | Purpose |
|-----------|-----|----------|
| **CR0.PG** | 31 | Enables paging globally. |
| **CR4.PAE**| 5 | Enables PAE paging format (mandatory for 64‑bit). |
| **IA32_EFER.LME** | 8 | Long Mode Enable bit (activates support). |
| **IA32_EFER.LMA** | 10 | Long Mode Active (read‑only, set when long mode is active). |


## The Transition in EchoOS

EchoOS performs these actions in sequence at the end of its loader:

1. **Enable PAE** – `CR4.PAE` is set to prepare for 64-bit page formats.  
2. **Load Page Tables** – `CR3` is loaded with the PML4 physical address.  
3. **Set Long Mode Enable** – `LME` bit is set in `IA32_EFER`.  
4. **Enable Paging** – `CR0.PG` is set to 1, enabling paging and activating long mode.  
5. **Far Jump to 64-bit Segment** – The CPU performs a far jump to the 64-bit code descriptor in the GDT:  
   ```asm
   jmp CODE_SEG64:entry64
   ```

> **Note:** This far jump is crucial — it reloads the CS register and forces the CPU to begin decoding instructions as 64-bit.


## Summary

- Long mode enables 64-bit execution with flat memory and full register width.  
- EchoOS activates it after completing paging setup.  
- Once active, segmentation is flat, paging is mandatory, and the 64-bit kernel begins execution.  
- This marks the successful completion of the EchoOS bootloader phase.
