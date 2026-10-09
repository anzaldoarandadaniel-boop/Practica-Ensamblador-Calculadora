.MODEL SMALL
.DATA
     NUM DB 5 DUP (?)
     E DB "    $"
    
.CODE
   PUBLIC IMP_CADENA
   PUBLIC RECIBE_DATO
   PUBLIC IMP_AX
  INICIO:

  IMP_CADENA PROC FAR
     PUSH AX
     MOV AH,9
     INT 21H
     POP AX
     RET 
  IMP_CADENA ENDP

  RECIBE_DATO PROC FAR
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH DI
    
            MOV AX,@DATA
            MOV DS,AX
       
 
            LEA DI,NUM 
            MOV CL,4
          S1:
            MOV AH,1H
            INT 21H
            CMP AL,0DH
            JE S2
            MOV [DI],AL
            DEC CL 
            INC DI
            CMP CL,0
            JE S2
            JMP S1
          S2:
            MOV CL,24H
            MOV [DI],CL
           

            MOV BX,0
            MOV CX,0
      
            
            MOV SI,DI
            LEA DI,NUM
            MOV CX,1
      
          E3:
            DEC SI
            MOV AH,0
            MOV AL,[SI]
            SUB AL,30H
            MOV DX,0
            MUL CX
            ADD BX,AX
            MOV DX,0
            MOV AX,CX
            MOV CX,10
            MUL CX
            MOV CX,AX
            CMP DI,SI
            JNE E3  
            MOV SI,BX
            
       POP DI
       POP DX
       POP CX
       POP BX
       POP AX
       RET
    RECIBE_DATO ENDP

   IMP_AX PROC FAR
     
      PUSH BX
      PUSH CX
      PUSH DX
      PUSH SI
      PUSH AX
            MOV AX,@DATA
            MOV DS,AX
            POP AX

            MOV BX,10
            LEA SI,E
            ADD SI,3
                        
      CICLO:
            MOV DX,0
            DIV BX
            ADD DL,30H
 
            MOV [SI],DL
            DEC SI
            
            CMP AX,0
            JNE CICLO                         
    
            LEA DX,E
            MOV AH,9H
            INT 21H
      POP SI
      POP DX
      POP CX
      POP BX
     
      RET
    IMP_AX ENDP
END INICIO
 

