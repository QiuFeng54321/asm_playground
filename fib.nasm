%include 'global_defs.nasm'

section .data
hi db 'hi', 0xa
hex dq 0xf24d
hex_digit db 0xd

section .text
    global _main
_main:
    mov arg1, hex_digit
    call print_hex_digit
    print_str hi, 3
    ; mov arg1, hex
    ; call print_hex_digit
    mov arg1, hex
    mov arg2, 4
    call print_hex
    exit 0