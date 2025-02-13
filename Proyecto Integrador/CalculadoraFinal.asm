;Hecho por Juan Antonio Perez Juarez
;INCO 215660996
.model small
.stack 100h
.data
    ; Datos del programa 1 (Calculadora)
    msg1 db 10,13,'Ingrese el primer numero: $'
    msg2 db 10,13,'Ingrese el segundo numero: $'
    msgSuma db 10,13,'Suma: $'
    msgResta db 10,13,'Resta: $'
    msgMult db 10,13,'Multiplicacion: $'
    msgDiv db 10,13,'Division: $'
    msgPot db 10,13,'Potencia: $'
    num1 db ?
    num2 db ?
    result dw ?

    ; Datos del programa 2 (angulo y trigonometria)
    msgAng db 10,13,'Ingrese un angulo en grados (0-90): $'
    msgSeno db 10,13,'Seno: $'
    msgCoseno db 10,13,'Coseno: $'
    msgGrafica db 10,13,'Grafica de Seno y Coseno: $'
    msgLinea db ' * $'
    msgEspacio db ' $'
    anguloGrados db ?
    resultadoSeno dw 0
    resultadoCoseno dw 0

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Ejecutar el primer programa (Calculadora)
    call calculadora
    

    ; Ejecutar el segundo programa (angulo y trigonometría)
    call angulo_trigonometria

    ; Terminar el programa
    jmp fin

; --- Calculadora ---
calculadora proc
    ; Mostrar mensaje para primer numero
    lea dx, msg1
    mov ah, 09h
    int 21h

    ; Leer primer numero
    mov ah, 01h
    int 21h
    sub al, 30h
    mov num1, al

    ; Mostrar mensaje para segundo numero
    lea dx, msg2
    mov ah, 09h
    int 21h

    ; Leer segundo numero
    mov ah, 01h
    int 21h
    sub al, 30h
    mov num2, al
    
    ; Suma
    lea dx, msgSuma
    mov ah, 09h
    int 21h
    mov al, num1
    add al, num2
    mov ah, 0
    mov result, ax
    call mostrar_resultado

    ; RESTA
    lea dx, msgResta
    mov ah, 09h
    int 21h
    
    mov al, num1
    sub al, num2
    mov ah, 0
    mov result, ax
    call mostrar_resultado
    
    ; MULTIPLICACION
    lea dx, msgMult
    mov ah, 09h
    int 21h
    
    mov al, num1
    mul num2
    mov result, ax
    call mostrar_resultado
    
    ; DIVISION
    lea dx, msgDiv
    mov ah, 09h
    int 21h
    
    mov ax, 0
    mov al, num1
    div num2
    mov ah, 0
    mov result, ax
    call mostrar_resultado
    
    ; POTENCIA
    lea dx, msgPot
    mov ah, 09h
    int 21h
    
    mov cx, 0
    mov cl, num2
    mov ax, 1
    mov bl, num1
    
    cmp cl, 0
    je fin_potencia
    
ciclo_potencia:
    mul bl
    loop ciclo_potencia
    
fin_potencia:
    mov result, ax
    call mostrar_resultado
    

mostrar_resultado proc
    mov ax, result
    mov cx, 0
    mov bx, 10
    
convertir:
    mov dx, 0
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convertir
    
mostrar:
    pop dx
    add dl, 30h
    mov ah, 02h
    int 21h
    loop mostrar
              
    ret

; --- trigonometria ---
angulo_trigonometria proc
    ; Mostrar mensaje para angulo
    lea dx, msgAng
    mov ah, 09h
    int 21h

    ; Leer angulo
    mov ah, 01h
    int 21h
    sub al, 30h
    mov anguloGrados, al

    ; Calcular seno y coseno
    call calcular_seno_coseno

    ; Mostrar resultados
    lea dx, msgSeno
    mov ah, 09h
    int 21h
    mov ax, [resultadoSeno]
    call mostrar_resultado

    lea dx, msgCoseno
    mov ah, 09h
    int 21h
    mov ax, [resultadoCoseno]
    call mostrar_resultado

    ; Graficar seno y coseno
    call graficar_trigonometrica

    ret
angulo_trigonometria endp

    ; Procedimiento para calculo de seno y coseno
calcular_seno_coseno proc
    ; Tabla de aproximaciones para 0 a 90 grados
    xor ax, ax
    mov al, anguloGrados
    
    ; Aproximaciones de seno
    cmp al, 30
    jle seno_menor_30
    cmp al, 60
    jle seno_entre_30_60
    jmp seno_mayor_60

seno_menor_30:
    mov word ptr [resultadoSeno], 50  ; 0.5
    jmp calcular_coseno

seno_entre_30_60:
    mov word ptr [resultadoSeno], 87  ; 0.87
    jmp calcular_coseno

seno_mayor_60:
    mov word ptr [resultadoSeno], 100 ; 1.0
    jmp calcular_coseno

calcular_coseno:
    ; Aproximaciones de coseno
    cmp al, 30
    jle coseno_menor_30
    cmp al, 60
    jle coseno_entre_30_60
    jmp coseno_mayor_60

coseno_menor_30:
    mov word ptr [resultadoCoseno], 87  ; 0.87
    ret

coseno_entre_30_60:
    mov word ptr [resultadoCoseno], 50  ; 0.5
    ret

coseno_mayor_60:
    mov word ptr [resultadoCoseno], 10  ; 0.1
    ret
calcular_seno_coseno endp

; Procedimiento para graficar funciones trigonometricas
graficar_trigonometrica proc
    lea dx, msgGrafica
    mov ah, 09h
    int 21h

    ; Primera linea - eje horizontal
    mov cx, 10
grafica_eje:
    lea dx, msgEspacio
    mov ah, 09h
    int 21h
    loop grafica_eje

    ; Calcular altura de seno y coseno
    mov ax, [resultadoSeno]
    mov bl, 5
    div bl
    mov cl, al  ; Altura de linea de seno

    mov ax, [resultadoCoseno]
    mov bl, 5
    div bl
    mov ch, al  ; Altura de linea de coseno

    ; Graficar seno
    mov cx, 5
grafica_seno:
    push cx
    lea dx, msgLinea
    mov ah, 09h
    int 21h
    pop cx
    loop grafica_seno

    ; Nueva linea
    mov dl, 10
    mov ah, 02h
    int 21h

    ; Graficar coseno
    mov cx, 5
grafica_coseno:
    push cx
    lea dx, msgLinea
    mov ah, 09h
    int 21h
    pop cx
    loop grafica_coseno

    ret
graficar_trigonometrica endp

; Procedimiento para mostrar resultado
mostrar_resultadoAri proc
    mov cx, 0
    mov bx, 10
    
convertirAri:
    mov dx, 0
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convertir
    
mostrarAri:
    pop dx
    add dl, 30h
    mov ah, 02h
    int 21h
    loop mostrar

    ; Salto de linea
    mov dl, 10
    mov ah, 02h
    int 21h
    
    ret
mostrar_resultadoAri endp    

fin:
    mov ah, 4ch
    int 21h
end main
