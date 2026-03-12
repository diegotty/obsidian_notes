---
created: 2024-10-05T21:59
updated: 2025-02-20T09:38
---
>[!index]-
>
>- [processo](#processo)
>	- [elementi di un processo](#elementi%20di%20un%20processo)
>	- [process control block](#process%20control%20block)
>		- [identificazione](#identificazione)
>		- [stato](#stato)
>		- [controllo](#controllo)
>	- [process image](#process%20image)
>- [dispatcher](#dispatcher)
>- [fasi di un processo](#fasi%20di%20un%20processo)
>	- [creazione](#creazione)
>	- [terminazione](#terminazione)
>	- [blocked](#blocked)
>	- [suspended](#suspended)
>		- [motivi per sospendere un processo](#motivi%20per%20sospendere%20un%20processo)
>- [creazione di processi](#creazione%20di%20processi)
>- [switching tra processi](#switching%20tra%20processi)
>	- [quando effettuare uno switch](#quando%20effettuare%20uno%20switch)
>	- [passaggi](#passaggi)
>- [SO come processo](#SO%20come%20processo)
>	- [gestione del SO senza processi](#gestione%20del%20SO%20senza%20processi)
>	- [esecuzione dell’SO all’interno dei processi utente](#esecuzione%20dell%E2%80%99SO%20all%E2%80%99interno%20dei%20processi%20utente)
>	- [gestione del SO basata sui processi](#gestione%20del%20SO%20basata%20sui%20processi)
>		- [come Linux gestisce il SO](#come%20Linux%20gestisce%20il%20SO)
>		- [esempio Unix SVR4 System V Release 4](#esempio%20Unix%20SVR4%20System%20V%20Release%204)
>	- [processi UNIX](#processi%20UNIX)

il sistema operativo deve gestire le diverse computazioni che si vuole eseguire su un sistema computerizzato, in particolare:
- permettere l’esecuzione alternata di processi multipli (interleaving), avendo più processi di processori
- assegnare risorse ai processi
- permettere lo scambio di informazioni tra processi
- permettere la sincronizzazione tra processi
# processo
un processo è un’istanza di un programma in esecuzione(un programma può avere più processi)
ha le seguenti caratteristiche:
- una sequenza di istruzioni da eseguire(codice), di solito memorizzati su archiviazione di massa(mentre i processi creati dal sistema operativo di solito sono già caricati)
- uno stato corrente
- un insieme associato di risorse(dati)
## elementi di un processo
- identificatore
- stato (running, …)
- priorità
- l’attuale situazione di tutti i registri della CPU (hardware context)
- puntatori alla memoria principale
- informazioni sullo stato dell’I/O usato
- informazioni di accounting (quale utente lo esegue)
## process control block
 contiene gli elementi del processo, ed è stored nella zona di spazio riservata al kernel (altrimenti tutti i programmi potrebbero gestire i processi)
- è creato e gestito dal SO, e gli permette di gestire più processi contemporaneamente
- contiene sufficienti info per poter bloccare/far riprendere un programma
- le sue informazioni possono essere raggruppate in 3 categorie: 
### identificazione
- PID(numero identificativo e unico assegnato ad ogni processo)
- Parent PID (PID del processo padre)
- identificatore dell’utente proprietario
### stato
informazioni sullo stato del processore(hardware context):
- registi utente(quelli accessibili in assembly)
- PC
- stack pointer
- registri di stato(flags)
- PSW
### controllo
- stato del processo
- priorità
- informazioni sullo scheduling
- l’evento da attendere per tornare ad essere ready, se attualmente in attesa
## process image
l’insieme di:
- programma sorgente
- dati
- stack delle chiamate
- PCB (solo il PCB si trova nel kernel !!)
>[!figure] ![[Pasted image 20241005221533.png]]
i dati che non si trovano nel PCB si trovano nella memoria virtuale
# dispatcher
il dispatcher è un piccolo programma che decide quando sospendere un processo per farne andare un altro in esecuzione
- è sempre in memoria, e fa parte del sistema operativo


>[!figure] ![[Pasted image 20241004115509.png]]
>gestione, da parte del dispatcher, dei processi


# fasi di un processo
## creazione
in un certo istante, in un sistema operativo ci sono n ≥ 1 processi(c’è sempre un processo master, che non può essere ucciso (se non spegnendo il computer))
i processi vengono spawnati attraverso il **process spawning**
- un processo(processo padre) crea un altro processo(processo figlio)
- si passa quindi da n a n+1 processi
## terminazione
un processo può terminare in 2 modi: 
- normale completamento(grazie a un’istruzione macchina, che genera un’interruzione per il SO)
- uccisioni (dal SO, dall’utente, o da un altro processo)
## blocked
lo stato di un processo quando sta aspettando un evento (es: ha fatto una richiesta all’I/O module, che è molto più lento) e quindi non è pronto per essere eseguito dal processore. il dispatcher non sceglie tra gli eventi blocked, che vengono accodati in una coda separata e vengono riamessi alla coda di eventi ready solo quando l’evento che stavano aspettando occorre(quindi, viene chiamata un’interruzione in cui il module comunica la fine dell’evento)
## suspended
può capitare che molti eventi siano blocked (aspettando I/O)dato che il processore è molto più veloce. tutti questi processi, caricati nella memoria primaria, stanno quindi occupando spazio prezioso nella RAM (supponiamo di avere molti processi) senza poter neanche essere eseguiti.
Lo stato blocked diventa suspeded quando il processo, per liberare memoria e non lasciare il processore inoperoso, viene swappato su disco
ci sono due tipi di suspend (due stati nel ciclo):
- blocked/suspend (swappato mentre era bloccato)
- ready/blocked (swappato mentre non era bloccato(era ready, running, blocked/suspended o addirittura new))

>[!figure] ![[Pasted image 20241004122152.png]]
### motivi per sospendere un processo

| motivo                       | commento                                                                                                                      |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| swapping                     | SO ha bisogno di rilasciare abbastanza memoria per portarci dentro un processo ready(motivo per sospendere un processo ready) |
| interno al SO                | SO sospetta che il processo stia causando problemi                                                                            |
| richiesta utente interattiva | debugging                                                                                                                     |
| periodicità                  | il processo viene eseguito periodicamente, e può venire sospeso in attesa della prossima esecuzione                           |
| richiesta del padre          | il padre vuole sospendere l’esecuzione di un figlio per esaminarlo o modificarlo, o per coordinare l’attività tra più figli   |
# creazione di processi
 per creare un processo, il SO deve:
 - assegnargli un PID unico
 - allocargli spazio in memoria principale
 - inizializzare il PCB
 - inserire il processo nella coda giusta (ready, ready/suspended)
 - creare o modificare altre strutture dati (es: quelle per l’accounting)
# switching tra processi
2 tipi di switch:
- switch di modalità
- switch tra processi
il SO deve tenere aggiornate tutte le strutture dati(es: tutte le code nel ciclo di esecuzione), in seguito ad uno switch tra processi !
## quando effettuare uno switch
## passaggi
tutti i passaggi avvengono in kernel mode:
- si salva il contesto del programma(registri e PC)
- si aggiorna il PCB, che è attualmente in running e spostarlo nella coda appropriata: read, blocked o ready/suspend(se il ciclo di esecuzione lo permette)
- si sceglie un altro processo da eseguire
- si aggiorna il PCB del nuovo processo
- si aggiornano le strutture dati per la gestione della memoria
- si ripristina il contesto del nuovo processo (tutti i registri della CPU, in modo che lo switch sia seamless per il processo)
# SO come processo
il SO è solo un insieme di programmi, ed è eseguito dal procesore come altro ogni programma, e molto spesso lascia che altri programmi vadano in esecuzione, per poi riprendere il controllo tramite interrupt
- è quindi lui stesso un processo?
## gestione del SO senza processi
- il Kernel è eseguito al di fuori dei processi, infatti il concetto di processo si applica solo ai programmi utente.
- il SO è quindi eseguito come un’entità separata, con privilegi più elevati, una sua zona di memoria dedicata sia per i dati che per il codice sorgente che per lo stack
>[!figure] ![[Pasted image 20241006130751.png]]
## esecuzione del SO all’interno dei processi utente
- il SO viene eseguito nel contesto di un processo utente: il SO non è pensato come una entità separata o dei processi a se stanti, bensì viene eseguito dai processi utente (cambiando la modalità di esecuzione)
- in questo modo, non c’è bisogno di un process switch per eseguire una funzione del SO, in quando viene utilizzato il processo running
- lo stack delle chiamate rimane separato: esiste lo user stack e il kernel stack, mentre i dati e il codice macchina vengono condivisi con i processi
>[!figure] ![[Pasted image 20241006131327.png]]

## gestione del SO basata sui processi
- il SO viene implementato come una serie di processi di sistema, con privilegi più alti, che quindi partecipano alla competizione per il processore, insieme ai processi utente
quindi, se un proceso effettua una syscall, viene creato un nuovo processo di sistema che la gestisce
- l’unica cosa che non è un processo è il meccanismo che gestisce lo switching tra i processi
 >[!figure] ![[Pasted image 20241006131622.png]]
 
### come Linux gestisce il SO 
le funzioni del kernel sono per lo più eseguite tramite interrupt, quindi on behalf of il processo corrente, ci sono però anche dei processi di sistema che partecipano alla normale competizione del processore, senza essere stati invocati esplicitamente ( sono infatti creati in fase di inizializzazione). i processi di sistema spesso svolgono funzioni periodiche per cui sono blocked o suspended per la maggior parte del tempo

### esempio Unix SVR4 System V Release 4
>[!figure] ![[Pasted image 20241006132024.png]]

alcune differenze dal ciclo a 7 fasi visto in precedenza:
- preempted: il kernel ha appena tolto l’uso del processore a questo processo, per fare un context switch
- zombie: quando un processo viene terminato, il suo PCB rimane nella tabella dei processi, per comunicare al processo padre della sua morte
## processi UNIX
boring …….