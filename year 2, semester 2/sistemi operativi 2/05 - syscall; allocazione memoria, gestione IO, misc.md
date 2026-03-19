---
related to: "[[04 - introduzione a C]]"
created: 2025-03-02T17:41
updated: 2025-05-11T21:48
completed: true
---
>[!index]
>- [programmazione di sistema](#programmazione%20di%20sistema)
>	- [system call](#system%20call)
>	- [funzioni general purpose](#funzioni%20general%20purpose)
>- [syscall](#syscall)
>	- [gestione errori](#gestione%20errori)
>		- [`errno`](#%60errno%60)
>		- [$\verb |void perror(const char *prefix)|$](#$%5Cverb%20%7Cvoid%20perror(const%20char%20*prefix)%7C$)
>		- [$\verb |char *strerror(int errum)|$](#$%5Cverb%20%7Cchar%20*strerror(int%20errum)%7C$)
>	- [allocazione della memoria](#allocazione%20della%20memoria)
>		- [$\verb |void *memset(void *s, int c, size_t n)|$](#$%5Cverb%20%7Cvoid%20*memset(void%20*s,%20int%20c,%20size_t%20n)%7C$)
>		- [$\verb |void *memcpy(void *dest, const void *src, size_t n)|$](#$%5Cverb%20%7Cvoid%20*memcpy(void%20*dest,%20const%20void%20*src,%20size_t%20n)%7C$)
>	- [memory-mapped I/O](#memory-mapped%20I/O)
>		- [$\verb |void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)|$](#$%5Cverb%20%7Cvoid%20*mmap(void%20*addr,%20size_t%20length,%20int%20prot,%20int%20flags,%20int%20fd,%20off_t%20offset)%7C$)
>		- [$\verb|int msync (void *addr, size_t len, int flags)|$](#$%5Cverb%7Cint%20msync%20(void%20*addr,%20size_t%20len,%20int%20flags)%7C$)
>		- [$\verb|int munmap(void *addr, size_t len)|$](#$%5Cverb%7Cint%20munmap(void%20*addr,%20size_t%20len)%7C$)
>	- [gestione file I/O](#gestione%20file%20I/O)
>		- [file descriptor](#file%20descriptor)
>		- [$\verb |int open(const char *pathname, int flags, mode_t)|$](#$%5Cverb%20%7Cint%20open(const%20char%20*pathname,%20int%20flags,%20mode_t)%7C$)
>		- [$\verb|ssize_t read(int fd, void *buf, size_t count)|$](#$%5Cverb%7Cssize_t%20read(int%20fd,%20void%20*buf,%20size_t%20count)%7C$)
>		- [$\verb |ssize_t write (int fd, const void *buf, size_t count)|$](#$%5Cverb%20%7Cssize_t%20write%20(int%20fd,%20const%20void%20*buf,%20size_t%20count)%7C$)
>		- [$\verb |int close(int fd)|$](#$%5Cverb%20%7Cint%20close(int%20fd)%7C$)
>	- [misc. syscall](#misc.%20syscall)
>		- [$\verb |int dup(int oldfd)|$](#$%5Cverb%20%7Cint%20dup(int%20oldfd)%7C$)
>		- [$\verb |int fstat(int fd, struct stat *buf)|$](#$%5Cverb%20%7Cint%20fstat(int%20fd,%20struct%20stat%20*buf)%7C$)
>		- [$\verb |int chmod(const char *pathname, mode_t mode)|$](#$%5Cverb%20%7Cint%20chmod(const%20char%20*pathname,%20mode_t%20mode)%7C$)
>		- [gestione directory](#gestione%20directory)
>		- [$\verb |int fcntl (int fd, int cmd, ...)|$](#$%5Cverb%20%7Cint%20fcntl%20(int%20fd,%20int%20cmd,%20...)%7C$)
>		- [$\verb |int select(int nfds, fd_set *readfds, fd_set *writedfs, fd_set *exceptfds, struct timeval *timeout)|$](#$%5Cverb%20%7Cint%20select(int%20nfds,%20fd_set%20*readfds,%20fd_set%20*writedfs,%20fd_set%20*exceptfds,%20struct%20timeval%20*timeout)%7C$)

# programmazione di sistema
come abbiamo visto nel primo modulo, il **kernel** è il componente del sistema operativo che gestisce le risorse disponibili ed offre l’accesso e l’utilizzo della risorse da parte dei processi
le principali risorse gestite dal kernel sono CPU, RAM e dispositivi di I/O
le **system call** offrono **un limitato numero** (che varia con la versione del sistema) di punti di accesso al kernel: permettono ad un processo di accedere ai servizi offerti dal kernel, e di conseguenza permettono al programmatore di creare programmi che interagiscono direttamente con il kernel !
>[!info]
![[Pasted image 20250425153955.png]]
## system call
le systemcall sono definite in linguaggio C, indipendentemente dalla tecnica usata dallo specifico sistema per invocare la system call, e **per ogni** system call esiste una funzione C avente lo stesso nome
- quando viene chiamata una syscall, il processo utente invoca questa funzione usando la sequenza standard C, che a sua volta invoca il corrispondente servizio del kernel utilizzando la tecnica necessaria (…….), ad esempio  mettendo i parametri della funzione C in un registro e poi generando un interrupt per il kernel, usando istruzioni macchina
le informazioni sulle syscall si trovano nella sezione 2 del man : `man 2 nome_system_call`
## funzioni general purpose
le funzioni dall’interno delle librerire di sistema (general purpose) non sono punti di accesso ai servizi del kernel !
- possono invocare una o più syscall (es: `prinf()` usa la syscall `write`), ma possono anche non usarne nessuna (es: `strcpy()`)
le informazioni sulle funzioni general purpose si trovano nella sezione 3 del man: `man 3 nome_funzione_libreria`
>[!info] differenza tra syscall e funzioni di sistema
>- sono entrambe funzioni C
>- entrambe forniscono servizi ad un’applicazione
>- **una funzione di sistema può essere rimpiazzata, ma una syscall no !!!**
>>[!example] esempio
>la syscall `sbrk` permette di allocare la memoria, e la funzione `malloc()` è implementata usando `sbrk`. possiamo implementare la nostra `malloc()`, ma dovremo sempre utilizzare la syscal `sbrk` !
>le syscall introducono una separazione di compiti: `sbrk` alloca chunk di memoria (in kernel mode), mentre `malloc()` gestisce l’area di memoria, in user mode
![[Pasted image 20250425215449.png]]
>- le funzioni di libreria **semplificano** l’uso delle syscall, che espongono una interfaccia minimale. le funzioni forniscono funzionalità elaborate e semplificano la gestione delle strutture dati di input e output !


# syscall
>[!warning] come riconoscere una syscall
guarderemo ora un numero di funzioni libreria e syscall. come facciamo a riconoscere se una data funzione è una syscall o non lo è ? 
>si può controllare attraverso il **man**, scrivendo `man 2 nome_funzione`: se esiste una entry, allora è una syscall
>- 4 any arch buddies, la syscalls man page va scaricata (pacchetto `man-packages`)
>>[!tip] fun tip
>>esiste il comando `strace` con sui si può runnare un programma (`strace ./a.out`) che fa vedere tutte le syscalls reali vengono eseguite (cool !!!)

>[!info] come funzionano le syscall (reminder idk im dumb)
le funzioni che usiamo, implementate in C, sono wrapper per le syscall: gestiscono gli argomenti che gli vengono passati e, attraverso un’istruzione speciale (`syscall`), invocano il kernel. la CPU entra in kernel mode, salta al codice che implementa la syscall (scritto in C + assembly), e una volta eseguito torna in user-mode
## gestione errori
l’esecuzione di una syscall può interrompersi e non andare a buon fine per vari motivi, tra cui, principalmente:
- il processo che la invoca non ha sufficienti privilegi per l’esecuzione
- non ci sono sufficienti risorse per l’esecuzione
- gli argomenti in ingresso alla syscall non sono validi
>[!tip] è fondamentale controllare i valori di ritorno per rilevare e segnalare all’utente il verificarsi di errori !
e, per un corretto funzionamento del programma, **è fondamentale gestire in maniera opportuna** l’eventuale errore verificatosi
### `errno`
`errno` è una variabile globale, impostata dalle syscall che termine con un errore ad un codice specifico, relativo all’errore che si è generato durante l’esecuzione
- le syscall che terminano con successo invece, lasciano invariato `errno`
ha senso utilizzare `errno` **solo dopo essersi accertati** che la syscall abbia ritornato un valore di errore (di solito -1), altrimenti si rischia di considerare un valore di `errno` incosistente (potrebbe essere l’`errno` di una syscall precedente all’ultima)
### $\verb |void perror(const char *prefix)|$
`perror()` è una funzione della libreria standard (`stdio.h`), che stampa su `stderr` il messaggio di errore convertendo il codice di `errno` in una stringa, formata da:
$$
\text{<prefix>:<errno\_string>}
$$
- $\text{<errno\_string>}$ rappresenta il messaggio di errore in formato stringa associato al valore di `errno`
>[!example] esempio
`perror("main")` invia su `stderr`:
$\text{"main:messaggio\_errore\_mnemonico\_=\_errno"}$
### $\verb |char *strerror(int errum)|$
`strerror()` è una funzione di libreria (`string.h`) che consente di convertire un codice di errore numerico `errno`, che acquisisce come parametro di input, nella sua equivalente rappresentazione in stringa

>[!info] debug syscall
è spesso utile monitorare il comportamento di un processo relativamente all’invocazione di syscall: è possibile scaricare il comando `strace` che permette di tracciare l’invocazione di syscall da parte di un processo e i relativi parenti
## allocazione della memoria
abbiamo visto le [[04 - introduzione a C#allocazione dinamica|funzioni per l’allocazione dinamica]] di memoria **nell’heap**
- nella libreria `alloca.h` è definita la funzione `void *alloca(size_t size)`, che permette di allocare dinamicamente **memoria nello stack** (da evitare per grandi dimensioni !)
le funzioni `malloc()`, `calloc()` e `realloc()` usano le vere syscall per la gestione della memoria, ad esempio `nmap()` (alloca memoria) e `brk()` (cambia dimensione del [[03 - processi#aree di memoria|data segment]] del processo)
- le funzioni (che allocano memoria dinamicamente) ritornano un puntatore (lo indica `void *nome(parametri)`), e come visto in precedenza serve fare il casting al tipo di puntatore relativo di dato contenuto nella memoria per poter utilizzare correttamente l’aritmetica dei puntatori
>[!warning] memory leakage
l’esecuzione di un programma che non gestisce correttamente la liberazione della memoria non più utilizzata può causare un aumento del consumo della memoria di sistema: questo può portare al fallimento del programma stesso, non riuscendo più ad allocare altra memoria da utilizzare, ed in generale può portare al deterioramento delle performance e del funzionamento del sistema
>- ricordiamoci di usare `free()` :)
### $\verb |void *memset(void *s, int c, size_t n)|$
- assegna il valore intero `c` a `n`byte contigui dell’area di memoria puntata da `s` (cool !)
### $\verb |void *memcpy(void *dest, const void *src, size_t n)|$
- copia `n` bytes contigui a partire da `src` in `dest`
	- le due aree di memoria non possono sovrapporsi !!!
	- es: utile per duplicare rapidamente un array

## memory-mapped I/O
### $\verb |void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)|$
 è inclusa in `<sys/mman.h>`, e crea un’area di memoria per mappare un file a partire da un indirizzo specificato (o non)
 è usata per mappare file o altre risorse presenti sul disco in memoria
 - in questo modo, lettura/scrittura dal/sul buffer risultano in lettura/scrittura sul disco, senza accedere al disco
 - restituisce l’indirizzo di partenza della regione mappata (buffer) se OK, `MAP_FAILED` se errore !
 
 argomenti:
 - `addrs` è l’indirizzo iniziale dell’area di memoria in cui vogliamo mappare il file. se `addr = 0`, sceglie il sistema
 - `fd` è il file descriptor (in quanto il file va aperto prim)
 - `len`è il numero di byte da trasferire
 - `off` indica l’offset nel file da cui iniziare a trasferire
 - `prot` indica il livello di protezione:

| `prot`       | description               |
| ------------ | ------------------------- |
| `PROT_READ`  | region can be read        |
| `PROT_WRITE` | region can be written     |
| `PROT_EXEC`  | region can be executed    |
| `PROT_NONE`  | region cannot be accessec |
-  i valori di `flag` possono essere:
	- `MAP_SHARED`: le operazioni sulla memoria modificano il file (R/W)
	- `MAP_PRIVATE`: viene creata una copia privata del mapped file e solo questa viene modificata
>[!tip] malloc()
`mmap()` è una syscall, e viene usata spesso da `malloc()` per grandi allocazioni

 >[!info] rappresentazione
 ![[Pasted image 20250511172930.png]]
 i file vengono mappati nella immagine del processo !


### $\verb|int msync (void *addr, size_t len, int flags)|$
permette di scrivere sul file le modifiche in memoria, e funziona solo se il flag passato a `mmap()` è `MAP_SHARED`
### $\verb|int munmap(void *addr, size_t len)|$
permette di *unmap*-are una regione di memoria precedentemente mappata con `mmap()`
- è l’equivalente di `free()` per la memoria mappata
## gestione file I/O
ricordiamo che:
- quando viene aperto un file mediante `open()`, viene creato un **file descriptor**
- le operazioni `write()` e `read()` su file operano mediante syscall
- è buona regola chiudere esplicitamente i file invocando `close()`
### file descriptor
un **file descriptor** è il riferimento ad un file aperto: è rappresentato da un intero piccolo, generato sequenzialmente dal valore 0. per default, ogni processo ha i associato i seguenti file descriptor:
- `0: stdin`
- `1: stdout`
- `2: stderr`
>[!info]- file descriptor
![[Pasted image 20250511175258.png]]

quando un file viene chiuso, il suo file descriptor viene liberato e può essere riutilizzato. (è quindi possibile aprire uno stesso file ed ottenere file descriptor diversi)

esistono dei flag associati ad ogni file descriptor:
- **file status flags**: associati allo stato di un file, e sono condivisi tra tutti i file descriptor che sono stati ottenuti per duplicazione da un unico file descriptor. si dividono in 3 categorie:
	- **modalità di accesso**: `read,write, read&write`, vengono specificati in `open()`, e non possono essere modificati una volta aperto il file
		- `O_RDONLY, O_WRONLY, O_RDWR`
	- **di apertura**: definiscono il comportamento di `open()` e non vengono mantenuti (quindi altri parametri di `open()`)
		- `O_CREAT`, `O_EXCL`(quando specificato insieme a `O_CREAT`, genera errore se il file esiste già)
	- **modalità operative**: definiscono il comportamento delle operazioni `read()` e `write()`. vengono sempre specificati in `open()`, e possono essere modificati anche dopo l’apertura del file
		- `O_APPEND`, `O_SYNC`(scrittura sincrona: la call ritorna solamente quando la scrittura dei dati nel file è terminata),  `O_TRUNC`(se il file esiste, e consente la scrittura, viene troncato dalla posizione 0)
- **file descriptor flags**: associati ai singoli file descriptor, descrivono proprietà e comportamento delle operazioni effettuate sul file
	- alcuni flag sono definiti solo per alcuni tipi di file speciali
>[!info] rappresentazione dei flag
i flag sono rappresentati mediante maschere di bit (es: `MACRO1 = 010000000`, `MACRO2=00010000`), e possono essere combinati mettendo in OR le maschere (es: `MACRO1 OR MACRO2 = 01010000` (`MACRO1` e `MACRO2` sono settati))
j

studiamo ora le syscall per la gestione dei file
### $\verb |int open(const char *pathname, int flags, mode_t)|$
restituisce `-1` se c’è stato un errore, altrimenti restituisce il file descriptor
- il parametro flags corrisponde ai file status flags (ed è equivalente al parametro `mode` di `fopen()
- `mode`indica le modalità di creazione del file (esiste una segnatura di `open()` senza questo parametro)

>[!info] differenza tra `open` e `fopen`
>- `fopen` restituisce un puntatore ad un FILE object, una struttura che contiene le informazioni richiesta dalle librerie I/O standard:
>	- il file descriptor
>	- un puntatore a un buffer (?) per lo stream
>	- la dimensione del buffer
>	- un conto del numero di caratteri attualmente presenti nel buffer
>	- una error flag
>	- etc
### $\verb|ssize_t read(int fd, void *buf, size_t count)|$
permette di leggere un file: restituisce `-1` se errore, altrimenti il numero di byte letti, che può essere < `count`se si raggiunge `EOF`
- `fd`: file descriptor
- `buf`: puntatore all’area di memoria in cui memorizzare i byte letti
- `count`: numero di byte da leggere
>[!info] differenza tra `read` e `fread`
>- `fread` legge da uno stream di tipo FILE, è bufferizzata e richiede la dimensione del tipo di dato da leggere. ritorna un FILE object
> - `read` non è bufferizzata e lavora sui byte indipendentemente dal tipo di dati in essi contenuto
### $\verb |ssize_t write (int fd, const void *buf, size_t count)|$
permette di scrivere un file: restituisce `-1` se errore, altrimenti il numero di byte scritti, che può essere < `count`se `write` viene interrotta (per esempio da un segnale (?))
- `fd`: file descriptor
- `buf`: puntatore all’area di memoria da cui leggere i byte (dichiarata `const` per non essere modificata dalla funzione)
- `count`: numero di byte da leggere
### $\verb |int close(int fd)|$
chiude il file descriptor `fd`: restituisce `-1` in caso di errore, altrimenti `0`
- nel caso venga chiuso l’ultimo file descriptor che fa riferimento ad un file rimosso, allora il file viene cancellato
## misc. syscall
### $\verb |int dup(int oldfd)|$
duplica il file descriptor (`oldfd`) e restituisce il valore del uovo `fd`
- restituisce `-1` in caso di errore
### $\verb |int fstat(int fd, struct stat *buf)|$
restituisce in `buf` le informazioni di stato del file specificato come `fd`
- ritorna `0` se termina correttamente, `-1` altrimenti
- esiste una versione che permette di specificare il file come path (`stat()`)
>[!info] definizione di `stat`
![[Pasted image 20250511185220.png]]
>etc..
>
>sono definite anche una serie di macro da utilizzare sulla struttura `stat`, per verificare il tipo del file (sono delle funzioni che ritornano `true/false`)
> - `S_ISREG(m), S_ISDIR(m), S_ISCHR(m), S_ISBLK(m), S_ISFIFO(m), S_ISLINK(m), S_ISSOCK(m)`
>
>sono 

### $\verb |int chmod(const char *pathname, mode_t mode)|$
cambia il **file mode** (quindi l’attributo `st_mode`)
- esiste una segnatura che permette di indicare il file come file descriptor (`fchmod()`)
`mode_t` è un numero ottale, ed esistono delle maschere predefinite, come:

| macro     | value   | meaning        |
| --------- | ------- | -------------- |
| `S_ISUID` | `04000` | set-user-id    |
| `S_ISGID` | `02000` | set-group-id   |
| `S_ISVTX` | `01000` | sticky bit     |
| `S_IRUSR` | `00400` | read by owner  |
| `S_IRGP`  | `00040` | read by group  |
| `S_IROTH` | `00004` | read by others |

### gestione directory
>[!info] gestione delle directory
$\verb |DIR *opendir(const char *name)|$
$\verb |struct dirent *readdir(DIR *dirp)|$
$\verb |int closedir(DIR *dirp)|$
queste funzioni di libereria permettono di aprire una directory il cui stream è ritornato da `opendir()`
>- in particolare `readdir` legge il contenuto della directory (**legge il prossimo elemento disponbile**)e ritorna la struttura `dirent` (o `NULL` se non ci sono più elementi)
![[Pasted image 20250511191014.png]]

### $\verb |int fcntl (int fd, int cmd, ...)|$
syscall molto versatile, che permette di effettuare operazioni sul file descriptor `fd`, ad esempio:
- duplicazione di `fd`
- manipolazione flag file descriptor di `fd`
- manipolazione di status flags di `fd`
il secondo argomento, `cmd`, specifica (attraverso costanti simboliche)un comando da fare sull’`fd`, mentre il terzo argomento è un argomento opzionale per `cmd` (notare che come terzo argomento si può passare anche il puntatore ad una struttura, come vedremo)
il valore di ritorno di `fcntl` dipende dall’operazione effettuata !
>[!into] flag di `fcntl`
sintassi: `COSTANTE_SIMBOLICA(terzo parametro expected)`
**manipolazione status flags**:
>- `F_GETFL(void)`: restituisce come risultato di `fcntl` file access mode e file status flag
>- `F_SETFL(int)`: imposta status flag, come `O_APPEND, O_ASYNC, O_DIRECT, O_NOATIME`, etc.
>
>**lock su file**:
>quando parliamo di lock, ci riferiamo al meccaniscmo che permette di controllare l’accesso a un file (o una sua regione), per prevenire race condition (e altre brutte cose) (proprio come in bd1)
> - `F_SETLK`: acquisisce/rilascia lock (se lock non ottenibile, fallisce)
> - `F_SETLKW`: acquisisce/rilascia lock, bloccante (se lock non ottenibile, aspetta finchè non diventa disponibile, e lo ottiene)
>- `F_GETLK`: testa esistenza lock
l’argomento di tutte queste costanti è lo struct `flock`
![[Pasted image 20250511193610.png]]
>
>-  `F_SETLK`: acquisice lock se `l_type = F_RDLCK or F_WRLCK`, lo rilasce se `l_type = F_UNLCK`, e restituisce `-1` se un altro processo ha il lock
>- `F_SETLKW`: come `F_SETLK` ma è bloccante se c’è già un lock sul file
>- `F_GETLK`: testa l’esistenza di un lock, e se il lock può essere messo, `fcntl` aggiorna `l_type` a `F_UNLCK` (viene quindi eseguita da `F_SETLK/LKW)
>
il locking è **adivisory**, cioè tutti i processi devono cooperare per rispettare i lock, in quanto il sistema non li impone automaticamente
>- tutti i processi fanno una `F_GETLK` o `F_SETLK/LKW` e osservano il risultato, in quanto cercare di scrivere un file sul quale un altro processo detiene un lock **NON** ha l’effetto di bloccare una scrittura !
### $\verb |int select(int nfds, fd_set *readfds, fd_set *writedfs, fd_set *exceptfds, struct timeval *timeout)|$
syscall che permette di monitorare uno o più file descriptor, rimanendo in attesa che almeno uno di essi sia disponibile per effettuare l’operazione richiesta
- l’utilizzo di `select` consente di sincronizzare dei processi, tramite il monitoraggio della disponibilità di accesso ad un file
argomenti: 
- `nfds`: numero **aumentato di uno** del file descriptor con il valore più alto tra quelli da monitorare
- `readfds`: insieme contenente i file descriptor per cui si richiede la lettura
- `writefds`: insieme contenente i file descriptor per cui si richiede la scrittura
- `exceptfds`: insieme contenente i file descriptor da controllare per eccezioni
- `timeout`: timeout di attesa. i valori possono essere:
	- $\infty$: la chiamata è bloccante (non termina finchè non è disponibile almeno un descrittore o si genera un’errore)
	- **intervallo definito**: la chiamata ritorna se è disponibile almeno un descrittore, oppure se è scaduto il timeout, oppure se si genera un errore
	- **zero**: la chiamata non è bloccante, ritorna subito dopo aver controllato i descrittori.
la funzione ritorna :
- il numero di file descriptor disponibili (non i loro identificatori !!!  un po inutile ngl idk )per l’operazione richiesta
- oppure ritorna `-1` in caso di errore
- oppure ritorna `0` se la chiamata termina per timeout prima che uno dei descrittori diventi disponibile
>[!warning] al termine dell’esecuzione, la funzione aggiorna le strutture dati contenenti i file descriptor da monitorare, per indicare quali di questi è disponibile per l’operazione richiesta

sono inoltre messe a disposizione 4 macro (funzioni) per la gestione degli insiemi di file descriptor (di tipo `fd_set`)

| macro        | descrizione                                                                             |
| ------------ | --------------------------------------------------------------------------------------- |
| `FD_ZERO()`  | svuota un insieme                                                                       |
| `FD_SET()`   | aggiunge un fle descriptor ad un insieme                                                |
| `FD_CLR()`   | rimuove un file descriptor da un insieme                                                |
| `FD_ISSET()` | testa se un file descriptor appartiene ad un insieme. utile quando `select` ritorna !!! |
