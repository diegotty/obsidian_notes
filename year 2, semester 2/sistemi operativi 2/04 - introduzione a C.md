---
created: 2025-04-10T13:15
updated: 2025-05-10T23:34
---
	# intro a C
## ambiente di sviluppo ed esecuzione
noi useremo **gcc**(GNU compiler collection), che include il **compilatore** di C, che svolge le attività di:
- pre-processing
- compilazione
- linking
>[!figure] C development workflow
![[Pasted image 20250326222525.png]]
>i passi dello sviluppo di un programma C

>[!warning] differenze con Java e python
la compilazione di un programma in java non produce un codice eseguibile, ma codice interpretabile dalla JVM. 
la “compilazione” di un programma in C mediante **gcc** invece, produce un “object code” che è un file eseguibile
>- il file eseguibile è quinidi indipendente dal **gcc**, ed eventualmente eseguibile anche su altri sistemi senza necessità di ri-compilarlo (mentre un file .class dovrà sempre essere dato in pasto alla JVM)
>- ciò vale anche per un programma scritto in C++

>[!figure] C ambiente di esecuzione
![[Pasted image 20250326222745.png]]
## primo programma in C
>[!info] primo programma
>```c
>#include <stdio.h>
>
>int main(){
>	printf("scrivi quello che vuoi !!! \n");
>	return 0;
>}
>```
>con `#` si indicano le direttive al preprocessore
>`stdio.h` è un **file header**(`.h`) che contiene costanti, funzioni per input, output e file handling
>- `<>` indicano che il file header è un file standard del C in `/usr/include`
>- `""` indicano che il file header è dell’utente e si trova nella directory corrente o in un path specificato
>- `-I` permette di specificare le directory in cui cercare gli header file

### compilare ed eseguire
per **compilare ed eseguire**: `gcc -Wall prog-name.c -o executable-name.o` (per compilare), `./executable-name.o` (per eseguire)
flags per `gcc`:
- `-Wall`: vengono stampati tutti i messasggi di warning (se ci sono)
- `-lm`: va specificato se si includono le librerie matematiche `<math.h` (ad esempio per usare funzioni come `sin, cos, log, ln, ...`)
per **solo precompilare/preprocessare** un file: `cpp helloworld.c > precompilato.c`
- in questo modo, vegnono eseguite tutte le direttive del compilatore; vengono eliminati i commenti
per **solo compilare** (un file precompilato): `gcc -c precompilato.c -o compilato.o`
- in questo modo, viene controllato che la sintassi sia corretta
- per ogni chiamata a funzione, viene controllato che venga rispettato il corrispettivo header (che quindi deve esistere al momento della chiamata)
- crea effettivamente del codice macchina, ma solo per il contenuto delle funzioni
	- ogni chiamata a funzione ha una destinazione simbolica
per **solo precompilare+compilare**(sostituisce i due step di sopra): `gcc -c file.c -o file.o`
per **solo linkare** il file: `gcc file.o`
- in questo modo, vengono risolte tutte le chiamate a funzioni: durante questo passo, per ogni funzione chiamata non basta più l’header, ma ci deve essere anche l’implementazione, che può essere data dal programmatore o fornita da librerie di sistema
- l’inclusione delle librerie può essere automatica o specificata dall’utente (es: la libreria `libc.a` che contiene `printf()` è incluse automaticamente)
per **linkare più file**: `gcc file1.o file2.o file3.o`
- si possono anche mischiare file `.c` e `.o` !
per fare **tutto**: `gcc file.c`/`gcc file1.c ... filen.c`
# variabili
sappiamo cos’è una variabile, poco da dire ….
`option_modifier data_type name_list;`
- **option_modifier**: `signed`, `unsigned`, `short`, `long`, `const`
- **data type**: specifica il tipo di valore, permette al compilatore di sapere quali sono le operazioni consentite sul tipo di dato e come deve essere rappresentato in memoria
- **name list**: lista di nomi di variabili
## tipi di variabili
>[!info] data types for numbers
![[Pasted image 20250329201811.png]]
>>[!info] characters + modifiers
>![[Pasted image 20250329201845.png]]

