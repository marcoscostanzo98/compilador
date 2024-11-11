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
_0 dd 0.0
_4 dd 4.0
_1 dd 1.0
_3_3 dd 3.3
_1_2 dd 1.2
_5_3 dd 5.3
_3 dd 3.0
_2 dd 2.0
cte_str1 db "ANTES DEL IF",'$', 12 dup (?)
_5 dd 5.0
cte_str2 db "mayor que",'$', 9 dup (?)
cte_str3 db "DESPUES DEL IF",'$', 14 dup (?)
_1_1 dd 1.1
_7_0 dd 7.0
cte_str4 db "esto es un string",'$', 17 dup (?)
@auxAssembler7 dd ?
@auxAssembler6 dd ?
@auxAssembler5 dd ?
@auxAssembler4 dd ?
@auxAssembler3 dd ?
@auxAssembler2 dd ?
@auxAssembler1 dd ?
@auxAssembler0 dd ?

.CODE
.startup

START:
	MOV AX, @DATA
	MOV DS, AX
	MOV es,ax

	FLD _0
	FSTP x
	FLD _0
	FSTP y
ET_6:
	FLD x
	FCOMP _4
	FSTSW ax
	SAHF
	JAE ET_37
	FLD _0
	FSTP y
ET_15:
	FLD y
	FCOMP x
	FSTSW ax
	SAHF
	JAE ET_30
	FLD _1
	FLD y
	FADD
	FSTP @auxAssembler0
	FLD @auxAssembler0
	FSTP y
	DisplayFloat y, 0
	newLine
	JMP ET_15
ET_30:
	FLD _1
	FLD x
	FADD
	FSTP @auxAssembler1
	FLD @auxAssembler1
	FSTP x
	JMP ET_6
ET_37:
	FLD _3_3
	FSTP b1
	FLD _5_3
	FLD _1_2
	FMUL
	FSTP @auxAssembler2
	FLD @auxAssembler2
	FLD b1
	FDIV
	FSTP @auxAssembler3
	FLD @auxAssembler3
	FSTP a1
	FLD _2
	FLD _3
	FADD
	FSTP @auxAssembler4
	DisplayFloat @auxAssembler4, 2
	newLine
	displayString cte_str1
	newLine
	FLD _2
	FLD _3
	FADD
	FSTP @auxAssembler5
	FLD @auxAssembler5
	FCOMP _4
	FSTSW ax
	SAHF
	JBE ET_68
	FLD _2
	FLD _3
	FADD
	FSTP @auxAssembler6
	DisplayFloat @auxAssembler6, 2
	newLine
	displayString cte_str2
	newLine
	DisplayFloat _4, 0
	newLine
ET_68:
	displayString cte_str3
	newLine
	FLD _7_0
	FLD _1_1
	FMUL
	FSTP @auxAssembler7
	DisplayFloat @auxAssembler7, 2
	newLine
	MOV SI, OFFSET cte_str4
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
