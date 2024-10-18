; Load kernel from disk to memory by load sector
; by sector to the source buffer and then perform
; a copy to an high memory address.
[bits 16]
load_kernel_to_memory:
    mov edi, KERNEL_START_ADDRESS ; Initial destination address (kernel address)
    mov cx, KERNEL_SECTORS
  
    .loop:
        call load_kernel_buffer
        push cx
        mov cx, SECTOR_SIZE
        mov si, BUFFER_ADDRESS
        call copy_buffer
        pop cx

        mov ax, [START_SECTOR]
        inc ax
        mov [START_SECTOR], ax

        dec cx
        jnz .loop

    ret

; Loads one kernel sector to the BUFFER_ADDRESS using  
; the BIOS routine. This procedure also resets the DS and ES 
; to perform the BIOS routine.
[bits 16]
load_kernel_buffer:
    pusha
    push ds
    push es

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov bx, BUFFER_ADDRESS         ; bx -> destination address
    mov cl, [START_SECTOR] ; start from sector 4 (as sector our bootloader is 3 sectors long)
    mov dh, 0x01                      ; dh -> num sectors (1 sector)
    mov dl, [BOOT_DRIVE]          ; dl -> disk
    call load_from_disk
    print16 disk_loaded_log

    pop es
    pop ds
    popa

    ret

; Copies buffer from the source index address (low memory address)
; to the destination index address (high memory address).
; Params:
;   - si: The source address of the buffer.
;   - edi: The destination address of the buffer.
;   - cx: The size of the buffer.
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
    ret                    ; Return from the procedure

START_SECTOR db (1 + NUM_SECTORS) + 1

