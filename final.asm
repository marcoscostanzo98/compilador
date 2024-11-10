include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE equ 40

.DATA
a1 dd ?
b1 dd ?
w dd ?
var1 dd ?
var2 dd ?
x dd ?
y dd ?
z dd ?
a dd ?
b dd ?
c dd ?
p1 db MAXTEXTSIZE dup (?),'$'
p2 db MAXTEXTSIZE dup (?),'$'
p3 db MAXTEXTSIZE dup (?),'$'
_3_0 dd 3.0
_4_0 dd 4.0
_0_9 dd 0.9
cte_str1 db "richarlison",'$', 11 dup (?)

.CODE
.startup

START:
	MOV AX, @DATA
	MOV DS, AX
	MOV es,ax

	FLD _3_0
	FSTP a1
	DisplayFloat _4_0, 2
	newLine
	DisplayFloat _0_9, 2
	newLine
	DisplayFloat var1, 0
	newLine
	MOV SI, OFFSET cte_str1
	MOV DI, OFFSET p1
	CALL COPIAR
	displayString p1
	newLine
	MOV AX, 4C00h
	INT 21h


STRLEN PROC NEAR
	mov bx, 0
STRL01:
	cmp BYTE PTR [SI+BX],'$'
	je STREND
	inc BX
	jmp STRL01
STREND:
	ret
STRLEN ENDP

COPIAR PROC NEAR
	call STRLEN
	cmp bx,MAXTEXTSIZE
	jle COPIARSIZEOK
	mov bx,MAXTEXTSIZE
COPIARSIZEOK:
	mov cx,bx
	cld
	rep movsb
	mov al,'$'
	mov BYTE PTR [DI],al
	ret
COPIAR ENDP

END START
