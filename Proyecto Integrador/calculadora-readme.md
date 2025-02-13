# Calculadora en Ensamblador EMU8086

## Descripción General
Este programa implementa una calculadora básica en lenguaje ensamblador para el emulador EMU8086. La calculadora realiza automáticamente cinco operaciones aritméticas básicas (suma, resta, multiplicación, división y potencia) con dos números ingresados por el usuario.

## Estructura del Programa

### Segmento de Datos (.data)
```assembly
msg1 db 10,13,'Ingrese el primer numero: $'
msg2 db 10,13,'Ingrese el segundo numero: $'
msgSuma db 10,13,'Suma: $'
msgResta db 10,13,'Resta: $'
msgMult db 10,13,'Multiplicacion: $'
msgDiv db 10,13,'Division: $'
msgPot db 10,13,'Potencia: $'
num1 db ?    ; Almacena el primer número
num2 db ?    ; Almacena el segundo número
result dw ?  ; Almacena el resultado de las operaciones
```

#### Detalles de las Variables
- Los mensajes utilizan `10,13` para salto de línea (CRLF)
- `$` marca el final de cada cadena
- `num1` y `num2` son variables de tipo byte (db)
- `result` es una variable de tipo word (dw) para almacenar resultados más grandes

### Funcionamiento Detallado

#### 1. Inicialización
```assembly
mov ax, @data
mov ds, ax
```
- Configura el segmento de datos (DS) para acceder a las variables

x#### 2. Entrada de Datos
- **Primer Número:**
  ```assembly
  lea dx, msg1    ; Carga el mensaje
  mov ah, 09h     ; Función para imprimir cadena
  int 21h         ; Llamada al sistema
  mov ah, 01h     ; Función para leer carácter
  int 21h         ; Lee el primer número
  sub al, 30h     ; Convierte de ASCII a número
  mov num1, al    ; Almacena el número
  ```

- **Segundo Número:**
  - Proceso similar al primer número
  - El número se almacena en `num2`

#### 3. Operaciones Aritméticas

##### Suma
```assembly
mov al, num1
add al, num2     ; Suma directa de bytes
mov ah, 0        ; Limpia el registro AH
mov result, ax   ; Guarda el resultado
```

##### Resta
```assembly
mov al, num1
sub al, num2     ; Resta directa de bytes
mov ah, 0
mov result, ax
```

##### Multiplicación
```assembly
mov al, num1
mul num2         ; Multiplica AL por num2
mov result, ax   ; El resultado está en AX
```

##### División
```assembly
mov ax, 0
mov al, num1
div num2         ; Divide AL entre num2
mov ah, 0        ; Solo guardamos el cociente
mov result, ax
```

##### Potencia
```assembly
mov cx, 0        ; Contador para el bucle
mov cl, num2     ; Exponente en CL
mov ax, 1        ; Resultado inicial
mov bl, num1     ; Base en BL

ciclo_potencia:
    mul bl       ; Multiplica por la base
    loop ciclo_potencia  ; Repite según el exponente
```

#### 4. Mostrar Resultados
El procedimiento `mostrar_resultado` convierte el número a ASCII y lo muestra:

1. **Conversión a ASCII:**
   ```assembly
   mov ax, result
   mov cx, 0      ; Contador de dígitos
   mov bx, 10     ; Divisor
   
   convertir:
       mov dx, 0
       div bx     ; Divide por 10
       push dx    ; Guarda el residuo (dígito)
       inc cx     ; Incrementa contador
       cmp ax, 0  ; Verifica si quedan dígitos
       jne convertir
   ```

2. **Mostrar Dígitos:**
   ```assembly
   mostrar:
       pop dx        ; Recupera dígito
       add dl, 30h   ; Convierte a ASCII
       mov ah, 02h   ; Función para mostrar carácter
       int 21h
       loop mostrar
   ```

## Limitaciones y Consideraciones

1. **Entrada de Datos:**
   - Solo acepta números de un dígito (0-9)
   - No valida la entrada de caracteres no numéricos

2. **Operaciones:**
   - **Suma:** Limitada a resultados de 16 bits
   - **Resta:** Puede dar resultados negativos sin manejarlos adecuadamente
   - **Multiplicación:** Limitada a resultados de 16 bits
   - **División:** No maneja división por cero
   - **Potencia:** Puede desbordar con exponentes grandes

3. **Salida:**
   - No muestra signo negativo en resultados
   - No muestra decimales en división

## Requisitos Técnicos
- Emulador EMU8086
- Archivo fuente con extensión `.asm`
- Mínimo 100h de espacio en stack

## Compilación y Ejecución
1. Abrir EMU8086
2. Cargar el archivo fuente
3. Compilar (F9)
4. Ejecutar (Ctrl + F5)

## Posibles Mejoras
1. Validación de entrada de datos
2. Manejo de números negativos
3. Manejo de números decimales
4. Manejo de errores (división por cero)
5. Soporte para números de múltiples dígitos
6. Interfaz más amigable
7. Optimización del código para mejor rendimiento

## Diagrama de Flujo del Programa
```
[INICIO]
   │
   ├─► Inicialización de segmentos
   │
   ├─► Entrada primer número
   │
   ├─► Entrada segundo número
   │
   ├─► Operaciones
   │    ├─► Suma
   │    ├─► Resta
   │    ├─► Multiplicación
   │    ├─► División
   │    └─► Potencia
   │
   ├─► Mostrar resultados
   │    └─► Conversión y display
   │
   └─► [FIN]
```

## Notas Adicionales
- El programa utiliza interrupciones DOS (21h) para E/S
- Los registros principales utilizados son:
  - AX (AL/AH) para operaciones
  - BX para división en mostrar_resultado
  - CX para contadores
  - DX para mensajes y residuos

Este documento proporciona una visión completa del funcionamiento interno del programa. Para cualquier modificación o mejora, se recomienda seguir la estructura establecida y considerar las limitaciones mencionadas.

