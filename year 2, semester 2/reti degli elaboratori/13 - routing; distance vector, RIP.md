---
created: 2025-05-06T13:13
updated: 2025-06-19T19:04
---
>[!index]
>- [routing](#routing)
>	- [algoritmi d’istradamento con distance vector](#algoritmi%20d%E2%80%99istradamento%20con%20distance%20vector)
>		- [equazione di bellman-ford](#equazione%20di%20bellman-ford)
>		- [vettore distanza](#vettore%20distanza)
>		- [problema nella modifica dei costi](#problema%20nella%20modifica%20dei%20costi)
>- [RIP](#RIP)
>	- [route determination algorithm](#route%20determination%20algorithm)
>	- [messaggi RIP](#messaggi%20RIP)
>	- [timer RIP](#timer%20RIP)
>	- [caratteristiche RIP](#caratteristiche%20RIP)
>	- [implementazione RIP](#implementazione%20RIP)
# routing
il routing si occupa di trovare il miglior percorso da far percorrere ad un pacchetto e inserilo nella tabella di routing (= tabella di forwarding)
- quindi il routing costruisce le tabelle, che vengono poi usate dal [[12 - livello di rete; DHCP, NAT, forwarding, ICMP#forwarding dei datagrammi IP|forwarding]]
>[!info] grafo di una rete di calcolatori
![[Pasted image 20250427140019.png]]
$\text{grafo:} G=(N,E)$
$N=\text{insieme di nodi (router) = \{u,v,w,x,y,z\}}$
$E=\text{insieme di archi (collegamenti)= \{(u,v), (u,x), (v,x), (v,w), (x,w), (x,y),(w,y),(w,z), (y,z)\}}$
>- un path nel grafo $G$ è una sequenza di nodi $(x_{1},x_{2},\dots,x_n)$ tale che ognuna delle coppie $(x_{1},x_{2}), (x_{2},x_{3}),\dots, (x_{n-1},x_{n})$ è collegata
>- $c(x,x')$ è il costo del collegamento $(x,x')$, ed il costo di un cammino è la somma di tutti i costi degli archi lungo il cammino
>
>il costo di un cammino può rappresentare:
>- la lunghezza fisica del collegamento
>- la velocità del collegamento
>- il costo monetario associato al collegamento

in un grafo di una rete di calcolatori, il **cammino a costo minimo tra 2 nodi** viene calcolato da un **algortimo d’instradamento**
## algoritmi d’instradamento con distance vector
l’algoritmo di istradamento con **vettore distanza** (distance vector - DV) è:
- **distribuito**: ogni nodo riceve informazione dai vicini e opera su quelle
- **asincrono**: non richiede che tutti i nodi operino al passo con gli altri
e si basa su :
### equazione di bellman-ford
si basa sulla **formula di bellman-ford**, che definisce: 
$$
D_{x}(y) := \text{il costo del percorso a costo minimo dal nodo $x$ al nodo $y$)}
$$
che si calcola: 
$$
D_{x}(y)=min_{v}\{c(x,v) + D_{v}(y)\}
$$
dove $min_{v}$ riguarda tutti i vicini di $x$
>[!example] rappresentazione grafica
![[Pasted image 20250427141721.png]]
i percorsi $(a\to y), (b\to y), (c\to y)$ sono percorsi a costo minimo precedentemente stabiliti
>$$
D_{xy} = min\{(c_{xa} + D_{ay}), (c_{xb} + D_{by}), (c_{xc} + D_{cy})\}
>$$

### vettore distanza
il **vettore distanza** è un array monodimensionale che rappresenta un **albero a costo minimo**: una combinazione di percorsi a costo minimo dalla radice dell’albero verso tutte le destinazioni
- essendo monodimensionale, non fornisce il percorso da seguire per giungere alla destinazione, ma **solo i costi minimi** per le destinazioni
>[!example] esempio
![[Pasted image 20250427142315.png]]
>il vettore distanza del nodo $A$ !

ogni nodo della rete, quando viene inizializzato, crea un vettore distanza **iniziale**, con le informazioni che il nodo riesce ad ottenere dai propri vicini (cioè i nodi a cui è direttamente collegato)
- per creare il vettore dei vicini, invia messaggi di `hello` attraverso le sue interfacce (e lo stesso fanno i vicini) e scopre le identità dei vicini e la sua distanza da ognuno di essi
- quindi il vettore distanza iniziale rappresenta il valore dei percorsi minimi verso i vicini
- dopo che ogni nodo ha creato il suo vettore distanza iniziale, ne invia una copia ai suoi vicini, che aggiornano il proprio vettore applicando l’equazione di bellman-ford !
>[!example]
![[Pasted image 20250427142912.png]]
**nota**: con $X[]$ si indica “l’intero vettore $X$”
>- dati i vettori distanza inziali, osserivamo cosa succede quando $B$ riceve una copia del vettore distanza di $A$
![[Pasted image 20250427143221.png]]
>- ora osserviamo cosa succede quando $B$ riceve una copia del vettore $E$
![[Pasted image 20250427143315.png]]

>[!info] logica dell’algoritmo d’istradamento con vettore distanza
l’algoritmo quindi usa la seguente idea di base:
>- ogni nodo invia una copia del proprio vettore distanza a ciascuno dei suoi vicini
>- quando un nodo $x$ riceve un nuovo vettore distanza $DV$, da qualcuno dei suoi vicini, lo salva e usa la formula di bellman-ford per aggiornare il proprio vettore distanza
>- se il vettore distanza del nodo $x$ è cambiato per via di tale passo di aggiornamento, il nodo $x$ manderà il proprio vettore distanza aggiornato a ciascuno dei suoi vicini
>>[!figure]- illustrazione
>![[Pasted image 20250427143748.png]]

>[!info] implementazione dell’algoritmo distance vector
```
pipo
```
### problema nella modifica dei costi
con le modalità di aggiornamento definite nell’algoritmo, si può verificare il **problema del conteggio all’infinito**: le buone notizie viaggiano in fretta, e le notizie cattive si propagano lentamente
>[!example] esempio di problema del conteggio all’infinito (**count to infinity**)
![[Pasted image 20250427144841.png]]
>in questo esempio il costo di ogni collegamento è unitario
>16 == $\infty$
>dato che bellman-ford prende il minimo, per aggiornare correttamente i due router servono diversi aggiornamenti !

esistono 2 soluzioni al problema del conteggio all’infinito:
- **split horizon**: invece di inviare la tabella attraverso ogni interfaccia, ciascun nodo invia solo una parte della sua tabella tramite le interfacce: se il nodo $B$ ritiene che il percorso ottimale per raggiungere il nodo $X$ passi attraverso $A$, allora **NON** deve fornire questa informazione ad $A$ (l’informazione è arrivata **da** $A$, e quindi la conosce già)
	- nell’esempio di sopra, $B$ elimina la riga di $X$ dalla tabella prima di inviarla ad $A$
- **poisoned reverse** (inversione avvelenata): si pone a $\infty$ il valore del costo del percorso che passa attraverso il vicino a cui si sta inviando il vettore
	- nell’esempio di sopra, $B$ pone a $\infty$ il costo verso $X$ quando invia il vettore ad $A$
# RIP
il **RIP** (**routing information protocol**) è un protocollo di routing che usa vettori distanza, 
- è tipicamente incluso in UNIX BSD dal 1982
- la metrica di costo del RIP è la **distanza misurata in hop**, in cui 15 è il numero massimo di hop, e il valore 16 indica $\infty$
	- ogni link ha costo unitario
>[!example] esempio
![[Pasted image 20250427153006.png]]
>- è necessario un hop per passare da un router a un host
>- è necessario un hop per passare da un router ad un altro router 
## route determination algorithm
periodicamente, ogni router su cui è attivo RIP, manda la propria tabella di routing (vettore distanza) per fornire informazioni agli altri router riguardo i network e gli host a cui il router sa arrivare. qualunque router nella stessa network del router che sta mandando informazioni potrà aggiornare la propria tabella in base alle informazioni che ricevono. 
- ogni router che riceve un messaggio da un altro router, nella stessa network, che dice di poter raggiungere la network $X$ a costo $N$, sa che può raggiungere la network $X$ a costo $N+1$
>[!warning] invece di inviare solo i vettori distanza, i router inviano anche l’intero contenuto della tabella di routing (quindi anche i next hop)
## messaggi RIP
RIP si basa su una coppia di processi client-server e sul loro scambio di messaggi:
- **RIP request**: quando un nuovo router viene inserito nella rete, invia una RIP request per ricevere immediatamente informazioni di routing
- **RIP response** (o **advertisements**): in risposta ad una request (**solicited response**), o periodicamente **ogni 30s** (**unsolicited response**)
>[!info] struttura messaggi RIP
la sezione voce può essere ripetuta, in quanto ogni messaggio contiene un elenco comprendente fino a 25 sottoreti di destinazione all’interno del sistema autonomo e la distanza del mittente rispetto a ciascuna di tali sottoreti
![[Pasted image 20250427154153.png]]
>- **com**: comando: 1 = richiesta, 2 = risposta
>- **vers**: versione (la versione corrente è 2)
>- **family**: famiglia del protocollo : per il TCP/IP il valore è 2
>- **tag**: informazioni sul sistema autonomo
>- **network address**: indirizzo di destinazione
>- **subnet mask**: maschera di sottorete
>- **next-hop address**: indirizzo del prossimo hop
>- **distance**: numero di hop fino alla destinazione
## timer RIP
sono presenti 3 timer nel RIP: 
- **timer periodico**: controlla l’invio di messaggi di aggiornamento (25-35 secondi)
- **timer di scadenza**: regola la validità dei percorsi: dura 180 secondi, e se entro lo scadere del timer non si riceve aggiornamento, il percorso viene considerato scaduto e il suo costo impostato a 16
- **timer per garbage collection**: permette l’eliminazione dei percorsi dalla tabella: dura 120 secondi, e allo scadere del timer, il router rimuove i percorsi con costo pari a 16

>[!info] guasto sul collegamento e recupero
come abbiamo detto, se un router non riceve notizie dal suo vicino per 180 secondi, il nodo adiecente/collegamento viene considerato spento o guasto
in tale occorrenza:
>- RIP modifica la tabella d’instradamento locale
>- propaga l’informazione mandando annunci ai router vicini
>- i vicini inviano nuovi messaggi se la loro tabella d’instradamento è cambiata
>- l’informazione che il collegamento è fallito si propaga rapidamente su tutta la rete, e l’utilizzo della **poisoned reverse** evita i loop

## caratteristiche RIP
- **split horizon** con **poisoned reverse**: serve per evitare che un router invii rotte non valide al router da cui ha imparato la rotta (quindi per evitare cicli)
- **triggered updates**: riduce il problema della convergenza lenta (lungo tempo affinchè tutti i router abbiamo una visione omogenea e coerente della rete)
- **hold-down**: fornisce robustezza: quando si riceve un’informazione di una rotta non più valida, si avvia un timer e tutti gli advertisement riguardanti quella rotta che arrivano entro il timeout non vengono considerati (in quanto probabilmente l’informazione è vecchia)
	- previene che informazioni errate si diffondano, e permette che il network “assorba” il fatto che una rotta non è più valida, senza creare routing loop
## implementazione RIP
il RIP viene implementato come un’applicazione sulla porta 520 che usa UDP
- un processo chiamato `routed` (route daemon) esegue RIP, cioè mantiene le informazioni d’istradamento e scambia messaggi con processi `routed` nei router vicini

>[!warning] poichè RIP viene implementato come un processo a livello di applicazione, può inviare e ricevere messaggi su una socket standard, e utilizzare un protocollo di trasporto standard

>[!figure] raffigurazione
![[Pasted image 20250427160209.png]]
