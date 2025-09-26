%define ENDL 0x0D, 0x0A

%define INFO_PREFIX "[INFO]: "
%define ERROR_PREFIX "[ERROR]: "
%define DEBUG_PREFIX "[DEBUG]: "

; ---------------------------
; Informational logs
; ---------------------------
log_disk_loaded:          db INFO_PREFIX, "Disk sectors read into memory.", ENDL, 0

; ---------------------------
; Error logs
; ---------------------------
err_disk_load:            db ERROR_PREFIX, "Disk read error: unable to load requested sectors.", ENDL, 0

; ---------------------------
; Debug logs
; ---------------------------
dbg_test:                 db DEBUG_PREFIX, "Debug checkpoint reached.", ENDL, 0
