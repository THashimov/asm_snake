[org 0x7C00]

call disc_load

mov ah, 0x0 ; Set graphical mode
mov al, 0x13 ; 320x200 screen
int 0x10

draw_pixel:
    mov ah, 0xC
    mov dx, 50
    mov cx, 50
    mov al, 0xF
    int 0x10


cont_loop:
    jmp $


%include "print.asm"
%include "read_disc.asm"


times 510-($ - $$) db 0
db 0x55, 0xaa

times 512 db 0