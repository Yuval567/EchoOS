%include "common/macros.asm"

[bits 16]
[org 0x7e00]

; Number of sectors
NUM_SECTORS equ 2 
SECTOR_SIZE equ 512

KERNEL_START_ADDRESS equ 0x100000

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
    
    call enable_A20
    call switch_to_unreal_mode

[bits 16]
unreal_entry:
    call load_kernel_to_memory
    call switch_to_32bit


[bits 32]
start_32:
    call KERNEL_START_ADDRESS
    stop

%include "common/logs.asm"
%include "common/utilities.asm"
%include "stage_1/disk.asm"
%include "stage_2/gdt.asm"
%include "stage_2/switch_to_32bit.asm"
%include "stage_2/kernel_loading.asm"


; boot drive variable
BOOT_DRIVE db 0

; padding the program to one sector
TOTAL_SIZE equ SECTOR_SIZE * NUM_SECTORS  
times TOTAL_SIZE - ($-$$) db 0