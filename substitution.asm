.Model SMALL   ;programm size will be less than or equal to 64k

.STACK  100 ;  size of the stack in  the programm

.DATA   ;beginning of the data segment label


ENC   DB  71h,77h,65h,72h,74h,79h,75h,69h,6Fh,70h,61h,73h,64h,66h,67h,68h,6Ah,6Bh,6Ch,7Ah,78h,63h,76h,62h,6Eh,6Dh

IMSG DB "Enter your input string:$"
EMSG DB "Encrypted:$"
DMSG DB "Decrypted (Assuming the input is already encrypted):$"  
OMSG DB "Original message after decrypting:$"  

EOUT DB 32 dup(0)
DOUT DB 32 dup(0)
OOUT DB 32 dup(0)

NLINE DB 13,10, '$'


buff        db  32        ;MAX NUMBER OF CHARACTERS ALLOWED (32).
            db  ?         ;NUMBER OF CHARACTERS ENTERED BY USER.
            db  32 dup(0) ;CHARACTERS ENTERED BY USER.

.CODE

    MOV AX,@DATA ; we are loading the base adress of . DATA label
                 ; into register AX                           
    MOV DS,AX    ;initialise data segment to the .DATA label
       
main:LEA DX,IMSG   ; offset of the message to DX
    CALL OutString
    
    MOV AH, 0Ah   ; capture string from keyboard
    LEA DX, buff
    INT 21h         ; calling MS-DOS API
      
    CALL NewLine
    
    MOV CL,buff+1    ; CL = number of input characters
    MOV CH,0
    
    MOV SI, offset buff+2   ; SI points to the beginning of the input string
    MOV AH,0  
    MOV DI,0         
           
loop1: MOV AL, [si]      ; read the character, input for Encrypt and Decrypt
       LEA DX,EOUT ; this defines the output location of Encrypt function, EOUT (Ecrypted Output)
       CALL Encrypt
       LEA DX,DOUT ; this defines the output location of Decrypt function, DOUT (Decrypted Output)
       CALL Decrypt
       
       MOV AL, EOUT[DI]  ; input for Decrypt is the output of Encrypt
       LEA DX, OOUT      ; output of Decrypt pointed to OOUT (Original Output) 
       CALL Decrypt       
       
       INC SI            ; increasing SI to point to the next char 
       INC DI            ; increasing DI to point to the next empty char
       LOOP loop1        ; looping over the string 
                   
    
    ; adding '$' to EOUT,DOUT and OOUT (end of string so that we can print it)
    MOV EOUT[DI+1],'$'   
    MOV DOUT[DI+1],'$'
    MOV OOUT[DI+1],'$'
    
    ; printing outputs
    
    LEA DX,EMSG                ; loading string address into DX
    CALL OutString             ; calling OutString procedure
    LEA DX,EOUT 
    CALL OutString 
    
    CALL NewLine
    
    LEA DX,DMSG
    CALL OutString
    LEA DX,DOUT 
    CALL OutString    
    
    CALL NewLine
    
    LEA DX,OMSG
    CALL OutString
    LEA DX,OOUT 
    CALL OutString    
    
    CALL NewLine
    CALL NewLine               
    
jmp main   
        
ret
 
PROC Encrypt NEAR
    PUSH AX
    PUSH BX
    SUB AL, 61h       ; index relative to 'a'
    LEA BX, ENC       ; table B contains the encrypted characters
    XLATB
    MOV BX,DX             
    MOV BX[DI],AL   ; save into output buffer
    POP BX                   
    POP AX
    RET
ENDP Encrypt

PROC Decrypt NEAR  ; DX = output buffer offset / DI = output buffer index
    PUSH AX
    PUSH CX
    PUSH SI
    PUSH BX
    
    MOV SI,0
    LEA BX,ENC
    MOV CL,26
    
loop2: CMP ENC[SI], AL ; comparing AL with the look up table elements (searching the encrypted table for the character) 
       JE found
       INC SI
       LOOP loop2 
found: MOV AX,SI ; AL = index of the character in the encryption table
       ADD AL,61h ; convert to corresponding decrypted character (add 'a')
       MOV BX,DX
       MOV [BX+DI],AL ; saving into output buffer
    
    POP BX         
    POP SI
    POP CX
    POP AX
    RET
ENDP Decrypt

 
PROC NewLine NEAR
    LEA DX,NLINE
    MOV AH,09H
    INT 21h  
    RET
ENDP NewLine  


PROC OutChar NEAR     ; character is in DL
    MOV AH,02H
    INT 21H 
    RET
ENDP OutChar  

PROC OutString NEAR   ; offset of msg is in DX
    MOV AH,09H
    INT 21H 
    RET
ENDP OutString