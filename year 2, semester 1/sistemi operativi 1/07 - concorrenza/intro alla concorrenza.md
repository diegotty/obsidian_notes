---
created: 2024-11-25
related to: "[[intro allo scheduling]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [terminologia](#terminologia)
>- [difficoltà della concorrenza](#difficolt%C3%A0%20della%20concorrenza)
>	- [esempio facile](#esempio%20facile)
>- [restrizione all’accesso singolo](#restrizione%20all%E2%80%99accesso%20singolo)
>- [race condition](#race%20condition)
>- [tipi di interazione tra processi](#tipi%20di%20interazione%20tra%20processi)
>- [processi in competizione](#processi%20in%20competizione)
>- [requisiti per utilizzare la mutua esclusione](#requisiti%20per%20utilizzare%20la%20mutua%20esclusione)
>- [4 dummies](#4%20dummies)
>- [disabilitazione delle interruzioni](#disabilitazione%20delle%20interruzioni)

per i SO moderni è essenziale supportare più processi in esecuzione che sia:
- multipogrammazione(un solo processore)
>[!figure] 
![[Pasted image 20241125104126.png]]
quando c’è un solo processore, i processi si alternano nel suo uso (**interleaving***)
- multiprocessamento (+ processori)
>[!figure]
![[Pasted image 20241125104237.png]] 
i processi si alternano nell’uso di un processore(**interleaving**), e possono sovrapporsi nell’uso dei vari processori
- computazione distribuita (cluster, più computatori)

un grosso problema da affrontare è la **concorrenza**, ovvero gestire il modo in cui i processi interagiscono

la concorrenza si manifesta nelle seguenzi occasioni:
- applicazioni multiple (bisogna condividere il tempo di calcolo)
- applicazioni strutturate per essere parallele
- struttura del sistema operativo (quando sli stessi SO sono costituiti da svariati processi o thread in esecuzione (es: in Linux ci sono i kernel thread))
## terminologia 
-  **operazione atomica**: una sequenza indivisibile di comandi (il dispatcher non può togliere il processore ad un processo se esso sta eseguendo una operazione atomica). inoltre nessun altro processo può vedere uno stato intermedio della sequenza (o interrompere, appunto, la sequenza)
 - **sezione critica**: parte del codice di un processo in cui c’è un accesso **esclusivo** ad una risorsa (nessun altro processo che voglia accedere in modo esclusivo alla stessa risorsa può farlo)
- **mutua esclusione**: requisito che impone che un solo processo sia un una data sezione critica (per risorsa condivisa). cioè quando due processi richiedono di accedere ad una stessa risorsa in comune, che però è fatta in modo tale che solo un processo alla volta possa accedere ad essa. in questa situazione, i processi si escludono mutualmente: se un processo accede a tale risorsa, esclude l’altro dall’utilizzo dal fare lo stesso
- **race condition**(corsa critica): violazione della mutua esclusione ( più di un processo riesce ad accedere alla stessa sezione critica)

- **deadlock(stallo)**: situazione in cui due o più processi non possono procedere con la prossima istruzione, perchè ciascuno attende l’altro
- **livelock(stallo attivo)**: situazione in cui due o più processi cambiano continuamente il proprio stato, l’uno in risposta dell’altro, senza fare alcunchè di “utile” (quindi sempre in stallo)
- **starvation(morte per fame)**: quando un processo, pur essendo ready, non viene mai scelto dallo scheduler
## difficoltà della concorrenza
- **LA** difficoltà della concorrenza è che non si può fare nessuna assunzione sul comportamento dei processi, e neanche su come funzionerà lo scheduler (però devo avere una soluzione che funziona per tutti i casi)
- un’altro grande problema è la condivisione di risorse (es: una stampante, o anche semplicemente 2 thread the accedono alla stessa variabile globale)
- bisogna anche gestire l’allocazione delle risorse condivise:
	- ad esempio, un processo potrebbe richiedere un dispositivo I/O e poi essere rimesso in `ready` prima di poterlo usare. quel dispositivo I/O va considerato `locked` oppure no ?
- spesso il manifestarsi di un errore dipende dallo scheduler e dagli altri processi presenti, quindi rilanciare l’ultimo processo spesso **non** riproduce lo stesso errore
### esempio facile
```c
/* chin e chout sono variabili globali */
void echo(){
	chin = getchar();
	chout = chin;
	putchar(chout);
}
//questo codice prende un carattere in input e lo stampa sullo schermo (esempio)
```

>[!example] esempio su un processore
se il codice venisse eseguito da 2 processi su un solo processore, lo scheduler protrebbe decidere di assegnare il processore in questo modo:
![[Pasted image 20241125111107.png]]
in questo caso, il carattere preso in input dal processo P1 viene perso, in quanto chin è globale e viene sovrascritta prima che P1 possa salvarla (e stamparla)

>[!example] esempio su più processori
![[Pasted image 20241208125616.png]]
>come si può notare, il problema potrebbe non risolversi anche se si usano 2 processori

## restrizione all’accesso singolo
si fa in modo che la funzione `echo()` diventi atomica, cioè: 
- dentro la funzione ci può entrare solo un processo alla volta. una volta che ci entra P1, a P2 viene negata l’entrata finche P1 non finisce. a quel punto, P2 viene riesumato e può essere completato
in questo modo non ci sono più comportamenti indesiderati, ma ci vuole un modo per gestire l’atomicità della funzione

## race condition
si ha una race condition quando:
- più processi o thread leggono e scrivono su una stessa risorsa condivisa, e lo fanno in modo tale che lo stato finale della risorsa dipende dall’ordine di esecuzione dei detti processi e thread
	- in particolare, il risultato può dipendere dal processo o thread che finisce per ultimo
**sezione critica** è la parte del codice di un processo che può portare ad una corsa critica

il SO deve quindi assicurare che processi ed output siano indipendenti dalla velocità di computazione (ovvero da che scheduling accade)

# tipi di interazione tra processi

| comunicazione                                                                       | relazione    | influenza                                                                                                                                   | problemi di controllo                                     |
| ----------------------------------------------------------------------------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| nessuna (ogni processo pensa di essere solo)                                        | competizione | risultato di un processo è indipendente dagli altri, tempo di esecuzione di un processo è dipendente dagli altri                            | mutua esclusione, deadlock, starvation                    |
| memoria condivisa (i processi sanno che c’è qualche altro processo)                 | cooperazione | risultato di un processo è dipendente dall’informazione data da altri processi, tempo di esecuzione di un processo è dipendente dagli altri | mutua esclusione, deadlock, starvation, coerenza dei dati |
| primitive di comunicazione ( i processi sanno anche i PID di alcuni altri processi) | cooperazione | risultato di un processo è dipendente dall’informazione data da altri, tempo di esecuzione di un processo è dipendente dagli altri          | deadlock, starvation                                      |
primitive di comunicazione: i processi possono mandare dati ad altri processi di cui conoscono il PID
memoria condivisa: un processo scrive nell’area di memoria condivisa, non sa chi la andrà a leggere

## processi in competizione
il problema principale in questo caso è che per l’accesso alle risorse i processi devono fare richiesta al SO (tramite syscall) (es: accesso a tastiera, monitor, disco …)
>[!info] mutua esclusione per processi in competizione
![[Pasted image 20241208131930.png]]
ogni processo chiama una funzione che entra nella sezione critica, fa l’operazione, ed esce

>[!info] mutua esclusione per processi cooperanti
in questo caso, è il programmatore che si occupa di scrivere `entercritical` ed `exitcritical`, in quanto spesso la risorsa condivisa riguarda il processo stesso
![[Pasted image 20241208131930.png]]

>[!example] esempio di starvation
>- A richiede accesso prima alla stampante
>- B fa la stessa cosa
>- il SO dà la stampante ad A
>- A rilascia la stampante e lo scheduler gli permette di richiederla nuovamente
>- il SO dà nuovamente la stampante ad A
>- si ripete all’infinito, B non riceve mai la stampante e muore di fame. con soli 2 processi è improbabile, ma con tanti processi diventa probabile

>[!example] esempio di deadlock
>- A richiede accesso prima alla stampante, e poi al monitor
>- B richiede accesso prima al monitor, e poi alla stampante
>- capita che lo scheduler faccia andare in esecuzione B in mezzo alle 2 richieste di A: B prende quindi il monitor, ed A deve aspettare. 
>- B rimane in esecuzione quel tanto che basta per fargli richiedere il monitor
>- le successive richieste (da parte di A per il monitor, e da parte di B per la stampante) non possono essere soddisfatte
>- in questo modo, A e B restano bloccati per sempre, eppure è tutto avvenuto legalemente !
## requisiti per utilizzare la mutua esclusione
qualsiasi meccanismo si usi per offire la mutua esclusione, deve soddisfare i seguenti requisiti:
- solo un processo alla volta può essere nella sezione critica per una risorsa
- non deve avvenire nè deadlock nè starvation
- non ci deve essere nessuna assunzione su scheduling dei processi, nè sul numero dei processi (nè sulla velocità dei processi)
- un processo deve entrare subito nella sezione critica, se nessun altro processo usa la risorsa (non bisogna farlo attendere !)
- un processo che si trova nella sua sezione non-critica non deve subire interferenze da altri processi (in particolare non può essere bloccato)
- un processo che si trova nella sezione critica ne deve prima o poi uscire
	- ci vuole cooperazione: se è stato pensato un protocollo per accedere ad una risorsa convidisa, un processo non può entrare nella sua sezione critica senza rispettarlo (es: chiamare `entercritical`)
## 4 dummies
ci sono N processi che eseguono la funzione `P`, e tutti possono scrivere nella variabile condivisa `bolt`
```c
**esempio 1
int bolt = 0;
void P(int i){
	while(true){
		bolt = 1;
		while (bolt == 1) /* wait and do nothing */;
		/*enter critical section */;
		bolt = 0;
		/*remainder*/;
	}
}
```
la logica: un processo mette `bolt` a 1 quando vuole entrare nella sezione critica, ed aspetta finchè non viene messa a 0 per entrarci.
- in questo esempio, 2 process in interleaving perfetto vanno in deadlock
- un processo singolo non entrerà mai nella sezione critica
- abbiamo rispettato la mutua esclusione (al massimo un processo nella sezione critica), ma il problema è che non ci entra nessuno

```c
**esempio 2
int bolt = 0;
void P(int i){
	while(true){
		while (bolt == 1) /* wait and do nothing */;
		bolt = 1;
		/*enter critical section */;
		bolt = 0;
		/*remainder*/;
	}
}
```
questa funzione permette la mutua esclusione per qualche scheduling, ma ciò non basta ! deve essere corretto per tutti i possibili scheduling, e ciò non accade:  basta che lo scheduler faccia eseguire i 2 processi in interleaving, e si viola la mutua esclusione: P1 entra ed esce dal while, ma prima di poter mettere `bolt=1`viene mandato in esecuzione P2 che entra nel while, esce dal while ed entra nella sezione critica. all’esecuzione di P1, anche esso entrerà nella sezione critica. violazine !!!!
>[!warning] il dispatcher può interrompere un processo in qualsiasi istante
>anche prima che una istruzione venga completata ! dobbiamo pensare il codice a livello assembler. un ciclo while (come nell’esempio sopra) non viene eseguito “tutto insieme” solo perchè è in una sola riga. solo le singole istruzioni assembler vegnono sempre completate, e tra una istruzione assembler e la prossima il dispatcher può togliere la CPU al processo

possiamo pensare `bolt=1;` come 2 istruzioni macchina (una carica 1 in un registro, l’altra carica il registro in RAM (ci fidiamo))
pensando in questo modo, anche `while (bolt == 1)` è composto da diverse operazioni.
potrebbe capitare che P2 venga eseguito fino a `bolt = 1`, ma in precedenza P1 fosse arrivato fino a “metà” di `while (bolt == 1)`, ovvero fino a caricare il valore della variabile bolt (che a quel punto era ancora 0) dentro un registro
quando P1 tornerà in esecuzione, per lui `bolt` varrà ancora 0 ! (in quanto riprenderà da dopo il caricamento)

## disabilitazione delle interruzioni
```c
while (true){
	/* prima della sezione critica*/;
	disabilita_interrupt();
	/*sezione critica */;
	riabilita_interrupt();
	/* rimanente */;
}
```
in questo modo, tolgo al dispatcher la possibilità di interrompere il processo che entra nella sezione critica !
- ciò garantisce la mutua esclusione
>[!figure] ciclo delle istruzioni con iterrupt
![[Pasted image 20241208145002.png]]

i problemi di questa strategia:
- se i processi abusano della disabilitazione, peggiorano le prestazioni del SO (in quanto cala la multiprogrammazione e quindi l’uso del processore)
la disabilitazione degli interrupt funziona “localmente” su ogni processore, quindi su sistemi con più processori questa strategia non funziona ( un altro processo può accedere alla zona critica semplicemente perchè è in esecuzione su un altro processore)
inoltre, di solito la disabilitazione degli interrupt è una cosa che si fa solo in kernel mode
