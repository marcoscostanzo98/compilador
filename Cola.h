#ifndef COLA_LISTA_MIXTA_H
#define COLA_LISTA_MIXTA_H

typedef struct {
    int contReal;
    int contId;
    int contTotal;
} t_listaMixtaContadores;

typedef struct NodoCola {
    t_listaMixtaContadores datos;
    struct NodoCola* sig;
} t_nodoCola;

typedef struct {
    t_nodoCola* frente;
    t_nodoCola* fondo;
} t_cola;

// Funciones
void crearCola(t_cola* c);
int colaVacia(t_cola* c);
int encolar(t_cola* c, t_listaMixtaContadores conts);
int desencolar(t_cola* c, t_listaMixtaContadores* conts);
void vaciarCola(t_cola* c);
void mostrarCola(const t_cola* c);

#endif // COLA_LISTA_MIXTA_H
