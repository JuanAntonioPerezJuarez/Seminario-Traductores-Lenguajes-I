PAGE 60,132

TITLE SEGMENTO_DE_DATOS
.MODEL SMALL
.STACK 64

.DATA
DAT1    DB      05H
DAT2    DB      10H
DAT3    DB      ?         ; Lugar para almacenar el resultado
TIME    EQU     10        ; Valor constante

.CODE
MAIN PROC FAR
    MOV AX, @DATA         ; Inicializa el segmento de datos
    MOV DS, AX

    MOV AL, DAT1          ; Mueve el valor de DAT1 a AL (registro de 8 bits)
    ADD AL, DAT2          ; Suma DAT2 al contenido de AL
    MOV DAT3, AL          ; Guarda el resultado en DAT3
    
    MOV AH, TIME          ; Mueve el valor constante de TIME a AH
    MOV AX, 4C00H         ; Termina el programa
    INT 21H
MAIN ENDP
END MAIN
