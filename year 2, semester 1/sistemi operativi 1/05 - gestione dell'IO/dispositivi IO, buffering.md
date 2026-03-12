---
created: 2024-11-21T14:24
updated: 2025-02-20T09:38
---
>[!index]
>
>- [categorie di dispositivi di IO](#categorie%20di%20dispositivi%20di%20IO)
>- [funzionamento dei dispositivi I/O](#funzionamento%20dei%20dispositivi%20I/O)
>- [input](#input)
>- [output](#output)
>- [differenze tra dispositivi IO](#differenze%20tra%20dispositivi%20IO)
>	- [data rate](#data%20rate)
>	- [applicazioni](#applicazioni)
>	- [complessità del controllo](#complessit%C3%A0%20del%20controllo)
>	- [unità di trasferimento dati](#unit%C3%A0%20di%20trasferimento%20dati)
>	- [rappresentazione dei dati](#rappresentazione%20dei%20dati)
>	- [condizioni d’errore](#condizioni%20d%E2%80%99errore)
>- [DMA](#DMA)
>- [evoluzione della funzione di I/O](#evoluzione%20della%20funzione%20di%20I/O)
>- [obiettivi nel progetto del SO](#obiettivi%20nel%20progetto%20del%20SO)
>- [efficienza](#efficienza)
>- [generalità](#generalit%C3%A0)
>- [progettazione gerarchica](#progettazione%20gerarchica)
>- [buffering dell’I/O](#buffering%20dell%E2%80%99I/O)
>- [buffer singolo](#buffer%20singolo)
>	- [buffer singolo orientato a blocchi](#buffer%20singolo%20orientato%20a%20blocchi)
>	- [buffer singolo orientato a stream](#buffer%20singolo%20orientato%20a%20stream)
>- [buffer circolare](#buffer%20circolare)
>- [pro e contro](#pro%20e%20contro)
>- [buffer zero copy](#buffer%20zero%20copy)

la gestione dell’IO è problematica per la progettazzione di SO, in quanto:
- c’è una grande varietà di dispositivi di IO
- c’è una grande varietà di applicazioni che li usano
- hanno poche caratteristiche comuni, e dobbiamo tenere conto di tali diversità, e gestire l’IO nel modo più unificato possibile
## categorie di dispositivi di IO
**leggibili dall’utente**:
- dispositivi usati per la comunicazione diretta con l’utente: stampanti, terminali (monitor, tastiera, mouse), joystick, etc.
**leggibili dalla macchina**
- dispositivi usati per la comunicazione con materiale elettronico: dischi, chiave USB, sensori, controllori, etc
**per la comunicazione**:
- dispositivi usati per la comunicazione con dispositivi remoti: modem, schede Ethernet, Wi-FI
# funzionamento dei dispositivi I/O
## input
un dispositivo di input prevede di essere interrogato sul valore di una certa grandezza fisica al suo interno
- tastiera: codice unicode degli ultimi tasti premuti
- mouse: cordinate dell’ultimo spostamento effettuato, quali tasti sono stati premuti
- disco: valore dei bit che si trovano in una certa posizione al suo interno
quando un processo effettua una syscall `read` su un dispositivo, vuole conoscere tale dato per poterlo elaborare
## output
un dispositivo di output prevede di poter cambiare il valore di una certa grandezza fisica al suo interno
- monitor moderno: valore RGB di tutti i suoi pixel
- stampante moderna: PDF di un file da stampare
- disco: valore dei bit che devono sovrascrivere quelli che si trovano in una certa posizione al suo interno
un processo che effettua una syscall `write` su un dispositivo di output vuole cambiare qualcosa

ci sono quindi, minimalmente, due syscall `read` e `write`, e tra i loro argomenti c’è un indentificato del dispositivo a cui ci si riferisce
- quando viene effettuata una delle due syscall, entra in gioco il kernel(avviene quindi un mode switch), che comanda l’inizializzazione del trasferimento di informazioni, mette il processo in `BLOCKED` e passa ad altro

>[!info] la parte del kernel che gestisce un particolare dispositivo di IO si chiama driver

spesso il trasferimento si fa con [[ciclo di esecuzione e interruzioni#accessso diretto in memoria|DMA]]
a trasferimento completato, arriva l’interrupt, si termina l’operaione e il processo torna ready
- ci possono essere problemi! (bad block su disco, etc)
# differenze tra dispositivi IO
i dispositivi IO possono differire sotto molti aspetti:
### data rate
>[!figure] ![[Pasted image 20241115072954.png]]
>come si può vedere, ci possono essere differenze anche elevate sulla velocità dei dispositivi
### applicazioni
- i dischi sono usati per memorizzare files, e richiedono un software(applicazione) per la gestione dei files
- ma i dischi sono usati anche per la memoria virtuale, per la quale serve altro software apposito
- un terminale (tastiera, mouse, etc) usato da un amministratore di sitema dovrebbe avere una priorità più alta
### complessità del controllo
- tastiera o mouse richiedono un controllo molto semplice, mentre una stampante è più complicata, e il disco è tra le cose più complicate da controllare
fortunatamente, non si fa tutto con il software, e molte cose vengono controllate da un hardware dedicato
- i dispositivi I/O(moderni ?) hanno un controller, un chip che permette di effettuare le operazioni necessarie
### unità di trasferimento dati
i dati possono essere trasferiti:
- in blocchi di byte di lunghezza fissa
- come un flusso di byte
### rappresentazione dei dati
i dati sono rappresntati secondo codifiche diverse in dispositivi diversi
- una vecchia tastiera magari li rappresenta in ASCII puro, ma una moderna li rappresenta in UNICODE
little-endian, big-endian
### condizioni d’errore
la natura degli errori varia di molto da dispositivo a dispositivo
- nel modo in cui gli errori vengono notificati
- sulle loro conseguenze (fataili/ignorabili)
- su come possono essere gestiti

# DMA 
il DMA (**direct memory access**) permete di effettuare IO:
- direttamente in memoria (senza passare per la CPU)
- con interruzioni
ed è la soluzione usata da tutti i sistemi moderni
il suo funzionamento è il seguente: 
\\TODO
DMa non ci fa perdere tempo perchè una volta dato il comando fa tutto in automatico e ci fa sapere quando ha finito (DMA dispositivo hardware, un chip solo per le operazioni specifiche per trasferimento dati I/O)
## evoluzione della funzione di I/O
ultime evoluzioni della funzione di I/O sono:
5. DMA: blocchi di dati viaggiano tra dispositivo e memoria, senza usare il procesore ( il processore fa qualosa solo all’inizio e alla fine di un’operazione di IO)
6. I/O channel: il modulo di IO diventa un processore separato, a cui il processore (CPU) manda comandi per eseguire certi programmi di I/O in memoria principale (esempio:la stampante, a cui noi diamo il PDF e poi il resto della traduzione viene fatta dal processo interno ad essa)
7. I/O processor: il processore di 6. ha una sua memoria dedicata (come cache, quindi fa operazioni senza dover usare la RAM). x esempio la VRAM !!
>[!info] il chipset
> il chipset è una collezione di componenti elettroniche (un insieme di circuiti nella scheda madre), che va a implementare le connessioni con i diversi dispositivi I/O, porte SATA, etc…
>il suo ruolo è quindi gestire i dispositivi e comunicare informazioni alla CPU. 
>![[Pasted image 20241116131705.png]]

# obiettivi nel progetto del SO
## efficienza
i vari dispositivi di I/O sono molto più lenti della memoria principale. usiamo la multiprogrammazione per eseguire processi mentre altri sono in attesa del completamento di un’operazione di I/O
però si potrebbe arrivare comunque al punto in cui tutti i processi caricati in RAM sono in attesa del completamento di un’operazione di I/O, e sarebbe quindi necessario swapparne alcuni per avere dei processi ready da eseguire. però anche lo swap è un’operazione di I/O ! ci potrebbe quindi essere bottleneck se ci sono tante operazioni di I/O richieste
## generalità
per semplicità ed evitare errori, sarebbe bene gestire i dispositivi di I/O in modo più uniforme possibile, pur nella loro diversità.
si possono fornire funzionalità generali come read, write, unlock, lock, open, close, e nascondere la maggior parte dei dettagli dei dispositivi I/O nelle procedure a basso livello (non usate dai programmatori)
# progettazione gerarchica 
per gestire la necessità di generalità, si usa la progettazione gerarchica: un insieme di livelli, in cui ogni livello si basa sul fatto che il livello sottostante sa effettuare operazioni più primitive (ogni livello fornisce servizi al livello superiore, e in livelli diversi vengono implementate funzionalità diverse)
- ogni livello contiene funzionalità simili per complessità, tempi di esecuzione e livello di astrazione
- modificare l’implementazione di un livello non dovrebbe avere effetti sugli altri livelli
per l’I/O, esistono 3 macrotipi di gerarchie:
>[!info] dispositivi locali
>![[Pasted image 20241116134531.png|80]]
>- logical I/O: il dispositivo viene visto come una risorsa logica (open, close, read…)
>- device I/O: trasforma richieste logiche in sequenze di comandi I/O
>- scheduling and control: esegue e controlla le sequenze di comandi, eventualmente gestendo anche l’accodamento

>[!info] dispositivi di comunicazione
>![[Pasted image 20241116134646.png|80]]
simile alla gerarchia per i dispositivi locali, ma al posto di logical I/O c’è una architettura di comunicazione (es TCP/IP)

>[!info] file system
>![[Pasted image 20241116134711.png|80]]
usato da dispositivi come disco HDD, SDD, CD, DVD, USB key, etc..
>- directory management: da nomi di file agli identificatori di file, gestisce implementa tutte le operazioni utente che hanno a che fare con i file (crearli, cancellarli, spostarli, …)
>- file system: struttura logica ed operazioni (apri, chiudi, leggi, scrivi, …)
>- organizzazione fisica: si occupa della gestione fisica

# buffering dell’I/O
nell’attesa del completamento di un’operazione I/O, alcune pagine hanno bisogno di rimanere in memoria, infatti: 
- il DMA scrive direttamente in memoria principale, e se il processo a cui il DMA deve mandare informazioni non è in memoria principale, la richiesta non può essere portata a termine
- però, per essere riportato in memoria, la richiesta I/O dovrebbe essere completata 
si crea qundi una situazione di deadlock
- ciò è risolvibile con il [[decisioni sulla gestione della memoria#frame locking|frame locking]], ma facendo ciò (e facendolo in modo pesante), si limita il numero di pagine swappabili, e le prestazioni del SO potrebbero decrescere

inoltre, come abbiamo visto, diversi dispositivi di I/O hanno velocità diverese, e ogni dispositivo è ottimizzato per operazioni di certe dimensioni, in base al loro tipo (trasferimento tra dispositivi I/O con dimensione di blocchi diverse)

si usa quindi il **buffering** come soluzione: uso una zona di memoria principale, in modo temporaneo, per effettuare trasferimenti di input in anticipo e di output in ritardo rispetto alle richieste

può essere statica o dinamica ! in Linux è dinamica
>[!figure] senza buffer
![[Pasted image 20241117164627.png]]
il SO accede al dispositivo di I/O quando ne ha necessità

## buffer singolo
>[!info] buffer singolo
![[Pasted image 20241117164709.png]]
il SO crea un buffer in memoria principale (kernel space) per una data richiesta di I/O.
>- lettura e scrittura nel buffer sono separate e sequenziali
### buffer singolo orientato a blocchi
- il blocco viene mandato nello spazio utente quando necessario
- inoltre, viene mandato anche il blocco successivo (**read ahead**), per il principio di località
- l’output invece, viene posticipato (viene “accumulato” nel buffer e mandato al dispositivo I/O in un solo momento)
### buffer singolo orientato a stream
- usato, per esempio, per i terminali, che hanno a che fare con linee (caratteri più invio)
- si bufferizza una linea di input o output, o un byte alla volta per i device in cui un singolo carattere premuto va gestito
## buffer circolare
>[!info] buffer circolare
>![[Pasted image 20241117165920.png]]
>- 2 o più buffer
>- un processo può trasferire dati da opppure a uno dei buffer, mentre il SO svuota o riempie gli altri
>- ciascun buffer è un’unità nel buffer circolare
>- viene usato quando l’operazione di I/O deve tenere il passo del processo
>- c’è un puntatore che viene mosso type beat
## pro e contro
**pro**:
- smussa i picchi di richieste di I/O (finchè i buffer non si riempiono)
- utile quando ci sono molti e diversi dispositivi di I/O da servire: migliora l’efficienza dei processi e del SO
**contro**:
-  introduce overhead a causa della copia intermedia in kernel memory
>[!figure] flow di un buffer
![[Pasted image 20241117170627.png]]
si nota il trasferimento in più nel kernel space
## buffer zero copy
il buffer zero copy evita inutili copie intermedie, evitando di trasferire i dati nello user space e trasferendoli direttamente da un kernel buffer ad un altro (come fa a funzionare questa cosa bro \\QUESTION)
