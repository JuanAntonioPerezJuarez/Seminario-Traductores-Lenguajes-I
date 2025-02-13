.model small
.stack 100h
.data
    msg1 db 10,13,'Ingrese un angulo en grados (0-90): $'
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
    
    ; Mostrar mensaje para ángulo
    lea dx, msg1
    mov ah, 09h
    int 21h
    
    ; Leer ángulo
    mov ah, 01h
    int 21h
    sub al, 30h
    mov anguloGrados, al

    ; Calcular seno y coseno mediante tablas de aproximación
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

    jmp fin

; Procedimiento para cálculo de seno y coseno
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

; Procedimiento para graficar funciones trigonométricas
graficar_trigonometrica proc
    lea dx, msgGrafica
    mov ah, 09h
    int 21h

    ; Primera línea - eje horizontal
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
    mov cl, al  ; Altura de línea de seno

    mov ax, [resultadoCoseno]
    mov bl, 5
    div bl
    mov ch, al  ; Altura de línea de coseno

    ; Graficar seno
    mov cx, 5
grafica_seno:
    push cx
    lea dx, msgLinea
    mov ah, 09h
    int 21h
    pop cx
    loop grafica_seno

    ; Nueva línea
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
mostrar_resultado proc
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

    ; Salto de línea
    mov dl, 10
    mov ah, 02h
    int 21h
    
    ret
mostrar_resultado endp

fin:
    mov ah, 4ch
    int 21h
end main