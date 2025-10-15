# IO Ports and Memory-Mapped IO

## Overview
Hardware devices on x86 are controlled in two main ways: **Port‑Mapped I/O (PMIO)** and **Memory‑Mapped I/O (MMIO)**.

**EchoOS** uses both models in different parts of the kernel: PMIO for classic PC devices (like the PIC, PIT, and keyboard controller) and MMIO for framebuffers and future PCI devices.


## Port‑Mapped I/O (PMIO)
Port‑Mapped I/O uses a **separate I/O address space** accessed with dedicated CPU instructions: `in` and `out`.  
Each device exposes one or more **I/O ports** at fixed addresses. For example: keyboard controller at `0x60`, PIC at `0x20/0xA0`.

### How it works
- The CPU decodes I/O port reads/writes separately from normal memory loads/stores.  
- Only privileged code (ring 0) can execute `in`/`out`.  
- Ports are addressed with 8/16/32-bit widths (`inb`, `inw`, `inl` / `outb`, `outw`, `outl`).

### In EchoOS
The kernel provides small wrappers around `in`/`out`.
Typical uses include:
- Acknowledging interrupts on the **PIC** (EOI on `0x20`/`0xA0`)  
- Reading **keyboard scancodes** (`0x60`)  

PMIO is simple and reliable for the baseline PC platform; it’s perfect for EchoOS’s early kernel bring‑up.


## Memory‑Mapped I/O (MMIO)
With **MMIO**, devices appear directly in the **physical address space**. Software accesses device registers by reading/writing memory at specific addresses.  

This means normal load/store instructions are used, typically through `volatile` pointers in C/C++.

### Why MMIO exists
- It removes the separate I/O space and special instructions, enabling uniform memory semantics.  
- It scales better to complex devices (PCI/PCIe) with many registers and large BARs.  
- It allows **framebuffer** access (like VGA text/graphics) as simple memory writes.

### In EchoOS
EchoOS can write directly to the VGA text buffer at **0xB8000** (MMIO) for terminal output.  
MMIO accesses use `volatile` pointers to avoid the compiler reordering or optimizing out device register reads/writes.


## PMIO vs MMIO

| Aspect | Port‑Mapped I/O (PMIO) | Memory‑Mapped I/O (MMIO) |
|-------|--------------------------|---------------------------|
| Address space | Separate I/O space (ports) | Part of physical memory space |
| CPU instructions | `in`/`out` | Regular loads/stores |
| Granularity | Usually byte/word/dword ports | Arbitrary register widths |
| Privilege | Ring 0 only | Ring 0 only |
| Caching | Not cached | Must be uncached / strongly ordered |
| Typical devices | PIC, PIT, legacy keyboard, early VGA regs | APIC/IOAPIC, PCIe BARs, framebuffers, GPUs |
| Ease of use | Simple for legacy | Better for complex/modern devices |


## Summary
- **PMIO** uses a dedicated port space and `in`/`out` instructions — ideal for legacy PC devices and early kernel bring‑up.  
- **MMIO** maps device registers into the physical address space — ideal for framebuffers, APIC, and PCIe devices. 