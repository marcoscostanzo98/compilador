#include "Lista.h"


 void crearLista(t_lista* l)
{
    *l = NULL;
}

int insertarEnListaSinDuplicados(t_lista *l, t_lexema lex)
{
    t_nodo *nue;
    while(*l)
    {
        if (!strcmp((*l)->lexema.nombre, lex.nombre))
        {
            return 0;
        }

        l = &(*l)->sig;
    }
    
    nue = (t_nodo*)malloc(sizeof(t_nodo));
    if(!nue)
    {
        return 0;
    }

    copiarLexema(&(nue->lexema), lex);
    nue->sig = NULL;
    *l = nue;

    return 1;
}

int quitarPrimeroDeLista(t_lista *l, t_lexema *lex)
{
    t_nodo *aux = *l;
    if(!aux)
    {
        return 0;
    }

    *l = aux->sig;
    copiarLexema(lex, aux->lexema);
    free(aux);

    return 1;
}

int buscarEnlista(const t_lista *l, const char *nombre, t_lexema *lex)
{
    while(*l && strcmp( (*l)->lexema.nombre, nombre ) != 0)
    {
        l = &(*l)->sig;
    }

    if (*l)
    {
        copiarLexema(lex, (*l)->lexema);
        return 1;
    }
    
    return 0;
}

int buscarEnListaPorValor(const t_lista *l, const char *valor, t_lexema *lex)
{
    while(*l && strcmp( (*l)->lexema.valor, valor) != 0)
    {
        l = &(*l)->sig;
    }

    if (*l)
    {
        copiarLexema(lex, (*l)->lexema);
        return 1;
    }
    
    return 0;
}


void buscarYactualizarTipoDato(t_lista* l, const char* nombre, const char* tipoDato)
{
    t_nodo* actual = *l;    
    while (actual) {
        if (strcmp(actual->lexema.nombre, nombre) == 0) 
        {
            strcpy(actual->lexema.tipodato, tipoDato);
            return;
        }
        actual = actual->sig;
    }
}

void vaciarLista(t_lista *l)
{
    t_nodo *elim;
    while(*l)
    {
        elim = *l;
        *l = elim->sig;
        free(elim);
    }
}

void duplicarLista(t_lista* orig, t_lista* dest)
{
    t_nodo* actual = *orig;
    while (actual) {
        insertarEnListaSinDuplicados(dest, actual->lexema);
        actual = actual->sig;
    }
}

void copiarLexema(t_lexema* dest, t_lexema orig)
{
    strcpy(dest->nombre, orig.nombre);
    strcpy(dest->tipodato, orig.tipodato);
    strcpy(dest->valor, orig.valor);
    strcpy(dest->longitud, orig.longitud);
}

void reverse(char str[], int length) {
    int start = 0;
    int end = length - 1;
    while (start < end) {
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;
        start++;
        end--;
    }
}

char* itoa(int num, char* str, int base) {
    int i = 0;
    int isNegative = 0;

    // Handle 0 explicitly, otherwise empty string is returned
    if (num == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }

    // In standard itoa(), negative numbers are only handled if base is 10
    if (num < 0 && base == 10) {
        isNegative = 1;
        num = -num;
    }

    // Process individual digits
    while (num != 0) {
        int rem = num % base;
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
        num = num / base;
    }

    // If the number is negative, append '-'
    if (isNegative) {
        str[i++] = '-';
    }

    str[i] = '\0';  // Append string terminator

    // Reverse the string
    reverse(str, i);

    return str;
}