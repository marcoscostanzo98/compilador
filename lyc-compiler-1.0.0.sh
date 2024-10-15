#!/bin/bash

# Step 1: Run flex to generate the lexical analyzer
flex Lexico.l

# Step 2: Run bison to generate the parser, with counterexamples for conflict debugging
bison -dyv -Wcounterexamples Sintactico.y

# Step 3: Compile the generated C files along with your source files
gcc lex.yy.c y.tab.c Lista.c Pila.c Polaca.c -o compilador

# Step 4: Run the compiler with the input file (only if compilation was successful)
if [ -f compilador ]; then
    ./compilador prueba.txt
else
    echo "Compilation failed, 'compilador' was not created."
fi

# Step 5: Cleanup the generated files
rm -f lex.yy.c y.tab.c y.tab.h y.output
