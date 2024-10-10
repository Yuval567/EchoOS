%include "common/macros.asm"

[bits 16]
[org 0x7e00]

; Number of sectors
NUM_SECTORS equ 2 

; where to load the kernel to
KERNEL_OFFSET equ 0x1000

; BIOS sets boot drive in 'dl'; store for later use
mov [BOOT_DRIVE], dl

start:
    ; setup stack
    mov ax, 0x9F00    ; Load segment 0x9F00
    mov ss, ax        ; Set the stack segment to 0x9F00
    mov sp, 0x0C00    ; Set stack pointer to 0xC00

    ; setup data segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    print16 stage_2_start

    ; load kernel from disk
    mov bx, KERNEL_OFFSET         ; bx -> destination address
    mov cl, (1 + NUM_SECTORS) + 1 ; start from sector 4 (as sector our bootloader is 3 sectors long)
    mov dh, 1                     ; dh -> num sectors (1 sector)
    mov dl, [BOOT_DRIVE]          ; dl -> disk
    call disk_load
    print16 disk_loaded_log
    
    print16 switch_to_32bit_log

    call switch_to_32bit

[bits 32]
start_32:
    print32 calling_kernel_log

    call KERNEL_OFFSET
    jmp $

%include "common/logs.asm"
%include "common/utilities.asm"
%include "stage_1/disk.asm"
%include "stage_2/gdt.asm"
%include "stage_2/switch_to_32bit.asm"

; boot drive variable
BOOT_DRIVE db 0

; padding the program to one sector
TOTAL_SIZE equ 512 * NUM_SECTORS  
times TOTAL_SIZE - ($-$$) db 0