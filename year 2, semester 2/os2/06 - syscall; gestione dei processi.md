---
related to: "[[05 - syscall; allocazione memoria, gestione IO, misc]]"
created: 2025-03-02T17:41
updated: 2025-11-21T11:32
completed: true
---
>[!index]
>- [gestione dei processi](#gestione%20dei%20processi)
>	- [creazione](#creazione)
>		- [$\verb |pid_t fork(void)|$](#$%5Cverb%20%7Cpid_t%20fork(void)%7C$)
>	- [terminazione](#terminazione)
>		- [zombie](#zombie)
>	- [syscall per controllo processi](#syscall%20per%20controllo%20processi)
>		- [$\verb |void _exit (int status)|$](#$%5Cverb%20%7Cvoid%20_exit%20(int%20status)%7C$)
>		- [$\verb |void exit (int status)|$](#$%5Cverb%20%7Cvoid%20exit%20(int%20status)%7C$)
>		- [$\verb |void abort(void)|$](#$%5Cverb%20%7Cvoid%20abort(void)%7C$)
>		- [$\verb |pid_t wait(int *status)|$](#$%5Cverb%20%7Cpid_t%20wait(int%20*status)%7C$)
>		- [$\verb |pid_t waitpid(pid_t pid, int *status, int options)|$](#$%5Cverb%20%7Cpid_t%20waitpid(pid_t%20pid,%20int%20*status,%20int%20options)%7C$)
>		- [$\verb |int execve(const char *filename, char * const argv[], char *const envp[])|$](#$%5Cverb%20%7Cint%20execve(const%20char%20*filename,%20char%20*%20const%20argv%5B%5D,%20char%20*const%20envp%5B%5D)%7C$)
>	- [gestione dell’ambiente](#gestione%20dell%E2%80%99ambiente)

# gestione dei processi
## creazione
`init` è il processo 0 (con `pid=1`), padre di tutti i processi in esecuzione del sistema.
da `init` vengono creati tutti i processi, mediante la syscall `fork()`, che consisten nella duplicazione del processo, e della creazione di relazioni **padre-figlio**!

>[!example]- esempio
notiamo come in questo caso, il terminale su cui è stato lanciato `pstree` è figlio di i3, e `pstree` è figlio di `zsh`
![[Pasted image 20250511210433.png]]

ogni processo nella gerarchia fa riferimento al processo padre:
- alla nascita, eredita codice e parte dello stato dal processo padre
- quando termina/muove, ritorna l’exit status al processo padre
e se il processo padre termine/muore prima del processo figlio, il processo figlio vene adottato da `init`
>[!info] rappresentazione
![[Pasted image 20250511210739.png]]
`PPID` contiene proprio il `pid` del processo padre
### $\verb |pid_t fork(void)|$
la syscall `fork()` crea un nuovo processo che è la copia del processo chiamante, a parte alcune strutture dati (es: il `pid`)
- una chiamata `fork()` ritorna 2 volte per ogni volta che viene chiamata:
	- una volta ritorna al proceso che l’ha invocata
	- l’altra volta ritorna al nuovo processo che è stato generato dall’eseguzione di `fork()`
in caso di errore ritorna `-1` al chiamante, e non viene creato nessun processo figlio

in particolare, un processo figlio creato con `fork`,
 - **eredita dal padre**:
	 - `uid`, `euid`, `gid`, `egid`
	 - groups id
	 - working directory
	 - ambiente del processo
	 - descrittori dei file
	 - terminale di controllo
	 - memoria condivisa
- **non eredita dal padre**:
	- `pid`: ogni figlio ha il suo proprio `pid`
	- `ppid`: nel figlio, il `ppid` è uguale al `pid` del padre (non al `ppid` del padre)
	- i timer: ogni processo ha i propri timer
	- record lock / memory lock: due processi non possono avere gli stessi lock
	- contatori risorse: i contatori dell’utilizzo delle riorse sono impostati a zero per il figlio
	- coda dei segnali: la coda dei segnali in attesa viene svuotata nel figlio
## terminazione
### zombie
un processo **zombie** è un processo terminato, ma il cui PCB è mantenuto dalla **process table** del kernel per permettere al processo padre di leggere l’exit status di esso
>[!warning] se il padre di un processo muore/termina mentre il figlio è in stato zombie, esso rimane in stato zombie !!
## syscall per controllo processi
richiedono `<sys/types.h>` e `<unistd.h`

| syscall                 | azione                                                                        | risultato                                               |
| ----------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------- |
| `pid_t getpid(void)`    | ritorna `pid` del processo chiamante                                          | termina sempre con successo                             |
| `pid_t getppid(void)`   | ritorna `pid` del padre del processo chiamante                                | ””                                                      |
| `uid_t getuid(void)`    | ritorna `uid` (utente proprietario) del processo chiamante                    | ””                                                      |
| `uid_t geteuid(void)`   | ritorna l’`euid` (effective uid) del processo chiamante                       | “”                                                      |
| `int setuid(uid_t uid)` | imposta l’`euid` del processo chiamanete a `uid` (parametro)                  | ritorna `-1` in caso di errore, `0` in caso di successo |
| `int setgid(uid_t uid`  | imposta l'`egid` (effective `gid`) del processo chiamante a `gid` (parametro) | “”                                                      |
vediamo le syscall utili per terminare un proceso:
### $\verb |void _exit (int status)|$
`_exit` è una syscall che termina il processo che la invoca, senza invocare handler. in particolare:
- chiude tutti i file descriptor
- i child vengono ereditati dal processo con `pid=1` (`init`)
- invia il segnale `SIGCHILD` al processo padre
- ritorna `status` e l’exit status al processo padre
### $\verb |void exit (int status)|$
`exit` è una funzione definita in `<stdlib.h>` che:
- invoca sono stati registrati nel processo con `atexit` e `on_exit`
- chiude tutti i file descriptor, svuota gli stream `stdio` e li chiude
- termina il processo
- ritorna `status & 0377` al padre \\add info
possono essere passate, come parametro per `status`, `EXIT_SUCCESS` e `EXIT_FAILURE` (autoesplicative)
>[!info] come viene lanciato e terminato un programma di C
![[Pasted image 20250511212852.png]]

### $\verb |void abort(void)|$
`abort`è una funzione definita in `<stdlib.h>`, che invia il segnale `SIGABRT` per il processo chiamante. quando viene lanciato `SIGABRT`, il processo termina in modo anormale (non vengono chiusi file o svuotati buffer)
- `SIGABRT`può essere intercettata e gestita
- per mandare `SIGABRT`, `abort` usa una syscall

guardiamo ora delle funzioni usate per:
- attendere cambiamenti di stato di un figlio del processo chiamante, e ottenere informazioni a riguardo
avviene un cambimento di stato quando:
- un processo figlio è terminato
	- in particolare, se un figlio viene terminato, `wait/waitpid` permettono al sistema di rilasciare correttamente le risorse associate al figlio (altrimenti, senza attesa, il figlio terminato rimane in uno stato zombie)
- un processo figlio viene arrestato da un segnale (`abort` !)
- un processo figlio viene ripristinato da un segnale
se un figlio ha già cambiato stato, le chiamate ritornano immediatamente (cambiato rispetto a cosa ? ) altrimenti si bloccano fino a quanto un figlio non cambia stato o un gestore di segnale non interrompe la chiamata
### $\verb |pid_t wait(int *status)|$
la syscall `wait` sospende l’esecuzione del processo chiamante fino a quando uno dei suoi figli non termina (ritorna `-1`) in caso di errore
### $\verb |pid_t waitpid(pid_t pid, int *status, int options)|$
la syscall `waitpid` sospende l’esecuzione del processo chiamante fino a quando un figlio, specificato dall’argomento `pid`, ha cambiato stato
il valore di `pid` può essere:
- `< -1`: attesa di qualunque figlio il cui `gid` del processo sia uguale al valore assoluto di `pid` (?)
- `-1`: aspettare qualunque processo figlio
- `0`: aspettare qualunque processo figlio il cui `gid` sia uguale a quello del processo chiamante
- `> 0`: aspettare il figlio il cui `pid` sia uguale al valore di `pid` (argomento)
il comportamento di default di `waitpid` è di aspettare finchè i figli non terminano, ma tale comportamento è modificabile attraverso l’argomento `options`:
- `WNOHANG`: torna immediatamente se nessun figlio è uscito
- `WUNTRACED`: torna anche se un figlio si è arrestato (ma non è tracciato attraverso la syscall `ptrace`). in questo caso viene fornito anche lo stato del figlio arrestato, anche se l’opzione non è specificata
- `WCONTINUED`: torna anche se un figlio arrestato è stato riesumato inviando `SIGCONT`
(i valori di sopra possono essere messi in OR)
>[!info] l’argomento `status`
l’argomento `status` viene usato da `wait/waitpid` per memorizzare il valore dello stato del processo figlio (o `NULL`)
in particolare, `status` può essere verificato con le seguenti macro: 
>- `WIFEXITED`: ritorna true se è terminato normalmente
>- `WEXTISTATUS`: ritorna l’exit status del figlio
>- `WIFSIGNALED`: ritorna true se è terminato per la ricezione di un segnale
>- `WTERMSIG`: ritorna il numero del segnale che ha causato la terminazione
>- `WCOREDUMP`: ritorna true se ha generato un core dump
>- `WIFSTOPPED`: ritorna true se il processo è in stato stopeed per la ricezione di un segnale
>- `WSTOPSIG`: ritorna il numero del segnale che ha causato lo switch in stato di stopped
>- `WIFCONTINUED`: ritorna true se il processo ha continuato per la ricezione di un segnale `SIGCONT`

guardiamo ora delle syscall e funzioni libreria che permettono la sostituzione dell’immagine del processo che la invoca con una nuova immagine
- la famiglia di funzione `exec` contiene diverese syscall (7 credo), ognuna con funzione minimalmente differente/argomenti diversi, noi vedremo la principlae
### $\verb |int execve(const char *filename, char * const argv[], char *const envp[])|$
la syscall `execve` sostituisce l’immagine del processo con quella contenuta in `filename` (che è un file binario, oppure uno script che inizia con `#! interpreter [optiona-arg]`)
- `argv[]`: contiene gli argomenti in input per il comendo eseguito, e `argv[0]` deve essere il comando stesso. l’array deve essere terminato con `NULL`
- `envp[]`: contiene l’ambiente della nuova immagine (LO VEDIAMO DOPO ….)
 `execve`sostituisce quindi le zone di memoria `text`, `bss` e `stack` del processo che invoca la funzione, con quelle del nuovo programma mandato in esecuzione. in particolare:
 - **vengono preservati**:
	 - `pid` e `ppid`
	 - `uid` e `gid`
	 - groups id
	 - session ID
	 - terminale di controllo
	 - working directory e root directory
	 - `umask`
	 - file locks 
	 - file descriptors (ad eccezione di quelli con flag `FD_CLOEXEX` settato)
	 - maschera dei segnali
	 - segnali in attesa
	 - ambiente (non scritto su slide ma vero credo)
 - **non vengono preservati**:
	 - `euid` e `egid`
	 - memory mapping
	 - timers
	 - memoria condivisa
	 - memory lock
>[!example] esempio
![[Pasted image 20250511222409.png]]
da bash passa a vi !!! con lo stesso `pid` !! crazy !!!

>[!info] funzioni della libreria `exec*`
![[Pasted image 20250511223018.png]]
riguardo gli argomenti:
>- `execl, execlp, execle`: prendono in ingresso un numero variabile di puntatori, per specificare gli argomenti in ingresso alla nuova immagine del processo: un puntatore per ogni argomento
>- `execv, execvp, execve`: prendono in ingresso un puntatore ad un vettore per specificare gli argomenti in ingresso alla nuova immagine del processo: ogni elemento del vettore è un argomento in ingresso
>
>- `execlp, execvp, execvpe`: nel caso il nome di un file non contenga uno `/`, usano la variabile d’ambiente `PATH` per cercare il file da utilizzare per la nuova immagine
>	- le altre funzioni della famiglia `exec` usano il path relativo o assoluto specificato in `filename`
>- `execle, execvpe`: il parametro `envp` consente di specificare l’ambiente della nuova immagine
>
>idk honestly but ok

per cambiare working dir o root dir del nuovo processo, posso usarele funzioni `chdir()` e `chroot()`, incluse in `<unistd.h>` che prendono come argomento un path che verrà usato per rimpazzare, rispettivamente, working dir e root dir al processo chiamante
## gestione dell’ambiente 
per **ambiente** di un processo si intende un insieme di variabili (le **variabili d’ambiente**) che contengono informazioni utili per il funzionamento del processo stesso
- è un blocco di memoria
>[!info] ambienti e processi
ogni processo ha il suo ambiente. quindi, quando viene eseguito il comando `printenv`, a che processo appartiene l’ambiente che viene stampato sul terminale ?
al processo `printenv` stesso, che viene creato dalla shell (`zsh` hehe) attraverso `fork`, ed eredita una copia dell’ambiente della shell

per poter accedere all’ambiente(della shell) da un programma C, si può:
- aggiungere l’argomento `envp` (array di variabili d’ambiente) ai parametri del main
	- molti ambienti linux passando **automaticamente** l’argomento `envp`, come estensione del sistema
- utilizzare la variabile globale `**environ`: `extern char **environ`
>[!info] altre funzioni utili per la gestione dell’ambiente
>```c
>// ritorna il valore nella variabile name
>char *getenv(const char *name);
>// setta (o aggiunge la variabile) name = value
>int setenv(const char *name, const char *value, int overwrite);
>// come sopra string=“name=value”
>int putenv(char *string);
>// rimuove name dalle variabili di ambiente
>int unsetenv(const char *name);
>// resetta l’ambiente *environ=NULL
>int clearenv(void);
