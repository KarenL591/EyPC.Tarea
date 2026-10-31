global _start

section .data
    msg_error_1 db "Error Fatal: faltan argumentos", 10, 0
    len_1       equ $ - msg_error_1
    msg_error_2 db "Error: No se pudo abrir el archivo", 10, 0
    len_2       equ $ - msg_error_2

section .text
_start:
    push ebp
    mov  ebp, esp
    sub  esp, 20             

    cmp  dword [ebp+4], 2    
    jl   .error_1

    mov  eax, 5               
    mov  ebx, [ebp+12]        
    mov  ecx, 0               
    int  0x80
    mov  [ebp-4], eax
    test eax, eax
    js   .error_apertura      

    mov  dword [ebp-8], 0   ;lines
    mov  dword [ebp-12], 0  ;words
    mov  dword [ebp-16], 0  ;chars

.leer:
    mov  eax, 3              
    mov  ebx, [ebp-4]
    mov  ecx, [ebp-20]
    mov  edx, 1
    int  0x80
    cmp  eax, 1
    jl   .fin                 

    mov  al, [ebp-20]
    cmp  al, 10               
    je   .salto
    cmp  al, ' '
    je   .palabra
    cmp  al, 9
    je   .palabra
    inc  dword [ebp-16]       
    jmp  .leer

.salto:
    inc  dword [ebp-8] 
.palabra:
    inc  dword [ebp-12]
    inc  dword [ebp-16]
    jmp  .leer
