disc_load:
    ; Each sector is 512 bytes 
    ; After booting, the drive number is saved in dl. We can save this in a variable
    ; Boot sector is in cylinder 0, head 0, sector 1
    ; So we need to read c = 0, h = 0, s = 2
    ; Read 1 sector
    ; Load the data to 0x7C00 + 512 = 0x7E00
    pusha
    mov ah, 2 ; Read disc
    mov al, 1 ; Number of sectors we want to read
    mov ch, 0 ; Cyclinder number we are reading from
    mov cl, 2 ; Sector number
    mov dh, 0 ; Head number
    mov es, [zero] ; Not quite sure why we set es to zero
    mov bx, 0x7E00 ; Set the address we want to start at
    int 0x13
    ; jc disc_error
    ; cmp al, 1
    ; jne disc_error
    popa
    ret

; disc_error:
;     mov bx, DISC_ERR_MSG
;     call print_string
;     jmp $


; DISC_ERR_MSG:
;     db "Error reading disc!", 0

zero: db 0
