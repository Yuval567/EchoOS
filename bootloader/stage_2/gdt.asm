; ============================================================
; Global Descriptor Table (GDT) setup
; Provides flat 32-bit memory model with code and data segments
; ============================================================

; ------------------------------
; GDT Layout
; ------------------------------
; Index  Selector  Description
;   0     0x00     Null descriptor (required by CPU)
;   1     0x08     32-bit code segment (base=0, limit≈4GB)
;   2     0x10     32-bit data segment (base=0, limit≈4GB)
;
; CODE_SEG = 0x08
; DATA_SEG = 0x10

; ------------------------------------------------------------
; Null descriptor (index 0) - must be all zeros
; ------------------------------------------------------------
gdt_start:
    dq 0x0

; ------------------------------------------------------------
; Code Segment Descriptor (index 1, selector = 0x08)
; Provides a 32-bit executable, readable code segment
; Base = 0x00000000, Limit = 0xFFFFF (4GB with granularity=4KB)
; ------------------------------------------------------------
gdt_code:
    dw 0xFFFF              ; Segment limit (bits 0–15)
    dw 0x0000              ; Base address  (bits 0–15)
    db 0x00                ; Base address  (bits 16–23)

    ;  P=1 (present), DPL=00 (ring 0), S=1 (code/data)
    ;  Type=1010 (executable, readable, accessed=0)
    db 10011010b

    ;  G=1 (granularity = 4KB), D=1 (32-bit), L=0 (not 64-bit), AVL=0
    db 11001111b

    db 0x00                ; Base address (bits 24–31)

; ------------------------------------------------------------
; Data Segment Descriptor (index 2, selector = 0x10)
; Provides a 32-bit writable data segment
; Base = 0x00000000, Limit = 0xFFFFF (4GB with granularity=4KB)
; ------------------------------------------------------------
gdt_data:
    dw 0xFFFF              ; Segment limit (bits 0–15)
    dw 0x0000              ; Base address  (bits 0–15)
    db 0x00                ; Base address  (bits 16–23)

    ;  P=1 (present), DPL=00 (ring 0), S=1 (code/data)
    ;  Type=0010 (data, writable, expand-up, accessed=0)
    db 10010010b

    db 11001111b

    db 0x00                ; Base address (bits 24–31)

gdt_end:

; ------------------------------------------------------------
; GDTR descriptor structure (for LGDT instruction)
; ------------------------------------------------------------
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Limit (size of GDT - 1)
    dd gdt_start                ; Base address of GDT

; ------------------------------------------------------------
; Useful selector constants
; ------------------------------------------------------------
CODE_SEG equ gdt_code - gdt_start  ; = 0x08 (first descriptor after null)
DATA_SEG equ gdt_data - gdt_start  ; = 0x10 (second descriptor)