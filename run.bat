PATH=C:\asm\TASM;

tasm numbers.asm
tasm final.asm
tlink Final.obj numbers.obj
final.exe
del final.obj
del numbers.obj
del final.exe
del final.map