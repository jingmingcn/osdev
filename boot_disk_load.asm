; Read some sectors from the boot disk using our disk_read function
[org 0x7c00]
    mov [BOOT_DRIVE], dl            ; BIOS stores our boot drive in DL,
                                    ; so it's best to remember this for later

    mov bp, 0x8000                  ; Here we set our stack safely out of the way
    mov sp, bp                      ; at 0x8000

    mov bx, 0x9000                  ; Load 2 sectors to 0x0000(ES):0x9000(BX)
    mov dh, 2                       ; from the boot disk
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov dx, [0x9000]                ; Print out the first loaded word, which
    call print_hex                  ; we expect to be 0xdada, stored at address 0x9000

    mov dx, [0x9000 + 512]          ; also, print the first word from the 2nd loaded sector:
    call print_hex                  ; should be 0xface

    jmp $

%include "print_string.asm" 
%include "print_hex.asm"
%include "disk_load.asm"

; Global variables 
BOOT_DRIVE: db 0

times 510-($-$$) db 0 
dw 0xaa55

; We know that BIOS will load only the first 512-byte sector from the disk, 
; so if we purposely add a few more sectors to our code by repeating some
; familiar numbers, we can prove to ourselfs that we actually loaded those 
; additional two sectors from the disk we booted from.

times 256 dw 0xdada
times 256 dw 0xface
