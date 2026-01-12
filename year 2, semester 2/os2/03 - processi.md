---
related to:
created: 2025-03-02T17:41
updated: 2026-01-12T20:23
completed: true
---
>[!index]
>- [processi](#processi)
>	- [rappresentazione dei processi](#rappresentazione%20dei%20processi)
>		- [PCB](#PCB)
>		- [aree di memoria](#aree%20di%20memoria)
>	- [stato di un processo](#stato%20di%20un%20processo)
>	- [modalità di esecuzione dei processi](#modalit%C3%A0%20di%20esecuzione%20dei%20processi)
>	- [pipelining dei comandi](#pipelining%20dei%20comandi)
>	- [comandi](#comandi)
# processi
in linux, le due entità fondamentali sono:
- **file**: descrivono/rappresentano le risorse
- **processi**: permettono di elaborare dati e usare le risorse. 
	- un file eseguibile, in esecuzione, è un **processo**
>[!example] esempi di processi
>esempi di processo sono quelli creati eseguendo i comandi delle lezioni precedenti: `dd, ls, cat, cp, ln, ....`
>ma non tutti i comandi creano dei processi: ad esempio `echo` o `cd` vengono eseguiti all’interno del processo di shell

>[!info] ridirezione dell’output
i simboli < e > possono essere utilizzati per redirigere l’output di un comando su un file ! cool !

## rappresentazione dei processi
[[gestione dei processi#elementi di un processo|roba già fatta a os1 ngl]]
### PCB
Il PCB è unico per ogni processo e contiene:
- PID: Process Identifier
- PPID: Parent Process Identifier
- real UID: Real User Identifier
- real GID: Real Group ID
- effective UID: Effective User Identifier (UID assunto dal processo in esecuzione)
- effective GID: Effective Group ID (come sopra per GID)
- saved UID: Saved User Identifier (UID avuto prima dell’esecuzione del SetUID)
- saved GID: Saved Group Identifier (come sopra per GID)
- current Working Directory: directory di lavoro corrente
- umask: file mode creation mask
- nice: priorità statica del processo
### aree di memoria
- **text segment**: le istruzioni da eseguire (in linguaggio macchina)
- **data segment**: dati statici inizializzati (variabili globali e locali static)e alcune env vars
- **BSS**: (Block Started from Symbol) contiene dati statici non inizializzati. la distinzione dal data segment si fa per motivi di realizzazione hardware (ok bro ….. un po vago bro …)
- **heap**: dati dinamici
- **stack**: chiamate a funzioni con corrispondenti dati dinamici
- **memory mapping segment**: tutto ciò che riguarda librerie esterne dinamiche usate dal processo, nonchè estensione dello heap in alcuni casi
>[!figure] illustrazione
![[Pasted image 20250322134008.png]]
## stato di un processo
- **running (R)**: in esecuzione su un processore
- **runnable (R)**: pronto per essere eseguito; aspetta scheduler
- **(interruptible) sleep (S)**: in attesa di qualche evento; non può essere scelto dallo scheduler
- **zombie (Z)**: terminato, il suo PCB viene ancora mantenuto dal kernel perchè il processo padre non ha ancora richiesto il suo “exit status”
- **stopped (T)**: caso particolare di sleeping: ha ricevuto un segnale `STOP` ed è in attesa di un segnale `CONT`
- **traced (t)**: in esecuzione di debug, oppure in generale in attesa di un segnale
- **uninterruptible sleep (D)**: come sleep, ma tipicamente sta facendo operazioni di IO su dischi lenti e non può essere interrotto ne ucciso
## modalità di esecuzione dei processi
- **foreground**: il comando può leggere l’input da tastiera e scrivere su schermo, e finchè non termina, il prompt non viene restituito e non si possono **sottomettere** altri comandi alla shell
- **background**: il comando non può leggere l’input da tastiera ma può scrivere su schermo. il prompt viene immediatamente restituito dopo aver eseguito il comando (non aspetta che il processo finisca) e si possono quindi dare altri comandi alla shell da subito
l’esecuzione in background è possibile con il carattere `&`
- non disponibile in tutte le shell, ma in bash si
>[!info] `bg`e`fg`
>- `bg` porta un processo in background
>- `fg%n` dove `%n` è il numero del job, lo riporta in foreground
>- `bg%n` dove `%n` è il numero del job, lo porta in background

>[!info] jobs vs processi
>**processi**: una istanza di un programma in esecuzione, gestiti dal kernel e identificati da un PID
>**job**: un gruppo di **uno o più processi** iniziati dalla **shell corrente**. i job sono gestiti dalla shell, e sono identificati da un job ID (JID ??? the rapper ???) (es: `%1, %2`)
>
per vedere la lista di job in esecuzione, si usa il comando `jobs [-l] [-p]`
>- `-l`: elenca PIDs dei job, oltre ai jobID
>- `-p`: elenca solo i PID dei job
>- `-n`: mostra solo i job il cui stato è cambiato dall’ultima chiamata di `jobs`
>- `-r`: mostra solo jobs che sono RUNNING
>- `-s`: mostra solo jobs che sono STOPPED

## pipelining dei comandi
è possibile eseguire un job composto da più comandi:
```
comando1 | comando2 | .... comando n
```
dove lo standard output di un comando $i$ diventa l’input del comando $i+1$
- se uso `|&`, viene ridirezionato lo standard error invece dello standard output allo standard input del comando successivo !
## comandi
>[!info] comandi
>### $\verb |ps [opzioni] [pid ...]|$
>mostra le informazioni dei processi in esecuzione, e legge le informazioni dai file virtuali in `/proc`
>- `ps` senza argomenti mostra i processi dell’utente attuale lanciati dalla shell corrente ! (x ogni processo mostra PID, TTY, TIME e CMD)
>- `[-e]`: tutti i figli del processo 0, cioè tutti i processi di tutti gli utenti lanciati da tutte le shell o al boot
>- `[-u] {utente}`: tutti i processi degli utenti nella lista
>- `[-p] {pid, ..}`: tutti i processi con i PID nella lista
>- `[-f]`: full-format listing (restituisce colonne aggiuntive: UID, PPID, C (fattore di utilizzo della CPU), STIME (tempo di avvio))
>- `[-l]`: display BSD long format (restituisce altre colonne addizionali: F (flag), PRI (priorità), NI (nice value), ADDR (indirizzo di memoria del processo), SZ, (dimensione immagine del processo, in pagine) WCHAN ())
>- `[-o] {field, ...}`: user defined format, per scegliere i campi da visualizzare 
>- `[-c] {cmd, ...}`: solo i processi il cui nome eseguibile è in `{cmds}`
>#### significato dei campi mostrati da $\verb |ps|$
>- `PPID`: parent pid
>- `C`: parte intera della percentuale di uso della CPU
>- `STIME/START`: l’ora in cui è stato invocato il comando (o data se è stato fatto partire da più di un giorno)
>- `TIME`: tempo di CPU usato fino ad ora
>- `CMD`: comando con argomenti
>- `F`: flags associati al processo (1: forkato ma non eseguito. 4: ha privilegi da superutenti. 5: entrambi i precedenti. 0: nessuno dei precedenti)
>	- il flag `[-y]`, usabile solo con il flag `[-l]`,  permette di non visualizzare i flag !
>- `s`: stato del processo in una sola lettera
>- `UID`: utente che ha lanciato il processo 
>- `PRI`: attuale priorità del processo
>- `NI`: valore di nice
>- `ADDR`: indirizzo di memoria del processo (mostrato per retrocompatibilità)
>- `SZ`: dimensione totale attuale del processo in numero di pagine (tutte le 6 aree di memoria del processo) in RAM e memoria virtuale
>- `WCHAN`: funzione all’interno la quale si è fermato il processo, se sta aspettendo qualche segnale/è in sleep
>### $\verb |top [-b] [-n \nu m] [-p {pid,}]|$
>`ps` interattivo, dinamico e real-time
>- `[-b]`: non accetta più comandi interattivi, ma continua a fare refresh ogni pochi secondi
>- `[-n num]`: fa solo `num` refresh
>- `[-p {pid, ...}]`: mostra solo i processi con PID nella lista
>### $\verb |kill [-l [signal]] [-signal] [pid]|$
>invia segnali ad un processo (non solo la teriminazione !)
>- `[-l]` mostra la lista dei segnali se non viene passato un segnale come argomento. altrimenti, viene passata la formattazione alternativa a quella dell’argomento (testo  o numero) (i segnali sono identificati dal numero oppure dal nome con `SIG` o senza `SIG`)
>- i segnali verranno presi in considerazione solo se il **real user** del processo è lo stesso che inivia il segnale (o se lo invia un superuser)
>- `CTRL+z` invia un `SIGSTOP` !
>- `CTRL+c` invia un `SIGINT` !
>- se non viene specificato nessun segnale, viene inviato il segnale `TERM`
>>[!warning] `SIGSTOP` e `SIGKILL` non possono essere gestiti da programmi !
>
>>[!example] esempio di segnali
>>- `SIGSTOP`: sospensione
>>- `SIGCONT`: continuazione di processi sospesi (il segnale inviato da `bg`)
>>- `SIGKILL`: terminazione in modo immediato e non gestibile dal proceso. non vengono eseguiti clean up codes o handlers
>>- `SIGINT`: chiede al processo di terminare. molti processi lo gestiscono per fare clean up (salvare lo stato, chiudere file)
>#### SIGUSR1 e SIGUSR2
>sono segnali impostati per essere usati dall’utente per le proprie necessità
>- consentono una semplice forma di comunicazione tra processi (in quanto un processo può mandare un segnale ad un altro processo, ed un programma può definire un gestore del segnale per `SIGUSR1` o `SIGUSR2`)
>### $\verb |nice [-n num] [comando]|$
>senza opzioni, dice quant’è il **niceness** di partenza (valore da aggiungere alla prorità ogni ms(credo ?), va da -19 a +20, con default 0)
>- priorità alta → valore di priorità basso
>- `nice [-n num] comando` lancia un comando con niceness `num`
>### $\verb |renice priority {pid}|$
>internviene su processi già in esecuzione (infatti chiede un PID), e altera la loro priorità
>### $\verb |strace [-p pid] [comando]|$
>- lancia `comando` visualizzando tutte le sue syscall
>- `[-o] filename` ridireziona l’output su un file
>	- utile per il debug di programmi che usano syscall
