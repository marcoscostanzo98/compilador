%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "Lista.h"

#define MAX_STR_LEN 40
#define MIN_INT -32768  //2^15 (1 para el signo) - 1 (el mayor número representable)
#define MAX_INT 32767   //2^15 (1 para el signo) - 1 (el mayor número representable)
#define MIN_FLOAT -2147483648
#define MAX_FLOAT 2147483647

#define TIPO_FLOAT  "CTE_FLOAT"
#define TIPO_INT    "CTE_INTEGER"
#define TIPO_STRING "CTE_STRING"

FILE *yyin;

void mostrar_token_inutil();
void validar_longitud_str(char* str);
void validar_rango_int(char* str);
void validar_rango_float(char* str);
void handleErr(char* str);
void obtenerLexema(char* nombre);

void agregar_a_TS(t_lexema lexema);
void agregar_string_a_TS(char* lex);
void agregar_num_a_TS(char* lex, char* tipo);
void agregar_id_a_TS(char* lex);

void eliminar_caracteres(char *s, char c);
void reemplazar_caracteres(char *s, char viejo, char nuevo);

extern t_lista lista_simbolos;

char nombre_cte_string[] = "cte_str";
int contadorString = 1;

%}

%option noyywrap
%option yylineno

/* Conjuntos */
DIGITO [0-9]
DIGITONOCERO [1-9]
LETRA [a-zA-Z]
PUNTO "."

/* Regex */
CONST_REAL  -?({DIGITO}*{PUNTO}{DIGITO}+|{DIGITO}+{PUNTO}{DIGITO}*)
CONST_INT   (-?{DIGITONOCERO}{DIGITO}*)|0
CONST_STR   \"[^\"]*\"
ID      {LETRA}({LETRA}|{DIGITO}|_)*


/* Operadores */
OP_ASIG ":="
OP_ADD  "+"
OP_SUB  "-"
OP_MUL  "*"
OP_DIV  "/"
OP_EQ   "=="
OP_NEQ  "!="
OP_GT   ">"
OP_GEQ  ">="
OP_LT   "<"
OP_LEQ  "<="
OP_AND  "AND"
OP_OR   "OR"
OP_NOT  "NOT"

/* Caracteres */
PAR_OP      "("
PAR_CL      ")"
CORCHETE_OP  "["
CORCHETE_CL  "]"
LLAVE_OP    "{"
LLAVE_CL    "}"
COMA        ","
DOSPUNTOS   ":"
PUNTOYCOMA  ";"

/* Palabras Reservadas */
INIT                    "init"
IF                      "si"
ELSE                    "sino"
WHILE                   "mientras"
T_INT                   "Int"
T_FLOAT                 "Float"
T_STRING                "String"
READ                    "leer"
WRITE                   "escribir"
GETPENULTIMATEPOSITION  "getPenultimatePosition"
SUMALOSULTIMOS          "sumaLosUltimos"

/* Comentarios */
COMENTARIO_ANIDADO  "*-".*{COMENTARIO}.*"-*"
COMENTARIO          "*-".*"-*"

%%
{OP_ASIG}                   {return OP_ASIG;}
{OP_ADD}                    {return OP_ADD;}
{OP_SUB}                    {return OP_SUB;}
{OP_MUL}                    {return OP_MUL;}
{OP_DIV}                    {return OP_DIV;}
{OP_EQ}                     {return OP_EQ;}
{OP_NEQ}                    {return OP_NEQ;}
{OP_GT}                     {return OP_GT;}
{OP_GEQ}                    {return OP_GEQ;}
{OP_LT}                     {return OP_LT;}
{OP_LEQ}                    {return OP_LEQ;}
{OP_AND}                    {return OP_AND;}
{OP_OR}                     {return OP_OR;}
{OP_NOT}                    {return OP_NOT;}
{PAR_OP}                    {return PAR_OP;}
{PAR_CL}                    {return PAR_CL;}
{CORCHETE_OP}               {return CORCHETE_OP;}
{CORCHETE_CL}               {return CORCHETE_CL;}
{LLAVE_OP}                  {return LLAVE_OP;}
{LLAVE_CL}                  {return LLAVE_CL;}
{COMA}                      {return COMA;}
{DOSPUNTOS}                 {return DOSPUNTOS;}
{PUNTOYCOMA}                 {return PUNTOYCOMA;}
{INIT}                      {return INIT;}
{IF}                        {return IF;}
{ELSE}                      {return ELSE;}
{WHILE}                     {return WHILE;}
{T_INT}                     {return T_INT;}
{T_FLOAT}                   {return T_FLOAT;}
{T_STRING}                  {return T_STRING;}
{READ}                      {return READ;}
{WRITE}                     {return WRITE;}
{GETPENULTIMATEPOSITION}    {return GETPENULTIMATEPOSITION;}
{SUMALOSULTIMOS}            {return SUMALOSULTIMOS;}


{ID}                    {obtenerLexema(yytext); agregar_id_a_TS(yytext); return ID;}
{CONST_REAL}            {validar_rango_float(yytext); obtenerLexema(yytext); agregar_num_a_TS(yytext, TIPO_FLOAT); return CONST_REAL;}
{CONST_INT}             {validar_rango_int(yytext); obtenerLexema(yytext); agregar_num_a_TS(yytext, TIPO_INT); return CONST_INT;}
{CONST_STR}             {validar_longitud_str(yytext); obtenerLexema(yytext); agregar_string_a_TS(yytext); return CONST_STR;}


{COMENTARIO_ANIDADO}    {printf("Comentario anidado: %s\n", yytext);}
{COMENTARIO}            {printf("Comentario: %s\n", yytext);}

"\n"
"\t"
"\n\t"
" "
"\r\n"

.                       {handleErr(yytext);}

%%


void validar_longitud_str(char* str){
    if(strlen(str) - 2 > MAX_STR_LEN) { // - 2 por las comillas
        printf("\nERROR: String %s tiene longitud mayor a la permitida de %d caracteres\n", yytext, MAX_STR_LEN);
        exit(1);
    }
}

void validar_rango_int(char* str){
    int val = atoi(str);
    if(val < MIN_INT || val > MAX_INT){
        printf("\nERROR: Constante entera %s fuera de rango\n", yytext);
        exit(1);
    }
}

void validar_rango_float(char* str){
    float val = atof(str);
    if(val < MIN_FLOAT || val > MAX_FLOAT){
        printf("\nERROR: Constante flotante %s fuera de rango\n", yytext);
        exit(1);
    }
}

void handleErr(char* str){
    printf("\nCaracter inesperado: %s\n", yytext);
    exit(1);
}

void obtenerLexema(char* nombre){
    strcpy(yylval.str_val, nombre);
}

void agregar_a_TS(t_lexema lexema){
    insertarEnListaSinDuplicados(&lista_simbolos, lexema);
}

/*
void agregar_string_a_TSOLD(char* lex)
{
    char lexCopy[100];
    strcpy(lexCopy, lex);

    t_lexema lexema;

    eliminar_caracteres(lexCopy, '"');
    strcpy(lexema.valor, lexCopy);
    strcpy(lexema.tipodato, TIPO_STRING);
    itoa(strlen(lexCopy), lexema.longitud, 10);
    strcpy(lexema.nombre, "_");

    strcat(lexema.nombre, lexCopy);
    reemplazar_caracteres(lexema.nombre, ' ', '_');

    

    //strcpy(yylval.str_val, lexema.nombre); //ESTO LO HACEMOS PARA QUE RETORNE ESO COMO LEXEMA

    agregar_a_TS(lexema);

    contadorString++;
}
*/

void agregar_string_a_TS(char* lex)
{
    char lexCopy[100];
    char cont[100];
    
    strcpy(lexCopy, lex);

    t_lexema lexema;

    eliminar_caracteres(lexCopy, '"');
    strcpy(lexema.valor, lexCopy);
    strcpy(lexema.tipodato, TIPO_STRING);
    itoa(strlen(lexCopy), lexema.longitud, 10);

    strcpy(lexema.nombre, nombre_cte_string);
    itoa(contadorString, cont, 10);
    strcat(lexema.nombre, cont);    

    //strcpy(yylval.str_val, lexema.nombre); //ESTO LO HACEMOS PARA QUE RETORNE ESO COMO LEXEMA

    agregar_a_TS(lexema);

    contadorString++;
}


void agregar_num_a_TS(char* lex, char* tipo)
{
    char lexCopy[100];
    char nombre[100];
    t_lexema lexema;

    if (!strcmp(tipo, TIPO_FLOAT))
    {
        strcpy(lexCopy, lex);
        if (lex[0] == '.') {
            strcpy(lexCopy, "0");
            strcat(lexCopy, lex);
        } else if (lex[strlen(lex) - 1] == '.') {
            strcpy(lexCopy, lex);
            strcat(lexCopy, "0");
        }

        strcpy(nombre, lexCopy);

    } else {
        strcpy(lexCopy, lex);
        strcat(lexCopy, ".0"); //esto no está bien, porque no queremos modificar el nombre
        strcpy(nombre, lex);
    }

    strcpy(lexema.valor, lexCopy);
    strcpy(lexema.tipodato, tipo);
    strcpy(lexema.longitud, "0");
    strcpy(lexema.nombre, "_");
    strcat(lexema.nombre, nombre);


    //strcat(lexema.nombre, lexCopy);

    reemplazar_caracteres(lexema.nombre, '-', 'n');
    reemplazar_caracteres(lexema.nombre, '.', '_');

    //strcpy(yylval.str_val, lexema.nombre); //ESTO LO HACEMOS PARA QUE RETORNE ESO COMO LEXEMA

    strcpy(yylval.str_val, lexema.valor); //esto lo hacemos para escribir directamente en la RI 0.X o X.0

    agregar_a_TS(lexema);
}

void agregar_id_a_TS(char* lex)
{
    t_lexema lexema;

    strcpy(lexema.nombre, lex);
    strcpy(lexema.valor, "");
    strcpy(lexema.tipodato, "");
    strcpy(lexema.longitud, "");

    agregar_a_TS(lexema);
}

void eliminar_caracteres(char *s, char c)
{
    int writer = 0, reader = 0;

    while (s[reader])
    {
        if (s[reader]!=c) 
        {   
            s[writer++] = s[reader];
        }

        reader++;       
    }

    s[writer]=0;
}

void reemplazar_caracteres(char *s, char viejo, char nuevo){
    int reader = 0;

    while (s[reader])
    {
        if (s[reader] == viejo)
        {
            s[reader] = nuevo;
        }

        reader++;
    }
}