;-------
;
;-------
.MODEL SMALL
.STACK 1000H
.Data
	CR EQU 0DH
	LF EQU 0AH
	number DB "00000$"
	a DW 5 DUP (0000H)	;declaring array a
.CODE
main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
	MOV AX, 0	;line number:5
	MOV BX, AX	;
	MOV AX, 9	;line number:5
	PUSH AX
	MOV AX, BX	;
MOV BX ,2
	MUL BX
	MOV SI, AX;	ASSIGNING INDEX REGISTER TO INDEX OF ARRAY
	POP AX
	MOV a[SI], AX	;assigning to global variable a
	SUB SP, 2	;ring variable i
	MOV AX, 0	;line number:7
	MOV BX, AX	;;Removing redundant assigment after it
MOV BX ,2
	MUL BX
	MOV SI, AX;	ASSIGNING INDEX REGISTER TO INDEX OF ARRAY
	MOV AX, a[SI]	; storing global array element a to AX
	MOV [BP-2], AX	;assigning to local variable i
	SUB SP, 2	;ng variable j
	SUB SP, 2	;ng variable k
	MOV AX, 10	;line number:9
	MOV [BP-6], AX	;assigning to local variable k
	SUB SP, 2	; variable y
	MOV AX, 0	;line number:11
	MOV [BP-8], AX	;assigning to local variable y
	SUB SP, 2	;ariable x
	MOV AX, 1	;line number:13
	MOV [BP-10], AX	;assigning to local variable x
	MOV AX, [BP-8]	; storing local variable y to AX
	PUSH AX
	MOV AX, [BP-10]	; storing local variable x to AX
	PUSH AX
	MOV AX, 2	;line number:14
	PUSH AX
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	POP BX
	POP AX
	ADD AX, BX
	MOV BX, AX	;
	MOV AX, [BP-6]	; storing local variable k to AX
	PUSH AX
	MOV AX, BX	;
MOV BX ,2
	MUL BX
	MOV SI, AX;	ASSIGNING INDEX REGISTER TO INDEX OF ARRAY
	POP AX
	MOV a[SI], AX	;assigning to global variable a
	MOV AX, 0	;line number:15
	MOV BX, AX	;;Removing redundant assigment after it
MOV BX ,2
	MUL BX
	MOV SI, AX;	ASSIGNING INDEX REGISTER TO INDEX OF ARRAY
	MOV AX, a[SI]	; storing global array element a to AX
	PUSH AX
	MOV AX, 5	;line number:15
	PUSH AX
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	MOV AX, 2	;line number:15
	MOV BX, AX	;;Removing redundant assigment after it
MOV BX ,2
	MUL BX
	MOV SI, AX;	ASSIGNING INDEX REGISTER TO INDEX OF ARRAY
	MOV AX, a[SI]	; storing global array element a to AX
	PUSH AX
	MOV AX, 5	;line number:15
	PUSH AX
	POP BX
	POP AX
	CWD
	DIV BX
	PUSH AX
	POP BX
	POP AX
	ADD AX, BX
	MOV [BP-6], AX	;assigning to local variable k;Removing redundant assigment after it
	CALL print_output
	CALL new_line
	ADD SP, 10
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
