
.model small
.stack 100h
.data

CR EQU 0DH
LF EQU 0AH

msg db 'CRYPTOGRAPHY $'
msg1 db CR, LF, 'Press 1 for Encryption', CR, LF, 'Press 2 for Decryption', CR, LF, 'Press 3 to Exit', CR, LF, '$'
msg2 db CR, LF, 'Invalid Input Please Try Again', '$'
msg3 db CR, LF, 'Enter message to Encrypt: ', '$'
msg4 db CR, LF, 'Encryption: ', '$'
msg5 db CR, LF, 'Enter message to Decrypt: ', '$'
msg6 db CR, LF, 'Decryption: ', '$'
msg7 db CR, LF, 'Enter Shift Gear: ', '$'

buffer db 50 dup('$')
inp db 50 dup('$')
num dw 0

.code

input proc
mov num,0
mov bx,offset inp
l1:
mov ah,01
int 21h
mov [bx],al
inc bx
cmp al,0dh
je l2
mov ah,0
mov cx,ax
mov ch,0
sub cl,48
mov ax,num
mov num,0
mov dx,10
mul dx
add ax,cx
mov num,ax
jmp l1
l2:
ret
input endp

main proc
mov ax, @data
mov ds, ax



	LEA dx, msg
	mov ah, 09		; Cryptography Message
	int 21h

	mov bx, offset buffer


l1:
	LEA dx, msg1
	mov ah, 09		; Reading Message
	int 21h

	mov ah, 1		; Reading Input
	int 21h

	cmp al, '1'		; If Encryption
	je l3
	
	cmp al, '2'		; If Decryption
	je l9

	cmp al, '3'		; If Exit
	je l15

	cmp al, '3'		; If Invalid
	jne l2

l2:
	LEA dx, msg2
	mov ah, 09		; Invalid Message
	int 21h

	jmp l1


l3:
	LEA dx, msg3		; Encryption Message
	mov ah, 09
	int 21h
	
l4:
	mov ah, 1		; Reading Input
	int 21h

	mov [bx], al		; Storing Strings

	cmp al, CR
	je l5

	inc bx

	cmp al, CR
	jne l4

l5:
	LEA dx, msg7
	mov ah, 09		; Shift Gears Message
	int 21h

	mov ax, 0	; reading Input
	call input
	mov cx, num

	mov bx, offset buffer

l6:
	cmp byte ptr [bx], CR		; If Carriage Return
	je l15

	cmp byte ptr [bx], 20h		; If Space
	je l7
	
	add [bx], cx		; Adding Gears
	
	cmp byte ptr [bx], 122		; Printing Loop
	jle l7

	cmp byte ptr [bx], 122		; Subtracting 26
	jg l8

l7:
	mov ah, 2
	mov dl, [bx]		; Printing The Encrypted String
	int 21h
	
	inc bx
	jmp l6

l8:
	sub byte ptr [bx], 26
	jmp l7


l9:
	LEA dx, msg5		; Decryption Message
	mov ah, 09
	int 21h

l10:
	mov ah, 1		; Reading Input
	int 21h

	mov [bx], al		; Storing Strings

	cmp al, CR
	je l11

	inc bx

	cmp al, CR		; jmp l10
	jne l10

l11:
	LEA dx, msg7
	mov ah, 09		; Shift Gears Message
	int 21h

	mov ax, 0	; reading Input
	call input
	mov cx, num

	mov bx, offset buffer

l12:
	cmp byte ptr [bx], CR		; If Carriage Return
	je l15

	cmp byte ptr [bx], 20h		; If Space
	je l13
	
	sub [bx], cx		; Adding Gears
	
	cmp byte ptr [bx], 96		; Printing Loop
	jg l13

	cmp byte ptr [bx], 96		; Subtracting 26
	jle l14

l13:
	mov ah, 2
	mov dl, [bx]		; Printing The Decrypted String
	int 21h
	
	inc bx
	jmp l12

l14:
	add byte ptr [bx], 26
	jmp l13

l15:
	mov ax, 4c00h
	int 21h
main endp
	end main