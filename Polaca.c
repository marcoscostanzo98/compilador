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
        polaca->lista = nuevoNodo;
        polaca->celdaActual++;
        return TRUE;
    }

    while( act->sig != NULL){
        act = act->sig;
    }

    nuevoNodo->sig = NULL;
    act->sig = nuevoNodo;
    polaca->celdaActual++;

	return TRUE;
}

int extraerPrimeroDePolaca ( t_polaca *polaca, char *cadena){
    if (polacaVacia(polaca)) return FALSE; // La lista está vacía
    t_nodo_polaca *temp = polaca->lista;
    strcpy(cadena, temp->cadena);
    polaca->lista = temp->sig;
    free(temp);
    polaca->celdaActual--;
    return TRUE;
}

int buscarYActualizarPolaca ( t_polaca *polaca, int numCelda, char* cadNueva){
    t_nodo_polaca *current = polaca->lista;
    int i;
    for (i = 0; current && i < numCelda; i++) {
        current = current->sig;
    }

    if (i == numCelda) {
        strcpy(current->cadena, cadNueva);
        return TRUE; // Actualizado
    }
    
    return FALSE; // No encontrado
}

int polacaVacia(t_polaca *polaca){
  return polaca->lista == NULL;
}

int duplicarPolaca(t_polaca *polacaOriginal, t_polaca *polacaDuplicada) {
    crearPolaca(polacaDuplicada); // Inicializa la nueva lista

    if (polacaVacia(polacaOriginal)) return TRUE; // Si la original está vacía, no hay nada que copiar

    t_nodo_polaca *actualOriginal = polacaOriginal->lista;
    t_nodo_polaca *nuevoNodo, *ultimoNodoDuplicado = NULL;

    while (actualOriginal) {
        // Crear un nuevo nodo
        nuevoNodo = (t_nodo_polaca*)malloc(sizeof(t_nodo_polaca));
        if (!nuevoNodo) return FALSE; // Error de memoria

        strcpy(nuevoNodo->cadena, actualOriginal->cadena);
        nuevoNodo->sig = NULL;

        // Enlazar el nuevo nodo a la lista duplicada
        if (!polacaDuplicada->lista) {
            polacaDuplicada->lista = nuevoNodo;
        } else {
            ultimoNodoDuplicado->sig = nuevoNodo;
        }
        
        // Actualizar el último nodo en la lista duplicada
        ultimoNodoDuplicado = nuevoNodo;

        // Pasar al siguiente nodo en la lista original
        actualOriginal = actualOriginal->sig;
        polacaDuplicada->celdaActual++;
    }
    
    return TRUE;
}

char* obtenerDePolaca(t_polaca *polaca, int numCelda) {
    if (numCelda < 0 || numCelda >= polaca->celdaActual) {
        return NULL; // Fuera de rango
    }

    t_nodo_polaca *current = polaca->lista;
    int i;

    // Recorrer la lista hasta la celda deseada
    for (i = 0; current && i < numCelda; i++) {
        current = current->sig;
    }

    return current ? current->cadena : NULL; // Retorna el valor si se encuentra
}