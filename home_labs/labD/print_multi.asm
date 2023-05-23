section .data
    text db "%02hhx", 0   ; Format string for printing a single byte in hexadecimal
    newline db 0xA, 0     ; Newline character string
    x_struct: db 5
    x_num: db 0xaa, 1, 2, 0x44, 0x4f
    input_buffer TIMES 600 DB 0 ; create buffer and all the values is 0

    y_struct: db 6
    y_num: db 0xaa, 1,2,3,0x44,0x4f
    res_struct: db 0
    res_num: times 10 db 0 ; Allocate space for result array


section .text
    global main, print_multi, getmulti,GetMaxMin, add_multi
    extern printf,stdin, fgets, malloc, free

add_multi:
    ; Get pointers to the structures in eax and ebx
    mov esi, eax
    mov edi, ebx

    ; Get the maximum and minimum length pointers
    call GetMaxMin

    ; Get the lengths from the structures
    movzx ecx, byte [eax]
    movzx edx, byte [ebx]

    ; Calculate the maximum length
    movzx eax, byte [eax]
    cmp edx, eax
    cmovg eax, edx

    ; Allocate memory for the result array
    push eax
    call malloc
    add esp, 4
    mov edi, eax   ; Store the pointer to the result array in edi

    ; Initialize carry to 0
    xor ebx, ebx

    ; Perform byte-wise addition
    xor esi, esi
    xor ecx, ecx
    add_looper:
        ; Get the current elements from the arrays
        mov al, byte [esi + x_num]
        mov dl, byte [esi + y_num]

        ; Add the elements along with the carry
        add al, dl
        adc bl, 0

        ; Store the result in the result array
        mov byte [ecx + edi], al

        ; Increment the pointers and the counter
        inc esi
        inc ecx

        ; Decrement the length counter
        dec eax
        jnz add_looper

    ; Set the length of the result structure
    mov byte [edi], cl

    ; Return the pointer to the result structure
    mov eax, edi
    ret


GetMaxMin:
    mov eax, dword [eax]
    mov ebx, dword [ebx]
    
    cmp ebx, eax                ; Compare the lengths
    jg switch_ptr            ; Jump if the length in ebx is greater

    ; If eax is greater or equal, return pointers as is
    ret

switch_ptr:
    xchg ebx, eax               ; Swap the pointers
    ret

getmulti:
    push dword[stdin]
    push 600
    push input_buffer
    call fgets
    push input_buffer

    call print_multi
    add esp ,16
    
    jmp exit_func

print_multi:
    ;initiliaze new stack
    push ebp
    mov ebp, esp

    mov edi, [ebp + 8] 
    mov al, byte[edi]         

    movzx ebx, al
    movzx eax, al
    add edi, eax 

    looper:
       push dword[edi]
       push text
       call printf
       add esp, 8

       dec edi
       dec ebx
       jnz looper
       jmp exit_func

main:
    ; Call add_multi function
    mov eax, x_struct
    mov ebx, y_struct
    call add_multi

    ; Print the arrays to be added and the result
    push eax
    call print_multi
    add esp, 4
    push ebx
    call print_multi
    add esp, 4
    call print_multi

    ; Free the allocated memory
    push eax
    call free
    add esp, 4

    ; Exit the program
    mov eax, 1       ; System call number for exit
    xor ebx, ebx     ; Exit code 0
    int 0x80         ; Call the kernel      ; Call the kernel

 exit_func:
    push newline
    call printf
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

