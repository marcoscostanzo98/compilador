%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "Lista.h"

FILE *yyin;
FILE *ts;

int yyerror();
int yylex();
void guardar_TS();

char* tabla_simbolos = "symbols.txt";
t_lista lista_simbolos;

%}

%union {
	char str_val[400];
}

%token <str_val> CONST_REAL
%token <str_val> CONST_INT
%token <str_val> CONST_STR
%token <str_val> ID

%token OP_ASIG
%token OP_ADD
%token OP_SUB
%token OP_MUL
%token OP_DIV
%token OP_EQ
%token OP_NEQ
%token OP_GT
%token OP_GEQ
%token OP_LT
%token OP_LEQ

%token OP_AND
%token OP_OR
%token OP_NOT
%token PAR_OP
%token PAR_CL
%token CORCHETE_OP
%token CORCHETE_CL
%token LLAVE_OP
%token LLAVE_CL
%token COMA
%token DOSPUNTOS
%token PUNTOYCOMA
%token INIT
%token IF
%token ELSE
%token WHILE
%token T_INT
%token T_FLOAT
%token T_STRING
%token READ
%token WRITE
%token GETPENULTIMATEPOSITION
%token SUMALOSULTIMOS
%token COMENTARIO
%token COMENTARIO_ANIDADO


/* START SYMBOL */
%start inicio


%left '+' '-'
%left '*' '/'
%right MENOS_UNARIO

%%
inicio: 
    programa {printf("   Programa es Inicio\n"); guardar_TS();}
;

programa:
    init            {printf("   Init es Programa\n");}
    |init bloque    {printf("   Init Bloque es Programa\n");}
    |bloque         {printf("   Bloque es Programa\n");}
;

bloque:
    bloque sentencia    {printf("   Bloque Sentencia es Bloque\n");}
    |sentencia          {printf("   Sentencia es Bloque\n");}
;

sentencia:
    struct_condicional  {printf("   Struct_condicional es Sentencia\n");}
    |asignacion         {printf("   Asignacion es Sentencia\n");}
    |leer               {printf("   Leer es Sentencia\n");}
    |escribir           {printf("   Escribir es Sentencia\n");}
    |funcion_especial   {printf("   Funcion_especial es Sentencia\n");}
;

init:
    INIT LLAVE_OP declaraciones LLAVE_CL {printf("   INIT LLAVE_OP Declaraciones LLAVE_CL es Init\n");}
;

declaraciones:
    declaraciones declaracion    {printf("   Declaraciones Declaracion es Declaraciones\n");}
    |declaracion                 {printf("   Declaracion es Declaraciones\n");}
;

declaracion:
    lista_ids DOSPUNTOS tipo_dato {printf("   Lista_ids DOSPUNTOS Tipo_dato es Declaracion\n");}
;

lista_ids:
    lista_ids COMA ID {printf("   Lista_ids COMA ID es Lista_ids\n");}
    |ID              {printf("   ID es Lista_ids\n");}
;

tipo_dato:
    T_STRING {printf("   T_STRING es Tipo_dato\n");}
    |T_FLOAT {printf("   T_FLOAT es Tipo_dato\n");}
    |T_INT   {printf("   T_INT es Tipo_dato\n");}
;

