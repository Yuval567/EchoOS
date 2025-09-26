; ---------------------------
; FloppyDisk Constants
; ---------------------------
HEADS equ 2
SECTORS_PER_TRACK equ 18
SECTOR_SIZE_BYTES equ 512

; ---------------------------
; Stage 1 bootloader Constants
; ---------------------------
LOADER_NUM_SECTORS equ 35           ; Number of sectors in the second stage bootloader
LOADER_START_ADDRESS equ 0x7e00     ; Address in memory where the second stage bootloader will be loaded 
LOADER_LBA equ 1                    ; LBA of the first sector of the second stage bootloader on disk


; ---------------------------
; Stage 2 bootloader Constants
; ---------------------------
KERNEL_START_ADDRESS equ 0x100400                               ; Address where the kernel will be loaded in memory

TEMP_SECTOR_BUFFER_ADDRESS equ 0x500                            ; Address in memory where sectors will be loaded temporarily
STACK_START_ADDRESS equ KERNEL_START_ADDRESS                    ; Address where the stack will be loaded in memory
LOADER_SIZE_BYTES equ SECTOR_SIZE_BYTES * LOADER_NUM_SECTORS    ; Size of the second stage bootloader in bytes

KERNEL_NUM_SECTORS equ 15                                       ; Number of sectors in the kernel image
KERNEL_LBA equ 1 + LOADER_NUM_SECTORS                           ; LBA of the first sector of the kernel image on disk