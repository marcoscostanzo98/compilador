#include <stdlib.h>
#include <stdio.h>
#include "Cola.h"

void crearCola(t_cola* c) {
    c->frente = NULL;
    c->fondo = NULL;
}

int colaVacia(t_cola* c) {
    return c->frente == NULL;
}

int encolar(t_cola* c, t_listaMixtaContadores conts) {
    t_nodoCola* nuevo = malloc(sizeof(t_nodoCola));
    if (!nuevo) return 0;

    nuevo->datos = conts;
    nuevo->sig = NULL;

    if (c->fondo)
        c->fondo->sig = nuevo;
    else
        c->frente = nuevo;

    c->fondo = nuevo;
    return 1;
}

int desencolar(t_cola* c, t_listaMixtaContadores* conts) {
    if (colaVacia(c)) return 0;

    t_nodoCola* aux = c->frente;
    *conts = aux->datos;
    c->frente = aux->sig;

    if (!c->frente)
        c->fondo = NULL;

    free(aux);
    return 1;
}

void vaciarCola(t_cola* c) {
    t_listaMixtaContadores aux;
    while (desencolar(c, &aux));
}

void mostrarCola(const t_cola* c) {
    t_nodoCola* actual = c->frente;
    int i = 1;

    printf("\nContenido de la cola:\n");
    while (actual != NULL) {
        printf("Nodo %d -> Real: %d | ID: %d | Total: %d\n", 
               i, 
               actual->datos.contReal, 
               actual->datos.contId, 
               actual->datos.contTotal);
        actual = actual->sig;
        i++;
    }

    if (i == 1)
        printf("La cola esta vacia.\n");
}
