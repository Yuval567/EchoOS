; --------------------------------------------------------------------------------------------------------
; Transitions the CPU from real mode to "unreal mode," allowing access to all memory (up to 4GB) 
; while remaining in real mode by temporarily enabling protected mode and loading 32-bit segment limits.
; Parameters: None
; Calls: enable_protected_mode
; --------------------------------------------------------------------------------------------------------
[bits 16]
switch_to_unreal_mode:
    push ds                     ; save DS   

    call enable_protected_mode  ; enable protected mode

    jmp $+3                     ; clear the instruction pre-fetch queue

    ; update segment registers to use the data segment selector in the GDT
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; disable protected mode (clear PE) but keep cached limits
    mov  eax, cr0
    and  eax, 0xFFFFFFFE      ; clear bit 0 (PE)
    mov  cr0, eax
    jmp  short $+2            ; flush prefetch queue (belt-and-suspenders)

    sti                         ; re-enable interrupts
    pop ds                      ; restore DS
    call unreal_mode_entry