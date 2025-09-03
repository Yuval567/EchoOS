; -------------------------------------------------------------------
; Enables the A20 address line, allowing access to memory above 1MB.
; Enables the A20 line via port 0x92 (System Control Port A)
; Parameters: None
; Returns: None
; -------------------------------------------------------------------
[bits 16]
enable_A20_gate:
    push ax

    in al, 0x92     ; Read the value from port 0x92
    or al, 0x02     ; Set bit 1 (A20 enable)
    out 0x92, al    ; Write the modified value back to port 0x92

    pop ax
    ret  

; ------------------------------------------------------------
; Loads the GDT descriptor into the GDTR register.
; Parameters: gdt_descriptor - pointer to the GDT descriptor
; Returns: None
; ------------------------------------------------------------
[bits 16]
load_gdt_descriptor:
    lgdt [gdt_descriptor]
    ret

; -----------------------------------------------------------------
; Enables protected mode by setting the PE bit in the CR0 register.
; Cancels interrupts to ensure a safe transition.
; Parameters: None
; Returns: None
; -----------------------------------------------------------------
[bits 16]
enable_protected_mode:
    push eax
    
    cli
    mov eax, cr0    ; read CR0 register
    or eax, 0x1     ; set PE bit (bit 0) in CR0
    mov cr0, eax    ; write back to CR0
    
    pop eax
    ret

; -------------------------------------------------------------------------------
; Switches the CPU to protected mode and jumps to the protected_mode_entry label.
; This function assumes that the GDT has already been loaded and that the
; segment selectors are set up correctly.
; Parameters: None
; Returns: None
; -------------------------------------------------------------------------------
[bits 16]
switch_to_protected_mode:
    call enable_protected_mode
    jmp CODE_SEG:protected_mode_entry   ; far jump to clear prefetch queue and switch to protected mode