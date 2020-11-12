
print_string:
    pusha

    loop:
        mov ax, [bx]
        mov ah, 0x0e
        cmp al, 0
        je return
        int 0x10
        add bx, 1
        jmp loop

    return:
        popa
        ret
