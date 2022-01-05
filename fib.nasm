%include 'global_defs.nasm'

section .data
newline db 0xa
test_hex dq 0x123abcde
num dq 0

section .text
    global _main
_main:
    print_hex test_hex, 4
    print_str newline, 1
    mov arg1, 50
    call fib
    mov [num], rax
    print_hex num, 8
    exit 0
fib:                                ; arg1: num (max 16^8)
    push rbx
    push rcx
    mov rax, 1
    mov rbx, 1
    mov rcx, 0
    dec arg1
    .lp:
        ; mov rax, rbx
        add rax, rcx
        mov rcx, rbx
        mov rbx, rax
        ; .b: mov [num], rax
        ; print_hex num, 8
        ; print_str newline, 1
        dec arg1
        cmp arg1, 0
        jle .endlp
        jmp .lp
    .endlp:
    pop rcx
    pop rbx
    ret
