%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Lista.h"
#include "Pila.h"
#include "Polaca.h"

#define STRING "string"
#define FLOAT "float"
#define INT "int"

extern FILE *yyin;
FILE *ts;

int yyerror();
int yylex();
void guardar_TS();
void actualizarTiposDeDato();
void validarTipoExpresion();
void validarTipoAsigExp(char* nombre);
void validarTipoAsigString(char* nombre);

t_lexema buscarIdEnTS(char* nombre);
t_lexema buscarValorEnTS(char* valor);


/* funciones de polaca */
void insertarPolaca(char* cad);
void guardarPolaca();

void guardarPolaca2();
void preprocesarPolaca(t_polaca* polaca, t_lista* listaTS);
int esSalto(const char* celda);

void avanzarPolaca();
void apilarCelda();
void actualizarCeldaPolaca(int celda, int nuevoValor);
void insertarEtiquetaEnPolaca();

void resolverSumaLosUltimos(int pivote);
void resolverGetUltimatePosition();

/* funciones de los ifs */
void insertarOperador();
void negarOperador();
void validarComparadores();
void resolverCondicionConector();

void resolverSalto(int postBloque, int esElse);

/* funciones de pila de celdas */
int desapilarCelda();
void apilarCelda();
void apilarCeldaAnterior();

/* funciones de assembler */
void generarAssembler();
void generarCabeceraAssembler(FILE* fAssembler, t_lista* listaTS);
void generarCuerpoAssembler(FILE* fAssembler);
void generarFinAssembler(FILE* fAssembler);
void operacionMatAsselmber(FILE* fAssembler, char* operador);
void asignacionAssembler(FILE* fAssembler);
void comparacionAssembler(FILE* fAssembler);
void BIAssembler(FILE* fAssembler);
void operacionEscribirAssembler(FILE* fAssembler);
void operacionLeerAssembler(FILE* fAssembler);

void mergeArchivosAssembler(FILE* fAssembler, FILE* fBodyAsm);

int esOperando(char* celda);
char* esOperadorMat(char* celda);
char* newAuxiliar();
char* convertirSalto(char* celda);


void procesarCeldaPolaca(FILE* fAssembler, char* celda);

/* funciones auxiliares */
void reemplazarCaracteres(char *s, char viejo, char nuevo);
void eliminarCaracteres(char *s, char c);
char* agregarPrefijo(const char *s, char *prefijo);
int esNumero(const char* celda);
int esCadena(const char* celda);

char* tabla_simbolos = "symbol-table.txt";
t_lista lista_simbolos;

t_polaca listaPolaca;
t_polaca polacaDup;

t_pila pilaCeldas;
t_pila pilaIds;
t_pila pilaTipoDatoExpresion;
t_pila pilaConectores;

t_pila pilaOperandos;
t_pila pilaAuxAssembler;

/* variables auxiliares */
char tipoDatoInit[10];
int contadorTag = 0;
int contListaAux = 0;
int auxActual = 0;

/* variables globales */
char operadorLogicoAct[10];
int negadorDeOperador;

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
inicio: 
    programa {printf("   Programa es Inicio\n"); generarAssembler();}
;

programa:
    init            {printf("   Init es Programa\n");}
    |init bloque    {printf("   Init Bloque es Programa\n");}
    |bloque         {printf("   Bloque es Programa\n");}
;

bloque:
    bloque sentencia    {printf("   Bloque Sentencia es Bloque\n\n");}
    |sentencia          {printf("   Sentencia es Bloque\n\n");}
;

sentencia:
    struct_condicional  {printf("   Struct_condicional es Sentencia\n");}
    |asignacion         {printf("   Asignacion es Sentencia\n");}
    |leer               {printf("   Leer es Sentencia\n");}
    |escribir           {printf("   Escribir es Sentencia\n");}
;

init:
    INIT LLAVE_OP declaraciones LLAVE_CL {printf("   INIT LLAVE_OP Declaraciones LLAVE_CL es Init\n");}
;

declaraciones:
    declaraciones declaracion    {printf("   Declaraciones Declaracion es Declaraciones\n");}
    |declaracion                 {printf("   Declaracion es Declaraciones\n");}
;

declaracion:
    lista_ids DOSPUNTOS tipo_dato {printf("   Lista_ids DOSPUNTOS Tipo_dato es Declaracion\n"); actualizarTiposDeDato();}
;

lista_ids:
    lista_ids COMA ID {printf("   Lista_ids COMA ID es Lista_ids\n"); apilar(&pilaIds, $3);}
    |ID              {printf("   ID es Lista_ids\n"); apilar(&pilaIds, $1);}
;

tipo_dato:
    T_STRING {printf("   T_STRING es Tipo_dato\n"); strcpy(tipoDatoInit, STRING);}
    |T_FLOAT {printf("   T_FLOAT es Tipo_dato\n"); strcpy(tipoDatoInit, FLOAT);}
    |T_INT   {printf("   T_INT es Tipo_dato\n"); strcpy(tipoDatoInit, INT);}
;

