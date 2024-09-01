#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    char nombre[100];
    char tipodato[100];
    char valor[100];
    char longitud[100];
}t_lexema;

typedef struct Nodo
{
    t_lexema lexema;
    struct Nodo *sig;
}t_nodo;

typedef t_nodo *t_lista;


void crearLista(t_lista* l);

int insertarEnListaAlFinal(t_lista *l, t_lexema lex);

int insertarEnListaSinDuplicados(t_lista *l, t_lexema lex);

int quitarPrimeroDeLista(t_lista *l, t_lexema *lex);

int obtenerPrimeroDeLista(t_lista *l, t_lexema *lex);

int buscarEnlista(const t_lista *l, const char *nombre, t_lexema *lex);

void vaciarLista(t_lista *l);

void copiarLexema(t_lexema* dest, t_lexema orig);