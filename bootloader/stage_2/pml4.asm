; =============================================================================
; Initial Paging Structures for Long Mode (x86_64)
; -----------------------------------------------------------------------------
; This file defines the initial PML4, PDPT, and PD for identity-mapped 2MiB pages.
; Used to enable paging and enter long mode in the bootloader.
; =============================================================================

; Page is present in memory
%define PG_PRESENT      (1 << 0)

; Page is writable
%define PG_ALLOW_WRITE  (1 << 1)

; Page size (1 for 2MiB pages)
%define PG_PS           (1 << 7)  

; Flags for 2MiB pages
%define PFLAGS_2M       (PG_PRESENT | PG_ALLOW_WRITE | PG_PS)

; -----------------------------------------------------------------------------
; Page Directory (PD) - 2MiB Identity Mapping
; Maps the first 8 MiB of memory using four 2MiB pages.
; Each entry is a 2MiB page, present and writable.
; Remaining entries are zeroed.
; -----------------------------------------------------------------------------
align 4096
initial_pdir:
    dq PFLAGS_2M | (0 << 21)      ; 0x00000000 - 0x00200000
    dq PFLAGS_2M | (1 << 21)      ; 0x00200000 - 0x00400000
    dq PFLAGS_2M | (2 << 21)      ; 0x00400000 - 0x00600000
    dq PFLAGS_2M | (3 << 21)      ; 0x00600000 - 0x00800000
    times (512-4) dq 0            ; Zero remaining entries

; -----------------------------------------------------------------------------
; Page Directory Pointer Table (PDPT)
; Points to the initial_pdir. Only the first entry is used.
; Remaining entries are zeroed.
; -----------------------------------------------------------------------------
align 4096
initial_pdptr:
    dq (PG_PRESENT|PG_ALLOW_WRITE) + initial_pdir ; First entry points to PD
    times 511 dq 0                                ; Zero remaining entries

; -----------------------------------------------------------------------------
; Page Map Level 4 (PML4)
; Top-level paging structure. Only the first entry is used.
; Points to initial_pdptr.
; Remaining entries are zeroed.
; -----------------------------------------------------------------------------
align 4096
initial_pml4:
    dq (PG_PRESENT|PG_ALLOW_WRITE) + initial_pdptr ; First entry points to PDPT
    times 511 dq 0                                 ; Zero remaining entries
