---
created: 2024-11-25
related to: "[[intro al filesystem]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [allocazione](#allocazione)
>	- [preallocazione](#preallocazione)
>	- [allocazione dinamica](#allocazione%20dinamica)
>- [dimensione delle porzioni](#dimensione%20delle%20porzioni)
>- [metodi di allocazione](#metodi%20di%20allocazione)
>	- [allocazione contigua](#allocazione%20contigua)
>	- [allocazione concatenata](#allocazione%20concatenata)
>	- [allocazione indicizzata](#allocazione%20indicizzata)
>- [gestione dello spazio libero](#gestione%20dello%20spazio%20libero)
>- [tabelle di bit](#tabelle%20di%20bit)
>- [porzioni libere concatenate](#porzioni%20libere%20concatenate)
>- [indicizzazione](#indicizzazione)
>- [lista dei blocchi liberi](#lista%20dei%20blocchi%20liberi)
>- [volumi](#volumi)
>- [dati e metadati](#dati%20e%20metadati)
>- [jounaling](#jounaling)
>	- [alternative al journaling](#alternative%20al%20journaling)
# gestione della memoria secondaria
il SO è responsabile dell’assegnamento di blocchi a file, e deve gestire 2 problemi correlati: 
- occorre allocare spazio per i file, e mantenerne traccia una volta allocato
- occorre tenere traccia dello spazio allocabile
chiaramente, un problema influenza l’altro
il SO alloca in “porzioni” o “blocchi”, cioè un sequenza **contigua** di settori
- tipicamente, viene usata la parola **porzioni** quando si parla di allocazione dinamica, e **blocchi** quando si usa la preallocazione
- in caso di porzioni, bisogna decidere se di dimensione fissa o dinamica, e quanto grandi

**allocation table**: per ogni file, mantiene le informazioni su dove sono sul disco le porzioni che lo lo compongono
## allocazione
### preallocazione
- la massima dimensione viene dichiarata a tempo di creazione
- tuttavia, la dimensione è facilmente stimabile in alcune applicazioni, e difficile in molte altre (utenti ed applicazioni sovrastimano la dimensione così da poter effetivamente (e senza problemi) memorizzare le informazioni desiderate nel file)
ciò risulta in uno spreco di spazio su disco
### allocazione dinamica
viene quindi preferita l’allocazione dinamica, in cui la dimensione viene aggiustata in base a syscall come `append` o `truncate`
## dimensione delle porzioni
ci sono due possibilità agli estremi:
- si alloca una porzione larga a sufficienza per l’intero file: in questo modo l’accesso sequenziale è il più veloce
- si alloca un blocco(sequenza di $n$ settori contigui, con $n$ fisso e piccolo (spesso $n = 1$)) alla volta
si cerca un punto d’incontro tra efficienza del singolo file ed efficienza del sistema
- porzioni piccole vuol dire grandi tabelle di allocazione, e quindi grande overhead, ma vuol dire anche maggior facilità di riuso dei blocchi
- le porzioni fisse grandi invece portano a frammentazione interna
- la frammentazione esterna invece è sempre possibile: i file possono essere cancellati (questo riguarda la contiguità delle aree allocate penso, roba della compattazione)
alla fine, ci sono 2 possibilità (valide sia per preallocazione che per allocazione dinamica):
- porzioni grandi e di dimensione variabile
	- ogni singola allocazione è contigua, e la tabella di allocazione è abbastanza contenuta (porzioni grandi)
	- complicata la gestione dello spazio libero !
- porzioni fisse e piccole
	- tipicamente, 1 blocco per porzione
	- molto meno contiguo del precedente
>[!info] preallocazione + porzioni grandi e di dimensione variabile
>se si usa questa combinazione, non c’è bisogno di una tabella di allocazione: per ogni file basta l’inizio e la lunghezza, in quanto ogni file è un’unica porzione
>- funziona come il porzionamento della RAM: si usano algoritmi come bset fit, first fit, next fit
> - rimane inefficiente per lo spazio libero: necessita periodica compattazione, che è molto più onerosa che la compattazione della RAM

## metodi di allocazione
>[!info] riassunto
![[Pasted image 20241119105124.png]]
> - la frequenza di allocazione è un overhead !
### allocazione contigua
un insieme di blocchi viene allocato per il file quando ques't’ultimo viene creato
- la preallocazione è necessaria, in quanto occorre sapere quanto, al massimo, sarà lungo il file (altrimenti, se crescesse, incontrerebe blocchi già occupati)
- è necessaria una sola entry nella tabella di allocazione dei file: blocco di partenza e lunghezza del file
- ci sarà frammentazione esterna, con conseguente necessità di compattazione
>[!info] immagine di riferimento
![[Pasted image 20241119105708.png]]
>- se mi arrivasse un file lungo 8 blocchi, in teoria ho lo spazio “fisico” per memorizzarlo, ma non in modo contiguo: c’è quindi bisogno di compattare, in questo modo:
![[Pasted image 20241119105831.png]]

### allocazione concatenata
viene allocato un blocco alla volta, e ogni blocco ha un puntatore al prossimo blocco (tipo lista linkata ! la prima parte del blocco sono dati del file, l’ultima (piccola) parte del blocco è il puntatore)
- è necessaria solo una entry nella tabella di allocazione dei file (il blocco di partenza e la lunghezza del file(che è calcolabile cmq))
- niente frammentazione esterna ! 
- è ok per file da accedere sequenzialmente, ma se serve un certo blocco che si trova $b$ blocchi dopo quello inziale, devo scorrere tutta la lista
>[!info] immagine di riferimento
![[Pasted image 20241119110103.png]]
per migliorare l’accesso non sequenziale, si ricorre al **consolidamento**, che consiste nel mettere i blocchi di un file contigui (analogo alla compattazione), in questo modo:
![[Pasted image 20241119110238.png]]

### allocazione indicizzata
via di mezzo tra allocazione contigua e allocazione concatenata !
la tabella di allocazione contiene una sola entry, con l’indirizzo di un blocco: questo blocco, in realtà, ha una entry per ogni porzione allocata al file (guarda foto). quindi funziona da tabella, anche se si trova in un blocco apparentemente indistinguibile dagli altri
-  perchè ciò sia possibile, ci deve essere un bit che indica se un blocco è composto da dati o è un indice
- se il file è troppo grande, si creano più livelli

>[!info] allocazione indicizzata con porzioni di lunghezza fissa
![[Pasted image 20241121211238.png]]
> l’allocazione con blocchi di lunghezza fissa evita la frammentazione esterna, in quanto non ho nessità di allocare blocchi contigui (uhh probably not \\QUESTION)
>- a volte occore il consolidamento, per migliorare la località

>[!allocazione indicizzata con porzioni di lunghezza variabile]
![[Pasted image 20241121211723.png]]
l’allocazione con blocchi di lunghezza variabile migliora la località ! in quanto i blocchi allocati sono contigui
il blocco che fa da tabella ora contiene anche la lunghezza (il numero di blocchi contigui allocati a partire dallo start block)
>- a volte occorre il consolidamento, per ridurre le dimensioni della tabella
>- la tabella è ordinata !

>[!info] ora possiamo capire meglio cosa vuol dire formattare un file system !
vuol dire prepararlo per raccogliere le informazioni secondo la struttura di un certo file system
es: se un file system usa l’allocazione indicizzata, è necessario che ci sia una file allocation table (vuota)
# gestione dello spazio libero
la gestione dello spazio libero è altrettando importante di quello occupato, e per allocare spazio per i file, è necessario sapere qual è lo spazio libero ! (non è realistico guardare la tabella di allocazione di tutti i file per determinare quali blocchi/porzioni sono liberi)
- serve quindi una **tabella di allocazione di disco**, oltre a quella di allocazione per i file, che viene aggiornata si alloca o si cancella un file
esistono diversi modi per gestire la gestione dello spazio libero: 
>[!warning] una parte della tabella che indica lo spazio libero va sempre tenuta in RAM
>spesso le operazioni di modifica sulla tabella dello spazio libero (quando un file viene allocato\deallocato) vengono registrate solo in memoria principale, e poi in seguito riportate su disco. ciò può portare a inconsistenza e i problemi che vedremo in seguito !
## tabelle di bit
si usa un vettore con un bit per ogni blocco su disco: 0 vuol dire libero, 1 vuol dire occupato
- questa soluzione minimizza lo spazio richiesto alla tabella di allocazione del disco
ha però dei problemi: 
- se il disco è quasi pieno, la ricerca di uno spazio libero può richiedere molto tempo (risolvibile con delle tabelle riassuntive di porzioni della tabella di bit)
## porzioni libere concatenate
come allocazione libera: le porzioni libere possono essere concatenate le une alle altre, usando, per ogni blocco libero, un puntatore ed un intero per la dimensione
- questa soluzione non ha praticamente overhead
ha però dei problemi:
- occorre leggere un blocco libero per conoscere il prossimo: se occorre allocarne molti, diventa time consuming 
- è lungo anche cancellare file molto frammentati (xke poi devo aggiungerli alla linked list)
## indicizzazione
si tratta lo spazio libero come un file, e quindi si usa un indice come si farebbe per un file
- per efficienza, l’indice gestisce le porzioni come se fossero di lunghezza variabile (c’è quindi una entry per ogni porzione libera del disco)
## lista dei blocchi liberi
ad ogni blocco viene assegnato un numero sequenziale, e la lista di questi numeri viene memorizzata in una parte dedicata del disco (per forza riservata, NON come [[#porzioni libere concatenate]])
- poco overhead ! la lista occupa poco spazio
- per avere parti della lista in memoria principale, si può organizzare la lista come stack, e tenere solo la parte alta. in questo modo si può usare pop per allocare, e push per deallocare, e quando lo stack caricato finisce, si prende una nuova parte del disco

# volumi
è un “disco logico”, cioè 
- una partizione di un disco
- più dischi messi insieme e visti come un disco solo (LVM)
è quindi un insieme di settori in memoria secondaria, che possono essere usati dal SO e dalle applicazioni
- i settori non devono essere per forza contigui, ma appariranno come tali al SO e alle applicazioni
un volume potrebbe essere il risultato dell’unione di volumi più piccoli !
# dati e metadati
**dati**: contenuto del file
**metadati**: lista di blocchi liberi, lista di blocchi all’interno dei file, data di ultima modifica, …
- i metadati devono essere su dicsco, perchè devono essere persistenti
- per efficienza, vengono anche tenuti in memoria principale, ma mantere sempre consistenti i metadati in memoria principale e su disco è inefficiente, quindi si fa solo di tanto in tanto, quando il disco è poco usato, e con più aggiornamenti insieme (buffering)
## jounaling
zona dedicata del disco(**log**) in cui scrivere le operazioni, prima di farne il commit nel file system
- in caso di reboot dopo un crash, basta leggere il log !!
il rispristino del disco, dopo un evento imprevisto (es : computer viene spento all’improvviso per mancanza di corrente, il disco viene rimosso senza dare un appropriato comando (unmount)) viene gestito con il log:
- all’inizio del disco viene scritto un bit che dice se il sistema è stato spento correttamente. a reboot, se il bit è 0, occorre eseguire un programma di ripristino del disco, che confronta il journal allo stato corrente del file system, e corregge le inconsistenze nel file system basandosi sulle operazioni salvate nel journal
ci sono 2 tipi di journal: 
**fisico**: copia nel journal **tutti i blocchi** che dovranno poi essere scritti nel file system, inclusi i metadati
- se c’è un crash durante la scrittura nel file system, basta copiare il contenuto del journal al file system al reboot successivo
**logico**: copia nei journal **solo i metadati** delle operazioni effettuate (es: modifica la lista dei blocchi liberi dopo la cancellazione di un file)
- se c’è un crash, si copiano i metadati dal journal al file system, ma questo può causare corruzione dati, in quanto il contenuto delle operazioni è perso perchè non salvato nel journal
### alternative al journaling
- Soft Updates File Systems: riordina le scritture su file system in modo da non avere mai inconsistenze (o meglio, consente solo alcune tipi di consistenze che non portano a perdite di dati (storage leaks))
- Log-Structured File Systems: l’intero file system è strutturato come un buffer circolare, detto **log**: dati e metadati sono scritti in modo sequenziale, sempre alla fine del log
- Copy-on-Write File Systems: evitano di sovrascrivere dei contenuti nei file: scrivono nuovi contenuti in blocchi vuoti, e poi aggiornano i metadati per puntare ad i nuovi contenuti