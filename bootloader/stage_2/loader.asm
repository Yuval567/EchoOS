%include "common/macros.asm"

[bits 16]
[org 0x7e00]

; Number of sectors
NUM_SECTORS equ 2 
KERNEL_SECTORS equ 1

; where to load the kernel to
KERNEL_OFFSET equ 0x500

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

    ; 

[bits 16]
load_disk:
    push ds
    push es
    
    mov ax, 0x0000    ; Set data segment to 0x0000
    mov ds, ax
    mov es, ax

    mov bx, KERNEL_OFFSET         ; bx -> destination address
    mov cl, (1 + NUM_SECTORS) + 1 ; start from sector 4 (as sector our bootloader is 3 sectors long)
    mov dh, KERNEL_SECTORS        ; dh -> num sectors (1 sector)
    mov dl, [BOOT_DRIVE]          ; dl -> disk
    call load_from_disk
    print16 disk_loaded_log

    pop es
    pop ds

    ret

[bits 16]
unreal_entry:
    call load_disk
    

    mov bx, [my_word]       ; Load the WORD into AX (0xABCD)
    mov eax, 0x100000
    mov word [ds:eax], bx

    stop


;     call switch_to_32bit
;     call update_32bit_stack


; [bits 32]
; start_32:
;     stop
;     call 0x1100


%include "common/logs.asm"
%include "common/utilities.asm"
%include "stage_1/disk.asm"
%include "stage_2/gdt.asm"
%include "stage_2/switch_to_32bit.asm"

; boot drive variable
BOOT_DRIVE db 0

my_word dw 0xABCD       ; Define a WORD with the value 0xABCD

; padding the program to one sector
TOTAL_SIZE equ 512 * NUM_SECTORS  
times TOTAL_SIZE - ($-$$) db 0