;-------
;
;-------
.MODEL SMALL
.STACK 1000H
.Data
	CR EQU 0DH
	LF EQU 0AH
	number DB "00000$"
.CODE
main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
	SUB SP, 2	;laring variable i
	SUB SP, 2	;laring variable j
	MOV AX, 0	;line number:5
	MOV [BP-2],AX
	MOV AX, [BP-2]	; storing local variable i to AX
	INC AX
	MOV [BP-2],AX
	MOV [BP-4],AX
	MOV AX, [BP-4]	; storing local variable j to AX
	CALL print_output
	CALL new_line
	MOV AX, 0	;line number:8
	ADD SP, 4
	POP BP
	MOV AX,4CH
	INT 21H
main ENDP
print_output proc  ;print what is in ax
	push ax
	push bx
	push cx
	push dx
	push si
	lea si,number
	mov bx,10
	add si,4
	cmp ax,0
	jnge negate
	print:
	xor dx,dx
	div bx
	mov [si],dl
	add [si],'0'
	dec si
	cmp ax,0
	jne print
	inc si
	lea dx,si
	mov ah,9
	int 21h
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	negate:
	push ax
	mov ah,2
	mov dl,'-'
	int 21h
	pop ax
	neg ax
	jmp print
print_output endp
new_line proc
	push ax
	push dx
	mov ah,2
	mov dl,cr
	int 21h
	mov ah,2
	mov dl,lf
	int 21h
	pop dx
	pop ax
	ret
new_line endp
END main
