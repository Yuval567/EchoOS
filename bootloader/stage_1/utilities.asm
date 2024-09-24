video_mem_start equ 0xb8000

; Prints a string to the screen
; Params:
;   - ds:si points to string
[bits 16]
print16_loop:
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

; Prints a string to the screen
; Params:
;   - ds:si points to string
[bits 32]
print32_loop:
    pusha

    mov ebx, video_mem_start  ; Set EBX to point to the video memory base address
    mov ecx, 0x07            ; Attribute byte (light gray on black)

    .loop:
        lodsb
        cmp al, 0
        je .done

        mov [ebx], al
        mov [ebx+1], cl
        add ebx, 2

        jmp .loop

    .done:
        popa
        ret                      ; Return from procedure
