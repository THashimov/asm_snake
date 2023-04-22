[org 0x7C00]

call disc_load
call init_start_point

move_down:
call draw_snake_down
call sleep
call clear_screen
jmp move_down


draw_snake_down:
    call draw_square
    inc dx
    inc word [squares_drawn]
    push ax
    mov al, [squares_drawn]
    cmp al, [len_of_snake]
    pop ax
    jc draw_snake_down
    mov word [squares_drawn], 0
    ret

clear_screen:
    push ax
    mov ah, 0
    mov al, 0x13
    int 0x10
    pop ax
    ret

sleep:
    push cx
    push ax
    mov cx, 0x9 ; Wait 0.5 seconds
    mov ah, 0x86 
    int 0x15
    pop ax
    pop cx
    ret

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

len_of_snake: dw 3
squares_drawn: dw 0