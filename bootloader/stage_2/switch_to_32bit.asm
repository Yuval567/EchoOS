[bits 16]
enable_A20:
    in al, 0x92              ; Read the value from port 0x92
    or al, 0x02              ; Set bit 1 (A20 enable)
    out 0x92, al             ; Write the modified value back to port 0x92
    ret                      ; A20 is now enabled

[bits 16]
enter_protected_mode:
    cli
    mov eax, cr0
    or eax, 0x1              ; 3. enable protected mode
    mov cr0, eax
    ret

[bits 16]
switch_to_32bit:
    call enter_protected_mode
    jmp CODE_SEG:update_32bit_stack
    

[bits 32]
update_32bit_stack:
    mov ax, DATA_SEG
    mov ss, ax
    mov ebp, 0x9000        ; 6. setup stack
    mov esp, ebp

    call start_32

[bits 16]
switch_to_unreal_mode:
    cli
    push ds
    lgdt [gdt_descriptor]   ; 2. load GDT descriptor

    call enter_protected_mode

    jmp $+2                ; Clear the instruction pre-fetch queue

    mov ax, DATA_SEG        ; 5. update segment registers
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    and al,0xFE            ; back to realmode
    mov  cr0, eax          ; by toggling bit again
    sti                    ; enable interrupts
    pop ds                 ; Retsore DS to original value
    
    call unreal_entry