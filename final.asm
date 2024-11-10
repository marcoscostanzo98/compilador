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
cte_str1 db "MAYOR GRINCH",'$', 5 dup (?)
cte_str2 db "MENOR",'$', 5 dup (?)
_0 dd 0.0
_1 dd 1.0
cte_str3 db "SALI",'$', 4 dup (?)
@auxAssembler0 dd ?

.CODE

START:
    MOV AX, @DATA
    MOV DS, AX
    MOV es,ax

    FLD _10
    FSTP var1
    FLD var1
    FCOMP _11
    FSTSW ax
    SAHF
    JLE ET_12
    displayString cte_str1
    newLine
    JMP ET_14
ET_12:
    displayString cte_str2
    newLine
ET_14:
    FLD var1
    FCOMP _0
    FSTSW ax
    SAHF
    JG ET_29
    DisplayFloat var1, 0
    newLine
    FLD _1
    FLD var1
    FADD
    FSTP @auxAssembler0
    FLD @auxAssembler0
    FSTP var1
    JMP ET_14
ET_29:
    displayString cte_str3
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
