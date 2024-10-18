; Load sectors from disk
; Params:
;   - es:bx -> buffer
;   - dh -> num sectors
;   - cl -> sector offset
;   - dl -> drive
[bits 16]
load_from_disk:
    pusha
    push dx

    mov ah, 0x02 ; read mode
    mov al, dh   ; read dh number of sectors
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0

    int 0x13      ; BIOS interrupt
    jc disk_error ; check carry bit for error

    pop dx
    cmp al, dh ; BIOS sets 'al' to the # of sectors actually read
            ; compare it to 'dh' and error out if they are !=
    jne sectors_error

    popa
    ret

    disk_error:
        popa
        print16 disk_load_error 
        stop

    sectors_error:
        popa
        print16 sectors_load_error 
        halt