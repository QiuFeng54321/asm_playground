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
%macro print_hex 2
        push arg1
        push arg2
        mov arg1, %1
        mov arg2, %2
        call _print_hex
        pop arg2
        pop arg1
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
print_hex_digit:                        ; arg1: *digit
    push rbx
    mov rbx, [arg1]                     ; *hex_digit_char = *arg1
    mov [hex_digit_char], rbx
    pop rbx
    and [hex_digit_char], byte 0xf      ; hex_digit_char &= 0b1111
    cmp [hex_digit_char], byte 10       ; if hex_digit_char < 10:
    jl .endif                           ;   goto .endif
    add [hex_digit_char], byte 39       ; hex_digit_char += 39 ('W' - '0')
    .endif:
        add [hex_digit_char], byte '0'  ; hex_digit_char += '0'
    print_str hex_digit_char, 1         ; print_str(hex_digit_char)
    ret
_print_hex:                             ; arg1: *num, arg2: size (bytes)
    push rdx
    mov rdx, arg1                       ; rdx = arg1
    add arg1, arg2                      ; arg1 += arg2 - 1
    dec arg1
    .lp:
        ror byte [arg1], 4              ; *arg1 >>> 4
        call print_hex_digit            ; print_hex_digit(arg1)
        ror byte [arg1], 4              ; *arg1 >>> 4
        call print_hex_digit            ; print_hex_digit(arg1)
        dec arg1                        ; arg1 --
        cmp arg1, rdx                   ; if arg1 < rdx:
        jl .endlp                       ;   break
        jmp .lp                         ; continue
    .endlp:
    pop rdx
    ret