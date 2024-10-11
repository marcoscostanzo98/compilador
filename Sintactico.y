%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "Lista.h"
#include "Pila.h"
#include "Polaca.h"

//si quieren lo sacamos, es lo mismo
#define STRING "string"
#define FLOAT "float"
#define INT "int"

FILE *yyin;
FILE *ts;

int yyerror();
int yylex();
void guardar_TS();
void actualizarTiposDeDato();
void validarTipoExpresion();
void validarTipoAsigExp(char* nombre);
void validarTipoAsigString(char* nombre);

t_lexema buscarIdEnTS(char* nombre);

/* funciones de polaca */
void insertarPolaca(char* cad);
void imprimirPolaca();
void avanzarPolaca();
void apilarCelda();
void resolverSaltoIfSimple();
void actualizarCeldaPolaca(int celda, int nuevoValor);
void insertarIntEnPolaca(int num);
void insertarEtiquetaEnPolaca();

/* funciones de los ifs */
void insertarOperador();
void negarOperador();

/* funciones de pila de celdas */
int desapilarCelda();
void apilarCelda();

char* tabla_simbolos = "symbol-table.txt";
t_lista lista_simbolos;

t_polaca listaPolaca;

t_pila pilaCeldas; // si
t_pila pilaIds; // si
t_pila pilaTipoDatoExpresion;

/* variables auxiliares */
char tipoDatoInit[10];
int contadorTag = 0;

/* variables globales */
char operadorLogicoAct[10];
int negadorDeOperador; //no olvidar actualizar e inicializar

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
    programa {printf("   Programa es Inicio\n"); guardar_TS(); imprimirPolaca();}
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
    T_STRING {printf("   T_STRING es Tipo_dato\n"); strcpy(tipoDatoInit, STRING);}
    |T_FLOAT {printf("   T_FLOAT es Tipo_dato\n"); strcpy(tipoDatoInit, FLOAT);}
    |T_INT   {printf("   T_INT es Tipo_dato\n"); strcpy(tipoDatoInit, INT);}
;

