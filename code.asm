.CODE
func_a PROC
	PUSH BP
	MOV BP, SP
	MOV AX, 7	;line number:4
	PUSH AX	;line number:4
	POP AX
	MOV a,AX
	POP BP
	RET
func_a ENDP
foo PROC
	PUSH BP
	MOV BP, SP
	MOV AX, [BP+4]	; storing local variable a to AX
	PUSH AX
	MOV AX, 3	;line number:8
	PUSH AX	;line number:8
	POP BX
	POP AX
	ADD AX, BX
	PUSH AX
	POP AX
	MOV [BP+4],AX
	MOV AX, [BP+4]	; storing local variable a to AX
	PUSH AX
	POP BP
	RET 2
foo ENDP
bar PROC
	PUSH BP
	MOV BP, SP
	MOV AX, 4	;line number:14
	PUSH AX	;line number:14
	MOV AX, [BP+6]	; storing local variable a to AX
	PUSH AX
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	MOV AX, 2	;line number:14
	PUSH AX	;line number:14
	MOV AX, [BP+6]	; storing local variable b to AX
	PUSH AX
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	POP BX
	POP AX
	ADD AX, BX
	PUSH AX
	POP AX
	MOV c,AX
	MOV AX, c	; storing global variable c to AX
	PUSH AX
	CALL print_output
	CALL new_line
	MOV AX, c	; storing global variable c to AX
	PUSH AX
	POP BP
	RET 4
bar ENDP
main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
	SUB SP, 2	;i
	SUB SP, 2	;j
	SUB SP, 2	;k
	SUB SP, 2	;l
	MOV AX, 5	;line number:23
	PUSH AX	;line number:23
	POP AX
	MOV [BP-2],AX
	MOV AX, 6	;line number:24
	PUSH AX	;line number:24
	POP AX
	MOV [BP-4],AX
	CALL func_a
	MOV AX, a	; storing global variable a to AX
	PUSH AX
	CALL print_output
	CALL new_line
	MOV AX, [BP-2]	; storing local variable i to AX
	PUSH AX
	CALL foo
	POP AX
	MOV [BP-6],AX
	MOV AX, [BP-6]	; storing local variable k to AX
	PUSH AX
	CALL print_output
	CALL new_line
	MOV AX, [BP-2]	; storing local variable i to AX
	PUSH AX
	MOV AX, [BP-4]	; storing local variable j to AX
	PUSH AX
	CALL bar
	POP AX
	MOV [BP-8],AX
	MOV AX, [BP-8]	; storing local variable l to AX
	PUSH AX
	CALL print_output
	CALL new_line
	MOV AX, 6	;line number:35
	PUSH AX	;line number:35
	MOV AX, [BP-2]	; storing local variable i to AX
	PUSH AX
	MOV AX, [BP-4]	; storing local variable j to AX
	PUSH AX
	CALL bar
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	MOV AX, 2	;line number:35
	PUSH AX	;line number:35
	POP BX
	POP AX
	ADD AX, BX
	PUSH AX
	MOV AX, 3	;line number:35
	PUSH AX	;line number:35
	MOV AX, [BP-2]	; storing local variable i to AX
	PUSH AX
	CALL foo
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	POP BX
	POP AX
	SUB AX, BX
	PUSH AX
	POP AX
	MOV [BP-4],AX
	MOV AX, [BP-4]	; storing local variable j to AX
	PUSH AX
	CALL print_output
	CALL new_line
	MOV AX, 0	;line number:39
	PUSH AX	;line number:39
	ADD SP, 8
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
