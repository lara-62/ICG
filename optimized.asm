;-------
;
;-------
.MODEL SMALL
.STACK 1000H
.Data
	CR EQU 0DH
	LF EQU 0AH
	number DB "00000$"
	a DW 1 DUP (0000H)	;declaring variable a
	b DW 1 DUP (0000H)	;declaring variable b
	c DW 1 DUP (0000H)	;declaring variable c
.CODE
func_a PROC
	PUSH BP
	MOV BP, SP
	MOV AX, 7	;line number:4
	MOV a, AX	;assigning to global variablea
	POP BP
	RET
func_a ENDP
foo PROC
	PUSH BP
	MOV BP, SP
	MOV AX, [BP+4]	; storing local variable a to AX
	PUSH AX
	MOV AX, 3	;line number:8
	PUSH AX
	POP BX
	POP AX
	ADD AX, BX
	MOV [BP+4], AX	;assigning to local variablea;Removing redundant assigment after it
	JMP L0	;nothing after return statement and before function end will execute
L0:
	POP BP
	RET 2
foo ENDP
bar PROC
	PUSH BP
	MOV BP, SP
	MOV AX, 4	;line number:16
	PUSH AX
	MOV AX, [BP+6]	; storing local variable a to AX
	PUSH AX
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	MOV AX, 2	;line number:16
	PUSH AX
	MOV AX, [BP+4]	; storing local variable b to AX
	PUSH AX
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	POP BX
	POP AX
	ADD AX, BX
	MOV c, AX	;assigning to global variablec;Removing redundant assigment after it
	JMP L1	;nothing after return statement and before function end will execute
L1:
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
	MOV AX, 5	;line number:25
	MOV [BP-2], AX	;assigning to local variablei
	MOV AX, 6	;line number:26
	MOV [BP-4], AX	;assigning to local variablej
	CALL func_a
	MOV AX, a	; storing global variable a to AX
	CALL print_output
	CALL new_line
	MOV AX, [BP-2]	; storing local variable i to AX
	PUSH AX
	CALL foo
	MOV [BP-6], AX	;assigning to local variablek;Removing redundant assigment after it
	CALL print_output
	CALL new_line
	MOV AX, [BP-2]	; storing local variable i to AX
	PUSH AX
	MOV AX, [BP-4]	; storing local variable j to AX
	PUSH AX
	CALL bar
	MOV [BP-8], AX	;assigning to local variablel;Removing redundant assigment after it
	CALL print_output
	CALL new_line
	MOV AX, 6	;line number:38
	PUSH AX
	MOV AX, [BP-2]	; storing local variable i to AX
	PUSH AX
	MOV AX, [BP-4]	; storing local variable j to AX
	PUSH AX
	CALL bar
	PUSH AX
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	MOV AX, 2	;line number:38
	PUSH AX
	POP BX
	POP AX
	ADD AX, BX
	PUSH AX
	MOV AX, 3	;line number:38
	PUSH AX
	MOV AX, [BP-2]	; storing local variable i to AX
	PUSH AX
	CALL foo
	PUSH AX
	POP BX
	POP AX
	CWD
	MUL BX
	PUSH AX
	POP BX
	POP AX
	SUB AX, BX
	MOV [BP-4], AX	;assigning to local variablej;Removing redundant assigment after it
	CALL print_output
	CALL new_line
	MOV AX, 0	;line number:42
	JMP L2	;nothing after return statement and before function end will execute
L2:
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
