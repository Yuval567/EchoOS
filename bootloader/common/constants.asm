; Stage 1 bootloader constants
LOADER_NUM_SECTORS equ 2    ; Number of sectors in the second stage bootloader
LOADER_START_SECTOR equ 2   ; Starting sector of the second stage bootloader on disk
LOADER_ADDRESS equ 0x7e00   ; Address in memory where the second stage bootloader will be loaded 


; Stage 2 bootloader constants
SECTOR_SIZE_BYTES equ 512                                       ; Size of a sector in bytes
BUFFER_ADDRESS equ 0x500                                        ; Address in memory where sectors will be loaded temporarily
KERNEL_NUM_SECTORS equ 15                                       ; Number of sectors in the kernel image
KERNEL_START_ADDRESS equ 0x100400                               ; Address where the kernel will be loaded in memory
STACK_START_ADDRESS equ KERNEL_START_ADDRESS                    ; Address where the kernel will be loaded in memory
LOADER_SIZE_BYTES equ SECTOR_SIZE_BYTES * LOADER_NUM_SECTORS    ; Size of the second stage bootloader in bytes
