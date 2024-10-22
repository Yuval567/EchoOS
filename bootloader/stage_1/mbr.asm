%include "common/macros.asm"

[bits 16]
[org 0x7c00]

; where to load the second stage loader to
LOADER_OFFSET equ 0x7e00

; BIOS sets boot drive in 'dl'; store for later use
mov [BOOT_DRIVE], dl

start:
    ; setup data segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    print16 stage_1_start

    ; load loader from disk
    mov bx, LOADER_OFFSET ; bx -> destination address
    mov cl, 0x02          ; start from sector 2 (as sector 1 is our boot sector)
    mov dh, 0x02          ; dh -> num sectors (2 sector)
    mov dl, [BOOT_DRIVE]  ; dl -> disk
    call load_from_disk
    print16 disk_loaded_log

    print16 calling_second_stage_log
    call LOADER_OFFSET
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