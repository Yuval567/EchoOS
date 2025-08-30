; Stage 1 bootloader constants
LOADER_NUM_SECTORS equ 2    ; Number of sectors in the second stage bootloader
LOADER_START_SECTOR equ 2   ; sector 1 is the MBR, so we start from sector 2
LOADER_ADDR equ 0x7e00      ; address in memory where the second stage bootloader will be loaded 


