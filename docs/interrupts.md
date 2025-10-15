# Interrupts, IDT, and ISRs in EchoOS

## Overview
Interrupts let the kernel react to events as they happen — timer ticks, keyboard input, disk I/O, or CPU exceptions. 

**PIC (Programmable Interrupt Controller)** — routes hardware IRQ lines to CPU interrupt vectors.  

**IDT (Interrupt Descriptor Table)** — a table the CPU consults to find the handler for each vector.

**ISRs/IRQ Handlers** — the assembly stubs and functions that actually handle the event.


## Exceptions & IRQs
- **Exceptions** (vectors 0–31): Synchronous faults or traps raised by the CPU. For example: divide-by-zero, page fault, general protection fault, etc... 


- **IRQs** (typically vectors 32–47 with PIC): Asynchronous hardware signals (timer, keyboard, etc.) delivered via the interrupt controller.

## The PIC and Remapping
### Why remap?
On legacy x86, the **8259A PIC** delivers hardware IRQs starting at vector **0x08**, which collides with CPU exceptions. To avoid this, EchoOS **remaps** the PIC so that IRQs start at **0x20**:

- Master PIC (IRQ0–IRQ7) → **0x20–0x27**  
- Slave PIC  (IRQ8–IRQ15) → **0x28–0x2F**

This keeps exceptions (0–31) and hardware interrupts (32–47) cleanly separated.

### End of Interrupt (EOI)
After handling an IRQ, the kernel must send an **EOI** to the PIC to restore that line:

Forgetting to send EOI, would cause the PIC not to deliver further interrupts for that line.


## The IDT (Interrupt Descriptor Table)
The **IDT** is an array of gate descriptors. Each entry tells the CPU:

- **Offset**: the handler’s code address.  
- **Selector**: which code segment (kernel CS) to use.  
- **Type/Attributes**: interrupt gate or trap gate, descriptor privilege level (DPL), and present bit.

### Gate types
- **Interrupt Gate (0xE)** — clears IF on entry, masking further maskable interrupts until `iret`. Best for IRQs and most faults.  
- **Trap Gate (0xF)** — leaves IF unchanged. Useful for debugging/traps (like breakpoints).

### EchoOS defaults
- **Present = 1**, **DPL = 0**, **Type = Interrupt Gate**, **Selector = kernel code segment**.  
- Handlers that need to be invokable from user space (rare in early EchoOS) would use a higher DPL.

Some exceptions push an **error code** automatically (e.g., #PF, #GP); your handler must account for it.



### Typical flow
1. Interrupt occurs → CPU pushes `RIP/EIP`, `CS`, `RFLAGS`, maybe error code.  
2. ISR stub runs, saves registers, pushes vector, calls C.  
3. C dispatcher identifies **exception vs IRQ**, calls the right handler.  
4. If it’s an IRQ, send **EOI** to PIC.  
5. Stub restores registers → `iret` returns to the interrupted context.


## Summary
- EchoOS separates **exceptions** and **IRQs** cleanly by remapping the PIC to **0x20–0x2F**.  
- The **IDT** maps vectors to **assembly stubs**, which save state and call a **C dispatcher**.  
