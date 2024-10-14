#include "Polaca.h"

void crearPolaca (t_polaca *polaca){
    polaca->celdaActual = 0;
    polaca->lista = NULL;
}

int insertarEnPolaca (t_polaca *polaca, char *cadena){
    t_nodo_polaca *nuevoNodo = (t_nodo_polaca*)malloc(sizeof(t_nodo_polaca));
    if (!nuevoNodo) return FALSE; // Error en asignacion de memoria
    strcpy(nuevoNodo->cadena,cadena);
    nuevoNodo->sig = NULL;

    t_nodo_polaca *act = polaca->lista;

    if( act == NULL )
    {
        //printf("esta vacia y asigno el primero\n");
        polaca->lista = nuevoNodo;
        polaca->celdaActual++;
        return TRUE;
    }

    while( act->sig != NULL){
        //printf("en polaca: %s\n", act->cadena);
        act = act->sig;
    }

    nuevoNodo->sig = NULL;
    act->sig = nuevoNodo;
    polaca->celdaActual++;

    //printf("celda actual: %d", polaca->celdaActual);
    //printf("\n");

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
    int i;
    for (i = 0; current && i < numCelda; i++) {
        //printf("en la celda num %d, contenido: %s\n", i, current->cadena);
        current = current->sig;
    }

    if (i == numCelda) {
        strcpy(current->cadena, cadNueva);
        return TRUE; // Actualizado
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
  return polaca->lista == NULL;
}

void duplicarPolaca( t_polaca *polacaOriginal, t_polaca *polacaNueva){
    crearPolaca(polacaNueva);
    t_nodo_polaca *current = polacaOriginal->lista;
    while (current) {
        insertarEnPolaca(polacaNueva, current->cadena);
        current = current->sig;
    }
}
