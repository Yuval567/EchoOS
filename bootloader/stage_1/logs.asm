; ---------------------------
; Informational logs
; ---------------------------
log_stage1_entry:         db INFO_PREFIX, "Stage 1 bootloader loaded. Beginning initialization...", ENDL, 0
log_calling_stage2:       db INFO_PREFIX, "Transferring control to Stage 2 bootloader.", ENDL, 0

; ---------------------------
; Error logs
; ---------------------------
err_stage2_failure:       db ERROR_PREFIX, "Stage 2 loader failed or crashed.", ENDL, 0