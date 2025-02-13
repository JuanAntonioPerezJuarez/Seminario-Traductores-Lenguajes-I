M_XDATA SEGMENT 
      
      ALGDGADU DB ? ; Numero ingresado por el usuario
      OUTER_FACT DW ? ; Resultado del factorial
      WELCOME DB "BIENVENIDO, PROGRAMA PARA CALCULAR FACTORIAL DE NUMERO DE 1 DIGITO",10,13,24H
      WOW64 DB "Ingrese Numero: ",10,13,24H 
      EQUAL DB "!= --GUARDADO EN VARIABLE 'OUTER_FACT'--$",  
       
M_XDATA ENDS

FULLCODE SEGMENT
    
ASSUME CS:FULLCODE, DS:M_XDATA        

START:  
    MOV AX, M_XDATA
    MOV DS, AX
               
    MOV DX, OFFSET WELCOME
    MOV AH, 09H
    INT 21H
               
    MOV DX, OFFSET WOW64
    MOV AH, 09H
    INT 21H
               
    MOV AH, 1H
    INT 21H
    MOV BX, OFFSET ALGDGADU
    SUB AL, 30H
    MOV [BX], AL
               
    CMP AL, 01H
    JBE NEXTQ
                                              
    MOV AX, 1       
    MOV BL, ALGDGADU
    MOV BH, 0H
                
    CALL $FACTORIAL
    MOV OUTER_FACT, AX  ; Guardar el resultado en OUTER_FACT
                
    LEA DX, EQUAL
    MOV AH, 09H
    INT 21H 

    ; Mostrar el factorial en decimal
    MOV AX, OUTER_FACT
    CALL PRINT_DECIMAL

    ; Terminar el programa
    MOV AH, 4CH
    INT 21H

$FACTORIAL PROC
    CMP BX, 1
    JE HVOC
    PUSH BX
    DEC BX
    CALL $FACTORIAL
    POP BX
    MUL BX
HVOC:                         
    RET
$FACTORIAL ENDP 

PRINT_DECIMAL PROC
    XOR CX, CX
    MOV BX, 10   ; Base decimal

CONVERT_DEC:
    XOR DX, DX
    DIV BX       ; Dividir AX entre 10
    PUSH DX      ; Guardar el digito (residuo)
    INC CX
    CMP AX, 0
    JNE CONVERT_DEC

PRINT_DIGITS:
    POP DX       ; Obtener el dígito
    ADD DL, '0'  ; Convertir a ASCII
    MOV AH, 02H
    INT 21H      ; Imprimir el digito
    LOOP PRINT_DIGITS

    RET
PRINT_DECIMAL ENDP

FULLCODE ENDS
                                 
NEXTQ:
    MOV AH, 02H
    MOV DL, '!'
    INT 21H
    MOV AH, 02H
    MOV DL, '='
    INT 21H
    MOV AH, 02H
    MOV DL, '1'
    INT 21H 
                                
END START
