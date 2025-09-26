LOADER_LBA equ 1                                ; LBA of the first sector of the second stage bootloader on disk
KERNEL_LBA equ LOADER_LBA + LOADER_NUM_SECTORS  ; LBA of the first sector of the kernel image on disk

LOADER_START_ADDRESS equ 0x7e00         ; Address in memory where the second stage bootloader will be loaded 
TEMP_SECTOR_BUFFER_ADDRESS equ 0x500    ; Address in memory where sectors will be loaded temporarily