>[!info] booleani
>- `_Bool`: può memorizzare solo 0 e 1 (qualunque valore diverso da 0 viene memorizzato come 1)
>- `bool`: memorizza `true/false` (richiede l’uso di `<stdbool.h>)
>	- 0 significa `false`, 1/diverso da 0 significa `true`

>[!info] stringhe
>- ultimo elemento dell’arrawy contiene carattere di fine stringa: `\0`(detto `NULL`)
## operatori
fun facts:
- `/`: il risultato è dello stesso tipo di dato dell’operando più grande (in termini di tipo di dato)
### dichiarazione di variabili
le variabili locali possono essere dichiarate tutte all’inizio di una funzione o possono essere dichiarate nel punto più vicino al loro primo uso.
esistono dei vantaggi per entrambi:
**dichiarazione all’inizio della funzione**:
- vantaggi:
	- **historical context**: era una convenzione all’inizio !
	- **memory allocation**: dichiarare variabili all’inizio della funzione permette al compilatore di allocare la memoria per tutte le variabili una sola volta, il che può migliorare performance. il layout della memoria è anche più semplice e può essere ottimizzato più facilmente
	- **scope visibiity**: lo scope delle variabili è più chiaro e prevedibile 
	- **error prevention**: la dichiarazione all’inizio può evitare errori riguardo a uso prima della dichiarazione
	- **code clarity**: il codie è più leggibile
- svantaggi:
	- promuove il riuso di variabili per scopi differenti, che non è una buona abitudine
**dichiarazione il più vicino possibile al punto di primo uso**:
- vantaggi:
	- riduce la vita delle variabili al minimo necessario
	- non promuove il riuso 
- svantaggi: 
	- poco ordinato

| placeholder | tipo                                                                              |
| ----------- | --------------------------------------------------------------------------------- |
| `%d/%i`     | integer                                                                           |
| `%l`        | long                                                                              |
| `%o`        | integer in ottale                                                                 |
| `%x`        | integer in esadecimale                                                            |
| `%f/%e/%g`  | float, rispettivament: formato standard, notazione scientifica, scelta automatica |
| `%lf`       | double                                                                            |
# input e output
l’ambiente run-time di C, quando un programma viene eseguito, apre 2 file: `stdin` e `stdout`
- tutte le funzioni essenziali per l’I/O sono nel file `stdio.h`
## output
```c
printf("format string", value-list);
```
- `value-list` può contenere sequenze di caratteri, variabili, costanti, espressioni logico-matematice
- `printf` riceve valori, ma C permette di manipolare anche indirizzi di memoria e passarli come input a funzioni (anche se per stampare il contenuto di una locazione di memoria, si usa `scanf`)
>[!figure] format string values
![[Pasted image 20250326231401.png]]
### output di variabili
`format_string` (guarda sopra) deve contenere dei **placeholder**. un placeholder inizia con % e dice che al suo posto ci andrà il valore di una variabile e che tipo di dato deve essere scritto
>[!example] esempio
 `printf("%d, %l", integerVar, longval);`

## input
```c
scanf(format-string, address-list);
```
- `format-string`: contiene placeholder che dicono a `scanf` in che tipo di dato la stringa input viene convertita
- `address_list`: contiene gli indirizzi di memoria in cui devono essere memorizzati i valori ricevuti in input
 - restituisce come risultato il numero di valori di input letti
 >[!example] esempio
 `scanf("%d", &peso);` 
 > - `peso` è una variabile intera, `&` estrae il suo indirizzo di memoria e lo passa a `scanf`
## stringhe
array di carattere con `NULL` (`\0`)come ultimo elemento
>[!info] carattere `\0`
![[Pasted image 20250408172419.png]]
il carattere `\0` viene aggiunto automaticamente se inizializzato come nel primo modo, ma non nel secondo !
>
>inoltre se scriviamo `char r[10] = "L9 4apr"`, `r[7] = \0`, mentre `r[8]` è indeterminato
>- in questo caso conviene scrivere `char r[] = "L9 4apr"`, in quanto verrà allocata una stringa di dimensione 8

`<string.h>` contiene funzioni e macro per la gestione delle stringhe
### funzioni 
- `char *strcpy(char *dest, const char *src)`: copia stringa `src` nella stringa `dest`
	- `char *strncpy(char *dest, const char *src, size_t n)`: uguale, ma al più `n` byte sono copiati
- `int strcmp(const char *s1, const char *s2)`: confronta il contenuto di `s1` con quello di `s2`. restituisce 
	- `0 if s1 == s2`
	- `<0 if s1 < s2`
	- `>0 se s1 > s2`
- `char *strcat(char *dest, const char *src)`: concatena il contenuto della stringa `src` con quello di `dest` e mette la nuova stringa in `dest`
esistono versioni che prendono un numero di byte anche per `strcmp` e `strcat`: `strncmp` e `strncat`

>[!info] const
usando const, dato che i parametri con `cost` non devono essere modificati, evitiamo modifiche accidentali, abbiamo una maggiore chiarezza semantica, e possiamo passare stringhe letterali (es: `strcat(buffer, "ciao);`)
## puntatori
mossa abbastanza etrusca spiegarmi le stringe dopo i puntatori. che cazzo sono tutti quegli asterischi //TODO rimouvi commento
i **puntatori** sono variabili che contengono l’indirizzo di una locazione di memoria
`<tipo> *var_name;`
- es: `char *dest;`, `int *intPointer;`
dovrebbero essere inizializzati a `NULL` o a un indirizzo valido ! 
- `double *aPtr = NULL;`
un puntatore ha 2 valori associati:
- **valore diretto**: l’indirizzo di un’altra cella di memoria. accessibile usando il nome della variabile !
- **valore indiretto**: il valore della cella di memoria il cui indirizzo è il valore diretto del puntatore. accessibile usando l’operatore indiretto `*`(asterisco)
### operatori `&` e `*`
gli operatori `*` e `&` vengono usati prima di una variabile e servono a:
- `*` operator: dereferencing operator, ritorna un sinonimo, un alias o un nickname a cui punta il suo operando (la variabile su cui viene usato)
- `&` operator: ritorna l’indirizzo del suo operando
>[!example] esempio: `&` operator
>```c
>int count = 5;
>int *countPtr = &count;
>```
>in questo modo, l’indirizzo di memoria in cui è memorizzata la variabile `count` è memorizzato in `countPtr`: potremmo dire che `countPtr` **punta** a `count`
![[Pasted image 20250409075316.png]]

>[!example] esempio: `*` operator
se ora scrivessimo:
>```c
>*countPtr = 10;
>```
>usando l’operatore `*`, verrà memorizzato il valore 10 all’indirizzo di memoria a cui punta `countPtr`
>![[Pasted image 20250409075528.png]]

>[!info] operatori nei parametri delle funzioni
nei parametri delle funzioni troviamo `*`
>![[Pasted image 20250409075647.png]]
>
>quando invochiamo delle funzioni, usiamo variabili con l’operatore `&` nei parametri !
![[Pasted image 20250409075750.png]]

definire il tipo del puntatore permette al compilatore di sapere quanti byte usare all’indirizzo “puntato” dal puntatore
```c
int x;
int *xPtr = &x;
*xPtr = 7;
```

>[!info] pointer e compilatore
immaginiamo di avere un array di 10 interi, che inizia all’indirizzo 100, e di avere `int *aPtr = 100;` (quindi che punta al primo intero dell’array)
cosa succede se scriviamo `aPtr = aPtr + 1`;
>- dato che non viene usato l’operatore `*`, non verrà modificato il valore del primo intero dell’array. verrà modificato il valore dell’indirizzo di memoria a cui punta `aPtr`. ma:
>	- dato che il compilatore “sa” che `aPtr` è un pointer e che punta ad un intero di lunghezza 4 a partire dall’indirizzo 100, al posto di aumentare di 1, `aPtr = aPtr + 1;` aumenta di 4 **byte** `aPtr`. in questo modo, `aPtr` punterà al prossimo (in questo caso il secondo) intero del vettore, all’indirizzo `104`

>[!info] relazione tra array e vettori
>al posto di accedere ad un vettore con l’indexing della variabile, dato che gli elementi di un vettore sono allocati in aree di memoria contigue, possiamo accedere ai vettori usando dei puntatori !
```c
int scores[10] = {87, 98, 93, 87, 83, 76, 86, 83, 86, 77};

int *scorePtr = NULL;
scorePtr = scores; // scores == &scores[0]
int n = 5;
scorePtr = scorePtr + 5; //accederà all'elemento distante 5 da quello corrente (in questo caso, scores[5])
// quindi scores[n] == *(scorePtr + n)
```
## allocazione dinamica
fino ad ora, abbiamo allocato solo memoria per variabili che sono allocate nello **stack** a tempo di compilazione (e di conseguenza, la dimensione di tali variabili deve essere nota a tempo di compilazione)
certe volte però, può essere utile/necessario allocare memoria a run time:
- la memoria allocata a run time viene presa dalla **heap**, una seconda area di memoria mantenuta dal sistema
le funzioni per allocare memoria in modo dinamico sono `calloc()` e `malloc()` (incluse in `stdlib.h`)
entrambe le funzioni restituiscono pointer ad una area di memoria **untyped**: sarà quindi necessario effettuare il casting sul pointer restituito al tipo di necessario
lo spazio allocato va rilasciato quando non è più utilizzato, con la funzione `free()`
### $\verb |void *calloc(size_t nmemb, size_t size)|$
usato per allocare dinamicamente un vettore nella heap (cioè la memoria allocata è contigua)
- `void *` indica che ritorna un pointer di memoria **untyped** !
	- se l’allocazione  non ha successo, viene ritornato `NULL`
- prende 2 argomenti: `nmemb`: il numero di elementi dell’array, e `size`, la quantità di memoria richiesta per un elemento
	- dovremmo mandare come parametri la funzione/operatore `sizeof`
>[!example] esempi
esempio 1 : stringa
>```c
>const int str_len = 500;
>char *str_ptr = NULL;
>
>str_ptr = (char *) calloc(str_len, sizeof(char));
>if (str_ptr == NULL){
>	printf("unable to allocate string. L \n");
>	exit(1);
>}
>```
>
>esempio 2 : interi
>```c
>const int arraySize = 1000;
>int *arrayPtr = NULL;
>
>arrayPtr = (int *) calloc(arraySize, sizeof(int));
>if (arrayPtr == NULL){
>	printf("unable to allocate array. L \n");
>	exit(1);
>}
>```

### $\verb |void *malloc(size_t size)|$
usato per ottenere dinamicamente memoria dall heap (come calloc), ma **non alloca in modo contiguo**
- l’argomento `size` indica la dimensione totale di memoria da allocare
- return values uguali a `calloc()`
>[!example] esempi
esempio 1 : stringa
>```c
>const int str_len = 500;
>char *str_ptr = NULL;
>
>str_ptr = (char *) malloc(str_len);
>if (str_ptr == NULL){
>	printf("unable to allocate string. L \n");
>	exit(1);
>}
>```
>
>esempio 2 : interi
>```c
>const int arraySize = 1000;
>int *arrayPtr = NULL;
>
>arrayPtr = (int *) calloc(arraySize * sizeof(int));
>if (arrayPtr == NULL){
>	printf("unable to allocate array. L \n");
>	exit(1);
>}
>```

>[!tip] indexing di memoria allocata dinamicamente
una volta ottenuto il pointer al primo elemento, è possibile usarlo come un array normale, con `[i]` come indexing ! cool !
>```c
>arrayPtr[3] = 3;
>```
### $\verb |void *realloc(void *ptr, size_t size)|$
`realloc()` modifica la dimensione dell’area di memoria precedentemente allocata con `malloc()/calloc()` e puntata da `ptr`, rendendola della dimensione specificata da `size`
- ritorna `NULL` in caso di errore
- il contenuto dell’area di memoria puntata da `ptr` non viene modificato (giustamente …)
- la nuova area di memoria allocata non viene inizializzata (se ad esempio quella originale lo era (huh))
- in caso di errore l’area di memoria originale rimane intatta
>[!example] esempio
```c
char *strptr = NULL;
const int SIZE_OF_ARRAY = 30;
strptr = (char *) calloc(SIZE_OF_ARRAY, sizeof(char) );
strptr1 = (char *) realloc(strptr, 10*SIZE_OF_ARRAY);
```
>[!warning] `strptr1` potrebbe essere diverso da `strptr` (nel senso che l’area di memoria inizia ad un indirizzo diverso !!)
>infatti, nel caso di aumento della dimensione, qualora non riuscisse ad allargare l’area correntemente allocata e puntata da `strptr`, alloca una nuova area, liberando quella correntemente puntata da `strptr`
### $\verb |void free(void *ptr)|$
usato per deallocare(rilasciare) dinamicamente **e contiguamente** memoria dalla heap
- `ptr` è il pointer all’inzio della memoria da deallocare

>[!warning] perchè non passiamo la lunghezza della memoria da deallocare a `free()`
>non è necessario, grazie a come è gestita la memoria in C.
>quando allochiamo dinamicamente memoria con `malloc()` o `calloc()`, oltre ad allocare lo spazio chiesto dall’utente, dello spazio viene allocato per mantenere **metadati** riguardo al blocco di memoria allocato : dimensione, status flags, etc … di solito, questi metadati vengono mantenuti **nella memoria subito precedente a quella a cui punta il pointer che viene restituito**
>- quindi quando viene passato lo stesso pointer a `free()`, **the allocator** guarda ai **metadati** memorizzati prima del pointer
>- per questo motivo non si dovrebbe **mai** passare a `free()` un puntatore che non è stato restituito da `malloc() o calloc()`, e bisogna passare sempre il puntatore originale restituito
>	- inoltre **double-freeing** (freeing lo stesso puntatore 2 volte) può corrompere la heap

## structs
un nuovo tipo di dato, che combina tipi di dato eterogenei (equivalente di classe in java ngl)
esistono 3 modi per definire uno **struct**:
>[!info] struct variable
>```c
>struct { //x, y sono membri dello struct
>	double x;
>	double y;
>} point2D; //nome della variabile struct
>```
>questa modo di definzione è poco comodo, in quanto tutte le variabili struct vanno definite dopo la `}` (vicino a `point2D`)

>[!info] tagged struct
>```c
>struct point3D {
>	// point3D: tag
>	double x;
>	double y;
>	double z;
>};
>
>struct point3D pointA, pointB, pointC; //ho creato 3 variabili struct !
>```
>questa soluzione è più portabile, in quanto potrei mettere la definizione di `struct point3D` in un header file e riutilizzarla

>[!info] type-defined structs
>```c
>typedef struct {
>	char ID[17];
>	long int income;
>	float taxRate;
>} taxpayer_t; //nome del nuovo tipo di dato
>
>taxpayer_t person1, person2;
>taxpayer_5 persons[100];
>```


>[!info] operatore `->`
l’operatore `->` viene usato per accedere a membri di uno struct quando la variabile di tipo struct è stata allocata come puntatore
>```c
>taxpayer_t * newTP(char *id, long int inc, float rate)
>taxpayer_t *pTP = malloc(sizeof(taxpayer_t));
>pTP->income = inc; // pTP è un pointer ed usiamo -> per accedere al membro income
>taxpayer_t persona;
>persona.inc = inc; // persona è una struct variable, quindi usiamo . per accedere ai membri
>```
>in particolare, `pTp->income = inc;` è uno shorthand per `(*pTP).inc = inc;`
>
>in oltre l’operatore `->` viene usato anche in altre situazion in C (tipo linked data structures) sempre relative all’uso di **structs***
### inzializzazione
gli struct si possono inizializzare, anche con meno campi !
```c
struct point3D pointA = {1.1, 1.2, 3.5}, pointB = {0.3, 4.5};
```
### passaggio di struct come parametri
si può passare uno struct come parametro di una funzione in 2 modi:
- **per valore**: la funzione accetta una variabile di tipo struct nel prototipo, e gli viene passato `var` (la variabile). questo modo è più semplice, ma la lo svantaggio che **i dati vengono copiati nello stack**
- **per riferimento**(attraverso un puntatore): la funzione accetta un puntatore nel prototipo, e  gli viene passato `&var` (ciò viene passato l’indirizzo di memoria in cui inizia lo struct). ha il vantaggio che **i parametri non vengono memorizzati nello stack**, andando così ad ottimizzarne l’uso, essendo una risorsa limitata
>[!info] deep dive visto che nelle slide o negli esempi questa roba non viene detta …. spero venga detto alle lezioni che non presenzio ….
>in C, i parametri vengono sempre passati per valore. è però possibile simulare il **pass-by-reference**, passando un pointer alla variabile
**passaggio per valore**:
>
>```C
>void modify(int x){
>	x = 42;
>}
>
>int main(){
>	int a = 10;
>	modify(a);
>	printf("%d \n", a); //a non viene modificato !! still prints 10
>}
>```
>- `x` è una copia di `a`, quindi qualunque cambiamento a `x` non modifica `a`
>
> **passaggio per riferimento**:
>```C
>void modify(int *x){
>	*x = 42;
>}
>
>int main(){
>	int a = 10;
>	modify(&a);
>	printf("%d \n", a); //a viene modificato !!! prints 42
>}
>```
>- dato che viene passato l’indirizzo di memoria di `a`, `modify()` può cambiare il valore di `a`, con `*x = 42;` (makes complete sense)
>
> e allora dato che passare parametri in 2 modi diversi ha effetti diversi, cosa intendiamo quando diciamo che in C, i parametri vengono sempre passati per valore ?
per il passaggio per valore è scontato, mentre per il passaggio per riferimento, viene **comunque** passato il valore, ma in questo caso il valore che viene passato è un pointer (l’indirizzo di `a`). **infatti**, `x` è **una copia** dell’indirizzo di `a` (proprio come nell’altro modo, `x` è una copia del valore di `a`).
e dato che sia `p` che `&a` puntano alla stessa memoria, modificare `*p` modifica anche `a`

>[!tip] btw
>gli array in C vengono sempre passati per reference (in particolare come pointer al primo elemento), quindi è possibile modificarli
## file I/O
tutte le funzioni per la gestione di file di testo sono nella libreria `stdio.h`
- ogni riga in un file di testo finisce con `\n`
- il file finisce con EOF

>[!info] per aprire un file
>- dichiarare un file pointer
>- aprire il file
>	- viene creata una struttura dati con le info necessarie per gestire il file
>	- viene allocata l’area di buffer
>	- collega il file pointer con la strutura
>- usare le funzioni I/O
>- chiudere il file
>	- scrive il contenuto buffer nel file, se necessario
>	- libera la memoria associata al file pointer

```c
#include <stdio.h>
#include <stdlib.h>

int main(){
	FILE *fp;
	fp = fopen("file.txt", "r");
	if (fp ==NULL){
		printf("errore in apertura \n");
		exit(1);
	}
if (fclose(fp) ==0) printf("chiusura corretta");
else printf("errore in chiusura);
}
```
### $\verb |int fscanf(FILE *stream, const char *format, \dots)|$
legge, da `stream`, i dati il cui tipo è specificato in `format`
`fscanf(file, "%d %49s", &number, word);`
- i parametri successivi indicano dove salvare i dati letti
### $\verb |int fprintf(FILE *stream, const char *format, \dots)|$
writes formatted data ad uno stream
`fprintf(file_ptr, "Hello, world!\n");`
### $\verb |char *fgets( char *s, int size, FILE *stream)|$
legge **massimo** `n-1`  caratteri dallo stream e avanza la posizione dell indicatore per lo stream
### $\verb |int fputs(const char *s, FILE *stream)|$
writes a string to the stream, up butnot including the null character
### $\verb |int feof(FILE *stream)|$
FUCK YOUUUUUUUUUUUUUUUUU
restituisce 0 se non trova EOF, altrimenti 