struct_condicional:
    IF PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL ELSE LLAVE_OP bloque LLAVE_CL
        {printf("   IF PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL ELSE LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
    |IF PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL
        {printf("   IF PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
    |WHILE PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL
        {printf("   WHILE PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
;

condicional:
    condicion                         {printf("   Condicion es Condicional\n");}
    |condicion operador_logico condicion {printf("   Condicion Operador_logico Condicion es Condicional\n");}
    |OP_NOT condicion                 {printf("   OP_NOT Condicion es Condicional\n");}
;

condicion:
    expresion comparador expresion    {printf("   Expresion Comparador Expresion es Condicion\n");}
;

comparador:
    OP_EQ  {printf("   OP_EQ es Comparador\n");}
    |OP_NEQ {printf("   OP_NEQ es Comparador\n");}
    |OP_GT  {printf("   OP_GT es Comparador\n");}
    |OP_GEQ {printf("   OP_GEQ es Comparador\n");}
    |OP_LT  {printf("   OP_LT es Comparador\n");}
    |OP_LEQ {printf("   OP_LEQ es Comparador\n");}
;    

operador_logico:
    OP_AND {printf("   OP_AND es Operador_logico\n");}
    |OP_OR {printf("   OP_OR es Operador_logico\n");}
;

asignacion:
    ID OP_ASIG expresion               {printf("   ID OP_ASIG Expresion es Asignacion\n");}
    |ID OP_ASIG CONST_STR              {printf("   ID OP_ASIG CONST_STR es Asignacion\n");}
    |ID OP_ASIG funcion_especial       {printf("   ID OP_ASIG Funcion_especial es Asignacion\n");}
;

expresion:
    expresion OP_ADD termino           {printf("   Expresion OP_ADD Termino es Expresion\n");}
    |expresion OP_SUB termino          {printf("   Expresion OP_SUB Termino es Expresion\n");}
    |termino                           {printf("   Termino es Expresion\n");}
;

termino:
    termino OP_MUL factor              {printf("   Termino OP_MUL Factor es Termino\n");}
    |termino OP_DIV factor             {printf("   Termino OP_DIV Factor es Termino\n");}
    |factor                            {printf("   Factor es Termino\n");}
;

factor:
    ID                                 {printf("   ID es Factor\n");}
    |OP_SUB PAR_OP expresion PAR_CL %prec MENOS_UNARIO 
        {printf("   OP_SUB PAR_OP Expresion PAR_CL es Factor (Menos Unario)\n");}
    |OP_SUB ID %prec MENOS_UNARIO
        {printf("   OP_SUB ID es Factor (Menos Unario)\n");}
    |CONST_INT                         {printf("   CONST_INT es Factor\n");}
    |CONST_REAL                        {printf("   CONST_REAL es Factor\n");}
    |PAR_OP expresion PAR_CL           {printf("   PAR_OP Expresion PAR_CL es Factor\n");}
;

leer:
    READ PAR_OP ID PAR_CL              {printf("   READ PAR_OP ID PAR_CL es Leer\n");}
;

escribir:
    WRITE PAR_OP expresion PAR_CL      {printf("   WRITE PAR_OP Expresion PAR_CL es Escribir\n");}
    |WRITE PAR_OP CONST_STR PAR_CL     {printf("   WRITE PAR_OP CONST_STR PAR_CL es Escribir\n");}
;

funcion_especial:
    ID OP_EQ nombre_funcion PAR_OP CONST_INT PUNTOYCOMA CORCHETE_OP lista_const CORCHETE_CL PAR_CL
        {printf("   ID OP_EQ Nombre_funcion PAR_OP CONST_INT PUNTOYCOMA CORCHETE_OP Lista_const CORCHETE_CL PAR_CL es Funcion_especial\n");}
;

nombre_funcion:
    GETPENULTIMATEPOSITION {printf("   GETPENULTIMATEPOSITION es Nombre_funcion\n");}
    |SUMALOSULTIMOS        {printf("   SUMALOSULTIMOS es Nombre_funcion\n");}
;

lista_const:
    lista_const COMA CONST_REAL        {printf("   Lista_const COMA CONST_REAL es Lista_const\n");}
    |lista_const COMA CONST_INT        {printf("   Lista_const COMA CONST_INT es Lista_const\n");}
    |CONST_INT                         {printf("   CONST_INT es Lista_const\n");}
    |CONST_REAL                        {printf("   CONST_REAL es Lista_const\n");}
;

%%

int main(int argc, char *argv[])
{
    crearLista(&lista_simbolos);

    if((yyin = fopen(argv[1], "rt")) == NULL){
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
    } else{ 
        yyparse();
    }
	
    fclose(yyin);
    return 0;
}

int yyerror()
{
    printf("\nError Sintactico\n");
    exit (1);
}

void guardar_TS(){
    ts = fopen(tabla_simbolos, "wt");
    if (ts == NULL) {
        printf("\nError al intentar guardar en la tabla de simbolos");
        return;
    }

    t_lexema lex;

    fprintf(ts, "NOMBRE|TIPO|VALOR|LONGITUD\n");
    while(quitarPrimeroDeLista(&lista_simbolos, &lex)) {
        fprintf(ts, "%s|%s|%s|%s\n", lex.nombre, lex.tipodato, lex.valor, lex.longitud);
    }

    fclose(ts);

    vaciarLista(&lista_simbolos);

    return;
}