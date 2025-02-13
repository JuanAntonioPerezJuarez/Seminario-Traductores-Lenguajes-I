.MODEL SMALL
.STACK 100H
.DATA
    N DB ?        ; Numero N
    CONTADOR DB 1 ; Contador inicial
    SUMA DW 0     ; Almacena la suma total
    MSG1 DB 'Ingrese N: $'
    MSG2 DB 10,13,'La suma es: $'
.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

    ; Pedir al usuario que ingrese N
    MOV DX, OFFSET MSG1
    MOV AH, 09H
    INT 21H

    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H 
    MOV N, AL    

    ; Comenzar la suma
SUM_LOOP:
    MOV AL, N        ; Mover N a AL
    CMP CONTADOR, AL
    JA END_SUM       
    MOV AL, CONTADOR 
    CBW              
    ADD [SUMA], AX   ; Sumar el contador a SUMA
    INC CONTADOR     ; Incrementar el contador
    JMP SUM_LOOP     ; Repetir el ciclo

END_SUM:
    ; Mostrar mensaje de resultado
    MOV DX, OFFSET MSG2
    MOV AH, 09H
    INT 21H

    ; Mostrar el resultado de la suma en decimal
    MOV AX, [SUMA]
    CALL PRINT_DECIMAL

    ; Terminar el programa
    MOV AX, 4C00H
    INT 21H

PRINT_DECIMAL PROC
    XOR CX, CX
    MOV BX, 10  ; Base decimal

CONVERT_DEC:
    XOR DX, DX
    DIV BX      ; Dividir AX entre 10
    PUSH DX     
    INC CX
    CMP AX, 0
    JNE CONVERT_DEC

PRINT_DIGITS:
    POP DX      
    ADD DL, '0' ; Convertir a ASCII
    MOV AH, 02H
    INT 21H     
    LOOP PRINT_DIGITS

    RET
PRINT_DECIMAL ENDP

END START
