org 0x8000           ; The kernel is loaded at memory address 0x8000 by the bootloader
bits 16              ; 16-bit real mode instructions

Start:
    ; ------------------------------------------------
    ; Print characters to the screen using BIOS teletype
    ; ------------------------------------------------
    mov ah, 0x0E     ; BIOS function 0x0E: teletype output (prints AL and advances cursor)
    
    mov al, 'n'      ; Character to print
    int 0x10         ; Call BIOS video interrupt
    
    mov al, 'o'      ; Next character
    int 0x10
    
    mov al, 'r'      ; Next character
    int 0x10
    
    mov al, 'O'      ; Next character
    int 0x10
    
    mov al, 'S'      ; Next character
    int 0x10

    ; ------------------------------------------------
    ; Stop execution
    ; ------------------------------------------------
    hlt              ; Halt CPU; nothing else to execute
