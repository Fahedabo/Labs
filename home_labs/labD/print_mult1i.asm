section .data
    format db "%02hhx", 0   ; Format string for printing a single byte in hexadecimal
    newline db 0xA      ; Newline character string
    x_struct: db 5
    x_num: db 0xaa, 1, 2, 0x44, 0x4f
    input_buffer TIMES 600 DB 0 ; create buffer and all the values is 0

section .text
    global main
    global getmulti
    global print_multi
    extern printf
    extern fgets
    extern stdin

getmulti:

    push dword[stdin]
    push 600
    push input_buffer
    call fgets
    add esp,12

print_multi:
    push ebp
    mov ebp, esp

    mov esi, [ebp + 8]      ; Get the pointer to struct multi from the function argument
    mov edi, byte[esi]          ; Move the size value to ecx


    loop_start:
        test edi, edi           ; Check if eax is zero
        jz loop_end             ; Jump to loop_end if eax is zero

        dec edi                 ; Decrement eax to get the correct index

        mov dl, [esi + edi + 1] ; Move the byte at num[eax] to dl
        push edx               ; Push the byte onto the stack
        push format             ; Push the format string onto the stack
        call printf             ; Call printf
        add esp, 8              ; Clean up the stack

        jmp loop_start          ; Jump to loop_start

    loop_end:
        push newline            ; Push the newline character onto the stack
        call printf             ; Call printf to print the newline
        add esp, 4              ; Clean up the stack

        pop ebp
        ret
;; for the print_multti
main:
    push ebp
    mov ebp, esp
    push x_struct
    call print_multi
    add esp, 4
    
    pop ebp
    ret