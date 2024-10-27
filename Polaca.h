#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRUE 1
#define FALSE 0

typedef struct s_nodo_polaca{
char cadena[100];               //VER SI EL TAMAÑO ESTA BIEN
struct s_nodo_polaca *sig;
}t_nodo_polaca;

typedef t_nodo_polaca* lista;

typedef struct {
    lista lista;
    int celdaActual;
}t_polaca;

void crearPolaca (t_polaca *polaca);
int insertarEnPolaca (t_polaca *polaca, char *cadena);
int extraerPrimeroDePolaca ( t_polaca *polaca, char *cadena);
int buscarYActualizarPolaca ( t_polaca *polaca, int numCelda, char* cadNueva);
int polacaVacia(t_polaca *polaca);
int duplicarPolaca(t_polaca *polacaOriginal, t_polaca *polacaDuplicada); 
