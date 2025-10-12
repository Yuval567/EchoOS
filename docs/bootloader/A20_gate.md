# A20 Gate

## Overview
The A20 line is the 21st address line on the x86 processor. In early IBM PC systems, this line was intentionally disabled to maintain compatibility with 8086-based software, which could only address up to 1 MB of memory. When A20 is disabled, the CPU effectively wraps addresses beyond 1 MB back to the beginning of memory — a behavior that can break any modern program using addresses above 1 MB.

For a modern operating system loader like **EchoOS**, this limitation must be removed before switching to protected mode or accessing higher memory addresses. Enabling the A20 line ensures that memory above 1 MB is accessible normally.

## Why It Exists
Originally, software written for the Intel 8086 expected address wrapping at 1 MB because that CPU only had 20 address lines (A0–A19). When IBM introduced the 80286 with a 24‑bit address bus, old programs started behaving incorrectly because the new CPU no longer wrapped around.

To fix that, IBM added a “gate” to control the 21st line (A20). This allowed the system to emulate 8086 behavior when necessary. Over time, this gate became a permanent part of the PC architecture — known as the **A20 Gate**.

## Enabling A20 in EchoOS
EchoOS enables the A20 line at the very beginning of the second‑stage loader, using **port 0x92**, also known as the **Fast A20** method. This is the simplest and most reliable option on most modern hardware and emulators.

### Implementation
In `bootloader/stage_2/protected_mode.asm`, the function `enable_A20_gate` is responsible for this step.

```asm
[bits 16]
enable_A20_gate:
    in   al, 0x92        ; Read System Control Port A
    or   al, 00000010b   ; Set bit 1 to enable A20
    out  0x92, al        ; Write back to the port
    ret
```

### How It Works
The I/O port `0x92` controls several hardware features, including the A20 line and system reset. Bit 1 corresponds to A20 — when it’s set, the A20 gate is opened, allowing access to memory above 1 MB.  
- **Bit 0**: System reset (writing 1 resets the CPU)  
- **Bit 1**: A20 enable (1 = enabled)

By setting bit 1, EchoOS ensures the CPU can read and write beyond the 1 MB boundary. This must happen before enabling protected mode or loading the kernel to high memory.

### Other Methods (Not Used in EchoOS)
Although port 0x92 is fast and simple, older or more complex systems might not support it. In those cases, there are two traditional alternatives:
1. **Keyboard controller (8042) method** – Uses ports `0x60` and `0x64` to send specific commands to the keyboard controller that toggle the A20 line. It’s reliable but slow and sometimes buggy under emulators.
2. **BIOS interrupt (INT 15h, AX=2401h)** – A firmware call that enables A20 through BIOS routines. It’s slower and not always available in minimal environments.

### In Context
Without A20, memory access above 1 MB would wrap around, causing unpredictable behavior when switching modes or loading the kernel at high memory addresses like `0x100000`.

## Summary
- The A20 gate removes the 1 MB address wrap‑around.  
- EchoOS enables A20 using **port 0x92**, a quick and reliable approach.  
- This step is required before entering protected mode or accessing high memory.  
- Other methods exist but are slower or less reliable.
