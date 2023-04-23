[org 0x7C00]

call disc_load
call init_start_point

check_for_key:
    call check_for_w_press
    cmp byte [direction], 's'
    je down
    
    call move_up
    jmp check_for_key

    down:
        call move_down

    jmp check_for_key
    
    ; je change_direction
    ; cmp al, 's'
    ; je change_direction

check_for_w_press:
    pusha
    mov ah, 1
    int 0x16
    jz no_key
    cmp al, 'w'
    je w_pressed
    
    jmp s_pressed

    w_pressed:
        mov byte [direction], 'w'
        jmp no_key

    s_pressed:
        mov byte [direction], 's'
        jmp no_key

    no_key:
        popa
        mov ah, 0x0 ; Set graphical mode
        mov al, 0x13 ; 320x200 screen
        int 0x10
        mov ah, 0xC
        mov al, 0xF
        ret

check_for_s_press:
    ret

move_up:
    call draw_snake_vert
    call sleep
    call clear_screen
    call increment_head
    ret
    
increment_head:
    ; To give the illusion of the snake moving up, we need to move the head coord up, the snake will still be drawn top to bottom
    push ax
    mov al, -1 ; This needs to run 1 times more than the length of the snake otherwise the head will be the same as the start. This needs to go one square further up than the tail
    for_each_square_inc:
        sub dx, 12
        inc al
        cmp al, [len_of_snake]
        jne for_each_square_inc
    pop ax 
    ret

move_down:
    call draw_snake_vert
    call sleep
    call clear_screen
    call decrement_head
    ret

decrement_head:
    ; For each square in the snake length, we sub 12 from dx
    ; With each move, the head moves 12 pixels. 10 for the body square and two to give a gap between squares
    push ax
    mov al, 1
    for_each_square_dec:
        sub dx, 12
        inc al
        cmp al, [len_of_snake]
        jne for_each_square_dec
    pop ax 
    ret

draw_snake_vert:
    call draw_square
    inc word [squares_drawn]
    push ax
    mov al, [squares_drawn]
    cmp al, [len_of_snake]
    pop ax
    jc draw_snake_vert
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
    mov cx, [col_pos] ; Reset the starting point of x
    inc dx ; Draw the next line down
    cmp word [row_counter], 11
    jne draw_square
    mov word [row_counter], 0
    inc dx ; Go to next line to leave a gap between squares
    mov [row_pos], dx ; Set the y pos to the current position
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

; %include "print.asm"
%include "read_disc.asm"

times 510-($ - $$) db 0
db 0x55, 0xaa

col_pos: dw 50
row_pos: dw 50

col_counter: dw 0
row_counter: dw 0

len_of_snake: dw 3
squares_drawn: dw 0

direction: db 's'