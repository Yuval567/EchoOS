# Loading the Kernel into Memory

## Overview
One of the clever techniques used in **EchoOS** is how the second stage loader reads the kernel from disk into high‑memory.  
The BIOS disk services (`INT 13h`) are limited to **16‑bit addressing**, meaning they can only load data into the first 1 MB of RAM.  
However, the kernel in EchoOS needs to be placed at a higher address (for example `0x100000`).

To overcome this limitation, the loader takes the following approach while running in **Unreal Mode**:
1. **Read each sector** from disk into a **temporary low‑memory buffer** that BIOS can access.
2. **Manually copy** the data from that buffer into the kernel’s final high‑memory address.

This approach keeps compatibility with BIOS and still allows EchoOS to load the kernel exactly where it needs to be.

## Loading Sequence

1. After enabling the A20 line and setting up the GDT, the loader switches into Unreal Mode to gain access to the full 32-bit address space.

2. It then prepares the disk read parameters — drive number and sector location (using CHS or LBA addressing).

3. A BIOS call (INT 13h, function 02h) is issued to read a single sector from disk into a low-memory buffer accessible by the BIOS.

4. The loader manually copies that sector from the temporary buffer to the target address in high memory.

5. The process repeats, advancing the sector index and destination address until the entire kernel is fully loaded into memory.

## Why This Works
- **Unreal Mode** gives 32‑bit segment limits, so high addresses like `0x100000` are valid.  
- **BIOS** still thinks it’s working in normal real mode and happily writes to the low buffer.  


## Relation to Unreal Mode
The copying occurs while Unreal Mode is active, meaning data segments have 4 GiB limits.  
Without Unreal Mode, writing beyond 1 MB would cause a wraparound and corrupt the lower memory area.

Unreal Mode allows safe access to both the BIOS and high‑memory at the same time — 
the key requirement for this two‑step loading method.

## Summary
- BIOS can only read below 1 MB — EchoOS works around it by loading sectors to low memory first.  
- The result is a clean, reliable kernel load process that keeps BIOS compatibility.

