%define PG_PRESENT      (1 << 0)
%define PG_ALLOW_WRITE  (1 << 1)
%define PG_PS           (1 << 7)
%define PFLAGS (PG_PRESENT | PG_ALLOW_WRITE | PG_PS)

align 4096
initial_pdir:
    dq PFLAGS | (0  << 21)   ; 0..2MiB
    dq PFLAGS | (1  << 21)   ; 2..4MiB
    dq PFLAGS | (2  << 21)   ; 4..6MiB
    dq PFLAGS | (3  << 21)   ; 6..8MiB
    times (512-4) dq 0

align 4096
initial_pdptr:
    dq (PG_PRESENT | PG_ALLOW_WRITE) + initial_pdir
    times 511 dq 0

align 4096
initial_pml4:
    dq (PG_PRESENT | PG_ALLOW_WRITE) + initial_pdptr
    times 511 dq 0
