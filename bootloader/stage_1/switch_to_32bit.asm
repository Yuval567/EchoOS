[bits 16]
enable_A20:
    in al, 0x92              ; Read the value from port 0x92
    or al, 0x02              ; Set bit 1 (A20 enable)
    out 0x92, al             ; Write the modified value back to port 0x92
    ret                      ; A20 is now enabled

[bits 16]
switch_to_32bit:
    call enable_A20
    cli                     ; 1. disable interrupts
    lgdt [gdt_descriptor]   ; 2. load GDT descriptor
    mov eax, cr0
    or eax, 0x1             ; 3. enable protected mode
    mov cr0, eax
    jmp CODE_SEG:init_32bit ; 4. far jump
    ret

[bits 32]
init_32bit:
    mov ax, DATA_SEG        ; 5. update segment registers
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; 6. setup stack
    mov esp, ebp

    call start_32