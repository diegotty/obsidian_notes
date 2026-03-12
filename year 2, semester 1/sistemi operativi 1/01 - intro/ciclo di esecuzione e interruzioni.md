---
created: 2024-09-30T22:18
updated: 2025-02-20T09:38
---
>[!index]
>
>- [tipi di istruzioni](#tipi%20di%20istruzioni)
>- [ciclo a due passi](#ciclo%20a%20due%20passi)
>- [interruzioni](#interruzioni)
>- [interruzioni sincrone](#interruzioni%20sincrone)
>- [interruzioni asincrone](#interruzioni%20asincrone)
>- [istruzioni di ritorno](#istruzioni%20di%20ritorno)
>- [ciclo con controllo per interruzioni](#ciclo%20con%20controllo%20per%20interruzioni)
>- [interrupt handler](#interrupt%20handler)
>- [ciclo con disabilitazione delle interruzioni](#ciclo%20con%20disabilitazione%20delle%20interruzioni)
>- [gestione i/o](#gestione%20i/o)
>	- [i/o programmato](#i/o%20programmato)
>	- [i/o da interruzioni](#i/o%20da%20interruzioni)
>	- [accessso diretto in memoria](#accessso%20diretto%20in%20memoria)
>- [system calls](#system%20calls)
>- [segnali](#segnali)
>- [gestione dei segnali](#gestione%20dei%20segnali)
>- [signal handler](#signal%20handler)

andiamo ad analizzare il ciclo di esecuzione, aggiungendo a mano a mano complessita’
### tipi di istruzioni
- scambio dati tra processore e memoria
- scambio dati tra processore e disp. i/o
- manipolazione di dati 
- controllo (modifica del PC tramite salti condizionati e non)
- operazioni riservate (abilitazione interrupt, abilitazione cache, abilitazione paginazione)
## ciclo a due passi
1. processore legge istruzione dalla memoria principale(fetch) e la carica nell’IR
2. il processore esegue l’istruzione prelevata
3. back to 1.
>[!example] esempio di esecuzione di un programma
>![[Pasted image 20241006105819.png]]
>il MSB dell’IR indica l’operazione da fare:
>- 0001: Load AC from memory
>- 0010: store AC to memory
>- 0101: add to AC from memory
# interruzioni
- paradigma dell’interazione hardware/software, interrompono la normale esecuzione sequenziale del processore, che consegue nell’esecuzione del software “di sistema”(parte del sistema operativo), che tipicamente non e’ stato scritto dall’utente che sta eseguendo un certo programma
cause:
- da programma(le uniche sincrone)
- da I/O
- da fallimento hardware
- da timer
## interruzioni sincrone
- hanno luogo come immediata conseguenza di una certa istruzione, al contrario delle interruzioni asincrone che (tipicamente)vengono sollevate molto dopo l’istruzione che le ha causate(se sono state causate da un istruzione to begin with)
le interruzioni di programma possono avere molte cause:
- overflow
- divisione per 0
- debugging
- syscall
- etc…
## interruzioni asincrone
- interruzioni da i/o → generate dal controllore di un dispositivo di i/o, che sono piu’ lenti del processore. quindi il processore manda un comando al dispositivo i/o e poi aspetta che il dispositivo lo “interrompa” quando e’ risucito a completare la richiesta. le interruzioni da i/o segnalano quindi il completamento o l’errore di una operazione i/o
- interruzioni da fallimento hw → cause come: improvvisa mancanza di potenza, errore di parita’ nella memoria
- interruzioni da comunicazione tra CPU → per sistemi con piu’ CPU
- interruzioni da timer → generate da un timer interno al processore

## istruzioni di ritorno
una volta finita l’interruzione, possono accadere diverse cose:
- se l’interruzione era asincrona, se la computazione non e’ stata completamente abortita come conseguenza dell’interruzione, si riprende dall’istruzione subito successiva a quella dove si e’ verificata l’interruzione
- se l’istruzione e’ sincrona, si possono avere:
	- faults(errori corregibili)→ viene rieseguita la stessa istruzione
	- aborts(errori non corregibili)→ si esegue il software collegato con l’errore
	- traps e syscalls → si continua dall’istruzione successiva

## ciclo con controllo per interruzioni
aggiungendo al primo ciclo, dopo ogni fetch-execute, viene controllato se c’e’ stata un’interruzione: se e; cosi, il programma viene sospeso e viene eseguita una funzione che gestisce l’interruzione: una **interrupt-handler routine**
>[!figure] ![[Pasted image 20241006110145.png]]
# interrupt handler
quando viene chiamato l’interrupt handler, il SO e hardware collaborano per salvare le informazioni (almeno PSW e PC) e settare il PC
>[!figure] ![[Pasted image 20241006110323.png]]
![[Pasted image 20241006110359.png]]
### ciclo con disabilitazione delle interruzioni
>[!figure] ![[Pasted image 20241006110508.png]]
## gestione i/o
con l’uso delle interruzioni si puo’ cambiare il modo in cui si gestiscono le chiamate all’i/o module.
#### i/o programmato
una volta mandata la richiesta di lettura/scrittura all’ i/o module, la cpu si ferma e legge lo stato del’i/o module finche esso non e’ pronto a scambiare dati. una volta pronto, viene effettuata l’operazione e la cpu torna a eseguire istruzioni.
in questo modo, non vengono chiamate interruzioni.
#### i/o da interruzioni
una volta mandata la richiesta di lettura/scrittura, il processore torna a fare altre cose, e viene interrotto quando il modulo i/o e’ pronto a scambiare dati. il processore salva quindi il contesto del programma che stava eseguendo e comincia ad eseguire il gestore dell’interruzione.
in questo modo, non c’e’ inutile attesa, ma viene consumato molto tempo di processore, che per ogni dato letto o scritto interrompe l’esecuzione del programma che stava eseguendo
#### accessso diretto in memoria
 è il metodo di I/O usato nei computer attuali: dato che le istruzioni di I/O tipicamente richiedono di trasferire informazioni tra dispositivo di I/O e memoria, si usa un dispositivo (DMA) un controller che gestisce il trasferimento diretto dei dati dalla memoria alla RAM
 è il metodo più efficiente
>[!figure] ![[Pasted image 20241006110627.png]]
rappresentazione grafica dei vari modi di gestire le chiamate all’i/o

## system calls
le system calls(già viste in archiettura degli elaboratori) sono interrupt “speciali”, che possono essere chiamati da un programma. 
- per esempio, il creare un nuovo processo è una syscall: fork (in Linux). dato che deve modificare la lista dei PCB, l’handler d questa syscall verà eseguito in modalità kernel
//TODO add info 
# segnali 
a differenza degli interrupt, i segnali:
- possono essere inviati da un processo ad un altro, tramite system call `kill` (misleading, non uccide il processo che la riceve(anche se nel 95% dei segnali mandati poi il processo viene ucciso))
>[!example] i segnali possono essere inviati da un processo in modalità sistema
![[Pasted image 20241015093214.png]]
## gestione dei segnali
quando un segnale viene lanciato, esso viene aggiunto all’opportuno campo del PCB del processo ricevente. quando il processo viene nuovamente schedulato per l’esecuzione, il kernel controlla prima se ci sono segnali pendenti, e se sì, esegue una opportuan funzione chiamata **signal handler**
## signal handler
i signal handler vengono eseguiti in user mode, e possono essere sovrascritti dal programmatore per gestire cosa deve accadere quando viene ricevuto un segnale
- esistono solo 2 signal handler non sovrascrivibili (SIGKILL, SIGSTOP)