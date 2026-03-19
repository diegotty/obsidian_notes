---
created: 2025-01-16T17:08
updated: 2025-02-20T09:38
---
[!index]
>
>- [file](#file)
>- [record](#record)
>- [puntatori](#puntatori)
>- [blocchi](#blocchi)
>- [operazioni sulla base di dati](#operazioni%20sulla%20base%20di%20dati)
>- [organizzazioni dei file](#organizzazioni%20dei%20file)
>- [file heap](#file%20heap)
>	- [ricerca](#ricerca)
>	- [costo medio della ricerca](#costo%20medio%20della%20ricerca)
>	- [inserimento](#inserimento)
>	- [modifica](#modifica)
>	- [cancellazione](#cancellazione)
>- [file hash](#file%20hash)
>	- [funzione hash](#funzione%20hash)

>[!info] rapprentazione memoria a disco rigido
![[Pasted image 20241129164243.png]]
[[dischi#HDD|come in SO!]], abbiamo testina che ruota, tracce e settori. il bottleneck per noi è il trasferimento dei dati (soprattuto in scrittura), che è molto più lento del tempo di elaborazione della CPU

 per il nostro interesse, faremo delle assuzioni su alcune cose.
 al momento della formattazione del disco, ogni traccia è suddivisa in **blocchi** di dimensione fissa (compresa tra $2^9$ e $2^{12}$ byte)
 >[!important] noi useremo gli accessi in memoria come unità di misura !
 >per accesso si intende il trasferimento di un blocco da memoria secondaria a memoria principale (lettura di un blocco) o da memoria principale a memoria secondaria (scrittura di un blocco)
 >in particolare, il tempo necessario per un accesso è dato dalla somma di: 
 >- tempo di posizionamento (della testina sulla traccia in cui si trova il blocco)
 >- tempo di rotazione (rotazione necessaria per posizionare la testina all’inizio del blocco)
 >- tempo di trasferimento (dei dati contenuti nel blocco)


## file
nel nostro caso, un file è un insieme omogeneo di record, construiti in base alla nostra tabella. il file è quindi la struttura di memorizzazione della tabella
inoltre, in ogni file ci sono record appartenenti ad un’unica relazione(ad una sola tabella)
## record
i record corrispondono alla tuple della nostra tabella, e oltre ai campi che corrispondono agli attributi, ci possono essere altri campi che contengono **informazioni sul record stesso** o **puntatori ad altri record/blocchi**
in particolare, all’inizio di un record alcuni byte possono essere utilizzati per:
- specificare il tipo del record (**è necessario quando in uno stesso blocco sono memorizzati record di tipo diverso, cioè record appartenenti a più file**)
- specificare la lungheza del record (se il record ha campi a lunghezza variabile (varchar in sql))
- contenere un bit di “cancellazione” o un bit di “usato/non usato” (tipo dirty bit ?)
- **offset**: numero di byte del record che prende il campo
	- se tutti i campi del record hanno lunghezza fissa, l’inizio di ciascun campo sarà sempre ad un numero fisso dall’inizio del record (e non ci servono gli offset immmagino ? almeno non per ogni record)
	- se invece il record contiene campi  a lunghezza variabile, all’inizio di ogni campo c’è un contatore che specifica la lunghezza del campo in numero di byte, **oppure** all’inizio del record ci sono gli offset dei campi a lunghezza variabile (**tutti i campi a lunghezza fissa precedono quelli a lunghezza variabile**)
		- notare che nel primo caso, per individuare la posizione di un campo,  bisogna esaminare tutti i campi precedenti per vedere quanto sono lunghi ! quindi la prima strategia è meno efficiente della seconda
## puntatori
un puntatore ad un record/blocco è un dato che permette di accedere rapidamente al record/blocco:
- nel caso il puntatore punti ad un blocco, punterà all’**indirizzo dell’inizio del blocco** sul disco
- nel caso il puntatore punti ad un record, abbiamo 2 possibilità:
	1. il puntatore punta all’inizio dell’indirizzo (primo byte) del record sul disco
	2. il puntatore sarà costituito da una coppia $(b,k)$, dove:
		- $b$ è l’indirizzo del blocco che contiene il record
		- $k$ è il valore della chiave (dobbiamo quindi efffettuare una ricerca ? \\QUESTION)
	-  nel secondo caso è possibile spostare il record all’interno del blocco, mentre nel primo no, altrimenti potremmo avere dei **dangling pointers**
## blocchi
sul blocco invece, ci possono essere, oltre ai record:
- informazioni sul blocco stesso
- puntatori ad altri blocchi (le strutture dati che vedremo usanto puntatori epr spostarsi attraverso i dati (puntano ad altri blocchi))
se un blocco contiene **solo** record di lunghezza fissa:
- il blocco è suddiviso in aree (**sottoblocchi**) di lunghezza fissa, ciascuna delle quali può contener un record, e i bit “usato/non usato” sono raccolti in uno o più byte all’inizio del blocco
- nota: se bisogna inserire un record nel blocco, occorre cercare un’area non usata: se il bit “usato/non usato” è in ciascun record, ciò può richiedere la scansione di tutto il blocco. per evitare ciò si possono raccogliere tutti i bit “usato/non usato” in uno o più byte all’inizio del blocco
invece, se il blocco contiene record di lunghezza variabile:
- si pone in ogni record un campo che ne specifica la lunghezza in termini di byte, **oppure** si pone all’inizio del blocco una **directory** contenente i puntatori(**offset**) ai record nel blocco
	- la **directory** può essere realizzata in uno dei modi seguenti: 
		- è preceduta da un campo che specifica quanti sono i puntatori nella directory
		- è una lista di puntatori ( e la sua fine è specificata da uno 0)
		- ha dimensione fissa e contiene il valore 0 negli spazi che non contengono puntatori
# operazioni sulla base di dati
un’operazione sulla base di dati consiste di:
- **ricerca**
- **inserimento**(implica ricerca, se vogliamo evitare duplicati)
- **cancellazione**(implica ricerca)
- **modifica**(implica ricerca)
di un record !
la ricerca è quindi alla base di tutte le altre operazioni !!
# organizzazioni dei file
esaminiamo ora diversi tipi di organizzazione fisica, che consentono la ricerca di record in base al valore di uno o più **campi chiave**
>[!warning] il termine “chiave” non va inteso nel senso in cui viene usato nella teoria relazionale, in quanto un valore della chiave in questo contesto (ricerca) non necessariamente identifica univocamente un record nel file
## file heap
>[!warning] non parliamo dell’heap - struttura dati studiata in algoritmi

“non organizzazione”, cioè collocazione dei record nei file in un ordine determinato solo dall’ordine di inserimento
- organizzazione con peggiore prestazioni in termini di numero di accessi in memoria richiesti dalle operazioni di ricerca (mentre l’inserimento è molto veloce se ammettiamo duplicati: in un file heap un record viene sempre inserito come ultimo record del file)
- l’accesso al file avviene attraverso la directory (indice di heap), che è un array di puntatori che puntano ai blocchi che contengono i record di quella tabella 

### ricerca
se si vuole ricercare un record, ci sono 2 casi:
- **chiave fornita indentifica univocamente i campi**: occorre scandire tutto il file, iniziando dal primo record fino ad incontrare il record desiderato
- **chiave fornita non identifica univocamente i campi**: occorre scandire tutto il file, **obbligatoriamente dall’inizio alla fine**, in quanto non sappiamo se, trovato il primo campo che corrisponde, ce ne sono altri che corrispondono al valore della chiave fornita
### costo medio della ricerca
se la chiave fornita per la ricerca identifica univocamente i campi, ha senso parlare di costo medio, in quanto il costo della ricerca varia in base a dove si trova il record: se il record si trova nell’$i$-esimo blocco, occorre effettuare $i$ accessi in lettura
>[!example] esempio
N = 151 record
ogni record ha dimensione 30 byte
ogni blocco contiene 65 byte
ogni blocco ha un puntatore al prossimo blocco (di dimensione 4 byte)
>
> **quanti record entrano in un blocco ?**
> $\frac{65-4}{30} = 2,03$, di cui consideriamo la parte intera inferiore($2$), in quanto: **in un blocco possiamo inserire solo record completi: non possiamo avere un record a cavallo di 2 blocchi
>
**quanti blocchi servono per memorizzare tutti i record ?**
$\frac{151}{2}=75,5$ di cui consideriamo la parte intera superiore ($76$), in quanto **i blocchi vengono allocati interamente se non specificato altrimenti**
>
>in questo caso quindi, in una ricerca, devo scorrere 76 blocchi, e potrei trovare il record in uno di questi 76 blocchi

poniamo: 
$N$: numero di record
$R$: numero di record che possono essere memorizzati in un blocco
$n = \frac{N}{R}$
per calcolare il costo medio della ricerca, calcoliamo la media degli accessi necessari per un record
>[!info] ragionamento
abbiamo $n$ blocchi, e in ogni blocco abbiamo $R$ record. nel primo blocco, ognuno dei $R$ record richiede 1 accesso in memoria per accedere a tale record. nel secondo blocco, ognuno dei $R$ record richiede 2 accessi (caricare il primo blocco, che scorriamo e in cui non troviamo il record, e con il puntatore alla fine del primo blocco carichiamo il secondo blocco in memoria principale). nel terzo blocco, ognuno dei $R$ record richiede 3 accessi, e così via.
>
> quindi, la somma degli accessi necessari per tutti i record è $R \cdot1 + R \cdot2+ \dots+ R \cdot n$, che dividiamo per il numero di record ($N$)
>mettiamo poi in evidenza $R$, e notiamo che $\frac{R}{N}$ è il reciproco di $n$, quindi lo possiamo sostituire con $\frac{1}{n}$. inoltre $(1 +2 + \dots + i +\dots+n)$ è la sommatoria di Gauss, che possiamo quindi sostituire con il risultato chiuso $\frac{n(n+1)}{2}$. 
>a questo punto, possiamo semplificare per $n$, e arriviamo alla conclusione che il costo medio della ricerca è $\simeq \frac{n}{2}$

$$
\begin{align}
\frac{R\cdot1+R\cdot 2+\dots+R\cdot n}{N}&=\frac{R\cdot(1+2+\dots+i+\dots+n)}{N} =\\
&=\frac{R}{N}\cdot \frac{n(n+1)}{2}=\frac{1}{n}\cdot \frac{n(n+1)}{2}= \\
&\simeq \frac{n}{2}
\end{align}
$$
### inserimento
per l’inserimento invece, è necessario:
- 1 accesso in lettura (per portare l’ultimo blocco in memoria principale)
- 1 accesso in scrittura (per riscrivere l’ultimo blocco in memoria secondaria, dopo aver inserito il record)
- + gli accessi necesari per il controllo del duplicato (che possiamo dire essere in media $\frac{n}{2}$, in quanto una volta trovato un record duplicato non abbiamo bisogno di continuare la ricerca)
### modifica
per la modifica, è necessario:
- costo medio della ricerca (per trovare il record da modificare)
- 1 accesso in scrittura (per riscrivere in memoria secondaria il blocco, dopo aver modificato il record)
### cancellazione
per la cancellazione, è necessario:
- costo medio della ricerca
- 1 accesso in lettura (per riutilizzare spazio ed evitare buchi, prendiamo l’ulitmo record e lo inseriamo al posto del record che cancelleremo)
- 2 accessi in scrittura (per riscrivere in memoria secondaria il blocco modificato(da cui abbiamo rimosso un record e aggiunto un record nello stesso posto) e l’ultimo blocco (da cui abbiamo rimosso un record))
## file hash
in questa organizzazione fisica, il file è diviso in **bucket**, cioè secchi numerati da $0$ a $B-1$
- ciascun **bucket** è costituito da uno o più blocchi (collegati mediante puntatori), ogni bucket è organizzato come un file heap
>[!figure] rappresentazione dei bucket
![[Pasted image 20241129184148.png]]

l’accesso ai bucket avviene attraverso la **bucket directory**, che contiene $B$ elementi
- l’$i$-esimo elemento contiene l’indirizzo (**bucket header**) del primo blocco dell’$i$-esimo blocco
la bucket directory viene memorizzata in blocchi
>[!figure] rappresenteazione bucket directory
![[Pasted image 20241129185521.png]]
### funzione hash
viene usata per mettere i record dentro un bucket con un criterio: dato un valore $v$ per la chiave, **il numero del bucket** in cui deve trovarsi un record con chiave $v$ è calcolato mediante una funzione, la funzione hash
- il risultato di una funzione hash deve essere compreso tra $0$ e $B-1$ (viene quindi usato il modulo)
>[!example] esempio di inserimento con funzione hash
![[Pasted image 20241129185717.png]]
in questo caso il record ha valore chiave $v$, che inserito nella funzione hash genera il numero $0$, quindi viene inserito nel bucket $0$ (alla fine dell’ultimo blocco, in quanto ogn bucket è gestito come un file heap)

una funzione hash, per essere “buona”, deve ripartire uniformemente i record nel bucket, cioè al variare del valore della chiave, deve assumere con la “**stessa**” probabilità uno dei valori compresi tra $0$ e $B-1$
una qualsiasi operazione su file hash, richiede la valutazione di $h(v)$ per individuare il bucket, e poi l’esecuzione dell’operazione sul bucket che è organizzato come un file heap
- in genere, una funzione hash trasforma la chiave in un intero, divide questo intero per $B$, e fornisce il resto della divisione come numero del bucket
>[!info] considerazioni
quanti più sono i bucket, più è basso il costo di ogni operazione. d’altra parte ci sono delle limitazioni sul numero di bucket:
>- ogni bucket deve avere almeno un blocco
>- è preferibile che la bucket directory abbia una dimensione tale che possa essere mantenuta in memoria principale, altrimenti durante l’utilizzo del file, saranno necessari ulteriori accessi per accedere ai blocchi della bucket directory

>[!example] esempio 1
supponiamo di avere un file di 250.000 record. ogni record occupa 300 byte, di cui 75 per il campo chiave. ogni blocco contiene 1024 byte. ogni puntatore a blocco occupa 4 byte.
**se usiamo una organizazione hash con 1200 bucket, quanti blocchi occorrono per la bucket directory ?**
>per sapere quanti blocchi servono per la bucket directory, dobbiamo calcolare quanti puntatori entrano in un blocco, in quanto la bucket directory è essenzialmente un array di puntatori indicizato da $0$ a $B-1$.
>$\frac{1024}{4}=256$. quindi il numero di blocchi necessari per la bucket directory è $\frac{1200}{256}=4,69 = 5$(parte intera superiore, perchè **non essendo stato specificato direttamente nell’esercizio, i blocchi vengono allocati interamente**). (notiamo che se ogni entry della bucket entry avesse anche un puntatore all’ultimo blocco del bucket, occorrerebbe considerare coppie intere di puntatori(non possiamo spezzare in due blocchi la coppia di puntatori per un bucket))
>
**quanti blocchi occorrono per i bucket, assumendo una distribuzione uniforme dei record nei bucket ?**
>assumento una distribuzione uniforme per i bucket, ci basta calcolare il numero di blocchi necessari per i record, e dividere per il numero di bucket. $\frac{1024-4}{300}=3,4=3$(parte intera inferiore perchè non possiamo memorizzare un record a cavallo di 2 blocchi). sappiamo che il numero di record nei bucket è uniforme, quindi $\frac{250.000}{1200}=208,3=209$ record in ogni bucket. servono quindi $\frac{209}{3}=69,6=70$ blocchi in ogni bucket, per un totale di $70 \cdot1200=84.000$ blocchi
>
**assumendo ancora che tutti i bucket contegano il numero medio di record, qual è il numero medio di accessi a blocco per ricercare un record che sia presente nel file ?**
>per calcolare il numero medio di accessi a blocco, dobbiamo calcolare il numero di accessi a blocco per ogni bucket (che è uguale per tutti i bucket, dato che hanno lo stesso numero di record). usando la formula chiusa, il costo medio della ricerca è $\frac{n}{2}=\frac{70}{2}=35$($n$ è il numero di blocchi per il singolo bucket/file heap). **potrebbe essere necessario aggiungere 1 accesso, se l’intera bucket directory non entra in memoria principale e il record del bucket necessario va preso dalla memoria secondaria**
>
**quanti bucket dovremmo creare per avere invece un numero medio di accessi a blocco inferiore o al massimo uguale a 10, assumendo comunque una distribuzione uniforme dei record nel bucket ?**
per avere un numero medio di accessi a blocco $\leq 10$, dovremmo avere massimo $20$ blocchi per bucket. avremmo quindi $20 \cdot 3 = 60$ record memorizzati in ogni bucket, per un totale di $\frac{250.000}{60}=4166,6=4167$ bucket 