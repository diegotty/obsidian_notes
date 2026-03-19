---
related to: "[[threads]]"
created: 2025-03-02T17:41
updated: 2025-05-15T08:52
completed: false
---
>[!index]
>- [multithreading](#multithreading)
>	- [vantaggi del multithreading](#vantaggi%20del%20multithreading)
>	- [implementazione di applicazioni multithread](#implementazione%20di%20applicazioni%20multithread)
>		- [modello “da molti a 1”](#modello%20%E2%80%9Cda%20molti%20a%201%E2%80%9D)
>		- [modello “da 1 a 1”](#modello%20%E2%80%9Cda%201%20a%201%E2%80%9D)
>		- [modello “da molti a molti”](#modello%20%E2%80%9Cda%20molti%20a%20molti%E2%80%9D)
>	- [librerie dei thread](#librerie%20dei%20thread)
>		- [pthreads](#pthreads)
>	- [implementazione](#implementazione)
>		- [$\verb |int pthread_create(ptid, pattr, start, arg)|$](#$%5Cverb%20%7Cint%20pthread_create(ptid,%20pattr,%20start,%20arg)%7C$)
>		- [$\verb |void pthread_exit(void *value_ptr)|$](#$%5Cverb%20%7Cvoid%20pthread_exit(void%20*value_ptr)%7C$)
>		- [$\verb |int pthread_join (pthread_t tid, void *pret)|$](#$%5Cverb%20%7Cint%20pthread_join%20(pthread_t%20tid,%20void%20*pret)%7C$)
>		- [terminazione di un processo multithread](#terminazione%20di%20un%20processo%20multithread)
>	- [implementazione di thread in Linux](#implementazione%20di%20thread%20in%20Linux)
>		- [$\verb |int clone(start, stack, flags, arg, ...)|$](#$%5Cverb%20%7Cint%20clone(start,%20stack,%20flags,%20arg,%20...)%7C$)
>		- [$\verb |int clone(flags, stack)|$](#$%5Cverb%20%7Cint%20clone(flags,%20stack)%7C$)

# multithreading
in un’**applicazione tradizionale**, il programmatore definisce un unico flusso di esecuzione delle istruzioni, che segue la logica del programma. quando il flusso di esecuzione arriva ad eseguire la funzione `exit()`, l’applicazione termina
le **applicazioni multithread** consentono al programmatore di definire diversi flussi di esecuzione: 
- ciascun flusso di esecuzione condivide le strutture dati principali dell’applicazione (esiste quindi della memoria condivisa)
- ciascun flusso di esecuzione procede in modo **concorrente ed indipendente** dagli altri flussi
- l’applicazione finisce solo quando tutti i flussi di esecuzione vengono terminati !
>[!info] processi e threads
![[Pasted image 20250514075556.png]]
> un processo per un’applicazione monothread è costituito da:
> - codice
> - strutture dati (variabili globali in memoria, heap)
> - file aperti
> - contenuto dei registri della CPU (process context)
> - posizione e contenuto dello stack 
>
>in una applicazione multithread alcune risorse sono comuni e condivise tra tutti i thread:
>- codice
>- strutture dati
>- file aperti
>
>mentre altre risorse sono private per ciascun thread:
>- contenuto dei registri della CPU
>- posizione e contenuto dello stack

| processi                                                                                       | thread                                                                                                                                   |
| ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| istanze di un programma in esecuzione (heavyweight)                                            | componente di un processo e più piccola unità di esecuzione (lightweight)                                                                |
| cambio di contesto (context switching) richiede interazione con SO                             | context switch non richiede interazione con SO                                                                                           |
| ogni processo ha il suo spazio di memoria                                                      | usano la memoria del processo a cui appartengono                                                                                         |
| richiedono più risorse di sistema                                                              | richiedono meno risorse di sistema                                                                                                       |
| difficili da creare                                                                            | facili da creare                                                                                                                         |
| comunicazione tra processi lenta in quanto ogni processo ha un differente indirizzo di memoria | comunicazione tra thread è veloce in quanto i thread condividono lo stesso indirizzo (e area) di memoria del processo a cui appartengono |
| ogni processo esegue indipendentemente (isolato)                                               | ogni thread può leggere, scrivere, modificare dati di altri thread                                                                       |
| grazie flavio                                                                                  | sperandeo.it                                                                                                                             |

>[!info]- e finalmente la foto vista in almeno altri 3 corsi:
![[Pasted image 20250514075815.png]]

>[!tip] perchè le applicazioni multithread sono importanti ?
**è difficile scrivere applicazioni tradizionali che sfruttino a fondo il parallelismo interno del calcolatore**, che comprende:
>- DMA
>  - **hyperthreading**: supporto a diversi flussi di esecuzione, ciascuno con un proprio insieme di registri, che si alternano sulle unità funzionali della CPU
>- **multicore**: diversi core di calcolo integrati sullo stesso chip e che condividono alcune risorse harware, quali cache L2, MMU, etc..
>- **multiprocessori**: diverse CPU integrate sulla stessa scheda madre

>[!example] esempio di applicazione multithread
un browser web potrebbe essere costituito dai seguenti thread:
>- thread principale di controllo dell’applicazione
>- thread per l’interazione con l’utente
>- thread per il rendering delle pagine in formato HTML
>- thread per la gestione dei trasferimenti di pagine e file dalla rete
>- thread per l’esecuzione dei frammenti di script integrati nelle pagine web
>- thread per l’esecuzione dei programmi java, flash, etc…
## vantaggi del multithreading
il multithreading ha numerosi vantaggi:
- **riduzione del tempo di risposta**: anche se una parte dell’applicazione è bloccata in attesa di eventi esterni, un altro thread può essere eseguito per interagire con l’utente o gestire altri eventi !
- **migliore condivisione delle risorse**: tutti i thread di una applicazione condividono delle risorse (strutture dati in memoria e file aperti), e la comunicazione tra i thread è immediata
- **maggiore efficienza**: rispetto ad una applicazione costituita da più processi cooperanti, l’applicazione multithread è più efficiente, perchè **il SO gestisce i thread più rapidamente**
	- in linux, creare un thread richiede $\frac{1}{10}$ del tempo richiesto per creare un nuovo processo
- **maggiore scalabilità**: i thread possono sfruttare in modo implicito il parallelismo interno del calcolatore
## implementazione di applicazioni multithread
esistono principalmente 2 componenti in un implementazione delle applicazioni multithread: 
- implementazione a livello utente
- implementazione a livello kernel
e ciò che caratterizza le applicazioni multithread è la relazione tra thread utente e thread kernel
 - la differenza tra thread utente e thread kernel è la diversa modalità di esecuzione: user mode o kernel mode
### modello “da molti a 1”
nel modello “**da molti a 1**”, detta anche implementazione **a livello utente** o **green threads** (corrisponde alla implementazione con [[threads#ULT (User Level Thread)|user level threads]]):
- una applicazione multithread è costituita da un **singolo processo** nel SO
- a diversi thread utente corrisponde un singolo thread kernel (quindi “da molti a 1”)
- il nucleo del SO non è coinvolto nella gestione dei flussi dell’applicazione
- l’applicazione, eventualmente usando una libreria di sistema, gestisce autonomamente i thread utente: schedula i vari flussi di esecuzione e si occupa della gestione di stack UM(user mode) e i contesti dei vai thread
- se un thread invoca una chiamata di sistema bloccante, il processo (e quindi tutti i thread utente) vengono bloccati
- è impossibile sfruttare in modo implicito il parallelismo interno del calcolatore
### modello “da 1 a 1”
nel modello “**da 1 a 1**”, detta anche implementazione **a livello kernel** o **native threads** (corrisponde alla implementazione con [[threads#KLT (Kernel Level Thread)|kernel level thread]]):
- ciascun thread utente dell’applicazione corrisponde ad un singolo thread kernel (quindi “da 1 a 1”)
- il nucleo del SO si occupa della gestione e schedulazione dei thread kernel (perciò gestisce anche i thread utente, dato che sono 1 a 1 ?)
- l’applicazione utilizza le API definita in una libreria di sistema: si occupa di creare/distruggere i thread utente e di gestire la comunicazione e sincronizzazione tra essi
	- la libreria implementa i servizi richiesti dall’applicazione invocando opportune chiamate di sistema
- ciascun thread utente può invocare chiamate di sistema bloccanti senza bloccare gli altri thread
- l’applicazione sfruttra in modo implicito il parallelismo interno del calcolatore
>[!info] differenza nell’implementazione
![[Pasted image 20250514084521.png]]

| user level                                                         | kernel level                                                                        |
| ------------------------------------------------------------------ | ----------------------------------------------------------------------------------- |
| SO inconsapevole dei threads                                       | SO consapevole dei threads                                                          |
| facile implementazione dei thread                                  | difficile implementazione dei threads                                               |
| context switch veloce, senza supporto hardware                     | context switch e costoso a livello di tempo e risorse, e richiede supporto hardware |
| una chiamata bloccante fatta da un thread blocca l’intero processo | una chiamata bloccante fatta da un thread non blocca l’intero processo              |
| ss. POSIX, Java threads                                            | es. Windows, Solaris                                                                |
### modello “da molti a molti”
nell’implementazione “**da molti a molti**”:
- gli $n_{u}$ thread utente della applicazione corrispondono a $n_{k}$ thread kernel (con $n_{k} \leq n_{u}$)
- il nucleo del SO di occupa della gestione e schedulazione dei thread kernel (quindi non gestisce direttamente i thread utente)
- l’applicazione utilizza le API definite in una librerira di sistema per:
	- definire il numero $n_{k}$ di thread kernel
	- creare e distruggere i thread utente
	- mappare i thread utente sui thread kernel
- la libreria di sistema, a sua volta:
	- usa chiamate di sistema per gestire i thead kernel
	- gestisce la schedulazione e lo stack UM dei thread utente mappati sullo stesso thread kernel
	- gestisce comunicazione e sincronizzazione tra thread (utente immagino)

>[!info] tutti i maggiori SO oggi supportano i thread nativi (quindi le implementazioni “da 1 a 1” e “da 1 a molti”)
la scelta del modello tra i due appena menzionati dipende dalla libreria thread utilizzata, non dal SO !
>- linux, MS windows, macOS tendono ad adottare il modello “da uno a uno”
>
>invece le librerie che implementano i thread a livello utente possono essere utilizzato con qualunque SO

## librerie dei thread
come abbiamo visto, generalemente il programmatore utilizza una libreria di sistema per realizzare una applicazione multithread
- le API offerte dalla libreria non sono direttamente correlate con la tipologia di thread utilizzata ! (?)
- alcune librerie sono specifiche per un determinato SO e tipologia di thread (es: libreria per i thread delle API win32 (?))
- alcune librerie di thread invece sono specifiche di un linguaggio ad alto livello (es: la libreria di thread di Java), e la libreria utilizza una libreria di thread di più basso livello
### pthreads
la libreria `pthreads` (POSIX threds) è definita dallo standard POSIX, che definisce le API, ma non quale debba essere la loro implementazione in uno specifico SO
>[!info] lore
in linux sono coesistite tre diverse implementazioni:
> - `LinuxThreads`: prima implementazione, basata sul modello “da uno a uno”. non più supportata
>- `NGPT`(nex generation POSIX threads):  svluppata da IBM sul modello “da molti a molti”. non più supportata
>- `NPTL`(nex generation POSIX threads): ultima implementazione, più efficiente, più aderente allo standard, basata sul modello “da uno a uno”
>
>**oggi in linux si utilizza esclusivamente `NPTL` !**

## implementazione
vediamo ora l’implementazione di threads in `pthreads`
### $\verb |int pthread_create(ptid, pattr, start, arg)|$
la funzione `pthread_create()` crea un nuovo thread:
- `ptid`: puntatore alla variabile di tipo `pthread_t` che conterrà l’identificatore del nuovo thread (`tid)
- `pattr`: puntatore ad una variabile contenente attributi (flag) per la creazione del thread
- `start`: funzione inizialmente eseguita dal thread, con prototipo `void *start(void *)`
- `arg`: puntatore passato come argomento a `start()`
### $\verb |void pthread_exit(void *value_ptr)|$
la funzione `pthread_exit()` termina l’esecuzione del thread che la invoca
- una volta terminato il thread, viene ritornato il valore in `value_ptr`
- la funzione viene implicitamente invocata quando la funzione iniziale `start` del thread termina
- se viene eseguita dall’ultimo thread di un processo, il processo stesso termina con una `exit(0)`(syscall exit ?)
### $\verb |int pthread_join (pthread_t tid, void *pret)|$
la funzione `pthread_join()` attende la conclusione di un thread:
- `tid` è l’identificatore del thread di cui si vuole attendere la terminazione
- `pret` è l’eventuale indirizzo di una variabile che riceverà il valore passato dal thread terminato in `pthread_exit()` (quindi è possibile ottenere il valore `value_ptr` di un thread terminato con `pthread_exit()`)
**non esiste un modo di indicare che si vuole attendere la terminazione di un thread qualunque :(**
### terminazione di un processo multithread
in unix, un processo viene terminato con la syscall `exit()`. in **linux** invece, le cose sono più complicate:
- la syscall `_exit` termina un singolo thread, mentre la syscall `exit_group` termina tutti i thread di un processo
- la funzione wrapper di C `_exit()` (**in linux**) esegue la syscall `exit_group`, non `_exit` !! (quindi termina tutti i thread del processo)
- la funzione di libreria (man 3) `exit()` invece, invoca, alla fine, la funzione wrapper `_exit()`, e come abbiamo visto, eseguire un `return` in `main()` è equivalente ad invocare la funzione di libreria `exit()` (quindi termina tutti i thread)
invece, la funzione di libreria `pthread_exit()` invoca direttamente la syscall `_exit` (quindi termina un solo thread)
>[!info] struttura di `pthread_attr_t`
il tipo `pthread_attr_t` viene usato per definire gli attributi di un thread alla sua creazione. questa struttura consente di personalizzare il comportamento dei thread:
> - `scope`: determina l’ambito di competizione del thread riguardo le risorse di sistema. i suoi valori possono essere:
> 	- `PTHREAD_SCOPE_PROCESS`: compete solo con i thread dello stesso processo (default value)
>	- `PTHREAD_SCOPE_SYSTEM`: il thread compete con tutti i thread del sistema
>- `detachstate`: determina se il thread è **joinabile** (se è possibile invocare la funzione `pthread_join()` su questo thread) oppure **detached** (le sue risorse vengono liberate automaticamente alla terminazione e non è joinable)
> 	- default valu è `PTHREAD_CREATE_JOINABLE`
>- `stackaddr`: permette di specificare un indirizzo di memoria per lo stack del thread. se impostato a `NULL` (default value), il sistema alloca automaticamente
>- `stacksize`: specifica la dimensione dello stack del thread. default è 1 megabyte
> - `priority`: spcifica la priorità del thread. di default eredita la priorità del padre
>- `intheritsched`: indica se il thread eredita la politica di scheduling del padre. default è `PTHREAD_INHERIT_SCHED`, altrimenti con `PTHREAD_EXPLICIT_SCHED` viene usata la politica definita in:
>- `schedpolicy`: specifica la politica di scheduling per il thread
> 	- default value è `SCHED_OTHER`. esistono anche `SCHED_FIFO, SCHED_RR`
>
>esiste una famiglia di funzioni di nome `pthread_attr_nomefunzione`, che permettono di modificare gli attributi dell’oggetto di tipo `pthread_attr_t`
> - es: `pthread_attr_setdetachstate(), pthread_attr_setintheritsched(), pthread_att, setscope()`, etc…
## implementazione di thread in Linux
([[threads#thread in Linux|già studiata circa !]])
l’implementazione dei thread in Linux è basata sul concetto di **LWP** (**light weight process**), cioè processo leggero: un processo che condivide alcune risorse selezionate con il proprio genitore
- per creare LWP, si usa la funzione di libreria `clone()`, con diversi possibili flag `CLONE_FLAG`:
	- `CLONE_FILES`: vengono condivisi i file descriptor
	- `CLONE_FS`: viene condiviso il file system (es: working dir)
	- `CLONE_SIGHAND`: viene condiviso il gestore dei segnali
	- `CLONE_THREAD`: il thread fa parte dello stesso processo 
	- `CLONE_VM`: viene condiviso lo spazio di memoria
>[!tip] yippie
>- la funzione `fork()` è uguale alla funzione `clone()` a cui non viene passato alcuno dei flag appena elencati
>- la funzione `pthread_create()` è uguale alla syscall `clone()`se gli vengono passati tutti i flag elencati
### $\verb |int clone(start, stack, flags, arg, ...)|$
come abbiamo detto, la funzione `clone()` è simile alla funzione `pthread_create()`
- `start`: funzione inizialmente eseguita dal LWP
- `stack`: indirizzo della cima dello stack UM del nuovo LWP
- `flags`: flags `CLONE_FLAG`
- `arg`: l’argomento passato a `start()`
la funzione di libreria `clone()` (questa) si basa sulla syscall `clone`, che ha una sintassi diversa:
### $\verb |int clone(flags, stack)|$
la syscall `clone` è simile alla syscall `fork()`:
- `flags`: i flag `CLONE_FLAG`
- `stack`: l’indirizzo della cima dello stack UM del nuovo LWP. se è nullo, il figlio utilizza una copia dello stack del padre