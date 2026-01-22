---
related to:
created: 2025-03-02T17:41
updated: 2026-01-22T21:57
completed: false
---
## indirizzamento
usiamo `&` per ottenere l’indirizzo di una variabile (la locazione di memoria a cui si trova la variabile (ricordiamo che ogni cella di memoria è indexata))

int occupa 4 byte

quando una operazione ha operandi di tipo diverso, C converte automaticamente il tipo più piccolo a quello più grande. formalmente diciamo che avviene una **promozione** da un tipo all’altro !

per dichiarare un puntatore è opportuno anteporre al nome della variabile un asterisco (`*`)

>[!example] se ho un `int *p`, e faccio `p+1` `p` punterà ai 4 byte successivi nella memoria !
>- un puntatore di tipo `int` può contenere l’indirizzo in memoria di qualsiasi variabile intera !

```c
// per puntare all'indirizzo di a
int a = 3;
int *p;

p = &a;
```

## allocazione dinamica
C supporta l’allocazione dinamica della memoria attraverso l’uso delle funzioni definite nella libreria `stdlib.h`. le principali sono `malloc(), realloc(), calloc() e free()`