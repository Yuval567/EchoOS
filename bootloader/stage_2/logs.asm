; ---------------------------
; Informational logs
; ---------------------------
log_stage2_entry:         db INFO_PREFIX, "Stage 2 bootloader loaded. Preparing environment...", ENDL, 0
log_unreal_mode_entry:    db INFO_PREFIX, "Entered unreal mode.", ENDL, 0
log_protected_mode_entry: db INFO_PREFIX, "Entered protected mode.", ENDL, 0

log_calling_kernel:       db INFO_PREFIX, "Transferring control to kernel entry point.", ENDL, 0
log_a20_enabled:          db INFO_PREFIX, "A20 line enabled successfully.", ENDL, 0
log_gdt_loaded:           db INFO_PREFIX, "GDT loaded successfully.", ENDL, 0
log_kernel_loaded:        db INFO_PREFIX, "Kernel successfully loaded into memory.", ENDL, 0

; ---------------------------
; Error logs
; ---------------------------
err_kernel_failure:       db ERROR_PREFIX, "Kernel failed or crashed.", ENDL, 0

; ---------------------------
; Debug logs
; ---------------------------
dbg_test:                 db DEBUG_PREFIX, "Debug checkpoint reached.", ENDL, 0