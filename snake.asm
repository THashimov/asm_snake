[org 0x7C00]

call disc_load
call init_start_point

start:
    inc word [len_of_snake]
    call draw_square
    inc dx
    cmp word [len_of_snake], 3
    jne start
    mov word [len_of_snake], 0
    jmp $


draw_square:
    inc word [row_counter]
    int 0x10 ; Draw the starting pixel
    call draw_right ; Draw a row
    mov cx, [col_pos] ; Reset the starting point of 
    inc dx
    cmp word [row_counter], 11
    jne draw_square
    mov word [row_counter], 0
    ret


draw_right:
    inc word [col_counter] ; Increment col_counter every iteration
    inc cx ; Increment which column we are drawing to
    int 0x10 ; Draw a pixel in the new column pos
    cmp word [col_counter], 11 ; Check if have drawn 10 pixel
    jne draw_right ; If not, run loop again
    mov word [col_counter], 0 ; If finished, reset col counter
    ret


init_start_point:
    mov ah, 0x0 ; Set graphical mode
    mov al, 0x13 ; 320x200 screen
    int 0x10
    mov ah, 0xC
    mov dx, [row_pos]
    mov cx, [col_pos]
    mov al, 0xF
    ret


%include "print.asm"
%include "read_disc.asm"


times 510-($ - $$) db 0
db 0x55, 0xaa

col_pos: dw 50
row_pos: dw 50

col_counter: dw 0
row_counter: dw 0

len_of_snake: dw 0