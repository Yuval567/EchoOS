; -----------------------------------------------------------------------------
; Reads sectors from disk using BIOS interrupt 0x13.
; 
; Parameters:
;   AX - Starting LBA (Logical Block Address)
;   CX - Number of sectors to read
;   BX - Buffer address to store read data
;   [BOOT_DRIVE] - Drive number (usually set elsewhere)
;
; Returns:
;   Data read from disk is stored at [BX], incremented by SECTOR_SIZE_BYTES per sector.
;
; Errors:
;   If disk read fails, prints err_disk_load and halts.
; -----------------------------------------------------------------------------
[bits 16]
load_from_disk:
    pusha

    .next_sector:
        cmp cx, 0
        je .done

        push ax                     ; save LBA
        push cx                     ; save sector count

        call convert_lba_to_chs     ; input AX, output: CH=cylinder, CL=sector, DH=head
        
        mov dl, [BOOT_DRIVE]
        mov al, 1                   ; read 1 sector at a time
        mov ah, 0x02                ; read mode for int 0x13
        int 0x13
        jc .disk_error              ; if carry flag set → error

        pop cx                      ; restore sector count
        pop ax                      ; restore LBA

        inc ax                      ; Increment LBA
        dec cx                      ; Decrement sector count
        add bx, SECTOR_SIZE_BYTES   ; Move buffer pointer to next sector

        jmp .next_sector
 
    .disk_error:
        popa
        print16 err_disk_load 
        stop

    .done:
        popa
        ret



; -----------------------------------------------------------------------------
; Converts a Logical Block Address (LBA) to Cylinder-Head-Sector (CHS) values.
;
; Parameters:
;   AX - LBA to convert
;
; Returns:
;   CH - Cylinder
;   CL - Sector (starts at 1)
;   DH - Head
;
; Uses:
;   HEADS - Number of heads per cylinder (defined elsewhere)
;   SECTORS_PER_TRACK - Number of sectors per track (defined elsewhere)
; -----------------------------------------------------------------------------
[bits 16]
convert_lba_to_chs:
    push ax
    push bx

    mov     bx, HEADS*SECTORS_PER_TRACK
    xor     dx, dx
    div     bx                     ; AX / SECTORS_PER_TRACK -> AX = Cylinder, DX = remainder
    mov     ch, al                 ; CH = cylinder

    mov     bx, SECTORS_PER_TRACK
    mov     ax, dx
    xor     dx, dx
    div     bx                     ; AX / SECTORS_PER_TRACK -> AX=head, DX=sectorIndex

    mov     dh, al                 ; DH = head
    inc     dl                     ; DL = sectorIndex+1
    mov     cl, dl                 ; CL = sector
    
    pop     bx
    pop     ax

    ret