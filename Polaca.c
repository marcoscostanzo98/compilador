#include <Polaca.h>

void crearPolaca (t_polaca *polaca){
    polaca->celdaActual = 0;
    polaca->lista = NULL;
}

int insertarEnPolaca (t_polaca *polaca, char *cadena){
    t_nodo_polaca *nuevoNodo = (t_nodo_polaca*)malloc(sizeof(t_nodo_polaca));
    if (!nuevoNodo) return FALSE; // Error en asignacion de memoria
    strcpy(nuevoNodo->cadena,cadena);
    nuevoNodo->sig = polaca->lista;
    polaca->lista = nuevoNodo;
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
  return polaca->lista;
}

void duplicarPolaca( t_polaca *polacaOriginal, t_polaca *polacaNueva){
    crearPolaca(polacaNueva);
    t_nodo_polaca *current = polacaOriginal->lista;
    while (current) {
        insertarEnPolaca(polacaNueva, current->cadena);
        current = current->sig;
    }
}
