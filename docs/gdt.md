# Global Descriptor Table (GDT)

## Overview
The **Global Descriptor Table (GDT)** defines how the CPU interprets memory segments in protected and long mode. 
It is one of the first data structures that an operating system sets up after enabling the A20 gate. 
In **EchoOS**, the GDT is prepared early in the second-stage loader to establish a flat memory model — 
a simple configuration where all segments cover the entire 4 GiB address space, starting at address 0.

Without the GDT, the CPU cannot safely switch to protected mode, as there would be no valid segment descriptors 
for code and data. Once the GDT is installed, the loader can enable protected mode and later transition to long mode.

## What the GDT Does
The GDT tells the CPU how to translate a **segment selector** (like a code or data segment) into a memory range. 
Each entry in the GDT is called a **descriptor**, which defines:
- The base address of the segment  
- Its size (limit)  
- Access permissions (readable, writable, executable, etc.)  
- Additional flags (granularity, operand size, long mode)

When the CPU runs in real mode, segmentation is fixed — each segment register simply shifts the base address by 16 bytes.  
In protected mode, however, the CPU reads the descriptor from the GDT and uses it to compute the *linear address* as:

```
linear_address = segment_base + offset
```

If paging is enabled later, this linear address is then translated into a *physical address* using page tables.


## Why EchoOS Needs It
EchoOS uses the GDT for several key reasons:
1. **Protected Mode Entry** — The CPU requires a valid GDT to execute the far jump that activates protected mode.  
2. **Unreal Mode** — EchoOS temporarily enables protected mode to load 32‑bit segment limits, then switches back to real mode.  
3. **Long Mode Transition** — Even in 64‑bit mode, a minimal GDT is required for code and data segment selectors.

The GDT ensures the system has stable and predictable segment behavior before paging and long mode take over.


## The Flat Memory Model
EchoOS uses a **flat segmentation model**, where:
- All segment bases are `0x00000000`
- Segment limits are set to the maximum (`0xFFFFF` with 4 KiB granularity = 4 GiB)
- This makes all segments overlap and cover the entire linear address space

This simplifies memory management and makes segmentation effectively invisible — 
the CPU behaves as if there’s only one continuous address space, which is exactly what we want before paging is enabled.


## Implementation in EchoOS

### Layout
The GDT in `bootloader/stage_2/gdt.asm` defines the following descriptors:

| Index | Selector | Type | Description |
|-------:|----------|------|-------------|
| 0 | 0x00 | Null | Required by CPU |
| 1 | 0x08 | 32‑bit Code | Flat segment for protected/unreal mode |
| 2 | 0x10 | 32‑bit Data | Flat data segment |
| 3 | 0x18 | 64‑bit Code | Used after entering long mode |
| 4 | 0x20 | 64‑bit Data | Data segment for long mode |

### Code Snippet
```asm
; 32-bit code segment
gdt_code32:
    dw 0xFFFF        ; Limit (bits 0–15)
    dw 0x0000        ; Base (bits 0–15)
    db 0x00          ; Base (bits 16–23)
    db 10011010b     ; Access: Present, Ring 0, Code Segment
    db 11001111b     ; Flags: 4 KiB granularity, 32-bit default
    db 0x00          ; Base (bits 24–31)

; 32-bit data segment
gdt_data32:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b     ; Access: Present, Ring 0, Data Segment
    db 11001111b     ; Flags: 4 KiB granularity, 32-bit
    db 0x00
```

These two descriptors create a 4 GiB flat model for 32‑bit mode.

### GDT Descriptor (GDTR)
The GDT itself is described to the CPU by a 6‑byte structure called the **GDTR**, which contains:
- 2 bytes: size of the GDT minus 1  
- 4 bytes: address of the GDT in memory

Example from `gdt.asm`:
```asm
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size of GDT
    dq gdt_start                ; Address of GDT
```

This structure is loaded into the CPU using the `lgdt` instruction:
```asm
lgdt [gdt_descriptor]
```

## Memory Access and Segmentation

### Real Mode vs Protected Mode
| Mode | Base | Limit | Description |
|------|------|--------|-------------|
| Real Mode | `segment * 16` | 64 KiB | Segment base fixed by register value |
| Protected Mode | From GDT | From GDT | Base and limit defined by descriptor |
| Long Mode | Ignored (mostly) | N/A | Flat model enforced by hardware |

In protected mode, when the CPU loads a segment selector (e.g., `mov ds, ax`), it fetches the corresponding descriptor from the GDT and caches it internally. 
This cached base and limit are then used for all memory accesses using that segment.

### Why Limits Matter
The **limit** field controls the maximum offset allowed within the segment. 
Accessing beyond the limit raises a *General Protection Fault (#GP)*. 
In a flat model, the limit is set to its maximum, so all addresses up to 4 GiB are valid.

### Flags Summary
| Flag | Purpose |
|------|----------|
| P (Present) | Must be 1 for valid segments |
| DPL (Descriptor Privilege Level) | Privilege level (0 = kernel) |
| S (Descriptor Type) | 1 for code/data, 0 for system segments |
| E (Executable) | 1 for code segments |
| RW (Readable/Writable) | Controls data/code access |
| G (Granularity) | 1 = 4 KiB blocks |
| D/B | 1 = 32‑bit segment |
| L | 1 = 64‑bit code segment |

## Transition to Long Mode
When the loader prepares for long mode, the 64‑bit code and data descriptors are also defined in the same GDT.  
In long mode, segmentation is mostly disabled — the CPU ignores base and limit fields, 
but still requires valid descriptors to reference during the transition.

The long‑mode code descriptor must have the **L-bit** set, indicating 64‑bit operation, and the **D-bit** cleared.

Example:
```asm
; 64-bit code segment
gdt_code64:
    dw 0x0000
    dw 0x0000
    db 0x00
    db 10011010b     ; Present, Ring 0, Executable
    db 00100000b     ; L=1 (64-bit), D=0
    db 0x00
```

## Summary
- The GDT defines how segment selectors map to memory.  
- EchoOS uses a flat segmentation model for simplicity.  
- It enables a safe transition from real mode to protected and then long mode.  
- Even in 64‑bit mode, a minimal GDT is still required for code and data segments.  
- Without a valid GDT, protected mode cannot function properly.
