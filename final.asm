include macros2.asm
.MODEL LARGE	;
.386
.STACK 200h;

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
p1 db 40 dup (?),'$'
p2 db 40 dup (?),'$'
p3 db 40 dup (?),'$'
_33 dd 33
_1 dd 1
_2 dd 2
_0 dd 0
_a_es_mas_grande_que_b db "a es mas grande que b",'$',21 dup (?)
_27 dd 27
_500 dd 500
_34 dd 34
_3 dd 3
_99999_99 dd 99999.99
_99_0 dd 99.0
_0_9999 dd 0.9999
_@sdADaSjfla%dfg db "@sdADaSjfla%dfg",'$',15 dup (?)
_asldk__fh_sjf db "asldk  fh sjf",'$',13 dup (?)
_a_es_mas_chico_o_igual_a_b db "a es mas chico o igual a b",'$',26 dup (?)
_a_no_es_mas_grande_que_b db "a no es mas grande que b",'$',24 dup (?)
_a_es_mas_chica_que_b_o_c db "a es mas chica que b o c",'$',24 dup (?)
_b_es_mas_chico_que_a_y_c db "b es mas chico que a y c",'$',24 dup (?)
_lo_opuesto db "lo opuesto",'$',10 dup (?)
base dd ?
_ewr db "ewr",'$',3 dup (?)
_8 dd 8
_55 dd 55
_5 dd 5
_28 dd 28
_13 dd 13
_4 dd 4
_17 dd 17
_52 dd 52
_10 dd 10
_7 dd 7
_7_+_5_>_10 db "7 + 5 > 10",'$',10 dup (?)
