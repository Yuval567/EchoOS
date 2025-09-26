; -----------------------------------------------------------------------------
; Sets up the CR3 register to point to the initial PML4 paging structure.
; -----------------------------------------------------------------------------
[bits 32]
load_paging_structures:
    mov eax, initial_pml4
    mov cr3, eax
    ret

; -----------------------------------------------------------------------------
; Enables long mode by setting the appropriate control registers:
;   - Loads paging structures
;   - Sets PAE in CR4
;   - Enables Long Mode in EFER MSR
;   - Enables paging and protection in CR0
; -----------------------------------------------------------------------------
[bits 32]
enable_long_mode:
    call load_paging_structures

    mov eax, cr4        ; Read CR4
    or eax, (1 << 5)    ; Set PAE (Physical Address Extension) bit
    mov cr4, eax        ; Write back to CR4

    mov ecx, 0xC0000080 ; EFER MSR address
    rdmsr               ; Read EFER into EDX:EAX
    or eax, (1 << 8)    ; Set LME (Long Mode Enable) bit
    wrmsr               ; Write back to EFER

    mov eax, cr0        ; Read CR0
    or eax, (1 << 31)   ; Set PG (Paging) bit
    or eax, (1 << 16)   ; Set WP (Write Protect) bit
    mov cr0, eax        ; Write back to CR0

    ret

; -----------------------------------------------------------------------------
; Performs the final transition to 64-bit long mode:
;   - Calls enable_long_mode
;   - Far jumps to 64-bit code segment and entry point
; -----------------------------------------------------------------------------
[bits 32]
switch_to_long_mode:
    call enable_long_mode
    jmp CODE_SEG64:long_mode_entry