//complicado de hacer la polaca, muchos saltos y se pueden anidar ifs, cuidado
struct_condicional:
    IF PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL {insertarPolaca("BI"); int celda = desapilarCelda(); actualizarCeldaPolaca(celda, listaPolaca.celdaActual+1); apilarCelda(); avanzarPolaca(); } ELSE LLAVE_OP bloque LLAVE_CL {int celda = desapilarCelda(); actualizarCeldaPolaca(celda, listaPolaca.celdaActual);}
        {printf("   IF PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL ELSE LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
    |IF PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL {resolverSaltoIfSimple();}
        {printf("   IF PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
    |WHILE PAR_OP {apilarCelda(); insertarEtiquetaEnPolaca();} condicional PAR_CL LLAVE_OP bloque LLAVE_CL {insertarPolaca("BI"); int celda = desapilarCelda(); actualizarCeldaPolaca(celda, listaPolaca.celdaActual+1); celda = desapilarCelda(); insertarIntEnPolaca(celda);}
        {printf("   WHILE PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
;

//complicado de hacer la polaca, muchos saltos y se pueden anidar ifs, cuidado
condicional:
    condicion                         {printf("   Condicion es Condicional\n");}
    |condicion operador_logico condicion {printf("   Condicion Operador_logico Condicion es Condicional\n");}
    |OP_NOT {negadorDeOperador = 1;} condicion                 {printf("   OP_NOT Condicion es Condicional\n"); negadorDeOperador = 0; /*ver si va acá*/} //cuidado con este porque esto cambia la comparación del comparador
;

//complicado de hacer la polaca, muchos saltos y se pueden anidar ifs, cuidado
condicion:
    expresion comparador expresion    {printf("   Expresion Comparador Expresion es Condicion\n"); insertarPolaca("CMP"); insertarOperador(); apilarCelda(); avanzarPolaca();}
;

//complicado de hacer la polaca, muchos saltos y se pueden anidar ifs, cuidado
comparador:
    OP_EQ  {printf("   OP_EQ es Comparador\n"); strcpy(operadorLogicoAct, "BNE");}
    |OP_NEQ {printf("   OP_NEQ es Comparador\n"); strcpy(operadorLogicoAct, "BEQ");}
    |OP_GT  {printf("   OP_GT es Comparador\n"); strcpy(operadorLogicoAct, "BLE");}
    |OP_GEQ {printf("   OP_GEQ es Comparador\n"); strcpy(operadorLogicoAct, "BLT");}
    |OP_LT  {printf("   OP_LT es Comparador\n"); strcpy(operadorLogicoAct, "BGE");}
    |OP_LEQ {printf("   OP_LEQ es Comparador\n"); strcpy(operadorLogicoAct, "BGT");}
;

//esto generaría saltos extras en los ifs, no sé si habrá que apilarlos o usar flags
operador_logico:
    OP_AND {printf("   OP_AND es Operador_logico\n");}
    |OP_OR {printf("   OP_OR es Operador_logico\n");}
;

// listo pero hay que validar el tipo de dato (IMPORTANTE!!!!!) ya estaría validado el tipo de dato
asignacion:
    ID OP_ASIG expresion                {printf("   ID OP_ASIG Expresion es Asignacion\n"); validarTipoAsigExp($1); insertarPolaca($1); insertarPolaca(":=");}
    |ID OP_ASIG CONST_STR               {printf("   ID OP_ASIG CONST_STR es Asignacion\n"); validarTipoAsigString($1); insertarPolaca($3); insertarPolaca($1); insertarPolaca(":=");}
    |ID OP_ASIG funcion_especial        {printf("   ID OP_ASIG Funcion_especial es Asignacion\n"); validarTipoAsigExp($1); insertarPolaca($1); insertarPolaca(":=");} //TODO: funcion_especial al final de todo debería apilar su tipo en pilaTipoDato
;

// listo
expresion:
    expresion OP_ADD termino                    {printf("   Expresion OP_ADD Termino es Expresion\n"); validarTipoExpresion(); insertarPolaca("+");}
    |expresion OP_SUB termino                   {printf("   Expresion OP_SUB Termino es Expresion\n"); validarTipoExpresion(); insertarPolaca("-");}
    |termino                                    {printf("   Termino es Expresion\n");}
;

// listo
termino:
    termino OP_MUL factor              {printf("   Termino OP_MUL Factor es Termino\n"); validarTipoExpresion(); insertarPolaca("*");}
    |termino OP_DIV factor             {printf("   Termino OP_DIV Factor es Termino\n"); validarTipoExpresion(); insertarPolaca("/");}
    |factor                            {printf("   Factor es Termino\n");}
;

//listo salvo el - unario
factor:
    ID                                 {printf("   ID es Factor\n"); insertarPolaca($1); t_lexema lex = buscarIdEnTS($1); apilar(&pilaTipoDatoExpresion, lex.tipodato);}
    |OP_SUB PAR_OP expresion PAR_CL %prec MENOS_UNARIO //VER COMO HACER PARA NO PERDER EL SIGNO - (creo que está resuelto)
        {printf("   OP_SUB PAR_OP Expresion PAR_CL es Factor (Menos Unario)\n"); insertarPolaca("-1"); insertarPolaca("*");} 
    |OP_SUB ID %prec MENOS_UNARIO               {printf("   OP_SUB ID es Factor (Menos Unario)\n"); t_lexema lex = buscarIdEnTS($2); apilar(&pilaTipoDatoExpresion, lex.tipodato); insertarPolaca($2); insertarPolaca("-1"); insertarPolaca("*");}
    |CONST_INT                                  {printf("   CONST_INT es Factor\n"); insertarPolaca($1); apilar(&pilaTipoDatoExpresion, INT);}
    |CONST_REAL                                 {printf("   CONST_REAL es Factor\n"); insertarPolaca($1); apilar(&pilaTipoDatoExpresion, FLOAT);}
    |PAR_OP expresion PAR_CL                    {printf("   PAR_OP Expresion PAR_CL es Factor\n");}
    |funcion_especial                           {printf("   Funcion_especial es Factor\n");}
    |OP_SUB funcion_especial %prec MENOS_UNARIO {printf("   OP_SUB Funcion_especial es Factor\n"); insertarPolaca("-1"); insertarPolaca("*");}
;

//listo
leer:
    READ PAR_OP ID PAR_CL              {printf("   READ PAR_OP ID PAR_CL es Leer\n"); insertarPolaca($3); insertarPolaca("LEER");}
;

//listo
escribir:
    WRITE PAR_OP expresion PAR_CL      {printf("   WRITE PAR_OP Expresion PAR_CL es Escribir\n"); insertarPolaca("ESCRIBIR");}
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

// funciones de manejo de la tabla de simbolos
void actualizarTiposDeDato(){
    char* nombre;
    t_lexema actual;
    while(!pilaVacia(&pilaIds)) {
        nombre = desapilar(&pilaIds);
        buscarEnlista(&lista_simbolos, nombre, &actual);

        if(strcmp(actual.tipodato, "")) {
            printf("Variable %s ya declarada", nombre);
            exit(1);
        }

        buscarYactualizarTipoDato(&lista_simbolos, actual.nombre, tipoDatoInit); //TODO: DEFINIR LA PRIMITIVA DE LISTA. VER SI DEBERÍA LLAMARSE BuscarYActualizarTipoDato
    }
}

t_lexema buscarIdEnTS(char* nombre){
    t_lexema lex;
    buscarEnlista(&lista_simbolos, nombre, &lex);

    if(strcmp(lex.tipodato, "") == 0){
        printf("variable '%s' no definida inicialmente\n", nombre);
        exit(1);
    }

    return lex;
}

// funciones de validaciones

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
    //ver si queremos pasarlo a float, eso lo hablamos entre todos despues
    if(strcmp(tipo1, tipo2) != 0){
        printf("distintos tipos de dato en calculo de expresion. Se intenta operar entre %s y %s\n", tipo1, tipo2);
        exit(1);
    }

    apilar(&pilaTipoDatoExpresion, tipo1);
}

void validarTipoAsigExp(char* nombre){
    char* tipoExp = desapilar(&pilaTipoDatoExpresion);

    /*
    t_lexema lex;
    buscarEnlista(&lista_simbolos, nombre, &lex);
    if (strcmp(lex.tipodato, "") == 0) {
        printf("variable '%s' no definida inicialmente\n", nombre);
        exit(1);
    }
    */

    t_lexema lex = buscarIdEnTS(nombre);
    if (strcmp(lex.tipodato, tipoExp) != 0) {
        printf("distintos tipos de dato. '%s' es %s y se intenta asignar un %s\n", lex.nombre, lex.tipodato, tipoExp);
        exit(1);
    }
}

void validarTipoAsigString(char* nombre){
    /*
    t_lexema lex;
        buscarEnlista(&lista_simbolos, nombre, &lex);
    if (!strcmp(lex.tipodato, "")) {
        printf("variable '%s' no definida inicialmente\n", nombre);
        exit(1);
    }
    */

    t_lexema lex = buscarIdEnTS(nombre);
    if (strcmp(lex.tipodato, STRING) != 0) {
        printf("distintos tipos de dato. '%s' es %s y se intenta asignar un %s\n", lex.nombre, lex.tipodato, STRING);
        exit(1);
    }
}

// funciones de manejo de la lista de polaca inversa:
void insertarPolaca(char* cad){
    insertarEnPolaca(&listaPolaca, cad);
}

void imprimirPolaca(){
    char elemPolaca[100];
    int celdaMax = listaPolaca.celdaActual;

    while(!polacaVacia(&listaPolaca)){
        extraerPrimeroDePolaca(&listaPolaca, elemPolaca);
        printf("%5s | ", elemPolaca);
    }

    printf("\n");

    for(int i = 0; i < celdaMax; i++){
        printf("%5d | ", i);
    }

    printf("\n");
}

void avanzarPolaca(){
    insertarEnPolaca(&listaPolaca, "_");
}

void actualizarCeldaPolaca(int celda, int nuevoValor) {
    char nuevaCeldaStr[100];
    itoa(nuevoValor, nuevaCeldaStr, 10);
    buscarYActualizarPolaca(&listaPolaca, celda, nuevaCeldaStr);
}

void insertarIntEnPolaca(int num) {
    char str[100];
    itoa(num, str, 10);
    insertarPolaca(str);
}

void insertarEtiquetaEnPolaca() {
    char tag[10];
    sprintf(tag, "ET_%d", contadorTag++);
    insertarEnPolaca(&listaPolaca, tag);
}

//funciones de pila celdas
int desapilarCelda(){
    char *celdaStr = desapilar(&pilaCeldas);    
    return atoi(celdaStr);
}

void apilarCelda(){
    char celdaStr[100];
    itoa(listaPolaca.celdaActual, celdaStr, 10);
    apilar(&pilaCeldas, celdaStr);
}

// funciones de ifs
void insertarOperador(){
    if(negadorDeOperador) {
        negarOperador();
    }

    insertarPolaca(operadorLogicoAct);
}

void negarOperador(){
    if(strcmp(operadorLogicoAct, "BEQ") == 0){
        strcpy(operadorLogicoAct, "BNE");
        return;
    }
    
    if(strcmp(operadorLogicoAct, "BNE") == 0){
        strcpy(operadorLogicoAct, "BEQ");
        return;
    }

    if(strcmp(operadorLogicoAct, "BLE") == 0){
        strcpy(operadorLogicoAct, "BGT");
        return;
    }
    
    if(strcmp(operadorLogicoAct, "BLT") == 0){
        strcpy(operadorLogicoAct, "BGE");
        return;
    }
    
    if(strcmp(operadorLogicoAct, "BGE") == 0){
        strcpy(operadorLogicoAct, "BLT");
        return;
    }

    if(strcmp(operadorLogicoAct, "BGT") == 0){
        strcpy(operadorLogicoAct, "BLE");
        return;
    }
}

void resolverSaltoIfSimple(){
    int celda = desapilarCelda();
    actualizarCeldaPolaca(celda, listaPolaca.celdaActual);
}