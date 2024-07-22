[bits 16]
[org 0x7c00]

%define ENDL 0x0D, 0x0A

; where to load the kernel to
KERNEL_OFFSET equ 0x1000

; BIOS sets boot drive in 'dl'; store for later use
mov [BOOT_DRIVE], dl

start:
    ; setup data segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    ; setup stack
    mov ss, ax
    mov sp, 0x7C00      ; stack grows downwards from where we are loaded in memory

    ; print hello world message
    mov si, msg_hello
    call printf

    ; load kernel
    mov bx, KERNEL_OFFSET ; bx -> destination
    mov dh, 1             ; dh -> num sectors (1 sector)
    mov dl, [BOOT_DRIVE]  ; dl -> disk
    call disk_load

;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
printf:
    ; save registers we will modify
    push ax

    .loop:
        lodsb               ; loads next character from si to al
        or al, al           ; verify if next character is null?
        jz .done

        mov ah, 0x0e        ; call bios interrupt
        int 0x10

        jmp .loop

    .done:
        pop ax  
        ret


disk_load:
    pusha
    push dx

    mov ah, 0x02 ; read mode
    mov al, dh   ; read dh number of sectors
    mov cl, 0x02 ; start from sector 2
                 ; (as sector 1 is our boot sector)
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0

    ; dl = drive number is set as input to disk_load
    ; es:bx = buffer pointer is set as input as well

    int 0x13      ; BIOS interrupt
    jc disk_error ; check carry bit for error

    pop dx     ; get back original number of sectors to read
    cmp al, dh ; BIOS sets 'al' to the # of sectors actually read
               ; compare it to 'dh' and error out if they are !=
    jne sectors_error
    popa
    ret

disk_error:
    mov si, disk_load_error
    jmp printf

sectors_error:
    mov si, disk_load_error
    jmp printf

msg_hello: db 'Hello world!', ENDL, 0

disk_load_error: db 'An error occured while loading disk', ENDL, 0
sectors_load_error: db "Couldn't load dx number of sectors", ENDL, 0

; boot drive variable
BOOT_DRIVE db 0

; padding the program to 512 bytes
times 510-($-$$) db 0

; magic number 
dw 0xAA55  