struct_condicional:
    if ELSE {insertarPolaca("BI"); avanzarPolaca(); resolverSalto(2, 0); apilarCeldaAnterior();} LLAVE_OP bloque LLAVE_CL {resolverSalto(1, 1);}
        {printf("   IF PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL ELSE LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}

    |if {resolverSalto(1, 0);}
       {printf("   IF PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}

    |WHILE PAR_OP {apilarCelda(); insertarEtiquetaEnPolaca();} condicional PAR_CL LLAVE_OP {resolverSalto(0, 0);} 
        bloque  LLAVE_CL {insertarPolaca("BI"); avanzarPolaca(); resolverSalto(1, 0); apilarCeldaAnterior(); 
                            int celda = desapilarCelda(); actualizarCeldaPolaca(celda, desapilarCelda());}
        {printf("   WHILE PAR_OP Condicional PAR_CL LLAVE_OP Bloque LLAVE_CL es Struct_condicional\n");}
;

if:
    IF PAR_OP condicional PAR_CL LLAVE_OP {resolverSalto(0, 0);} bloque LLAVE_CL

condicional:
    condicion                         {printf("   Condicion es Condicional\n"); apilar(&pilaConectores, "");}
    |condicion operador_logico {resolverCondicionConector();} condicion {printf("   Condicion Operador_logico Condicion es Condicional\n");}
    |OP_NOT {negadorDeOperador = 1;} condicion                 {printf("   OP_NOT Condicion es Condicional\n"); apilar(&pilaConectores, ""); negadorDeOperador = 0;}
;

condicion:
    expresion comparador expresion {printf("   Expresion Comparador Expresion es Condicion\n"); validarComparadores(); insertarPolaca("CMP"); insertarOperador(); apilarCelda(); avanzarPolaca();}
;

comparador:
    OP_EQ  {printf("   OP_EQ es Comparador\n"); strcpy(operadorLogicoAct, "BNE");}
    |OP_NEQ {printf("   OP_NEQ es Comparador\n"); strcpy(operadorLogicoAct, "BEQ");}
    |OP_GT  {printf("   OP_GT es Comparador\n"); strcpy(operadorLogicoAct, "BLE");}
    |OP_GEQ {printf("   OP_GEQ es Comparador\n"); strcpy(operadorLogicoAct, "BLT");}
    |OP_LT  {printf("   OP_LT es Comparador\n"); strcpy(operadorLogicoAct, "BGE");}
    |OP_LEQ {printf("   OP_LEQ es Comparador\n"); strcpy(operadorLogicoAct, "BGT");}
;

operador_logico:
    OP_AND {printf("   OP_AND es Operador_logico\n"); apilar(&pilaConectores, "AND");}
    |OP_OR {printf("   OP_OR es Operador_logico\n"); apilar(&pilaConectores, "OR");}
;

asignacion:
    ID OP_ASIG expresion                {printf("   ID OP_ASIG Expresion es Asignacion\n"); validarTipoAsigExp($1); insertarPolaca($1); insertarPolaca(":=");}
    |ID OP_ASIG CONST_STR               {printf("   ID OP_ASIG CONST_STR es Asignacion\n"); validarTipoAsigString($1); insertarPolaca($3); insertarPolaca($1); insertarPolaca(":=");}
;

expresion:
    expresion OP_ADD termino                    {printf("   Expresion OP_ADD Termino es Expresion\n"); validarTipoExpresion(); insertarPolaca("+");}
    |expresion OP_SUB termino                   {printf("   Expresion OP_SUB Termino es Expresion\n"); validarTipoExpresion(); insertarPolaca("-");}
    |termino                                    {printf("   Termino es Expresion\n");}
;

termino:
    termino OP_MUL factor              {printf("   Termino OP_MUL Factor es Termino\n"); validarTipoExpresion(); insertarPolaca("*");}
    |termino OP_DIV factor             {printf("   Termino OP_DIV Factor es Termino\n"); validarTipoExpresion(); insertarPolaca("/");}
    |factor                            {printf("   Factor es Termino\n");}
;

factor:
    ID                                 {printf("   ID es Factor\n"); insertarPolaca($1); t_lexema lex = buscarIdEnTS($1); apilar(&pilaTipoDatoExpresion, lex.tipodato);}
    |OP_SUB PAR_OP expresion PAR_CL %prec MENOS_UNARIO
        {printf("   OP_SUB PAR_OP Expresion PAR_CL es Factor (Menos Unario)\n"); insertarPolaca("-1"); insertarPolaca("*");}
    |OP_SUB ID %prec MENOS_UNARIO               {printf("   OP_SUB ID es Factor (Menos Unario)\n"); t_lexema lex = buscarIdEnTS($2); apilar(&pilaTipoDatoExpresion, lex.tipodato); insertarPolaca($2); if(strcmp(lex.tipodato, STRING) == 0){printf("\nError semantico, las variables string no tienen signo\n"); exit(1);} insertarPolaca("-1"); insertarPolaca("*");}
    |CONST_INT                                  {printf("   CONST_INT es Factor\n"); printf("VA A INSERTAR: %s\n", $1); insertarPolaca($1); apilar(&pilaTipoDatoExpresion, INT);}
    |CONST_REAL                                 {printf("   CONST_REAL es Factor\n"); insertarPolaca($1); apilar(&pilaTipoDatoExpresion, FLOAT);}
    |PAR_OP expresion PAR_CL                    {printf("   PAR_OP Expresion PAR_CL es Factor\n");}
    |funcion_especial                           {printf("   Funcion_especial es Factor\n");}
    |OP_SUB funcion_especial %prec MENOS_UNARIO {printf("   OP_SUB Funcion_especial es Factor\n"); insertarPolaca("-1"); insertarPolaca("*");}
;

leer:
    READ PAR_OP ID PAR_CL              {printf("   READ PAR_OP ID PAR_CL es Leer\n"); insertarPolaca($3); insertarPolaca("LEER");}
;

escribir:
    WRITE PAR_OP expresion PAR_CL      {printf("   WRITE PAR_OP Expresion PAR_CL es Escribir\n"); insertarPolaca("ESCRIBIR");}
    |WRITE PAR_OP CONST_STR PAR_CL     {printf("   WRITE PAR_OP CONST_STR PAR_CL es Escribir\n"); insertarPolaca($3); insertarPolaca("ESCRIBIR");}
;

funcion_especial:
    suma_los_ultimos            {printf("   Suma_los_ultimos es Funcion_especial\n");}
    |get_penultimate_position   {printf("   Get_penultimate_position es Funcion_especial\n");}
;

suma_los_ultimos:
    SUMALOSULTIMOS PAR_OP CONST_INT PUNTOYCOMA CORCHETE_OP lista_const CORCHETE_CL PAR_CL
        {printf("   SUMALOSULTIMOS PAR_OP CONST_INT PUNTOYCOMA CORCHETE_OP Lista_const CORCHETE_CL PAR_CL es Suma_los_ultimos\n");resolverSumaLosUltimos(atoi($3));}
;

get_penultimate_position:
    GETPENULTIMATEPOSITION PAR_OP CORCHETE_OP lista_const CORCHETE_CL PAR_CL
        {printf("   GETPENULTIMATEPOSITION PAR_OP CORCHETE_OP Lista_const CORCHETE_CL PAR_CL es Get_penultimate_position\n"); resolverGetUltimatePosition();}
;

lista_const:
    lista_const COMA CONST_REAL        {printf("   Lista_const COMA CONST_REAL es Lista_const\n");apilar(&pilaCeldas, $3);apilar(&pilaTipoDatoExpresion, FLOAT);contListaAux++;}
    |lista_const COMA CONST_INT        {printf("   Lista_const COMA CONST_INT es Lista_const\n");apilar(&pilaCeldas, $3);apilar(&pilaTipoDatoExpresion, INT);contListaAux++;}
    |CONST_INT                         {printf("   CONST_INT es Lista_const\n");apilar(&pilaCeldas, $1);apilar(&pilaTipoDatoExpresion, INT);contListaAux++;}
    |CONST_REAL                        {printf("   CONST_REAL es Lista_const\n");apilar(&pilaCeldas, $1);apilar(&pilaTipoDatoExpresion, FLOAT);contListaAux++;}
;

%%

int main(int argc, char *argv[])
{
    crearLista(&lista_simbolos);
    crearPila(&pilaCeldas);
    crearPila(&pilaIds);
    crearPila(&pilaTipoDatoExpresion);
    crearPila(&pilaConectores);
    crearPolaca(&listaPolaca);

    if((yyin = fopen(argv[1], "rt")) == NULL){
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
    } else{ 
        yyparse();
    }

    guardar_TS();
    guardarPolaca(); 
	
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
        printf("\nError al intentar guardar en la tabla de simbolos\n");
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
            printf("\nVariable %s ya declarada\n", nombre);
            exit(1);
        }

        buscarYactualizarTipoDato(&lista_simbolos, actual.nombre, tipoDatoInit);
    }
}

t_lexema buscarIdEnTS(char* nombre){
    t_lexema lex;
    buscarEnlista(&lista_simbolos, nombre, &lex);

    if(strcmp(lex.tipodato, "") == 0){
        printf("\nVariable '%s' no definida inicialmente\n", nombre);
        exit(1);
    }

    return lex;
}

// funciones de validaciones
void validarTipoExpresion(){
    char* tipo1 = desapilar(&pilaTipoDatoExpresion);
    char* tipo2 = desapilar(&pilaTipoDatoExpresion);

    //con esta opción los 2 operadores tienen que ser del mismo tipo para avanzar con la expresión
    if(strcmp(tipo1, STRING) == 0 || strcmp(tipo2, STRING) == 0){
        printf("\nNo se pueden realizar operaciones entre strings\n");
        exit(1);
    }

    if(strcmp(tipo1, tipo2) != 0){
        printf("\nDistintos tipos de dato en calculo de expresion. Se intenta operar entre %s y %s\n", tipo1, tipo2);
        exit(1);
    }

    apilar(&pilaTipoDatoExpresion, tipo1);
}

void validarTipoAsigExp(char* nombre){
    char* tipoExp = desapilar(&pilaTipoDatoExpresion);

    t_lexema lex = buscarIdEnTS(nombre);
    
    if (strcmp(tipoExp, STRING) == 0) {
        printf("\nError sintactico. no se puede utilizar string como expresion\n");
        exit(1);
    }


    if (strcmp(lex.tipodato, tipoExp) != 0) {
        printf("\nDistintos tipos de dato. '%s' es %s y se intenta asignar un %s\n", lex.nombre, lex.tipodato, tipoExp);
        exit(1);
    }
}

void validarTipoAsigString(char* nombre){
    t_lexema lex = buscarIdEnTS(nombre);
    if (strcmp(lex.tipodato, STRING) != 0) {
        printf("\nDistintos tipos de dato. '%s' es %s y se intenta asignar un %s\n", lex.nombre, lex.tipodato, STRING);
        exit(1);
    }
}

// funciones de manejo de la lista de polaca inversa:
void insertarPolaca(char* cad){
    insertarEnPolaca(&listaPolaca, cad);
}

void guardarPolaca(){
    FILE *codigo_intermedio;
    codigo_intermedio = fopen("intermediate-code.txt", "wt");
    if (!codigo_intermedio) {
        printf("\nError al intentar generar el codigo intermedio\n");
        return;
    }

    if(polacaVacia(&listaPolaca)){
        fclose(codigo_intermedio);
        return;
    }

    char elemPolaca[100];

    extraerPrimeroDePolaca(&listaPolaca, elemPolaca);
    fprintf(codigo_intermedio, "%s", elemPolaca);
    while(!polacaVacia(&listaPolaca)){
        extraerPrimeroDePolaca(&listaPolaca, elemPolaca);
        fprintf(codigo_intermedio, "|%s", elemPolaca);
    }

    fclose(codigo_intermedio);
    return;
}

void avanzarPolaca(){
    insertarEnPolaca(&listaPolaca, "_");
}

void actualizarCeldaPolaca(int celda, int nuevoValor) {
    char nuevaCeldaStr[100];
    itoa(nuevoValor, nuevaCeldaStr, 10);
    buscarYActualizarPolaca(&listaPolaca, celda, nuevaCeldaStr);
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

void apilarCeldaAnterior(){
    char celdaStr[100];
    itoa(listaPolaca.celdaActual - 1, celdaStr, 10);
    apilar(&pilaCeldas, celdaStr);
}

void resolverSumaLosUltimos(int pivote){
    char tipo_dato_fin_aux[10];
    if(pivote < 1 || pivote > contListaAux){
        insertarPolaca("0.0");
        t_lexema lex0;
        strcpy(lex0.nombre,"_0");
        strcpy(lex0.tipodato,"CTE_INTEGER");
        strcpy(lex0.valor,"0.0");
        strcpy(lex0.longitud,"0");
        insertarEnListaSinDuplicados(&lista_simbolos, lex0);
        strcpy(tipo_dato_fin_aux,INT);
    } else {
        int tamAux = contListaAux-pivote+1;
        char * tope1 = desapilar(&pilaCeldas);
        insertarPolaca(tope1);
        tamAux--;
        contListaAux--;
        while(tamAux!=0){
            char * tope2 = desapilar(&pilaCeldas);
            validarTipoExpresion();
            insertarPolaca(tope2);
            insertarPolaca("+");
            tamAux--;
            contListaAux--;
        }

        strcpy(tipo_dato_fin_aux, desapilar(&pilaTipoDatoExpresion));
    }

    while(contListaAux!=0){
        desapilar(&pilaCeldas);
        desapilar(&pilaTipoDatoExpresion);
        contListaAux--;
    }

    apilar(&pilaTipoDatoExpresion,tipo_dato_fin_aux);
}

void resolverGetUltimatePosition(){
    if(!desapilar(&pilaCeldas))
        yyerror();

    desapilar(&pilaTipoDatoExpresion);
    char* pult= desapilar(&pilaCeldas);
    char* tipo_dato_aux=desapilar(&pilaTipoDatoExpresion);
    if(!pult)
        yyerror();
    
    insertarPolaca(pult);
    contListaAux=contListaAux-2;
    while(contListaAux!=0){
        desapilar(&pilaCeldas);
        desapilar(&pilaTipoDatoExpresion);
        contListaAux--;
    }

    apilar(&pilaTipoDatoExpresion,tipo_dato_aux);
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

void resolverSalto(int postBloque, int esElse){
    int celda;
    char * conector = topePila(&pilaConectores);

    //CASO IF SIMPLE
    if(strcmp(conector, "") == 0){
        if(postBloque){
            celda = desapilarCelda();
            actualizarCeldaPolaca(celda, listaPolaca.celdaActual);
            if(postBloque == 1){ //para el caso de if else, en el cuerpo del verdadero (2) no tiene que desapilar el conector, solo después del cuerpo del else (1).
                desapilar(&pilaConectores);
            }
        }

        //no hago nada
        return;
    }

    //CASO AND
    if(strcmp(conector, "AND") == 0){
        if(postBloque){ //si es if else, debería desapilar con postBloque en 2 pero 1 solo con postBloque en 1
            //Si se llama post bloque, actualizo las dos celdas de los saltos para que me lleven al final del condicional; sino no hago nada
            celda = desapilarCelda();
            actualizarCeldaPolaca(celda, listaPolaca.celdaActual);

            if((postBloque == 1 && !esElse) || postBloque == 2 ){ //solo desapilo 2 cuando estoy en un postBloque excepto en el 2° resolverSalto del if-else
                celda = desapilarCelda();
                actualizarCeldaPolaca(celda, listaPolaca.celdaActual);
            }

           if(postBloque == 1){ //para el caso de if else, en el cuerpo del verdadero (2) no tiene que desapilar el conector, solo después del cuerpo del else (1).
                desapilar(&pilaConectores);
            }
        }

        //no hago nada
        return;
    }

    //CASO OR
    if(strcmp(conector, "OR") == 0){
        //Si se llama post bloque actualizo la celda que me lleva al final del condicional; si es pre bloque SALTEO (desapilo y luego apilo de nuevo) la celda que me lleva
        //al fin del condicional (porque eso lo leo POST BLOQUE) y actualizo la celda que me lleva al body en caso de cumplirse la primera condición.
        if(postBloque){
            //celda que me debería llevar despues al fin de todo el if
            celda = desapilarCelda();
            actualizarCeldaPolaca(celda, listaPolaca.celdaActual);

            if(postBloque == 1){ //para el caso de if else, en el cuerpo del verdadero (2) no tiene que desapilar el conector, solo después del cuerpo del else (1).
                desapilar(&pilaConectores);
            }
            return;
        }else{
            //celda que me debería llevar despues al fin de todo el if
            int celda_aux = desapilarCelda();

            //actualizo la celda que me lleva si se cumple la primera condicion
            int celda_cond_true = desapilarCelda();
            actualizarCeldaPolaca(celda_cond_true, listaPolaca.celdaActual);

            //vuelvo a apilar la celda que me lleva al fin del if
            apilarCeldaAnterior();
        }
    }
}

void validarComparadores() {
    char* tipo1 = desapilar(&pilaTipoDatoExpresion);
    char* tipo2 = desapilar(&pilaTipoDatoExpresion);

    if(!strcmp(tipo1, STRING) || !strcmp(tipo2, STRING)) {
        printf("\nError en condicion. No se pueden realizar comparaciones con cadenas\n");
        exit(1);
    }

    if(strcmp(tipo1, tipo2) != 0){
        printf("\nError en condicion. Se intenta comparar operadores %s y %s\n", tipo1, tipo2);
        exit(1);
    }
}

void resolverCondicionConector(){
    char * conector = desapilar(&pilaConectores);
    if(strcmp(conector, "OR") == 0){
        insertarPolaca("BI");
        int celda = desapilarCelda();
        actualizarCeldaPolaca(celda, listaPolaca.celdaActual + 1);
        apilarCelda();
        avanzarPolaca();
    }

    apilar(&pilaConectores, conector);
}


// funciones de assembler
void generarAssembler(){
    crearPila(&pilaOperandos);
    crearPila(&pilaAuxAssembler);

    FILE* fAssembler = fopen("final.asm", "wt+");
    if(!fAssembler) {
        printf("\nError al abrir el archivo final.asm\n");
        exit(1);
    }

    FILE* fBodyAsm = fopen("final.temp", "wt+");
    if(!fBodyAsm) {
        printf("\nError al abrir el archivo final.temp\n");
        exit(1);
    }

    //duplico la lista_simbolos para cargar las variables:
    t_lista simbolosDup;
    crearLista(&simbolosDup);
    duplicarLista(&lista_simbolos, &simbolosDup);

    //duplico la polaca para poder iterarla
    duplicarPolaca(&listaPolaca,&polacaDup);

    preprocesarPolaca(&polacaDup, &simbolosDup);

    //escribo el body del assembler:
    generarCuerpoAssembler(fBodyAsm);

    //escribo la cabecera del assembler:
    generarCabeceraAssembler(fAssembler, &simbolosDup);

    mergeArchivosAssembler(fAssembler, fBodyAsm);

    //escribo el fin del assembler:
    generarFinAssembler(fAssembler);

    printf("\n\nAssembler generado exitosamente\n\n");
    fclose(fAssembler);
}


void guardarPolaca2(){
    FILE *codigo_intermedio;
    codigo_intermedio = fopen("intermediate-code-test.txt", "wt");
    if (!codigo_intermedio) {
        printf("\nError al intentar generar el codigo intermedio\n");
        return;
    }

    if(polacaVacia(&polacaDup)){
        fclose(codigo_intermedio);
        return;
    }

    char elemPolaca[100];

    extraerPrimeroDePolaca(&polacaDup, elemPolaca);
    fprintf(codigo_intermedio, "%s", elemPolaca);
    while(!polacaVacia(&polacaDup)){
        extraerPrimeroDePolaca(&polacaDup, elemPolaca);
        fprintf(codigo_intermedio, "|%s", elemPolaca);
    }

    fclose(codigo_intermedio);

    return;
}

void preprocesarPolaca(t_polaca* polaca, t_lista* listaTS){
    int celdaActual = 0, celdaSaltoInt;
    char buf[100], celda[100], celdaSalto[100], celdaAnt[100];

    t_lexema actual;
    while(celdaActual != polaca->celdaActual) { //iteramos para cambiar las celdas con valores (que no sean saltos) a sus respectivos nombres de la tabla de símbolos
        strcpy(celda, obtenerDePolaca(polaca, celdaActual));

        if (esNumero(celda)) {
            buscarEnListaPorValor(listaTS, celda, &actual);
            
            if(celdaActual == 0 || !esSalto(celdaAnt)){
                buscarYActualizarPolaca(polaca, celdaActual, actual.nombre);
            }
        } else if(esCadena(celda)) {
            strcpy(buf, celda);
            eliminarCaracteres(buf, '"');
            buscarEnListaPorValor(listaTS, buf, &actual);
            buscarYActualizarPolaca(polaca, celdaActual, actual.nombre);
        }
        
        strcpy(celdaAnt, celda);
        celdaActual++;
    }

    celdaActual = 0;

    while(celdaActual != polaca->celdaActual) { //iteramos para modificar las celdas de saltos por sus respectivas etiquetas
        //si la celda actual de la polaca es un salto, actualiza la celda del salto con un @ET_numCelda
        strcpy(celda, obtenerDePolaca(polaca, celdaActual));

        if(esSalto(celda)) {
            //actualiza act+1 con ET_[contenidoActual]
            strcpy(celdaSalto, obtenerDePolaca(polaca, celdaActual+1));
            celdaSaltoInt = atoi(celdaSalto);

            sprintf(buf, "ET_%d", celdaSaltoInt);
            buscarYActualizarPolaca(polaca, celdaActual+1, buf);

            //actualiza celda del salto con @ET_[celdaActual]: [contenidoActual]
            if(celdaSaltoInt < polaca->celdaActual){
                strcpy(celda, obtenerDePolaca(polaca, celdaSaltoInt));

                if(strstr(celda, "@ET_") == NULL){
                    sprintf(buf, "@ET_%d:%s", celdaSaltoInt, celda);
                    buscarYActualizarPolaca(polaca, celdaSaltoInt, buf);
                }
            } else {
                sprintf(buf, "@ET_%d:_FINAL_TAG", celdaSaltoInt);
                insertarEnPolaca(polaca, buf);
            }
        }

        celdaActual++;
    }
}

int esNumero(const char* celda) {
    int lenCelda = strlen(celda);
    if((celda[0] >= '0' && celda[0] <= '9')
    || (celda[0] == '-' && lenCelda > 1)){
        return 1;
    }

    return 0;
}

int esCadena(const char* celda){
    int len = strlen(celda);
    return celda[0] == '"' && celda[len-1] == '"';
}

int esSalto(const char* celda) {

    if(celda[0] == '"') //esta validación se hace para evitar que casos con constantes strings como "a:BI" sean consideradas saltos
        return 0;
    

    char* celdaAux = strstr(celda, ":"); //esto se hace para aquellos casos donde le celda donde cae un salto tenga a su vez otro salto
    if(celdaAux){
        celdaAux++;
    } else {
        celdaAux = (char*)celda;
    }

    if (!strcmp(celdaAux, "BLE") ||
        !strcmp(celdaAux, "BEQ") ||
        !strcmp(celdaAux, "BNE") ||
        !strcmp(celdaAux, "BGT") ||
        !strcmp(celdaAux, "BLT") ||
        !strcmp(celdaAux, "BGE") ||
        !strcmp(celdaAux, "BI")) {
        return 1;
    }

    return 0;
}


void generarCabeceraAssembler(FILE* fAssembler, t_lista* listaTS){
    fprintf(fAssembler, "include macros2.asm\ninclude number.asm\n.MODEL LARGE\n.386\n.STACK 200h\n\nMAXTEXTSIZE equ 40\n\n.DATA\n");

    t_lexema lexActual;
    char tipo[3];
    char valorStr[256];
    char auxAsm[100];
    char* punto;
    int tieneValor, esString, tieneLongitud;

    while(quitarPrimeroDeLista(listaTS, &lexActual)) {
        esString = (strcmp(lexActual.tipodato, "CTE_STRING") == 0 || strcmp(lexActual.tipodato, "string") == 0);
        tieneValor = strlen(lexActual.valor);
        tieneLongitud = atoi(lexActual.longitud);

        if(esString){
            if(!tieneLongitud){ //si es una variable
                sprintf(valorStr, "MAXTEXTSIZE dup (?),'$'");
            } else {
                sprintf(valorStr, "\"%s\",'$', %s dup (?)", lexActual.valor, lexActual.longitud);
            }

            fprintf(fAssembler, "%s db %s\n", lexActual.nombre, valorStr);

            continue; //ya completé este lexema, paso al siguiente
        }

        //si no es cte string ni variable string:
        fprintf(fAssembler, "%s dd %s\n", lexActual.nombre, tieneValor ? lexActual.valor : "?");
    }

    while(!pilaVacia(&pilaAuxAssembler)){
        strcpy(auxAsm, desapilar(&pilaAuxAssembler));
        fprintf(fAssembler, "%s dd ?\n", auxAsm);
    }

    fprintf(fAssembler, "\n.CODE\n.startup\n\nSTART:\n\tMOV AX, @DATA\n\tMOV DS, AX\n\tMOV es,ax\n\n");
}

// funciones del cuerpo de assembler
void generarCuerpoAssembler(FILE* fAssembler){
    char celdaPolaca[100];
    while(extraerPrimeroDePolaca(&polacaDup, celdaPolaca)) {
        procesarCeldaPolaca(fAssembler, celdaPolaca);
    }
}

void procesarCeldaPolaca(FILE* fAssembler, char* celda) {
    //tengo que validar si la celda actual corresponde a una etiqueta que tengo que completar
    //por un lado, puede ser la celda desde la que salto (ET_num)  --> se extrae cuando detecta un salto (BIAssembler o comparacionAssembler)
    //por otro, la celda donde cae el salto (@ET_num:)
    t_lexema lexemaActual;

    if(strncmp(celda, "@ET_", 4) == 0){
        //escribimos en el assembler ET_num:\n y sigue normal

        //y le sacamos ese prefijo a la celda (@ET)
        char* posPunto = strstr(celda, ":");

        char nombreTag[36];

        int cantACopiar = posPunto - celda;
        strncpy(nombreTag, celda+1, cantACopiar); //acá se tiene el ET_numero:, luego se escribe en el assembler
        nombreTag[cantACopiar] = '\0';

        fprintf(fAssembler, "%s\n", nombreTag);

        celda = posPunto+1;
    }

    if (esOperando(celda)) { //si está en la TS, es un operando
        apilar(&pilaOperandos, celda); //cte, ids, etc.
        return;
    }

    char* operador = esOperadorMat(celda);
    if (strcmp(operador, "") != 0){
        operacionMatAsselmber(fAssembler, operador); //+, -, *, /
        return;
    }

    if(strcmp(celda, ":=") == 0){
        asignacionAssembler(fAssembler); //:=
        return;
    }

    if(strcmp(celda, "CMP") == 0){
        comparacionAssembler(fAssembler); //resuelve los saltos condicionales desapilando también la celda que sigue
        return;
    }

    //esta celda se saltea porque el tag del while ya se escribe al resolver el @ET_
    if(strncmp(celda, "ET_", 3) == 0){
        return;
    }

    if(strcmp(celda, "BI") == 0){
        BIAssembler(fAssembler); //resuelve saltos incondicionales
    }

    if(strcmp(celda, "ESCRIBIR") == 0){
        operacionEscribirAssembler(fAssembler);
        return;
    }

    if(strcmp(celda, "LEER") == 0){
        operacionLeerAssembler(fAssembler);
        return;
    }
}

int esOperando(char* celda){
    t_lexema lex;
    return buscarEnlista(&lista_simbolos, celda, &lex);
}

char* esOperadorMat(char* celda){
    char operador[2];
    if ( strcmp(celda, "+")==0 ){
       return "FADD";
    }
    if ( strcmp(celda, "-")==0 ){
        return "FSUB";
    }
    if ( strcmp(celda, "*")==0 ){
        return "FMUL";
    }
    if ( strcmp(celda, "/")==0 ){
        return "FDIV";
    }

    return "";
}

void operacionMatAsselmber(FILE* fAssembler, char* operador){
    char* op1 = desapilar(&pilaOperandos);
    char* op2 = desapilar(&pilaOperandos);
    
    char* result = newAuxiliar(); //genera un auxiliar y lo agrega a la pila de auxiliares de assembler

    char buff[100];

    if(strcmp(operador, "FDIV") == 0 || strcmp(operador, "FSUB") == 0){ //para estos casos carga los operadores al revés para evitar hacer un fxch
        sprintf(buff, "FLD %s\n\tFLD %s", op2, op1);
    } else {
        sprintf(buff, "FLD %s\n\tFLD %s", op1, op2);
    }

    fprintf(fAssembler, "\t%s\n\t%s\n\tFSTP %s\n", buff, operador, result);
    apilar(&pilaOperandos, result);
}

char* newAuxiliar(){
    static char aux[20];
    sprintf(aux, "@auxAssembler%d", auxActual++);
    apilar(&pilaAuxAssembler, aux); //pila de elementos que van a ser agregados a la hora de escribir la cabecera
    return aux;
}

void asignacionAssembler(FILE* fAssembler) {
    t_lexema lex;

    char buffer[100];
    char* variable = desapilar(&pilaOperandos);
    char* valor = desapilar(&pilaOperandos);

    buscarEnlista(&lista_simbolos, valor, &lex);

    if( strcmp(lex.tipodato, "CTE_STRING")==0 || strcmp(lex.tipodato, STRING)==0 )
		sprintf(buffer, "\tMOV SI, OFFSET %s\n\tMOV DI, OFFSET %s\n\tCALL COPIAR\n", valor, variable);
    else
        sprintf(buffer, "\tFLD %s\n\tFSTP %s\n", valor, variable);
    
    fprintf(fAssembler, "%s", buffer);
}

void comparacionAssembler(FILE* fAssembler){
    char celda[100];
    char tag[100];
    char* op2 = desapilar(&pilaOperandos);
    char* op1 = desapilar(&pilaOperandos);

    extraerPrimeroDePolaca(&polacaDup, celda); //sacamos el branch de la polaca

    char* jump = convertirSalto(celda);

    extraerPrimeroDePolaca(&polacaDup, tag); //sacamos la celda a la que salta

    fprintf(fAssembler, "\tFLD %s\n\tFCOMP %s\n\tFSTSW ax\n\tSAHF\n\t%s %s\n", op1, op2, jump, tag);
}

char* convertirSalto(char* celda){
    switch (celda[0]) {
        case 'B':
            switch (celda[1]) {
                case 'N':
                    if (celda[2] == 'E' && celda[3] == '\0') return "JNE";
                    break;
                case 'E':
                    if (celda[2] == 'Q' && celda[3] == '\0') return "JE";
                    break;
                case 'L':
                    if (celda[2] == 'E' && celda[3] == '\0') return "JBE";
                    if (celda[2] == 'T' && celda[3] == '\0') return "JB";
                    break;
                case 'G':
                    if (celda[2] == 'T' && celda[3] == '\0') return "JA";
                    if (celda[2] == 'E' && celda[3] == '\0') return "JAE";
                    break;
            }
    }

    return NULL;  // Retorna NULL si no coincide con ningún caso
}

void BIAssembler(FILE* fAssembler){
    char celda[100];
    extraerPrimeroDePolaca(&polacaDup, celda);
    fprintf(fAssembler, "\tJMP %s\n", celda);
}


void operacionEscribirAssembler(FILE* fAssembler){
    char buffer[100];
    t_lexema lex;
    char* variable = desapilar(&pilaOperandos);

    buscarEnlista(&lista_simbolos, variable, &lex);

    if( strcmp(lex.tipodato, "CTE_STRING")==0 || strcmp(lex.tipodato, "string")==0 ){
        fprintf(fAssembler, "\tdisplayString %s\n\tnewLine\n", variable);
        return;
    }

    if( strcmp(lex.tipodato, INT)==0 || strcmp(lex.tipodato, "CTE_INTEGER") == 0){
        fprintf(fAssembler, "\tDisplayFloat %s, 0\n\tnewLine\n", variable);
        return;
    }

    if( strcmp(lex.tipodato, FLOAT)==0 || strcmp(lex.tipodato, "CTE_FLOAT") == 0){
        fprintf(fAssembler, "\tDisplayFloat %s, 2\n\tnewLine\n", variable);
        return;
    }

    //este caso sería cuando lo que se va a escribir no está en la TS sino que es un resultado de una operación
    fprintf(fAssembler, "\tDisplayFloat %s, 2\n\tnewLine\n", variable);
}

void operacionLeerAssembler(FILE* fAssembler){
    t_lexema lex;
    char* variable = desapilar(&pilaOperandos);

    buscarEnlista(&lista_simbolos, variable, &lex);
    if( strcmp(lex.tipodato, "string")==0 ){
        fprintf(fAssembler, "\tgetString %s\n\tnewLine\n", variable);
        return;
    }

    if( strcmp(lex.tipodato, INT)==0 || strcmp(lex.tipodato, FLOAT)==0 ){
        fprintf(fAssembler, "\tGetFloat %s\n\tnewLine\n", variable);
        return;
    }
}

void mergeArchivosAssembler(FILE* fAssembler, FILE* fBodyAsm){
    //posiciono el body al inicio
    fseek(fBodyAsm, 0, SEEK_SET);
    char* buf = NULL;
    size_t len = 0;
    while(!feof(fBodyAsm)){
        getline(&buf, &len, fBodyAsm);
        fprintf(fAssembler, "%s", buf);
    }

    fclose(fBodyAsm);
    remove("final.temp"); 
}

//funciones de fin de assembler
void generarFinAssembler(FILE* fAssembler){
    fprintf(fAssembler, "\tMOV AX, 4C00h\n\tINT 21h\n");
    fprintf(fAssembler, "\n\nSTRLEN PROC NEAR\n\tmov bx, 0\nSTRL01:\n\tcmp BYTE PTR [SI+BX],'$'\n\tje STREND\n\tinc BX\n\tjmp STRL01\nSTREND:\n\tret\nSTRLEN ENDP\n");
	fprintf(fAssembler, "\nCOPIAR PROC NEAR\n\tcall STRLEN\n\tcmp bx,MAXTEXTSIZE\n\tjle COPIARSIZEOK\n\tmov bx,MAXTEXTSIZE\nCOPIARSIZEOK:\n\tmov cx,bx\n\tcld\n\trep movsb\n\tmov al,'$'\n\tmov BYTE PTR [DI],al\n\tret\nCOPIAR ENDP\n");
	fprintf(fAssembler, "\nEND START\n");
}

void reemplazarCaracteres(char *s, char viejo, char nuevo){
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

void eliminarCaracteres(char* str, char c) {
    int i, j = 0;
    int len = strlen(str);

    for (i = 0; i < len; i++) {
        if (str[i] != c) {
            str[j++] = str[i];
        }
    }
    str[j] = '\0';
}

char* agregarPrefijo(const char *s, char *prefijo){
    char *conPrefijo = malloc(strlen(s)+strlen(prefijo)+1);
    strcpy(conPrefijo, prefijo);
    strcat(conPrefijo, s);
}

