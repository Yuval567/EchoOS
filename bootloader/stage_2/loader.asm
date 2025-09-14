%include "common/macros.asm"
%include "common/constants.asm"



; -----------------------------------------------------------------------------
; Main entry point for the stage 2 bootloader.
; Initializes stack and data segments, enables A20, loads the GDT, switches to
; unreal mode, and begins loading the kernel.
;
; Steps:
;   1. Stores the boot drive number from DL for later use.
;   2. Enables the A20 gate.
;   3. Loads the GDT descriptor.
;   4. Switches to unreal mode.
;   5. Proceeds to unreal_mode_entry.
;
; Parameters:
;   - DL: Boot drive number (set by BIOS)
; Returns:
;   - Does not return on success (transfers control to kernel).
; -----------------------------------------------------------------------------
[bits 16]
[org LOADER_START_ADDRESS]
start:
    ; BIOS sets boot drive in 'dl'; store for later use
    mov [BOOT_DRIVE], dl

    ; initialize stack
    mov ax, 0x9F00    ; Load segment 0x9F00
    mov ss, ax        ; Set the stack segment to 0x9F00
    mov sp, 0x0C00    ; Set stack pointer to 0xC00

    ; initialize data segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    print16 log_stage2_entry

    call enable_A20_gate
    print16 log_a20_enabled
    
    call load_gdt_descriptor
    print16 log_gdt_loaded

    call switch_to_unreal_mode

; ------------------------------------------------------------------------
; Entry point after switching to unreal mode.
; Loads the kernel from disk into memory and prepares for protected mode.
;
; Steps:
;   1. Loads the kernel into memory.
;   2. Switches to protected mode.
;
; Parameters: None
; Returns: None
; ------------------------------------------------------------------------
[bits 16]
unreal_mode_entry:
    print16 log_unreal_mode_entry
    call load_kernel_to_memory
    print16 log_kernel_loaded

    call switch_to_protected_mode

; ---------------------------------------------------------------------------
; Entry point after switching to protected mode (32-bit).
; Sets up segment registers and stack, then transfers control to the kernel.
;
; Steps:
;   1. Sets up all segment registers for protected mode.
;   2. Sets up the stack pointer and base pointer.
;   3. Calls the kernel entry point.
;   4. Halts if control returns.
;
; Parameters: None
; Returns: None
; ---------------------------------------------------------------------------
[bits 32]
protected_mode_entry:
    ; Set up segment registers for protected mode
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set up stack for protected mode
    mov esp, STACK_START_ADDRESS
    mov ebp, esp

    ; ; Enable PAE (bit 5 of CR4)
    ; mov eax, cr4
    ; or eax, (1 << 5)    ; set bit 5
    ; mov cr4, eax

    ; ; 2. Load PML4 physical address
    ; mov eax, initial_pml4
    ; mov cr3, eax

    ; ; 3. Enable LME (Long Mode Enable) via MSR
    ; mov ecx, 0xC0000080   ; IA32_EFER
    ; rdmsr
    ; or eax, (1 << 8)      ; set LME (bit 8)
    ; wrmsr

    ; ; 4. Enable paging
    ; mov eax, cr0
    ; or eax, (1 << 31)     ; set PG
    ; mov cr0, eax

    ; print32 log_protected_mode_entry

    ; print32 log_calling_kernel
    call KERNEL_START_ADDRESS

    ; If we return here, hang the system
    stop


%include "common/logs.asm"
%include "common/utilities.asm"
%include "common/disk.asm"
%include "stage_2/logs.asm"
%include "stage_2/32bit_gdt.asm"
%include "stage_2/protected_mode.asm"
%include "stage_2/unreal_mode.asm"
%include "stage_2/load_kernel.asm"
%include "stage_2/pml4.asm"

; boot drive variable
BOOT_DRIVE db 0
