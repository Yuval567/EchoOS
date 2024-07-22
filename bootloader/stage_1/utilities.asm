[bits 16]

; Define the PRINT macro
%macro print 1
    mov si, %1
    call printf
%endmacro

; Prints a string to the screen
; Params:
;   - ds:si points to string
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
