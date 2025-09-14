PG_PRESENT      equ 1 << 0
PG_ALLOW_WRITE  equ 1 << 1
PG_PS           equ 1 << 7


align 4096
initial_pml4:
    dq (PG_PRESENT | PG_ALLOW_WRITE) + initial_pdptr
    times 511 dq 0

align 4096
initial_pdptr:
    dq (PG_PRESENT | PG_ALLOW_WRITE) + initial_pdir
    times 511 dq 0

align 4096
initial_pdir:
    dq PG_PRESENT | PG_ALLOW_WRITE | PG_PS
    times 511 dq 0
