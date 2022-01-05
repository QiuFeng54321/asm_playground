%include 'global_defs.nasm'

section .data
hi db 'hi', 0xa
hex dq 0x2bf23de6
hex_digit db 0xd

section .text
    global _main
_main:
    print_str hi, 3
    print_hex hex, 4
    exit 0