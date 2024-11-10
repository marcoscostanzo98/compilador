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
_10 dd 10.0
_11 dd 11.0
_12 dd 12.0
cte_str1 db "x es el mayor",'$', 13 dup (?)
cte_str2 db "x no es el mayor AND",'$', 20 dup (?)
cte_str3 db "x no es el mayor OR",'$', 19 dup (?)
cte_str4 db "a:BI",'$', 4 dup (?)
cte_str5 db "@ET_1:BI",'$', 8 dup (?)
cte_str6 db "ET_1",'$', 4 dup (?)
cte_str7 db "SALI",'$', 4 dup (?)

.CODE
.startup

START:
	MOV AX, @DATA
	MOV DS, AX
	MOV es,ax

	FLD _10
	FSTP var1
	FLD _11
	FSTP var2
	FLD _12
	FSTP x
	FLD x
	FCOMP var1
	FSTSW ax
	SAHF
	JBE ET_16
	JMP ET_21
ET_16:
	FLD x
	FCOMP var2
	FSTSW ax
	SAHF
	JBE ET_39
ET_21:
	FLD x
	FCOMP var1
	FSTSW ax
	SAHF
	JBE ET_35
	FLD x
	FCOMP var2
	FSTSW ax
	SAHF
	JBE ET_35
	displayString cte_str1
	newLine
	JMP ET_37
ET_35:
	displayString cte_str2
	newLine
ET_37:
	JMP ET_41
ET_39:
	displayString cte_str3
	newLine
ET_41:
	FLD _10
	FSTP var1
	displayString cte_str4
	newLine
	displayString cte_str5
	newLine
	displayString cte_str6
	newLine
	displayString cte_str7
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
