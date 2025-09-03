; -------------------------------------------------------------
; Reads a specified number of sectors from the boot drive 
; into memory using BIOS interrupt 0x13.
;
; Parameters:
;   - es:bx -> Destination memory address
;   - dh -> Number of sectors to read
;   - cl -> Starting sector number
;   - dl -> Boot drive number
;
; Returns:
;   - On success: Returns with no error.
;   - On failure: Prints an error message and halts the system.
; -------------------------------------------------------------
[bits 16]
load_from_disk:
    pusha

    push dx             ; save dx as we use dh and dl

    mov ah, 0x02        ; read mode
    mov al, dh          ; read dh number of sectors
    mov ch, 0x00        ; cylinder 0
    mov dh, 0x00        ; head 0

    int 0x13            ; BIOS interrupt
    jc load_disk_error  ; check carry bit for read error

    pop dx              ; restore dx

    ; BIOS sets 'al' to the number of sectors actually read
    cmp al, dh
    ; Compare it to 'dh' and error out if they are not equal
    jne insufficient_sectors

    popa
    ret

    load_disk_error:
        popa
        print16 err_disk_load 
        stop

    insufficient_sectors:
        popa
        print16 err_sector_count 
        stop