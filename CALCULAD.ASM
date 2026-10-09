.MODEL SMALL
.STACK 100H

.DATA
    NUM DB 5 DUP (?)
    E DB "    $"
    MSG_MENU DB 10, 13, "--- CALCULADORA ---", 10, 13
             DB "1. Suma", 10, 13
             DB "2. Resta", 10, 13
             DB "3. Multiplicacion", 10, 13
             DB "4. Division", 10, 13
             DB "5. Salir", 10, 13
             DB "Elige una opcion: $"
    MSG_NUM1 DB 10, 13, "Ingresa el primer numero (0-9999): $"
    MSG_NUM2 DB 10, 13, "Ingresa el segundo numero (0-9999): $"
    MSG_RES  DB 10, 13, "El resultado es: $"
    MSG_ERR  DB 10, 13, "Opcion no valida. Intenta de nuevo.$"
    MSG_SALIR DB 10, 13, "Saliendo del programa...$"

.CODE
INICIO PROC
    MOV AX, @DATA
    MOV DS, AX

MENU_LOOP:
    ; Mostrar menú
    LEA DX, MSG_MENU
    CALL IMP_CADENA

    ; Leer opción del usuario
    MOV AH, 01H
    INT 21H
    MOV BL, AL          ; Guardar opción en BL

    ; Verificar si es salir
    CMP BL, '5'
    JE SALIR

    ; Pedir primer número
    LEA DX, MSG_NUM1
    CALL IMP_CADENA
    CALL RECIBE_DATO
    MOV BP, SI          ; Guardar num1 en BP

    ; Pedir segundo número
    LEA DX, MSG_NUM2
    CALL IMP_CADENA
    CALL RECIBE_DATO
    MOV DI, SI          ; Guardar num2 en DI

    ; Evaluar operación
    CMP BL, '1'
    JE SUMAR
    CMP BL, '2'
    JE RESTAR
    CMP BL, '3'
    JE MULTIPLICAR
    CMP BL, '4'
    JE DIVIDIR
    JMP OPCION_INVALIDA

SUMAR:
    MOV AX, BP
    ADD AX, DI
    JMP IMPRIMIR

RESTAR:
    MOV AX, BP
    SUB AX, DI
    JMP IMPRIMIR

MULTIPLICAR:
    MOV AX, BP
    MUL DI              ; AX = AX * DI
    JMP IMPRIMIR

DIVIDIR:
    MOV AX, BP
    MOV DX, 0
    DIV DI              ; AX = AX / DI
    JMP IMPRIMIR

IMPRIMIR:
    LEA DX, MSG_RES
    CALL IMP_CADENA
    CALL IMP_AX         ; Imprime el resultado que está en AX
    JMP MENU_LOOP

OPCION_INVALIDA:
    LEA DX, MSG_ERR
    CALL IMP_CADENA
    JMP MENU_LOOP

SALIR:
    LEA DX, MSG_SALIR
    CALL IMP_CADENA
    MOV AH, 4CH
    INT 21H
INICIO ENDP

; --- FUNCIONES DE LA PROFESORA ---
IMP_CADENA PROC
    PUSH AX
    MOV AH, 9
    INT 21H
    POP AX
    RET 
IMP_CADENA ENDP

RECIBE_DATO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI
    
    MOV AX, @DATA
    MOV DS, AX
       
    LEA DI, NUM 
    MOV CL, 4
  S1:
    MOV AH, 1H
    INT 21H
    CMP AL, 0DH
    JE S2
    MOV [DI], AL
    DEC CL 
    INC DI
    CMP CL, 0
    JE S2
    JMP S1
  S2:
    MOV CL, 24H
    MOV [DI], CL
       
    MOV BX, 0
    MOV CX, 0
    MOV SI, DI
    LEA DI, NUM
    MOV CX, 1
  E3:
    DEC SI
    MOV AH, 0
    MOV AL, [SI]
    SUB AL, 30H
    MOV DX, 0
    MUL CX
    ADD BX, AX
    MOV DX, 0
    MOV AX, CX
    MOV CX, 10
    MUL CX
    MOV CX, AX
    CMP DI, SI
    JNE E3  
    MOV SI, BX
        
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
RECIBE_DATO ENDP

IMP_AX PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH AX
    MOV AX, @DATA
    MOV DS, AX
    POP AX

    MOV BX, 10
    LEA SI, E
    ADD SI, 3
                        
  CICLO:
    MOV DX, 0
    DIV BX
    ADD DL, 30H
    MOV [SI], DL
    DEC SI
    CMP AX, 0
    JNE CICLO                         
    
    LEA DX, E
    MOV AH, 9H
    INT 21H
    
    POP SI
    POP DX
    POP CX
    POP BX
    RET
IMP_AX ENDP

END INICIO
