org 0x7c00

start:

LOADER_ORIG_ADDR equ 0x100
LOADER_ORIG_SECTOR equ 0x1A

pushad
pushf

mov ah, 0x42 ; Read Sectors From Drive
lea si, [DAP]
int 0x13

jmp far 0x0:LOADER_ORIG_ADDR     ; jump to MBR

; With LBA support
; http://en.wikipedia.org/wiki/INT_13H#INT_13h_AH.3D41h:_Check_Extensions_Present
DAP:
db 0x10
db 0
dw 1
dw LOADER_ORIG_ADDR ; sector
dw 0x0000  ; destination segment (0)
dq LOADER_ORIG_SECTOR  ; segment

; Structure of a modern standard MBR
; Bootstrap code area (part 1)
X db (218 - X + start) dup (0)

