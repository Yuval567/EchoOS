; null segment descriptor
gdt_start:
    dq 0x0 ; reserve 8 bytes

; code segment descriptor (4 bytes)
gdt_code:
    dw 0xffff    ; segment length, bits 0-15
    dw 0x0       ; segment base, bits 16-31
    
    db 0x0       ; segment base, bits 16-23
    db 10011010b ; flags (8 bits) {P: 0, DPL: 0, 1, TYPE: 1, C: 0, R: 1, A: 0}
    db 11001111b ; flags (4 bits) + segment length, bits 16-19, {G: 1, D: 1, L: 0, AVL: 0}
    db 0x0       ; segment base, bits 24-31

; data segment descriptor (4 bytes)
gdt_data:
    dw 0xffff    ; segment length, bits 0-15
    dw 0x0       ; segment base, bits 16-31

    db 0x0       ; segment base, bits 16-23
    db 10010010b ; flags (8 bits) {P: 0, DPL: 0, 1, TYPE: 0, C: 0, R: 1, A: 0}
    db 11001111b ; flags (4 bits) + segment length, bits 16-19 {G: 1, D: 1, L: 0, AVL: 0}
    db 0x0       ; segment base, bits 24-31

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit)
    dd gdt_start ; address (32 bit)

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start