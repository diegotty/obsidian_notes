---
related to: 
created: 2025-03-02T17:41
updated: 2025-03-28T19:16
completed: false
---
# union-find
**union-find**, noto anche come **disjoint-set union**(**DSU**), è una struttura dati per gestire insiemi **disgiunti**, in particolare per facilitare operazioni di **unione** e **ricerca** efficienti su tali insiemi
le tre operazioni fondamentali di union-find sono:
- `Crea(S)`: restituisce una struttura dati union-find sull’insieme $S$ di elementi, **dove ciascun elemento è in un insieme separato**
- `Find(x, C)`: restituisce il nome dell’insieme (della struttura dati $C$) a cui appartiene l’elemento $x$
- `Union(A, B, C)`: modifica la struttura dati $C$ fondendo la componente $A$ con la componente $B$, e restituisce **il nome della nuova componente**
>[!info]- quando è utile la struttura dati union-find
>dato che ci permette una gestione efficiente di insiemi disgiunti, union-find è utile in diversi contesti, tra cui l’evoluzione di un grafo nel tempo attraverso l’aggiunta di archi. in questo caso, gli insiemi disgiunti rappresentano le componenti connesse del grafo. guarda [[10 - spanning tree#algoritmo di Kruskal| l’algoritmo di kruskal !]]

>[!info] concetto di nome dell’insieme
il nome dell’insieme è il modo di rappresentare un insieme (nel nostro caso, rappresentiamo la componente connessa, con il nome di uno dei nodi al suo interno)
>
>la scelta fatta nelle implementazioni che seguono è quella di scegliere come nome dell’insieme quello di un particolare elemento dell’insieme stesso. in particolare, pensiamo di assegnare all’insieme **il nome dell’elemento massimo in esso contenuto**
>- discorso molto simile a classe di equivalenza e scelta dei rappresentati, ma in questo caso ci serve un solo rappresentante per identificare la componente
## implementazione
per implementare la struttura dati per $n$ elementi  nel modo più semplice, mantienamo il **vettore** $C$ delle $n$ componenti ([[03 - colorazione di grafi, componenti connesse#componente connessa|vettore delle componenti]])
- in questo modo, quando la componente $i$ verrà fusa con la componente $j$, se $i > j$ allora tutte le occorrenze di $j$ nel vettore $C$ verranno sostituite da $i$
>[!warning] esistono diverse implementazioni della struttura union-find, e in ognuna variano i costi per le operazioni `find()` e `union()`! 
>noi ne studieremo 2:
>- `union()` in $O(n)$ e `find()` in $O(1)$
>- `union()` in $O(1)$ e `find()` in $O(\log n)$
>
> esistono poi implementazioni con euristica e altre cose molto cool

>[!info] `union()` in $\Theta(n)$, `find()` in $\Theta(1)$
>```python
>def Crea(G):
>	C = [i for i in range(len(G))]
>	return C
>
>def Find(u, C):
>	return C[u]
>
>def Union(a, b, C):
>	if a > b:
>		for i in range(len(C)):
>			if C[i] == b: C[i]=a
>	else:	
>		for i in range(len(C)):
>			if C[i] == a: C[i]=b
>```
>in questa implementazione:
>- `crea()` ha costo $\Theta(n)$
>- `find()` ha costo $\Theta(1)$
>- `union()` ha costo $\Theta(n)$

ha anche senso bilanciare i costi, cioè rendere `union()` meno costosa, anche a costo di pagare qualcosa in più per `find()`
>[!info] `union()` in $O(1)$, `find()` in $O(n)$
**IDEA**:
>se usiamo il vettore dei padri per rappresentare le componenti connesse, `union()` dovrà cambiare solo un elemento del vettore, mentre `find()` dovrà semplicemente risalire l’albero(vettore dei padri è un albero) fino alla radice
>```python
>def Crea(G):
>	C = [i for i in range(len(G))]
>	return C
>
>def Find(u, C):
>	while u != C[u]:
>		u = C[u]
>	return u
>
>def Union(a, b, C):
>	if a > b:
>		C[b] = a
>	else
>		C[a] = b
>```
>in questa implementazione:
>- `crea()` ha costo $\Theta(n)$
>- `find()` ha costo $\Theta(n)$
>- `union()` ha costo $\Theta(1)$

per miglioare questa implementazione, è necessario evitare che i cammini per raggiungere le radici del vettore dei padri non diventino troppo lunghi
- dobbiamo quindi mantenere gli alberi bilanciati !
**IDEA**:
quando eseguo `union()` per fondere due componenti, scelgo sempre come nuova radice la componente che contiene il maggior numero di elementi
- in questo modo, per **almeno la metà** dei nodi presenti nelle due componenti coinvolte nella fusione, la lunghezza del cammino non aumenta (per le altre aumenta di 1)
inoltre(soprattutto) con quest’accorgimento garantiamo la seguente proprietà:
>[!dimostrazione]- se un insieme ha altezza $h$, allora l’insieme contiene almeno $2^h$ elementi
>assumiamo per assurdo che durante una delle fusioni si sia formata una nuova componente di altezza $h$, che non rispetta la proprietà. consideriamo la prima volta in cui accade, siano $ca$ e $cb$ le componenti che si fondono.
>possono essere accadute 2 cose: 
>-**$ca$ e $cb$ erano componenti con la stessa altezza**: allora avevano entrambe altezza $h-1$, ed ognuna aveva almeno $2^{h-1}$ elementi (in quanto nelle fusioni precedenti la proprietà era sempre stata verificata). quindi il numero totale di elementi della nuova componente è $2^{h-1} + 2^{h-1}=2^h$, e la proprietà è verificata
>-**$ca$ e $cb$ erano componenti con altezza diversa**: allora l’altezza dopo la fusione è quella della componente di altezza maggiore, che doveva essere già di altezza $h$ e conteneva già da sola $2^h$ elementi 

quindi l’altezza delle componenti non potrà mai superare $\log_{2} n$ (altrimenti avrei la componente con più di $n$ nodi)

>[!info] `union()` in $O(1)$, `find()` in $O(\log n)$
in questa implementazione devo fare in modo che ai nodi radice sia associato anche il numero di elementi che la componente contiene (quindi una volta che il nodo non è radice, non ci interessa più quel numero ?)
>- ogni elemento in $C$ è caratterizzato da una copia $\text{(x, numero)}$ dove $x$ è il nome dell’elemento e $\text{numero}$ è **il numero di nodi dell’albero radicato in $x$**
>```python
>def Crea(G):
>	C = [(i, 1) for i in range(len(G))] # ogni nodo è una componente
>	return C
>
>def Find(u, C): # componenti memorizzate come vettore dei padri
>	while u != C[u]
>		u = C[u]
>	return u
>
>def Union(a, b, C):
>	tota, totb = C[a][1], C[b][1] # numero di nodi in componente
>	if tota >= totb:
>		C[a] = (a, tota + totb)
>		C[b] = (a, totb)
>	else:
>		C[b] = (b, tota + totb)
>		C[a] = (b, tota)
>```
>in questa implementazione:
>- `crea()` ha costo $\Theta(n)$
>- `find()` ha costo $\Theta(\log n)$
>- `union()` ha costo $\Theta(1)$

esercizio ::::
- dato che è un dag, so che il costo da u a u è 0.
- dato che è un dag, tutti i nodi prima di u (nella rappresentazione di sort topologico), sono irraggiungibili da u

quando arrivo ad un nodo, so che ho calcolato le distanze di ogni nodo entrante in tale nodo.