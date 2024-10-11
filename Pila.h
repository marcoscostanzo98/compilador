#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LEN 100

// Definición de la estructura de un nodo de la pila
typedef struct s_nodo_pila {
    char dato[MAX_LEN];
    struct s_nodo_pila* siguiente;
}t_nodo_pila;

typedef t_nodo_pila* t_pila;

void crearPila(t_pila *pila);
int apilar(t_pila *pila, char *dato);
char* desapilar(t_pila *pila);
void vaciarPila(t_pila *p);
int pilaVacia(const t_pila* p);