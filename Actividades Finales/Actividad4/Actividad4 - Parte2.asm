.MODEL SMALL
.STACK
.DATA
    NUM     DB  5       ; Numero para calcular el factorial
    FACT    DW  1       ; Variable para almacenar el factorial   
    
    MSG     DB  'Factorial Calculado: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AL, NUM        ; Mover el numero al registro AL
    MOV BL, AL         ; Guardar el valor en BL para el ciclo

FACTORIAL_LOOP:
    CMP BL, 1          
    JE  END_LOOP       

    MOV AX, FACT       ; Cargar el valor actual de FACT en AX
    MUL BL             ; Multiplicar AX por BL (AX = AX * BL)
    MOV FACT, AX       ; Guardar el nuevo valor en FACT

    DEC BL             ; Decrementar BL (BL = BL - 1)
    JNZ FACTORIAL_LOOP 

END_LOOP:                                       
    MOV AH, 09H
    LEA DX, MSG
    INT 21H

    MOV AX, FACT
    CALL PRINT_DECIMAL ; Llamar a una rutina para mostrar el valor en decimal

    ; Finalizar el programa
    MOV AX, 4C00H
    INT 21H

MAIN ENDP

; Rutina para mostrar un numero en decimal
PRINT_DECIMAL PROC
    XOR CX, CX          ; Reiniciar contador de dígitos
    MOV BX, 10          ; Base decimal

CONVERT_DEC:
    XOR DX, DX          ; Limpiar DX
    DIV BX              ; Dividir AX entre 10
    PUSH DX             ; Guardar el residuo (el digito actual)
    INC CX              ; Aumentar el contador de digitos
    CMP AX, 0           ; AX es 0
    JNE CONVERT_DEC     ; Si no, seguir dividiendo

PRINT_DIGITS:
    POP DX              ; Obtener el digito del stack
    ADD DL, '0'         ; Convertirlo a ASCII
    MOV AH, 02H         ; Funcion de imprimir un caracter
    INT 21H             ; Llamar a la interrupcion para mostrar el digito
    LOOP PRINT_DIGITS   ; Repetir para todos los digitos

    RET
PRINT_DECIMAL ENDP
END MAIN
