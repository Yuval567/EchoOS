%define PG_PRESENT      (1 << 0)
%define PG_ALLOW_WRITE  (1 << 1) 
%define PG_PS           (1 << 7)
%define PFLAGS_2M       (PG_PRESENT | PG_ALLOW_WRITE | PG_PS)

; align 4096
; initial_pdir:
;     dq PFLAGS_2M | (0  << 21)   ; 0..2 MiB
;     dq PFLAGS_2M | (1  << 21)   ; 2..4 MiB
;     dq PFLAGS_2M | (2  << 21)   ; 4..6 MiB
;     dq PFLAGS_2M | (3  << 21)   ; 6..8 MiB
;     times (512-4) dq 0

align 4096
initial_pdir:
    dq (1<<0)|(1<<1)|(1<<7) | (0  << 21)
    dq (1<<0)|(1<<1)|(1<<7) | (1  << 21)
    dq (1<<0)|(1<<1)|(1<<7) | (2  << 21)
    dq (1<<0)|(1<<1)|(1<<7) | (3  << 21)
    times (512-4) dq 0

; PDPT (PAE top level): Present ONLY, points to PD @ 0x9000
align 4096
initial_pdptr:
    dq (1<<0) + initial_pdir    ; EXPECT at runtime: 0x00009001
    times 511 dq 0