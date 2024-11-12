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
_3 dd 3.0
_1 dd 1.0
_2 dd 2.0
_0 dd 0.0
cte_str1 db "a es mas grande que b - 3",'$', 25 dup (?)
cte_str2 db "a es mas grande que b - 2",'$', 25 dup (?)
_27 dd 27.0
_500 dd 500.0
_34 dd 34.0
_99999_99 dd 99999.99
_99_0 dd 99.0
_0_9999 dd 0.9999
cte_str3 db "@sdADaSjfla%dfg",'$', 15 dup (?)
cte_str4 db "asldk  fh sjf",'$', 13 dup (?)
cte_str5 db "a es mas grande que b -1",'$', 24 dup (?)
cte_str6 db "a es mas chico o igual a b",'$', 26 dup (?)
cte_str7 db "a no es mas grande que b",'$', 24 dup (?)
cte_str8 db "a es mas chica que b o c",'$', 24 dup (?)
cte_str9 db "b es mas chico que a y c",'$', 24 dup (?)
cte_str10 db "lo opuesto",'$', 10 dup (?)
base dd ?
cte_str11 db "a es mas grande que b 1",'$', 23 dup (?)
cte_str12 db "a es mas grande que b 2",'$', 23 dup (?)
cte_str13 db "a es mas grande que b 3",'$', 23 dup (?)
cte_str14 db "a es mas grande que b 4",'$', 23 dup (?)
cte_str15 db "ewr",'$', 3 dup (?)
_8 dd 8.0
_55 dd 55.0
_5 dd 5.0
_28 dd 28.0
_13 dd 13.0
_4 dd 4.0
_17 dd 17.0
_52 dd 52.0
_10 dd 10.0
_7 dd 7.0
cte_str16 db "7 + 5 > 10",'$', 10 dup (?)
_20 dd 20.0
cte_str17 db "Ambas condiciones se cumplen",'$', 28 dup (?)
_11 dd 11.0
cte_str18 db "Solo la primera se cumple",'$', 25 dup (?)
_30 dd 30.0
cte_str19 db "Solo la segunda se cumple",'$', 25 dup (?)
@auxAssembler23 dd ?
@auxAssembler22 dd ?
@auxAssembler21 dd ?
@auxAssembler20 dd ?
@auxAssembler19 dd ?
@auxAssembler18 dd ?
@auxAssembler17 dd ?
@auxAssembler16 dd ?
@auxAssembler15 dd ?
@auxAssembler14 dd ?
@auxAssembler13 dd ?
@auxAssembler12 dd ?
@auxAssembler11 dd ?
@auxAssembler10 dd ?
@auxAssembler9 dd ?
@auxAssembler8 dd ?
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

	FLD _3
	FSTP a
	FLD _1
	FSTP b
	FLD _2
	FSTP c
	FLD _0
	FSTP x
	FLD _0
	FSTP y
	FLD a
	FCOMP b
	FSTSW ax
	SAHF
	JBE ET_27
	FLD c
	FCOMP b
	FSTSW ax
	SAHF
	JBE ET_27
	displayString cte_str1
	newLine
ET_27:
	FLD a
	FCOMP b
	FSTSW ax
	SAHF
	JBE ET_44
	FLD c
	FCOMP b
	FSTSW ax
	SAHF
	JBE ET_44
	FLD x
	FCOMP y
	FSTSW ax
	SAHF
	JNE ET_44
	displayString cte_str2
	newLine
ET_44:
	FLD _27
	FLD c
	FSUB
	FSTP @auxAssembler0
	FLD @auxAssembler0
	FSTP x
	FLD _500
	FLD a
	FADD
	FSTP @auxAssembler1
	FLD @auxAssembler1
	FSTP x
	FLD _3
	FLD _34
	FMUL
	FSTP @auxAssembler2
	FLD @auxAssembler2
	FSTP x
	FLD a
	FLD b
	FDIV
	FSTP @auxAssembler3
	FLD @auxAssembler3
	FSTP x
	FLD _99999_99
	FSTP w
	FLD _99_0
	FSTP w
	FLD _0_9999
	FSTP w
	MOV SI, OFFSET cte_str3
	MOV DI, OFFSET p1
	CALL COPIAR
	MOV SI, OFFSET cte_str4
	MOV DI, OFFSET p2
	CALL COPIAR
	FLD _1
	FSTP var1
	FLD _2
	FSTP var2
	FLD var1
	FCOMP var2
	FSTSW ax
	SAHF
	JBE ET_94
	displayString cte_str5
	newLine
	JMP ET_96
ET_94:
	displayString cte_str6
	newLine
ET_96:
	FLD _1
	FSTP a
	FLD _1
	FSTP b
	FLD _2
	FSTP c
	FLD var1
	FCOMP var2
	FSTSW ax
	SAHF
	JA ET_112
	displayString cte_str7
	newLine
ET_112:
	FLD _1
	FSTP a
	FLD _1
	FSTP b
	FLD _2
	FSTP c
	FLD var1
	FCOMP var2
	FSTSW ax
	SAHF
	JBE ET_128
	JMP ET_133
ET_128:
	FLD x
	FCOMP a
	FSTSW ax
	SAHF
	JBE ET_135
ET_133:
	displayString cte_str8
	newLine
ET_135:
	FLD var1
	FCOMP var2
	FSTSW ax
	SAHF
	JBE ET_158
	FLD a
	FCOMP b
	FSTSW ax
	SAHF
	JB ET_147
	JMP ET_152
ET_147:
	FLD c
	FCOMP b
	FSTSW ax
	SAHF
	JB ET_156
