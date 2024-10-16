#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Definimos la estructura para un NodoP de la pila
typedef struct NodoP {
    char *dato;
    struct NodoP *siguiente;
} NodoP;

// Definimos la estructura de la pila
typedef struct t_pila {
    NodoP *cima;
    int tam;
} t_pila;

// Función para crear un nuevo NodoP
NodoP* crearNodo(const char *dato) {
    NodoP *nuevo_nodo = (NodoP *)malloc(sizeof(NodoP));
    nuevo_nodo->dato = (char *)malloc(strlen(dato) + 1);
    strcpy(nuevo_nodo->dato, dato);
    nuevo_nodo->siguiente = NULL;
    return nuevo_nodo;
}

// Inicializa la pila
t_pila* crearPila() {
    t_pila *pila = (t_pila *)malloc(sizeof(t_pila));
    pila->cima = NULL;
    pila->tam = 0;
    return pila;
}

// Verifica si la pila está vacía
int pilaVacia(t_pila *pila){
    return pila->tam == 0;
}

// Agrega un elemento a la pila
void apilar(t_pila *pila, const char *dato) {
    NodoP *nuevo_nodo = crearNodo(dato);
    nuevo_nodo->siguiente = pila->cima;
    pila->cima = nuevo_nodo;
    pila->tam++;
}

// Elimina y devuelve el elemento en la cima de la pila
char* desapilar(t_pila *pila) {
    if (pilaVacia(pila)) {
        printf("La pila está vacía. No se puede desapilar.\n");
        return NULL;
    }
    NodoP *nodo_a_eliminar = pila->cima;
    char *dato = nodo_a_eliminar->dato;
    pila->cima = nodo_a_eliminar->siguiente;
    free(nodo_a_eliminar);
    pila->tam--;
    return dato;
}

// Devuelve el elemento en la cima de la pila sin eliminarlo
char* topePila(t_pila *pila) {
    if (pilaVacia(pila)) {
        printf("La pila está vacía. No se puede ver la cima.\n");
        return NULL;
    }
    
    return pila->cima->dato;
}