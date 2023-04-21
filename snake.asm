[org 0x7C00]

call disc_load

cont_loop:
    jmp $


%include "print.asm"
%include "read_disc.asm"


times 510-($ - $$) db 0
db 0x55, 0xaa

times 512 db 0