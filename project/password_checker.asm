ORG 0x100

MBR_SECTOR equ 0x19
MBR_ADDRESS equ 0x7c00

PASSWORD equ 0x9752 ;ASCII '123'

; Print  'Please, input password!'
lea si, [enter_password_db]
call print_string
call new_line


; Read password string
lea    di, [password_db]
mov    cx, password_size_db
call   get_string
call   new_line

; Calculate and check the password

mov eax, password_size_db
lea esi, [password_db]

push  eax
push  esi

call calc_crc16

;Check
cmp ax, PASSWORD

je if_true_password

; If wrong password
lea si, [error_password_db]
call    print_string
call    new_line
call    get_chr
int     0x19

; If correct password
if_true_password:
lea si, [success_password_db]
call    print_string
call    new_line
call    get_chr

; Load original MBR.....
mov dl,  0x80 ;hard drive 0
mov ah,  0x42
lea esi, [MBR_DAP]
int      0x13
jc       error

popf
popad

; Jump to original MBR
jmp 0:MBR_ADDRESS


;-------------------------------- functions ------------------------------
; alias for '\n'
new_line:
    push si
    lea  si, [new_line_db]
    call print_string
    pop  si
    ret

get_chr:
    mov ah, 0
    int 0x16
    ret

error:
    lea  esi, [error_message_db]
    call print_string
    call get_chr
    int  0x19 ;reboot
    ret

print_string:
    lodsb
    test al, al
    jz   exit_print_string
    mov  ah, 0xE
    int  0x10
    jmp  print_string
exit_print_string:
    ret

; Read user input
get_string:
    mov  ah, 0
    int  0x16
    cmp  al, 0xD
    jz   exit_get_string
    stosb
    mov  al, '*'
    mov  ah, 0xE
    int  0x10
    loop get_string
exit_get_string:
    ret
;-------------------------------- functions ------------------------------

; data
true_password equ 0xE81D
new_line_db db 13, 10, 0
enter_password_db   DB  'Please, input password!', 0
error_message_db   DB  'Error load mbr from drive!', 0
success_password_db   DB  'Good job! Press any key to start windows...', 0
error_password_db   DB  'Invalid password! Press any key...', 0

password_db DB 3 DUP(0)
password_size_db = $-password_db

; With LBA support
; http://en.wikipedia.org/wiki/INT_13H#INT_13h_AH.3D41h:_Check_Extensions_Present
MBR_DAP:
db 0x10
db 0
dw 1
dd MBR_ADDRESS
dq MBR_SECTOR

include "crc16.asm"
