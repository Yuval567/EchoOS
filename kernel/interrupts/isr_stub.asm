global isr_stub

isr_stub:
    ; Send end of interrupt signal to PIC
    mov al, 0x20
    out 0x20, al

    ; Return from interrupt
    iretq
