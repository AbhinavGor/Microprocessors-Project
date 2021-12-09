; 8086 subroutine to encrypt/decrypt lower case characters using xlat

name "crypt"

include 'emu8086.inc'

org 100h


jmp start

;                            'abcdefghijklmnopqrstvuwxyz'

table1      db 97 dup (' '), 'klmnxyzabcopqrstvuwdefghij'

table2      db 97 dup (' '), 'hijtuvwxyzabcdklmnoprqsefg'

msg1        DB  'Enter the message: ', '$'

msg2        DB  'Encrypted message: ', '$'

msg3        DB  'Decrypted message: ', '$'

n_line      DB  0DH,0AH,'$'                 ;for new line

str         DB  256 DUP('$')                ;buffer string

enc_str     DB  256 DUP('$')                ;encrypted string

dec_str     DB  256 DUP('$')                ;decrypted string



start:

           
; print message
LEA    dx,msg1
; output of a string at ds:dx
MOV    ah,09h
INT    21h
; read the string
PUSH   CS
POP    DS
LEA    DI,str
MOV    DX,00FFH
CALL   GET_STRING
; print new line
LEA    dx,n_line
; output of a string at ds:dx
MOV    ah,09h
INT    21h                
           
                     
                     
; encrypt:
LEA    bx, table1
LEA    si, str
LEA    di, enc_str
CALL   parse
                                          
; print message
LEA    dx,msg2
; output of a string at ds:dx
MOV    ah,09h
INT    21h
; show result:
LEA    dx, enc_str
; output of a string at ds:dx
MOV    ah, 09
INT    21h
; print new line
LEA    dx,n_line
; output of a string at ds:dx
MOV    ah,09h
INT    21h     
                
           
                
; decrypt:
LEA    bx, table2
LEA    si, enc_str
LEA    di, dec_str
CALL   parse

; print message
LEA    dx,msg3
; output of a string at ds:dx
MOV    ah,09h
INT    21h
; show result:
LEA    dx, dec_str
; output of a string at ds:dx
MOV    ah, 09
INT    21h
; print new line
LEA    dx,n_line
; output of a string at ds:dx
MOV    ah,09h
INT    21h
           
           
           
; wait for any key...
mov    ah, 0
int    16h



; subroutine to encrypt/decrypt
; parameters: 
;             si - address of string to encrypt
;             bx - table to use.


;           'abcdefghijklmnopqrstvuwxyz'

;table1:    'qwertyuiopasdfghjklzxcvbnm'

;table2:    'kbumcngphqrszyijadlewgbvft'

parse proc near

next_char:
	cmp    [si], '$'      ; end of string?
	je     end_of_string
	cmp    [si], ' '
	je     skip
	
	mov    al, [si]
	cmp    al, 'a'
	jb     skip
	cmp    al, 'z'
	ja     skip	
	; xlat algorithm: al = ds:[bx + unsigned al] 
	xlatb     ; encrypt using table2.  
	mov    [di], al
	inc    di

skip:
	inc    si	
	jmp    next_char

end_of_string:
    inc    si
    mov    [si], '$'

ret
parse endp


DEFINE_GET_STRING       ;predefined macro in umu8086.inc to read a string input

END