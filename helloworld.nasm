default rel
%include 'global_defs.nasm'
section .data
    msg db 'Hello World!;', 0xa, 0
    len equ $ - msg
    asterisk db '*'

section .bss
    s2 resb len


section .text
    global _main

_main:
    mov r8, s2
    mov r9, 'a'
    mov r10, msg
    .lp:
        print_str asterisk, 1
        cmp [r10], byte 0
        je .endlp
        cmp [r10], byte ';'
        jne .if
        mov [r8], byte '?'
        jmp .endif
        .if:
            ; mov rcx, [rax]
            mov [r8], r9
        .endif:
        inc r10
        inc r8
        inc r9
        jmp .lp
    .endlp:
    print_str s2, len

    exit 0
    
