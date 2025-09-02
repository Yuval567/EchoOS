%include "common/macros.asm"
%include "common/constants.asm"

[bits 16]
[org LOADER_ADDRESS]
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
    
    print16 stage_2_start
    
    call enable_A20
    print16 a20_gate_enabled_log
    
    call switch_to_unreal_mode

[bits 16]
unreal_entry:
    print16 unreal_mode_entry_log
    call load_kernel_to_memory
    print16 kernel_loaded_log
    
    print16 switch_to_32bit_log
    call switch_to_32bit


[bits 32]
start_32bit:
    print32 calling_kernel_log
    call KERNEL_START_ADDRESS
    stop

%include "common/logs.asm"
%include "common/utilities.asm"
%include "common/disk.asm"
%include "stage_2/gdt.asm"
%include "stage_2/mode_switching.asm"
%include "stage_2/kernel_loading.asm"


; boot drive variable
BOOT_DRIVE db 0

; padding the program to one sector
TOTAL_SIZE equ SECTOR_SIZE_BYTES * LOADER_NUM_SECTORS
times TOTAL_SIZE - ($-$$) db 0