; -------------------------------------------------------------------------
; Loads the kernel from disk into high memory, sector by sector.
; For each sector:
;   - Loads the sector into a buffer using BIOS routines.
;   - Copies the buffer to the kernel's destination address in high memory.
;   - Increments the sector number and destination address.
; Parameters: None
; Returns: None
; -------------------------------------------------------------------------
[bits 16]
load_kernel_to_memory:
    mov edi, KERNEL_LOAD_ADDRESS
    mov cx, KERNEL_NUM_SECTORS
  


    .load_chunks_loop:
        call load_kernel_sector
        
        push cx
        
        mov cx, DISK_SECTOR_SIZE_BYTES
        mov si, TEMP_SECTOR_BUFFER_ADDRESS
        
        call copy_buffer

        pop cx

        mov ax, [CURRENT_LBA]
        inc ax
        mov [CURRENT_LBA], ax

        dec cx
        jnz .load_chunks_loop

    ret

; ---------------------------------------------------------------------------
; Loads one kernel sector from disk into TEMP_SECTOR_BUFFER_ADDRESS using BIOS routines.
; Temporarily resets DS and ES for BIOS compatibility.
; Parameters: None
; Returns: None
; ---------------------------------------------------------------------------
[bits 16]
load_kernel_sector:
    pusha

    push ds
    push es

    ; reset segments for BIOS call
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ax, [CURRENT_LBA]
    mov bx, TEMP_SECTOR_BUFFER_ADDRESS
    mov cx, 0x01            ; Read 1 sector
    
    call load_from_disk
    print16 log_disk_loaded

    pop es
    pop ds
    
    popa

    ret

; -----------------------------------------------------------------------------------
; Copies a buffer from a source address in low memory to a destination address
; in high memory.
; Parameters:
;   - si: Source address of the buffer
;   - edi: Destination address in high memory
;   - cx: Size of the buffer (number of bytes to copy)
; Returns: None
; Notes: This procedure modifies si and edi; their initial values are not preserved.
; -----------------------------------------------------------------------------------
[bits 16]
copy_buffer:
    ; Load byte from source (buffer at [si]) and store in destination ([es:edi])
    mov al, [si]           ; Load byte from buffer
    mov [ds:edi], al       ; Store byte to kernel address in high memory

    ; Increment source and destination pointers
    inc si
    inc edi

    ; Decrement counter
    loop copy_buffer
    ret

; Variable holding the current sector number to load.
; Initialized to the first kernel sector after the bootloader.
CURRENT_LBA dw KERNEL_LBA
