---
related to: "[[06 - syscall; gestione dei processi]]"
created: 2025-03-02T17:41
updated: 2025-12-27T12:06
completed: false
---
>[!index]
>- [segnali](#segnali)
>	- [gestione dei segnali](#gestione%20dei%20segnali)
>		- [$\verb |int sigprocmask(int how, const sigset_t *set, sigset_t *oldset)|$](#$%5Cverb%20%7Cint%20sigprocmask(int%20how,%20const%20sigset_t%20*set,%20sigset_t%20*oldset)%7C$)
>	- [esecuzione di handler di segnali](#esecuzione%20di%20handler%20di%20segnali)
>		- [$\verb |sighandler_t signal(int signum, sighandler_t handler)|$](#$%5Cverb%20%7Csighandler_t%20signal(int%20signum,%20sighandler_t%20handler)%7C$)
>		- [$\verb |int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)|$](#$%5Cverb%20%7Cint%20sigaction(int%20signum,%20const%20struct%20sigaction%20*act,%20struct%20sigaction%20*oldact)%7C$)
>	- [altre syscall utili](#altre%20syscall%20utili)
>		- [$\verb |int kill(pid_t pid, int sig)|$](#$%5Cverb%20%7Cint%20kill(pid_t%20pid,%20int%20sig)%7C$)
>		- [$\verb |unsigned int alarm(unsigned int seconds)|$](#$%5Cverb%20%7Cunsigned%20int%20alarm(unsigned%20int%20seconds)%7C$)
>		- [$\verb |int pause(void)|$](#$%5Cverb%20%7Cint%20pause(void)%7C$)
>		- [$\verb |int sigpending(sigset_t *set)|$](#$%5Cverb%20%7Cint%20sigpending(sigset_t%20*set)%7C$)
>		- [$\verb |int sigsuspend(sigset_t *mask)|$](#$%5Cverb%20%7Cint%20sigsuspend(sigset_t%20*mask)%7C$)

# segnali
i segnali sono **interrupt software**, e possono essere inviati:
- dal kernel ad un processo
- da un processo ad un altro processo
vengono spesso generati dopo condizioni anomale che si verificano, come:
- richiesta di sospensione da parte dell’utente (come prendendo con un processo running sul terminale`ctrl+z` = SIGSTOP)
- richiestsa di terminazione da parte dell’utente (`ctrl+c` = SIGINT)
- un’eccezione hardware (divisione per 0, riferimento di memoria non valido, etc… )
ma può essere anche generato da condizioni **non** anomale:
- la terminazione di un processo figlio
- un timer settato con `alarm()` scade
- un segnale inviato da un processo ad un altro mediante la syscall `kill`
- un dato arriva su una connessione di rete (`SIGURG`)
- un processo scrive su una PIPE che non ha un “lettore” (`SIGPIPE`)

la lista completa dei segnali (che sono costanti intere) è in `<signal.h>` (o `man 7 signal`), e ad ogni segnale è associato un evento
>[!info] lista dei segnali
`SIGINT 2`: terminazione <`CTRL+C`> da tastiera
`SIGQUIT 3`: core dump, uscita
`SIGILL 4`: core dump,istruzione illegale
`SIGABR 6`: core dump, abort
`SIGFPE 8`: core dump, eccezione di tipo aritmetico
`SIGKILL 9`: terminazione, `kill` (non gestibile)
`SIGUSR1 10`: terminazione, definito dall’utente
`SIGSEGV 11`: core dump, segmentation fault
`SIGUSR2 12`: terminazione, definito dall’utente
`SIGPIPE 13`: terminazione, scrittura senza lettori su pipe o socket
`SIGALRM 14`: terminazione, allarme temporizzato
`SIGTERM 15`: terminazione, terminazione software
`SIGCHLD 17`: ignorato status del figlio cambiato
`SIGSTOP 19`: stop, sospende del processo (non gestibile)
`SIGTSTP 20`: stop, stop da tastiera
`SIGTTIN 21`: stop, lettura su tty in background
`SIGTTOU 22`: stop, scrittura su tty in background

## gestione dei segnali
i segnali sono un esempio di eventi **asincroni**:
- occorrono ad un tempo casuale
- il processo deve dire al kernel cosa fare se e quando l’evento occorre: deve definire l’**azione associata al processo**
si possono fare 3 cose quando viene generato un segnale:
1. **ignorare il segnale** (**ignore**): autoesplicativo, si può fare con tutti i segnali tranne `SIGKILL` e `SIGSTOP` (altrimenti perdo l’abilità di chiudere il processo quando voglio)
2. **catturare il segnale** (**catch**): il processo chiede al kernel di eseguire una funzione definita dal programmatore (il **signal handler**)
	- i segnali `SIGKILL` e `SIGSTOP` non possono essere catturati (stesso motivo di sopra)
3. **eseguire l’azione di default**: possibile perchè ad ogni segnale è associata una azione di default: il **default hadler**
>[!info] handler di default
>- termina il processo e genera il core dump
>- termina il processo senza generare il core dump
>- ignora e rimuovi il segnale
>- sospende il processo
>- riesuma il processo 
descrizioni più dettagliate sono fornite su **APUE** (un libro di unix)

quando un processo riceve un segnale che deve gestire con un handler:
1. interrompe il proprio flusso di esecuzione
2. esegue l’handler associato al segnale
3. riprende l’esecuzione dal punto in cui era stato interrotto
tali passi posson essere realizzati con le seguenti funzioni
### $\verb |int sigprocmask(int how, const sigset_t *set, sigset_t *oldset)|$
`sigprocmask` è un wrapper per la syscall `rt_sigprocmask` (che chiama la syscall), e consente di ottenere/settare la **maschera segnali** (**signal mask**)del thread su cui viene chiamata(ci dice quindi i segnali bloccati)
>[!info] signal mask
la **signal mask** è un insieme di segnali, usato in modo tale che quando viene generato un segnale, ci sono due possibilità:
>- se il segnale è nella signal mask, è **bloccato**, quindi rimane pending fino a che non viene sbloccato
>- se il segnale non è nella signal mask, viene spedito al processo/thread immediatamente
>la signal mask è quindi un “filtro” per i segnali che possono arrivare ad determinato processo
 >- ogni proceeso e thread ha una signal mask
- `how` permette di definire come gestire il segnale,e può assumere i seguenti valori:
	- `SIG_BLOCK`: blocca i segnali definiti in `set` (argomento)
	- `SIG_UNBLOCK`: sblocca i segnali definiti in `set`
	- `SIG_SETMASK`: setta la maschera a `set`
- `set` è la maschera da usare
- `oldset` è dove viene memorizzata la maschera presente prima dell’invocazione della funzione (può essere utile per ripristinare la mask dopo la chiamata)
>[!info] considerazioni su `sigprocmask`
>- è applicabile solo a processi e non a threads, in quanto ogni thread ha una sua maschera
>- `SIGKILL` e `SIGSTOP` non possono essere bloccati
>- la maschera dei segnali viene mantenuta dopo exec
## esecuzione di handler di segnali
>[!warning] l’uso della syscall `signal()` è deprecato in quanto l’implementazione varia across UNIX versions
> **usare `sigaction`!!!!**

### $\verb |sighandler_t signal(int signum, sighandler_t handler)|$
la funzione `signal` imposta l’handler del segnale `signum` alla funzione `handler` (entrambi argomenti), e restituise `SIG_ERR` o il valore precedente dell’handler
- esistono 2 macro che si possono passare a `handler`:
	- `SIG_IGN`: ignora il segnale
	- `SIG_DFL`: assegna l'handler di default (utile per ripristinare l’handler del segnale)
### $\verb |int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)|$
la versione **non deprecata** di `signal`, permette di fare le stesse cose di essa
- `signum`: segnale di cui modificare l’handler
- `act`: handler del segnale 
- `oldact`: handler precedente (viene “ritornato” immagino)
se viene passato `null` all’argomento `act`, viene usato `oldact` al posto di `act` (quindi non viene modificato nulla)
>[!info] struttura di `act` e `oldact`
>```c
>struct sigaction {
>	// puntatore alla funzione signal handler
>	// può essere SIG_IGN, SIG_DFL o puntatore a funzione
>	void (*sa_handler)(int);
>	
>	// Alternativo a sa_handler
>	void (*sa_sigaction)(int, siginfo_t *, void *);
>	
>	// spefica la maschera dei segnali che dovrebbero essere bloccati 
>	// durante l’esecuzione dell’handler
>	sigset_t sa_mask;
>	
>	// flags per modificare il comportamento del segnale
>	int sa_flags;
>	
>	// obsoleto
>	void (*sa_restorer)(void);
>};

## altre syscall utili
### $\verb |int kill(pid_t pid, int sig)|$
la syscall `kill` invia il segnale `sig` ad un processo `pid`.
in particolare:
- `pid > 0`: il segnale è inviato al processo con pid `pid`
- `pid = 0`: il segnale è inviato a tutti i processo del process group del chiamante
- `pid = -1`: il segnale è inviato a tutti i processi (tranne `init`) per cui il chiamante ha i privilegi per inviare un segnale
- `pid < -1`: il segnale è inviato a tutti i processi del processo group del chiamante con pid= `-pid`
### $\verb |unsigned int alarm(unsigned int seconds)|$
la syscall `alarm` invia `SIGALARM` dopo `seconds` secondi
### $\verb |int pause(void)|$
la syscall `pause` blocca il processo chiamante finchè un segnale non viene ricevuto
### $\verb |int sigpending(sigset_t *set)|$
la syscall `sigpending` restituisce l’insieme dei segnali che sono pending per il processo/thread chiamante 
### $\verb |int sigsuspend(sigset_t *mask)|$
la syscall `sigsuspend` sospende il processo che la invoca, e rimpiazza la con la signal mask `mask`. inoltre, il processo rimane sospeso finchè non arriva un segnale per cui è definito un handler (o finchè non arriva un segnale di terminazione)