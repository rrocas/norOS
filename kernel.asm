org 0x8000
bits 16

Start:
main_loop:
    ; Clear screen (only at start)
    cmp byte [init_done], 1
    je skip_clear
    mov ah, 0x06
    mov al, 0
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    mov byte [init_done], 1
skip_clear:

    ; Print logo (only at start)
    cmp byte [logo_done], 1
    je skip_logo
    mov si, message
    call print_string
    mov byte [logo_done], 1
skip_logo:

    ; Show prompt
    call draw_prompt

    ; Keyboard input loop
    mov si, 0x9000          ; input buffer start
listen_loop:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D            ; Enter pressed
    je end_input
    mov [si], al
    inc si
    mov ah, 0x0E
    int 0x10
    jmp listen_loop

end_input:
    mov byte [si], 0        ; end of string

    ; Compare command
    mov si, 0x9000          ; buffer start
    mov di, cmd_quit
    call compare_cmd
    cmp ax, 1
    je do_quit

    ; If command doesn't match, clear buffer and show prompt again
    jmp main_loop

do_quit:
    mov ah, 0x4C
    int 0x21                ; exit program

; -----------------------------
; Print string routine
; -----------------------------
print_string:
    lodsb
    cmp al, 0
    je ret_string
    mov ah, 0x0E
    int 0x10
    jmp print_string
ret_string:
    ret

; -----------------------------
; Draw prompt routine
; -----------------------------
draw_prompt:
    mov al, 0x0D
    mov ah, 0x0E
    int 0x10
    mov al, 0x0A
    int 0x10
    mov al, '#'
    int 0x10
    ret

; -----------------------------
; Command comparison logic
; -----------------------------
compare_cmd:
    mov ax, 1
cmp_loop:
    lodsb
    mov bl, [di]
    cmp al, bl
    jne cmp_fail
    cmp al, 0              ; end of string
    je cmp_succ
    inc di
    jmp cmp_loop
cmp_fail:
    xor ax, ax
    ret
cmp_succ:
    mov ax, 1
    ret

; -----------------------------
; Data
; -----------------------------
message db 'norOS',0
cmd_quit db 'quit',0
init_done db 0
logo_done db 0
