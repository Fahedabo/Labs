section .data
    format db "%02x", 0   ; Format string for printing a single byte in hexadecimal
    newline db 10, 0      ; Newline character string
    x_struct: db 5
    x_num: db 0xaa, 1, 2, 0x44, 0x4f

section .text
    global print_multi
    extern printf
    global main
    extern print_multi
    

print_multi:
    push ebp
    mov ebp, esp

    mov edi, [ebp + 8]      ; Get the pointer to struct multi from the function argument
    mov al, byte[edi]          ; Move the size value to ecx

    movzx ecx, al
    mov eax, 0            ; Clear eax for the loop index

loop_start:
    cmp eax, ecx            ; Compare the loop index with the size value
    jge loop_end            ; Jump to loop_end if the loop index is greater than or equal to the size

    mov dl, [edi + eax + 1] ; Move the byte at num[eax] to dl
    push edx                ; Push the byte onto the stack
    push format             ; Push the format string onto the stack
    call printf             ; Call printf
    add esp, 8              ; Clean up the stack

    inc eax                 ; Increment the loop index
    jmp loop_start          ; Jump to loop_start

loop_end:
    push newline            ; Push the newline character onto the stack
    call printf             ; Call printf to print the newline
    add esp, 4              ; Clean up the stack

    pop ebp
    ret

main:
    push ebp
    mov ebp, esp
    
    lea eax, [x_struct]
    push eax
    call print_multi
    add esp, 4

    pop ebp
    ret