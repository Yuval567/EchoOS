%define ENDL 0x0D, 0x0A

bootloader_start_log: db 'Hello world!', ENDL, 0
disk_loaded_log: db 'Disk Loaded!', ENDL, 0

disk_load_error: db 'An error occurred while loading disk', ENDL, 0
sectors_load_error: db "Couldn't load dx number of sectors", ENDL, 0