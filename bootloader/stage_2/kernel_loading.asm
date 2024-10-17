; where to load the kernel to
BUFFER_ADDRESS equ 0x500
KERNEL_SECTORS equ 9

[bits 16]
load_kernel_to_memory:
    mov edi, KERNEL_START_ADDRESS ; Initial destination address (kernel address)
    mov cx, KERNEL_SECTORS
  
    .loop:
        call load_disk
        push cx
        mov cx, SECTOR_SIZE
        mov si, BUFFER_ADDRESS
        call copy_loop
        pop cx

        mov ax, [START_SECTOR]
        inc ax
        mov [START_SECTOR], ax

        dec cx
        jnz .loop

    ret

[bits 16]
load_disk:
    pusha
    push ds
    push es

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov bx, BUFFER_ADDRESS         ; bx -> destination address
    mov cl, [START_SECTOR] ; start from sector 4 (as sector our bootloader is 3 sectors long)
    mov dh, 1                      ; dh -> num sectors (1 sector)
    mov dl, [BOOT_DRIVE]          ; dl -> disk
    call load_from_disk
    print16 disk_loaded_log

    pop es
    pop ds
    popa

    ret

[bits 16]
copy_loop:
    ; Load byte from source (buffer at [si]) and store in destination ([es:edi])
    mov al, [si]           ; Load byte from buffer
    mov [ds:edi], al       ; Store byte to kernel address in high memory

    ; Increment source and destination pointers
    inc si
    inc edi

    ; Decrement counter
    loop copy_loop
    ret                    ; Return from the procedure

START_SECTOR db (1 + NUM_SECTORS) + 1

