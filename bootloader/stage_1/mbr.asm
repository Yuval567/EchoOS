%include "common/macros.asm"
%include "common/constants.asm"

[bits 16]
[org 0x7c00]
start:
    ; BIOS sets boot drive in 'dl'; store for later use
    mov [BOOT_DRIVE], dl

    ; initialize data segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    print16 stage_1_start

    ; load second stage bootloader from disk
    mov bx, LOADER_ADDRESS   
    mov cl, LOADER_START_SECTOR
    mov dh, LOADER_NUM_SECTORS
    mov dl, [BOOT_DRIVE]
    call load_from_disk
    
    print16 disk_loaded_log

    ; jump to second stage bootloader
    print16 calling_second_stage_log
    call LOADER_ADDRESS

    ; if we return here, hang the system
    print16 stage_2_fail_error
    stop

%include "common/utilities.asm"
%include "common/logs.asm"
%include "common/disk.asm"

; boot drive variable
BOOT_DRIVE db 0

; padding the program to 512 bytes
times 510-($-$$) db 0

; magic number 
dw 0xAA55