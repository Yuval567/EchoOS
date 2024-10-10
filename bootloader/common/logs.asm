%define ENDL 0x0D, 0x0A

stage_1_start: db "First stage loaded and starting.", ENDL, 0
stage_2_start: db "Second stage loaded and starting.", ENDL, 0

calling_second_stage_log: db "Calling second stage loader.", ENDL, 0
calling_kernel_log: db "Calling Kernel!", 0

switch_to_32bit_log: db "Switching to 32bit", ENDL, 0

disk_loaded_log: db 'Disk Loaded', ENDL, 0
disk_load_error: db 'An error occurred while loading disk', ENDL, 0
sectors_load_error: db "Couldn't load dx number of sectors", ENDL, 0

debug_log: db "TEST", ENDL, 0
