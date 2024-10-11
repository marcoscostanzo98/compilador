#include "Pila.h"


void crearPila(t_pila *pila)
{
    *pila = NULL;
}


int apilar(t_pila *pila, char *dato) 
{
    t_nodo_pila *nue = (t_nodo_pila*)malloc(sizeof(t_nodo_pila));
    if(!nue)
        return 0;

    strcpy(nue->dato, dato);
    nue->siguiente = *pila;
    *pila = nue;
    return 1;
}

char* desapilar(t_pila *pila)
{
    if(*pila == NULL)
        return NULL;

    t_nodo_pila *elim = *pila; 
    char* dato = strdup(elim->dato);
    *pila = elim->siguiente;
    free(elim);
    return dato;
}

void vaciarPila(t_pila *p)
{
    while(*p)
    {
        t_nodo_pila *elim = *p;
        *p = elim->siguiente;
        free(elim);
    }
}

int pilaVacia(const t_pila* p)
{
    return *p == NULL;
}