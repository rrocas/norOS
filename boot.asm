org 0x7C00           ; Set the origin of the bootloader in memory (BIOS loads boot sector here)
bits 16              ; We are in 16-bit real mode

Start:
    cli              ; Clear interrupts while setting up
    xor ax, ax       ; Zero out AX register
    mov ds, ax       ; Set Data Segment (DS) to 0
    mov es, ax       ; Set Extra Segment (ES) to 0

    ; ------------------------------------------------
    ; Load kernel from disk using BIOS interrupt 0x13
    ; ------------------------------------------------
    mov ah, 0x02     ; BIOS function 0x02: read sectors from disk
    mov al, 1        ; Number of sectors to read = 1
    mov ch, 0        ; Cylinder = 0
    mov cl, 2        ; Sector = 2 (the kernel starts at sector 2)
    mov dh, 0        ; Head = 0
    mov dl, 0x80     ; Drive = 0x80 (first hard disk)
    mov bx, 0x8000   ; Memory address to load the kernel (segment:offset = 0x0000:0x8000)
    int 0x13         ; Call BIOS disk service
    jc load_error    ; Jump to error if Carry Flag is set (disk read failed)

    ; Jump to the kernel code we just loaded
    jmp 0x0000:0x8000

load_error:
    hlt              ; Halt CPU if loading failed

; ------------------------------------------------
; Boot sector must be exactly 512 bytes
; ------------------------------------------------
times 510-($-$$) db 0 ; Fill the remaining space with zeros
dw 0xAA55             ; Boot signature required by BIOS
