[bits 16]
[org 0x7c00]

%include "macros.asm"

; where to load the kernel to
KERNEL_OFFSET equ 0x1000

; BIOS sets boot drive in 'dl'; store for later use
mov [BOOT_DRIVE], dl

start:
    ; setup data segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    ; setup stack
    mov ss, ax
    mov sp, 0x7C00      ; stack grows downwards from where we are loaded in memory

    ; print hello world message
    print16 bootloader_start_log

    ; load kernel
    mov bx, KERNEL_OFFSET ; bx -> destination
    mov dh, 1             ; dh -> num sectors (1 sector)
    mov dl, [BOOT_DRIVE]  ; dl -> disk
    call disk_load
    print16 disk_loaded_log

    ; call clear_screen

    print16 switch_to_32bit_log
    call switch_to_32bit

[bits 32]
start_32:
    print32 calling_kernel_log
    call KERNEL_OFFSET
    jmp $

%include "utilities.asm"
%include "logs.asm"
%include "disk.asm"
%include "gdt.asm"
%include "switch_to_32bit.asm"

; boot drive variable
BOOT_DRIVE db 0

; padding the program to 512 bytes
times 510-($-$$) db 0

; magic number 
dw 0xAA55  