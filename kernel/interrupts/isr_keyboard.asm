global isr_keyboard
extern keyboard_handler

isr_keyboard:
    ; Save registers
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11

    ; Call the keyboard handler
    call keyboard_handler

    ; Restore registers
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax

    ; Send end of interrupt signal to PIC
    mov al, 0x20
    out 0x20, al

    ; Return from interrupt
    iretq
