#include "Polaca.h"

void crearPolaca (t_polaca *polaca){
    polaca->celdaActual = 0;
    polaca->lista = NULL;
}

int insertarEnPolaca (t_polaca *polaca, char *cadena){
    t_nodo_polaca *nuevoNodo = (t_nodo_polaca*)malloc(sizeof(t_nodo_polaca));
    if (!nuevoNodo) return FALSE; // Error en asignacion de memoria
    strcpy(nuevoNodo->cadena,cadena);

    t_nodo_polaca *act = polaca->lista;

    if( act == NULL )
    {
        printf("esta vacia y asigno el primero\n");
        polaca->lista = nuevoNodo;
        return TRUE;
    }

    //printf("no esta vacia\n");
    //printf("valor de aca: %s\n", act->cadena);
    while( act->sig != NULL){
        //printf("valor de aca: %s\n", act->sig->cadena);
        act = act->sig;
    }

    nuevoNodo->sig = NULL;
    act->sig = nuevoNodo;
    polaca->celdaActual++;

    //printf("valor de aca: %s\n", nuevoNodo->cadena);
    //printf("\n\n\n");

	return TRUE;
}

/*
int insertarEnPolacaOLD (t_polaca *polaca, char *cadena){
    t_nodo_polaca *nuevoNodo = (t_nodo_polaca*)malloc(sizeof(t_nodo_polaca));
    if (!nuevoNodo) return FALSE; // Error en asignacion de memoria
    strcpy(nuevoNodo->cadena,cadena);

    nuevoNodo->sig = polaca->lista;
    polaca->lista = nuevoNodo;
    polaca->celdaActual++;
	return TRUE;
}
*/

// ver si esto podría retornar un char* directamente en lugar del copy
int extraerPrimeroDePolaca ( t_polaca *polaca, char *cadena){
    if (polacaVacia(polaca)) return FALSE; // La lista está vacía
    t_nodo_polaca *temp = polaca->lista;
    strcpy(cadena, temp->cadena);
    polaca->lista = temp->sig;
    free(temp);
    polaca->celdaActual--;
    return TRUE;
}

int buscarEnPolaca(const t_polaca *polaca, const char *cadena){
  t_nodo_polaca *current = polaca->lista;
    while (current) {
        if (strcmp(current->cadena, cadena) == 0) {
            return TRUE; // Encontrado
        }
        current = current->sig;
    }
    return FALSE; // No encontrado
}

int buscarYActualizarPolaca ( t_polaca *polaca, int numCelda, char* cadNueva){
    t_nodo_polaca *current = polaca->lista;
    for (int i = 0; current && i < numCelda; i++) {
        if (i == numCelda) {
            strcpy(current->cadena, cadNueva);
            return TRUE; // Actualizado
        }
        current = current->sig;
    }
    return FALSE; // No encontrado
}

int verUltimoPolaca(t_polaca *polaca, char* cadena){
    if (polacaVacia(polaca)) return FALSE; // La lista está vacía
    t_nodo_polaca *current = polaca->lista;
    while (current->sig) {
        current = current->sig;
    }
    strcpy(cadena, current->cadena);
    return TRUE;
}

int polacaVacia(t_polaca *polaca){
  return !(int)polaca->lista;
}

void duplicarPolaca( t_polaca *polacaOriginal, t_polaca *polacaNueva){
    crearPolaca(polacaNueva);
    t_nodo_polaca *current = polacaOriginal->lista;
    while (current) {
        insertarEnPolaca(polacaNueva, current->cadena);
        current = current->sig;
    }
}
