# Unreal Mode

## Overview
**Unreal Mode** (also known as *Big Real Mode*) is a hybrid state of the x86 CPU that allows 16‑bit real‑mode code to access memory above 1 MB.  
It combines real mode’s BIOS compatibility with the extended addressing capability of protected mode.

In **EchoOS**, Unreal Mode is used in the second‑stage loader to copy the kernel into high memory (e.g. `0x100000`) before switching fully to protected mode.  
It provides the best of both worlds — 32‑bit memory access and working BIOS interrupts.

## Why Unreal Mode Is Needed
In regular real mode, addresses are computed as `segment * 16 + offset`, giving a maximum of **1 MB (0xFFFFF)**.  
Even if the A20 gate is enabled, the CPU can’t naturally generate addresses above 1 MB because segment limits are fixed at 64 KiB.

Protected mode solves this with 32‑bit descriptors, allowing access up to 4 GiB — but BIOS interrupts stop working in that mode.  
Unreal Mode is the workaround: it enters protected mode only briefly to load 32‑bit segment descriptors, then returns to real mode.  
The CPU keeps the cached segment limits from those descriptors, letting real‑mode code access all 4 GiB of memory while still using BIOS services.

## How It Works
Each segment register (CS, DS, ES, FS, GS, SS) has two parts:
- A **visible selector**, which holds the segment value (e.g., `0x10`).
- A **hidden descriptor cache**, which stores the base, limit, and flags of that segment.

When switching back from protected to real mode, the CPU keeps the hidden descriptor cache.  
This means the 32‑bit base and limit values remain active, even though the processor is back in real mode.

Effectively, the CPU behaves as if it’s still using 32‑bit descriptors for data access, but the instruction set and interrupts remain in real mode.


## Flow
After enabling the A20 gate and loading the GDT, EchoOS performs the following sequence:

1. **Enable Protected Mode temporarily** by setting the PE bit in `CR0`.  
2. **Load 32‑bit data segments** (`DS`, `ES`, `FS`, `GS`, `SS`) from the GDT.  
3. **Return to Real Mode** by clearing the PE bit in `CR0`.  
4. The segment registers now hold 4 GiB data limits, even though the CPU is back in real mode.

This allows the loader to copy the kernel to any memory location below 4 GiB while still using BIOS interrupts for disk reads.

## Why It Works
The CPU doesn’t automatically reload segment limits when CR0.PE is cleared.  
The hidden part of each segment register still holds the 32‑bit base and limit values fetched from the GDT.  
As long as new segment values aren’t loaded afterward, the large limits remain in effect.

This trick works consistently on all x86 CPUs since the 80386, even though it’s not an officially documented mode.

## Benefits
- **Full access to extended memory** without losing BIOS interrupts.  
- **No paging or 32‑bit kernel required** at this stage.  
- **Simple to implement** — just a few instructions are needed.  
- **Perfect for loaders** that need to read large binaries or prepare page tables.

## Limitations
- Once back in real mode, we must **not reload segment registers**, or the cached 32‑bit limits are lost.  
- Code still runs in 16‑bit mode; no 32‑bit instructions can be executed yet.  
- Not officially defined in Intel’s manuals, but universally supported by hardware and emulators.

## When EchoOS Uses Unreal Mode
In EchoOS, Unreal Mode is used specifically to
load the kernel binary into high memory (starting around `0x100000`) while taking advantage of BIOS interrupt.  


## Summary
- Unreal Mode combines real-mode BIOS access with protected-mode memory limits.  
- EchoOS uses it to move data into high memory safely before protected mode.  
- It works by caching 32‑bit segment descriptors and re-entering real mode.  
- Once the kernel is loaded, Unreal Mode is no longer needed.
