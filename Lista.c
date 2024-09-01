#include "Lista.h"


 void crearLista(t_lista* l)
{
    *l = NULL;
}

int insertarEnListaAlFinal(t_lista *l, t_lexema lex)
{
    t_nodo *nue;
    while(*l)
    {
        l = &(*l)->sig;
    }

    nue = (t_nodo*)malloc(sizeof(t_nodo));
    if(!nue)
    {
        return 0;
    }
    
    copiarLexema(&(nue->lexema), lex);
    nue->sig = NULL;
    *l = nue;

    return 1;
}

int insertarEnListaSinDuplicados(t_lista *l, t_lexema lex)
{
    t_nodo *nue;
    while(*l)
    {
        if (!strcmp((*l)->lexema.nombre, lex.nombre) && !strcmp((*l)->lexema.tipodato, lex.tipodato))
        {
            return 0;
        }

        l = &(*l)->sig;
    }
    
    nue = (t_nodo*)malloc(sizeof(t_nodo));
    if(!nue)
    {
        return 0;
    }

    copiarLexema(&(nue->lexema), lex);
    nue->sig = NULL;
    *l = nue;

    return 1;
}

int quitarPrimeroDeLista(t_lista *l, t_lexema *lex)
{
    t_nodo *aux = *l;
    if(!aux)
    {
        return 0;
    }

    *l = aux->sig;
    copiarLexema(lex, aux->lexema);
    free(aux);

    return 1;
}

int obtenerPrimeroDeLista(t_lista *l, t_lexema *lex)
{
    t_nodo *aux = *l;
    if(!aux)
    {
        return 0;
    }

    *l = aux->sig;
    copiarLexema(lex, aux->lexema);
    
    return 1;
}

int buscarEnlista(const t_lista *l, const char *nombre, t_lexema *lex)
{
    while(*l && strcmp( (*l)->lexema.nombre, nombre ) != 0)
    {
        l = &(*l)->sig;
    }

    if (*l)
    {
        copiarLexema(lex, (*l)->lexema);
        return 1;
    }
    
    return 0;
}

void vaciarLista(t_lista *l)
{
    t_nodo *elim;
    while(*l)
    {
        elim = *l;
        *l = elim->sig;
        free(elim);
    }
}

void copiarLexema(t_lexema* dest, t_lexema orig)
{
    strcpy(dest->nombre, orig.nombre);
    strcpy(dest->tipodato, orig.tipodato);
    strcpy(dest->valor, orig.valor);
    strcpy(dest->longitud, orig.longitud);
}
