default rel
%define print 0x02000004
%define exit_ 0x02000001
%define arg1 rdi
%define arg2 rsi
%define arg3 rdx
%macro print_str 2
        push rax
        push arg1
        push arg2
        push arg3
        mov rax, print
        mov arg1, 1
        mov arg2, %1
        mov arg3, %2
        syscall
        pop arg3
        pop arg2
        pop arg1
        pop rax
%endmacro
%macro exit 1
    mov rax, exit_
    mov rdi, %1
    syscall
%endmacro

section .data
    test_str db 'test', 0xa
    zero_char db '0'
    W_char db 87
section .bss
    hex_digit_char resb 1

section .text
print_hex_digit:                        ; arg1: digit
    push rax
    mov rax, [arg1]          ; rax = *arg1
    and rax, 0xf
    cmp rax, 10                        ; if arg1 >= 10:
    jge .af                             ;   goto .af
    jmp .digit                          ; else goto .digit
    .af:
        add rax, [W_char]               ; rax += W_char (87)
        jmp .endif                      ; goto .endif
    .digit:
        add rax, [zero_char]            ; rax += zero_char
    .endif:
    ; and rax, 0fh
    mov [hex_digit_char], rax
    print_str hex_digit_char, 1                    ; print(rax)
    pop rax
    ret
print_hex:                              ; arg1: num, arg2: len
    push rbx
    push rdx
    mov rbx, arg1
    ; and rbx, byte 0xf
    ; shr rcx, 4
    mov rdx, 0
    .lp:
        ; push arg1
        ; ; print_str test_str, 4
        ; mov arg1, rcx         ; print(rdx, 1)
        ; call print_hex_digit
        ; shr byte [rcx], 4                 ; rdx &= 0b1111
        ; mov arg1, rcx                ; print(rdx, 1)
        ; call print_hex_digit
        ; pop arg1
        ; shr byte [rcx], 4
        ; add byte [r10], byte 48
        ; mov rcx, current_digit
        ; mov rcx, [rax]
        mov arg1, rbx
        call print_hex_digit
        shr byte [rbx], 4
        ; and byte [rbx], byte 0xf
        mov arg1, rbx
        call print_hex_digit
        inc rbx
        add rdx, 2                         ; rcx ++
        cmp rdx, arg2                   ; if rcx <= arg1:
        jge .endlp                       ;   break
        jmp .lp                         ; continue
    .endlp:
    pop rdx
    pop rcx
    ret