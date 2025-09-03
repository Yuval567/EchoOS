%include "common/macros.asm"
%include "common/constants.asm"

; -------------------------------------------------------------------------
; Main entry point for the stage 1 bootloader (MBR).
; Loads the second stage bootloader from disk and transfers control to it.
;
; Steps:
;   1. Stores the boot drive number from DL for later use.
;   2. Loads the second stage bootloader from disk into memory.
;   3. Jumps to the second stage bootloader.
;   4. If control returns, prints an error and halts the system.
;
; Parameters:
;   - DL: Boot drive number (set by BIOS)
; Returns:
;   - Does not return on success (jumps to stage 2 loader).
;   - If stage 2 fails, prints error and halts.
; -------------------------------------------------------------------------
[bits 16]
[org 0x7c00]
start:
    ; BIOS sets boot drive in 'dl'; store for later use
    mov [BOOT_DRIVE], dl

    ; initialize data segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    print16 log_stage1_entry

    ; load second stage bootloader from disk
    mov bx, LOADER_ADDRESS   
    mov cl, LOADER_START_SECTOR
    mov dh, LOADER_NUM_SECTORS
    mov dl, [BOOT_DRIVE]
    call load_from_disk
    
    print16 log_disk_loaded

    ; jump to second stage bootloader
    print16 log_calling_stage2
    call LOADER_ADDRESS

    ; if we return here, hang the system
    print16 err_stage2_failure
    stop

%include "common/utilities.asm"
%include "common/logs.asm"
%include "common/disk.asm"
%include "stage_1/logs.asm"

; boot drive variable
BOOT_DRIVE db 0

; padding the program to 512 bytes
times 510-($-$$) db 0

; magic number 
dw 0xAA55