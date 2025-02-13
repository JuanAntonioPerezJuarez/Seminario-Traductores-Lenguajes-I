.MODEL SMALL
.STACK 100H
.DATA
    ;Mensaje
    MSG DB "Este programa fue Muy dificil de realizar, profe... Plis, piedad&"
    
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ;CLS
    MOV AH, 06H    
    MOV AL, 0      
    MOV BH, 02H    
    MOV CH, 0      
    MOV CL, 0      
    MOV DH, 24     
    MOV DL, 79     
    INT 10H        
    
    
    
    MOV AH, 02H    ;Posicion del Cursos
    MOV BH, 0      
    MOV DH, 12     
    MOV DL, 15     
    INT 10H        
    
    ;Imprimir mensaje
    MOV AH, 09H    
    LEA DX, MSG    
    INT 21H        
    
    
    MOV AH, 01H
    INT 21H
    
    ;Regresa el control al SO
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN