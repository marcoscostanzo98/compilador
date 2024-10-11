%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "Lista.h"
#include "Pila.h"
#include "Polaca.h"

FILE *yyin;
FILE *ts;

int yyerror();
int yylex();
void guardar_TS();
void actualizarTiposDeDato();
void validarTipoExpresion();
void validarTipoAsigExp(char* nombre);
void validarTipoAsigString(char* nombre);


void insertarPolaca(char* cad);

char* tabla_simbolos = "symbol-table.txt";
t_lista lista_simbolos;

t_polaca listaPolaca;

t_pila pilaCeldas; // si
t_pila pilaIds; // si
t_pila pilaTipoDatoExpresion;

/* variables auxiliares */
char* tipoDatoInit;

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


/* START SYMBOL */
%start inicio


%left '+' '-'
%left '*' '/'
%right MENOS_UNARIO

%%
//no se expresa en polaca ni lleva lógica extra
inicio: 
    programa {printf("   Programa es Inicio\n"); guardar_TS();}
;

//no se expresa en polaca ni lleva lógica extra
programa:
    init            {printf("   Init es Programa\n");}
    |init bloque    {printf("   Init Bloque es Programa\n");}
    |bloque         {printf("   Bloque es Programa\n");}
;

//no se expresa en polaca ni lleva lógica extra
bloque:
    bloque sentencia    {printf("   Bloque Sentencia es Bloque\n\n");}
    |sentencia          {printf("   Sentencia es Bloque\n\n");}
;

//no se expresa en polaca ni lleva lógica extra
sentencia:
    struct_condicional  {printf("   Struct_condicional es Sentencia\n");}
    |asignacion         {printf("   Asignacion es Sentencia\n");}
    |leer               {printf("   Leer es Sentencia\n");}
    |escribir           {printf("   Escribir es Sentencia\n");}
;

//no se expresa en polaca ni lleva lógica extra
init:
    INIT LLAVE_OP declaraciones LLAVE_CL {printf("   INIT LLAVE_OP Declaraciones LLAVE_CL es Init\n");}
;

//no se expresa en polaca ni lleva lógica extra
declaraciones:
    declaraciones declaracion    {printf("   Declaraciones Declaracion es Declaraciones\n");}
    |declaracion                 {printf("   Declaracion es Declaraciones\n");}
;

//no se expresa en polaca pero hay que apilar los ids de lista_ids y actualizar la TS con el valor de tipo_dato (guardar en variable global o apilar, mejor tener la var global)
//ya estaría
declaracion:
    lista_ids DOSPUNTOS tipo_dato {printf("   Lista_ids DOSPUNTOS Tipo_dato es Declaracion\n"); actualizarTiposDeDato();}
;

//no se expresa en polaca pero hay que apilarlos
//ya estaría
lista_ids:
    lista_ids COMA ID {printf("   Lista_ids COMA ID es Lista_ids\n"); apilar(&pilaIds, $3);}
    |ID              {printf("   ID es Lista_ids\n"); apilar(&pilaIds, $1);}
;

//no se expresa en polaca pero hay que guardarlo en una var global para actualizar la TS
//ya estaría
tipo_dato:
    T_STRING {printf("   T_STRING es Tipo_dato\n"); strcpy(tipoDato, $1);}
    |T_FLOAT {printf("   T_FLOAT es Tipo_dato\n"); strcpy(tipoDato, $1);}
    |T_INT   {printf("   T_INT es Tipo_dato\n"); strcpy(tipoDato, $1);}
;

//complicado de hacer la polaca, muchos saltos y se pueden anidar ifs, cuidado
struct_condicional:
    IF PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL ELSE LLAVE_OP bloque LLAVE_CL
        {printf("   IF PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL ELSE LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
    |IF PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL
        {printf("   IF PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
    |WHILE PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL
        {printf("   WHILE PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
;

//complicado de hacer la polaca, muchos saltos y se pueden anidar ifs, cuidado
condicional:
    condicion                         {printf("   Condicion es Condicional\n");}
    |condicion operador_logico condicion {printf("   Condicion Operador_logico Condicion es Condicional\n");}
    |OP_NOT condicion                 {printf("   OP_NOT Condicion es Condicional\n");} //cuidado con este porque esto cambia la comparación del comparador
;

//complicado de hacer la polaca, muchos saltos y se pueden anidar ifs, cuidado
condicion:
    expresion comparador expresion    {printf("   Expresion Comparador Expresion es Condicion\n");}
;

//complicado de hacer la polaca, muchos saltos y se pueden anidar ifs, cuidado
comparador:
    OP_EQ  {printf("   OP_EQ es Comparador\n");}
    |OP_NEQ {printf("   OP_NEQ es Comparador\n");}
    |OP_GT  {printf("   OP_GT es Comparador\n");}
    |OP_GEQ {printf("   OP_GEQ es Comparador\n");}
    |OP_LT  {printf("   OP_LT es Comparador\n");}
    |OP_LEQ {printf("   OP_LEQ es Comparador\n");}
;    

//esto generaría saltos extras en los ifs, no sé si habrá que apilarlos o usar flags
operador_logico:
    OP_AND {printf("   OP_AND es Operador_logico\n");}
    |OP_OR {printf("   OP_OR es Operador_logico\n");}
;

// listo pero hay que validar el tipo de dato (IMPORTANTE!!!!!) ya estaría validado el tipo de dato
asignacion:
    ID OP_ASIG expresion                {printf("   ID OP_ASIG Expresion es Asignacion\n"); validarTipoAsigExp($1); insertarPolaca($1); insertarPolaca($2);}
    |ID OP_ASIG CONST_STR               {printf("   ID OP_ASIG CONST_STR es Asignacion\n"); validarTipoAsigString($1); insertarPolaca($1); insertarPolaca($1);}
    |ID OP_ASIG funcion_especial        {printf("   ID OP_ASIG Funcion_especial es Asignacion\n"); validarTipoAsigExp($1); insertarPolaca($1); insertarPolaca($2);} //TODO: funcion_especial al final de todo debería apilar su tipo en pilaTipoDato
;

// listo
expresion:
    expresion OP_ADD termino                    {printf("   Expresion OP_ADD Termino es Expresion\n"); validarTipoExpresion(); insertarPolaca($2);}
    |expresion OP_SUB termino                   {printf("   Expresion OP_SUB Termino es Expresion\n"); validarTipoExpresion(); insertarPolaca($2);}
    |termino                                    {printf("   Termino es Expresion\n");}
;

// listo
termino:
    termino OP_MUL factor              {printf("   Termino OP_MUL Factor es Termino\n"); validarTipoExpresion(); insertarPolaca($2);}
    |termino OP_DIV factor             {printf("   Termino OP_DIV Factor es Termino\n"); validarTipoExpresion(); insertarPolaca($2);}
    |factor                            {printf("   Factor es Termino\n");}
;

//listo salvo el - unario
factor:
    ID                                 {printf("   ID es Factor\n"); insertarPolaca($1)}
    |OP_SUB PAR_OP expresion PAR_CL %prec MENOS_UNARIO //VER COMO HACER PARA NO PERDER EL SIGNO -
        {printf("   OP_SUB PAR_OP Expresion PAR_CL es Factor (Menos Unario)\n");}
    |OP_SUB ID %prec MENOS_UNARIO               {printf("   OP_SUB ID es Factor (Menos Unario)\n"); insertarPolaca($2);} //VER COMO NO PERDER EL SIGNO -
    |CONST_INT                                  {printf("   CONST_INT es Factor\n"); insertarPolaca($1); apilar(&tipoDatosExpresion, TIPO_INT);}
    |CONST_REAL                                 {printf("   CONST_REAL es Factor\n"); insertarPolaca($1); apilar(&tipoDatosExpresion, TIPO_FLOAT);}
    |PAR_OP expresion PAR_CL                    {printf("   PAR_OP Expresion PAR_CL es Factor\n");}
    |funcion_especial                           {printf("   Funcion_especial es Factor\n");}
    |OP_SUB funcion_especial %prec MENOS_UNARIO {printf("   OP_SUB Funcion_especial es Factor\n");} //VER COMO NO PERDER EL SIGNO -
;

//listo
leer:
    READ PAR_OP ID PAR_CL              {printf("   READ PAR_OP ID PAR_CL es Leer\n"); insertarPolaca($3); insertarPolaca("LEER");}
;

//listo
escribir:
    WRITE PAR_OP expresion PAR_CL      {printf("   WRITE PAR_OP Expresion PAR_CL es Escribir\n"); insertarPolaca($3); insertarPolaca("ESCRIBIR");}
    |WRITE PAR_OP CONST_STR PAR_CL     {printf("   WRITE PAR_OP CONST_STR PAR_CL es Escribir\n"); insertarPolaca($3); insertarPolaca("ESCRIBIR");}
;

//complicado, Santi ya hizo unas reglas pero habría que ver si funcionan bien
funcion_especial:
    suma_los_ultimos            {printf("   Suma_los_ultimos es Funcion_especial\n");}
    |get_penultimate_position   {printf("   Get_penultimate_position es Funcion_especial\n");}
;

//complicado, Santi ya hizo unas reglas pero habría que ver si funcionan bien
suma_los_ultimos:
    SUMALOSULTIMOS PAR_OP CONST_INT PUNTOYCOMA CORCHETE_OP lista_const CORCHETE_CL PAR_CL
        {printf("   SUMALOSULTIMOS PAR_OP CONST_INT PUNTOYCOMA CORCHETE_OP Lista_const CORCHETE_CL PAR_CL es Suma_los_ultimos\n");}
;

//complicado, Santi ya hizo unas reglas pero habría que ver si funcionan bien
get_penultimate_position:
    GETPENULTIMATEPOSITION PAR_OP CORCHETE_OP lista_const CORCHETE_CL PAR_CL
        {printf("   GETPENULTIMATEPOSITION PAR_OP CORCHETE_OP Lista_const CORCHETE_CL PAR_CL es Get_penultimate_position\n");}
;


//facil, Santi ya hizo unas reglas pero habría que ver si funcionan bien. Tener cuidado pq las 2 funciones usan este mismo no terminal, vamos a necesitar un flag.
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
    crearPila(&pilaCeldas);
    crearPila(&pilaIds);
    crearPila(&pilaTipoDatoExpresion);
    crearPolaca(&listaPolaca);

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

void actualizarTiposDeDato(){
    char* nombre;
    t_lexema actual;
    while(!pilaVacia(&pilaIds)) {
        strcpy(nombre, desapilar(&pilaIds));

        buscarEnlista(&lista_simbolos, nombre, &actual);

        if(strcmp(actual.tipo, "")) {
            printf("Variable %s ya declarada", nombre);
            exit(1);
        }

        buscarYActualizar(&lista_simbolos, actual, tipoDato); //TODO: DEFINIR LA PRIMITIVA DE LISTA. VER SI DEBERÍA LLAMARSE BuscarYActualizarTipoDato
    }
}

//TODO: ver si realmente es necesario.
void validarTipoExpresion(){
    char* tipo1 = desapilar(&pilaTipoDatoExpresion);
    char* tipo2 = desapilar(&pilaTipoDatoExpresion);

/* con esta opcion si hay un float y un int entonces se transforma a float, caso contrario queda int.
    if(strcmp(tipo1, TIPO_INT) == 0 || strcmp(tipo2, TIPO_INT) == 0){
        apilar(&pilaTipoDatoExpresion, TIPO_INT);
        return;
    }

    apilar(&pilaTipoDatoExpresion, TIPO_FLOAT);
*/

//con esta opción los 2 operadores tienen que ser del mismo tipo para avanzar con la expresión
    if(strcmp(tipo1, tipo2) != 0){
        printf("distintos tipos de dato"); //TODO: hacer un comentario mas bello
        exit(1);
    }

    apilar(&pilaTipoDatoExpresion, tipo1);
}

void validarTipoDatoAsigExp(char* nombre){
    char* tipoExp = desapilar(&pilaTipoDatoExpresion);

    t_lexema lex;
    
    int encontrado = buscarEnlista(&lista_simbolos, nombre, &lex);
    if(!encontrado) {
        printf("variable %s no declarada", nombre);
        exit(1);
    }

    if (strcmp(lex.tipoDato, tipoExp) != 0) {
        printf("distintos tipos de dato"); //TODO: hacer un comentario mas bello
        exit(1);
    }
}

void validarTipoAsigString(char* nombre){
    t_lexema lex;
    
    int encontrado = buscarEnlista(&lista_simbolos, nombre, &lex);
    if(!encontrado) {
        printf("variable %s no declarada", nombre);
        exit(1);
    }

    if (strcmp(lex.tipoDato, TIPO_STRING) != 0) {
        printf("distintos tipos de dato"); //TODO: hacer un comentario mas bello
        exit(1);
    }
}

// funciones de manejo de la lista de polaca inversa:
void insertarPolaca(char* cad){
    insertarEnPolaca(&lista_polaca, cad);
}