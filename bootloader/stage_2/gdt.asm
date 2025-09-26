; ============================================================
; Global Descriptor Table (GDT) setup
; Supports flat 32-bit and 64-bit memory models
; ============================================================

; ------------------------------
; GDT Layout
; ------------------------------
; Index  Selector  Description
;   0     0x00     Null descriptor      (mandatory)
;   1     0x08     32-bit code segment  (base=0, limit=4GB)
;   2     0x10     32-bit data segment  (base=0, limit=4GB)
;   3     0x18     64-bit code segment  (base=0, limit=0)
;   4     0x20     64-bit data segment  (base=0, limit=0)
;
; CODE_SEG32 = 0x08
; DATA_SEG32 = 0x10
; CODE_SEG64 = 0x18
; DATA_SEG64 = 0x20

; -----------------------------------------------------------------------------
; Start of the GDT structure. The first entry is always a null descriptor.
; -----------------------------------------------------------------------------
gdt_start:
    dq 0x0                        ; Null descriptor (required by x86 CPUs)

; -----------------------------------------------------------------------------
; 32-bit code segment descriptor:
; - Base: 0x00000000
; - Limit: 0xFFFFFFFF (4GB)
; - Access: Executable, Readable, Accessed=0, DPL=0, Present=1
; - Flags: 32-bit, 4KB granularity
; -----------------------------------------------------------------------------
gdt_code32:
    dw 0xFFFF                     ; Segment limit (15:0)
    dw 0x0000                     ; Base address (15:0)
    db 0x00                       ; Base address (23:16)
    db 10011010b                  ; Access byte: code, readable, present
    db 11001111b                  ; Flags: 4KB granularity, 32-bit
    db 0x00                       ; Base address (31:24)

; -----------------------------------------------------------------------------
; 32-bit data segment descriptor:
; - Base: 0x00000000
; - Limit: 0xFFFFFFFF (4GB)
; - Access: Writable, Accessed=0, DPL=0, Present=1
; - Flags: 32-bit, 4KB granularity
; -----------------------------------------------------------------------------
gdt_data32:
    dw 0xFFFF                     ; Segment limit (15:0)
    dw 0x0000                     ; Base address (15:0)
    db 0x00                       ; Base address (23:16)
    db 10010010b                  ; Access byte: data, writable, present
    db 11001111b                  ; Flags: 4KB granularity, 32-bit
    db 0x00                       ; Base address (31:24)

; -----------------------------------------------------------------------------
; 64-bit code segment descriptor:
; - Base: 0x00000000
; - Limit: 0x00000000 (ignored in long mode)
; - Access: Executable, Readable, Accessed=0, DPL=0, Present=1
; - Flags: 64-bit code segment
; -----------------------------------------------------------------------------
gdt_code64:
    dw 0x0000                     ; Segment limit (15:0) (ignored)
    dw 0x0000                     ; Base address (15:0)
    db 0x00                       ; Base address (23:16)
    db 10011010b                  ; Access byte: code, readable, present
    db 00100000b                  ; Flags: 64-bit segment
    db 0x00                       ; Base address (31:24)

; -----------------------------------------------------------------------------
; 64-bit data segment descriptor:
; - Base: 0x00000000
; - Limit: 0x00000000 (ignored in long mode)
; - Access: Writable, Accessed=0, DPL=0, Present=1
; - Flags: 64-bit data segment (long mode ignores most flags)
; -----------------------------------------------------------------------------
gdt_data64:
    dw 0x0000                     ; Segment limit (15:0) (ignored)
    dw 0x0000                     ; Base address (15:0)
    db 0x00                       ; Base address (23:16)
    db 10010010b                  ; Access byte: data, writable, present
    db 00000000b                  ; Flags: 64-bit data segment (ignored)
    db 0x00                       ; Base address (31:24)

gdt_end:

; -----------------------------------------------------------------------------
; GDTR descriptor structure for LGDT instruction.
; Contains the size of the GDT and its linear address.
; -----------------------------------------------------------------------------
gdt_descriptor:
    dw gdt_end - gdt_start - 1    ; Size of GDT in bytes minus 1
    dd gdt_start                  ; Linear address of GDT

; -----------------------------------------------------------------------------
; Selector constants for use in segment register loading.
; -----------------------------------------------------------------------------
CODE_SEG32 equ gdt_code32 - gdt_start ; Selector for 32-bit code segment (0x08)
DATA_SEG32 equ gdt_data32 - gdt_start ; Selector for 32-bit data segment (0x10)
CODE_SEG64 equ gdt_code64 - gdt_start ; Selector for 64-bit code segment (0x18)
DATA_SEG64 equ gdt_data64 - gdt_start ; Selector for 64-bit data segment (0x20)
