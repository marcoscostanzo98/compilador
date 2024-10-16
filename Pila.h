#ifndef PILA_H
#define PILA_H

#define TRUE 1
#define FALSE 0

// Definición de la estructura de un NodoP
typedef struct NodoPila {
    char *dato;
    struct NodoPila *siguiente;
} NodoP;

// Definición de la estructura de la pila
typedef struct {
    NodoP *cima;
    int tam;
} t_pila;

// Funciones para la pila
NodoP* crearNodo(const char *dato);
t_pila* crearPila();
int pilaVacia(t_pila *pila);
void apilar(t_pila *pila, const char *dato);
char* desapilar(t_pila *pila);
char* topePila(t_pila *pila);

#endif // PILA_H