ET_152:
	displayString cte_str9
	newLine
	JMP ET_158
ET_156:
	displayString cte_str10
	newLine
ET_158:
	FLD _1
	FSTP a
	FLD _3
	FSTP b
ET_166:
	FLD a
	FCOMP b
	FSTSW ax
	SAHF
	JAE ET_181
	displayString cte_str11
	newLine
	FLD _1
	FLD a
	FADD
	FSTP @auxAssembler4
	FLD @auxAssembler4
	FSTP a
	JMP ET_166
ET_181:
	FLD a
	FCOMP b
	FSTSW ax
	SAHF
	JAE ET_201
	FLD c
	FCOMP b
	FSTSW ax
	SAHF
	JAE ET_201
	displayString cte_str12
	newLine
	FLD _1
	FLD a
	FADD
	FSTP @auxAssembler5
	FLD @auxAssembler5
	FSTP a
	JMP ET_181
ET_201:
	FLD a
	FCOMP b
	FSTSW ax
	SAHF
	JAE ET_209
	JMP ET_214
ET_209:
	FLD c
	FCOMP b
	FSTSW ax
	SAHF
	JAE ET_228
ET_214:
	displayString cte_str13
	newLine
	FLD _1
	FLD a
	FADD
	FSTP @auxAssembler6
	FLD @auxAssembler6
	FSTP a
	FLD _1
	FLD c
	FADD
	FSTP @auxAssembler7
	FLD @auxAssembler7
	FSTP c
	JMP ET_201
ET_228:
	FLD a
	FCOMP b
	FSTSW ax
	SAHF
	JAE ET_236
	JMP ET_241
ET_236:
	FLD c
	FCOMP b
	FSTSW ax
	SAHF
	JAE ET_260
ET_241:
	FLD c
	FCOMP b
	FSTSW ax
	SAHF
	JNE ET_248
	displayString cte_str14
	newLine
ET_248:
	FLD _1
	FLD a
	FADD
	FSTP @auxAssembler8
	FLD @auxAssembler8
	FSTP a
	FLD _1
	FLD c
	FADD
	FSTP @auxAssembler9
	FLD @auxAssembler9
	FSTP c
	JMP ET_228
ET_260:
	displayString cte_str15
	newLine
	DisplayFloat var1, 0
	newLine
	FLD _2
	FSTP x
	DisplayFloat _2, 0
	newLine
	FLD _17
	FLD _52
	FADD
	FSTP @auxAssembler10
	DisplayFloat @auxAssembler10, 2
	newLine
	FLD _17
	FLD _52
	FADD
	FSTP @auxAssembler11
	FLD _5
	FLD @auxAssembler11
	FADD
	FSTP @auxAssembler12
	FLD _5
	FLD @auxAssembler12
	FMUL
	FSTP @auxAssembler13
	FLD @auxAssembler13
	FSTP y
	FLD _17
	FLD _17
	FMUL
	FSTP @auxAssembler14
	FLD @auxAssembler14
	FSTP y
	FLD _3
	FLD _52
	FMUL
	FSTP @auxAssembler15
	FLD @auxAssembler15
	FSTP z
	FLD _2
	FLD _2
	FMUL
	FSTP @auxAssembler16
	FLD @auxAssembler16
	FLD x
	FSUB
	FSTP @auxAssembler17
	FLD @auxAssembler17
	FSTP y
	FLD _0
	FSTP z
	FLD _0
	FSTP z
	FLD _7
	FLD _5
	FADD
	FSTP @auxAssembler18
	FLD @auxAssembler18
	FCOMP _10
	FSTSW ax
	SAHF
	JBE ET_314
	displayString cte_str16
	newLine
ET_314:
	FLD _0
	FSTP x
	FLD _5
	FSTP y
	FLD _0
	FSTP z
ET_323:
	FLD x
	FCOMP y
	FSTSW ax
	SAHF
	JA ET_354
ET_329:
	FLD y
	FCOMP z
	FSTSW ax
	SAHF
	JBE ET_342
	FLD _1
	FLD z
	FADD
	FSTP @auxAssembler19
	FLD @auxAssembler19
	FSTP z
	JMP ET_329
ET_342:
	FLD y
	FLD _1
	FSUB
	FSTP @auxAssembler20
	FLD @auxAssembler20
	FSTP y
	FLD _1
	FLD x
	FADD
	FSTP @auxAssembler21
	FLD @auxAssembler21
	FSTP x
	JMP ET_323
ET_354:
	FLD _1
	FSTP x
	FLD _10
	FSTP y
	FLD _20
	FSTP z
ET_363:
	FLD x
	FCOMP y
	FSTSW ax
	SAHF
	JAE ET_371
	JMP ET_376
ET_371:
	FLD z
	FCOMP y
	FSTSW ax
	SAHF
	JBE ET_417
ET_376:
	FLD y
	FCOMP x
	FSTSW ax
	SAHF
	JBE ET_407
	FLD y
	FCOMP z
	FSTSW ax
	SAHF
	JAE ET_395
	displayString cte_str17
	newLine
	FLD z
	FLD _11
	FSUB
	FSTP @auxAssembler22
	FLD @auxAssembler22
	FSTP z
	JMP ET_405
ET_395:
	displayString cte_str18
	newLine
	FLD _30
	FSTP z
	FLD _10
	FLD x
	FADD
	FSTP @auxAssembler23
	FLD @auxAssembler23
	FSTP x
ET_405:
	JMP ET_415
ET_407:
	displayString cte_str19
	newLine
	FLD _1
	FSTP z
	FLD _11
	FSTP x
ET_415:
	JMP ET_363
ET_417:
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
