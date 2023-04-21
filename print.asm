print_string:
    pusha
    mov ah, 0x0E
    print_start:
        mov al, [bx] ; Move the current char bx is pointing to into al
        cmp al, 0
        je print_end ; If al = 0, we have hit the null terminator
        int 0x10 ; Else, we can print and increment the bx pointer
        inc bx
        jmp print_start
    print_end:
        popa
        ret