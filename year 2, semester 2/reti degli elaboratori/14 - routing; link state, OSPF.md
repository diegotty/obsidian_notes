---
created: 2025-05-06T13:13
updated: 2025-06-19T19:04
---
>[!index]
>- [link state](#link%20state)
>	- [link state database](#link%20state%20database)
>- [algoritmo d’instradamento a stato del collegamento](#algoritmo%20d%E2%80%99instradamento%20a%20stato%20del%20collegamento)
>	- [algoritmo di dijkstra](#algoritmo%20di%20dijkstra)
>- [confronto tra algoritmi LS e DV](#confronto%20tra%20algoritmi%20LS%20e%20DV)
>- [OSPF](#OSPF)
>	- [messaggi OSPF](#messaggi%20OSPF)

dopo aver visto il routing usante [[13 - routing; distance vector, RIP#algoritmi d’istradamento con distance vector|distance vector]], studiamo gli algoritmi di routing usanti **link state**
## link state
lo stato di un link indica il costo associato al link (collegamento). ogni nodo deve conoscere i costi di tutti i collegamenti della rete, e la mappa completa di tutti i link state deve essere mantenuta dal **link state database** (**LSDB**)
- se il costo è $\infty$ significa che il collegamento non esiste oppure è stato interrotto
### link state database
il **link state database** è una matrice che contiene la mappa completa della rete. è unico per tutta la rete, ed ogni nodo ne possiede una copia
>[!example] esempio di LSDB
![[Pasted image 20250504140304.png]]

>[!info] come si costruisce il LSDB
>innanizitutto ogni nodo della rete deve conoscere i propri vicini e i costi dei collegamenti verso di loro. se ciò non si verifica:
>- ogni nodo invia un messaggio di `hello` a tutti i suoi vicini
>- ogni nodo riceve gli `hello` dei vicini e crea la lista dei vicini con i relativi costi dei collegamenti
> 	- la lista (vicino, costo) viene chiamata **LS packet** (**LSP**)
>- ogni nodo esegue un **flooding** dei LSP: 
>	 - invia a tutti i vicini il proprio LSP
>	 - quando riceve l’LSP di un vicino, se è un nuovo LSP allora lo inoltra a tutti i suoi vicini diretti eccetto quello da cui lo ha ricevuto
>
>>[!example] esempio
>![[Pasted image 20250504141221.png]]

## algoritmo d’instradamento a stato del collegamento
l’algoritmo di instradamento usato da algoritmi con **link state** è l’**algoritmo di dijkstra** ! ([[09 - algoritmo di dijkstra|precedentemente studiato ad algo2]])
sappiamo che la topolgia di rete e tutti i costi dei collegamenti sono noti a tutti i nodi: con l’algoritmo di dijkstra ogni nodo calcola il cammino a costo minimo verso tutti gli altri nodi della rete !
- tutti i nodi applicano dijkstra, in modo indipendente, quindi link state è un routing distribuito
una volta applicato dijkstra, ogni nodo crea una **tabella d’inoltro** !
### algoritmo di dijkstra
definiamo la seguente notazione:
- $N$: insieme dei nodi rella rete
- $c(x,y)$: costo del collegamento dal nodo $x$ al nodo $y$
- $D(v)$: costo del cammino minimo dal nodo origine alla destinazione $v$, per quanto riguarda l’iterazione corrente (il nodo radice che sta applicando dijkstra)
- $p(v)$: immediato predecesore di $v$ lungo il cammino
- $N’$: sottoinsieme di nodi per cui il cammino a costo minimo dall’origine è definitivamente noto
>[!info] implementazione
![[Pasted image 20250505182729.png]]

## confronto tra algoritmi LS e DV
- **complessità dei messaggi**:
	- **LS**: con $n$ nodi, $E$ collegamenti, implica l’inviio di $O(nE)$ messaggi !
	- **DV**: richiede scambi tra nodi adiacenti. il **tempo di convergenza**, cioè il tempo necessario affichè tutti i router abbiamo una visione coerente e aggiornata della topologia di rete, può variare
- **robustezza**:
	- **LS**: se un router funziona male, può comunicare via broadcast un costo sbagliato per uno dei suoi collegamenti connessi (ma non per altri !). inoltre i nodi si occupano di calcolare soltanto le proprie tabelle
	- **DV**: un nodo può comunicare **cammini** a costo minimo errati a tutte le destinazioni. inoltre la tabella di ciascun nodo può essere usata dagli altri, quindi un calcolo erraro si può facilmente diffondere per l’intera rete
	quindi **OSPF** è più robusto di **RIP**
- **velocità di convergenza**:
	- **LS**: l’algoritmo ha complessità $O(n^2)$
	- **DV**: può convergere lentamente, può presentare cicli di instradamento e può presentare il problema del conteggio infinito
# OSPF
**OSPF** (**open shortest path first**) è un **protocollo di routing**: è più di un algoritmo ! essendo un protocollo, deve definire il suo ambito di funzionamento, i messaggi che vengono scambiati, la comunicazione tra router e l’interazione con altri procotolli
- è **open** perchè le specifiche del protocollo sono pubblicamente disponibili
OSPF è un protcollo a **link state**: utilizza il flooding di informazioni di link state, e l’algoritmo di dijkstra per determinare i percorsi minimi. in particolare:
- con OSPF, ogni volta che si verifica un cambiamento nello **stato di un collegamento**, il router manda informazioni d’instradamento a **tutti** gli altri router (trigged updates)
- invia periodicamente (ogni 30 minuti) messaggi OSPF all’intero sistema autonomo, utilizzando il flooding
## messaggi OSPF
esistono 4 “tipi” di messaggi OSPF:
- **hello**: usato dai router per annunciare la propria esistenza ai i vicini che conosce
- **database description**: risposta ad hello, consente di ottenere il LSDB a chi si è appena connesso
- **link-state request**: usato per richiedere specifiche informazioni su un collegamento
- **link-state update**: messsaggio principale, usato da OSPF per la costruzione del LSDB
- **link-state ack**: riscontro ai link-state update (per fornire affidabilità)