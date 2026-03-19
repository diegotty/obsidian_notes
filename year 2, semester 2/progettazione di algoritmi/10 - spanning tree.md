---
related to: 
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [spanning tree](#spanning%20tree)
>	- [algoritmo di Kruskal](#algoritmo%20di%20Kruskal)
>		- [correttezza](#correttezza)
>		- [implementazione](#implementazione)
>	- [algoritmo di Kruskal con UNION-FIND](#algoritmo%20di%20Kruskal%20con%20UNION-FIND)
>		- [implementazione](#implementazione)
# spanning tree
uno **spanning tree**(albero di copertura) è l’albero in cui esiste una unica componente connessa, con il minimo costo ( in cui il costo dello spanning tree è la somma dei pesi di tutti gli archi)
>[!info] problema: minimo spanning tree
>dato un grafo non diretto, pesato e connesso $G$, vogliamo conoscere lo spanning tree con costo minimo

la soluzione è un albero(grafo connesso aciclico) perchè qualunque ciclo sarebbe una ridondanza (l’eliminazione di un qualunque arco del ciclo non farebbe perdere la connessione e diminuirebbe il costo della soluzione). andiamo quindi alla ricerca in $G$ di un albero che **“copre”** l’intero grafo e la somma dei costi dei suoi archi sia minima !
data l’importanza di di questo problema, esistono diversi algoritmi per risolvere questo problema. noi vedremo il seguente:
## algoritmo di Kruskal
>[!info] logica
>- parti con il grafo $T$ che contiene tutti i nodi di $G$ e nessun arco di $G$.
>- considera uno dopo l’altro gli archi del grafo $G$ in ordine di costo crescente.
>- se l’arco forma ciclo in $T$ con gli archi già presi, allora non prenderlo, altrimenti inseriscilo in $T$.
>- al termine restituisci $T$

l’algoritmo rientra perfettamente nel paradigma nella tecnica greedy !
### correttezza
introduciamo lo pseudocodice dell’algoritmo:
```
kursal(G):
	T = set()
	inizializza E con gli archi di G
	while E != []:
		estrai da E un arco (x,y) di peso minimo
		if l'inserimento di (x,y), in T non crea ciclo con gli archi in T:
			inserisci l'arco (x,y) in T
	return T
```
per dimostrare la correttezza dell’algoritmo, dobbiamo far vedere che al termine dell’algoritmo $T$ è un spanning tree e che non c’è un altro spanning tree che costa meno

>[!dimostrazione] dimostrazione
>**produce uno spanning tree**: 
>supponiamo per assurdo che al termine in $T$ ci sia più di una componente. 
>dato che il grafo di partenza $G$ per ipotesi è connesso, deve esistere (in $G$) un arco che connette le due componenti. dato che non è stato scelto dall’algoritmo, ciò implica che quando è stato estratto, avrebbbe creato un ciclo. (per creare un ciclo, sarebbe dovuto esistere già un cammino che collegava le due componenti). ma dato che non crea ciclo ad algoritmo terminato, non creava ciclo neanche al momento in cui è stato estratto, quindi sarebbe stato aggiunto a $T$ e non scartato
>
**non c’è uno spanning tree per $G$ che costa meno di $T$**:
>tra tutti i minimi spanning tree per $G$, prendiamo quello che differisce nel minor numero di archi da $T$: lo spanning tree $T^*$.
supponiamo per assurdo che il costo dell’albero $T$ prodotto dall’algoritmo abbia costo maggiore (e quindi sia diverso) di, $T^*$. faremo vedere che questa assuzione porterebbe all’assurdo perchè avrebbe come conseguenza l’esistenza di un altro minimo spanning tree per $G$ che differisce da $T$ in meno archi di $T^*$.
siano $e_{1},e_{2},\dots$ gli archi, in ordine, che sono stati considerati dall’algoritmo e sia $e$ il primo arco preso che non compare in $T^*$. aggiungendo $e$ a $T^*$, si crea sicuramente un ciclo $C$. il ciclo $C$ a sua volta, conterrà sicuraemtene un arco $e’$ che non appartiene a $T$,($T$ non può avere tutti gli archi del ciclo $C$,  altrimenti $e$ non sarebbe stato preso nell’algoritmo).
consideriamo ora l’albero $T'$ ottenuto aggiungendo $e$ e rimuovendo $e’$ a $T^*$. $$\text{costo (T') = costo(T*) - costo(e') + costo (e)}$$
>inoltre $\text{costo(e)} <= \text{costo(e')}$, infatti tra i due archi $e$ ed $e’$ che non creavano ciclo, l’algoritmo ha considerato prima l’arco $e$.
>ma allora $T’$ è un altro minimo spanning tree che differisce da $T$, ma in meno archi di quanto faccia $T^*$. ciò contraddice l’ipotesi che $T^*$ differisce da $T$ nel minor numero di archi.
`sort()` - flavio sperandeo

### implementazione
>[!info] implementazione
>**IDEE**:
>- con un pre-processing, ordino gli archi della lista $E$ cosicchè scorrendo la lista ottengo di volta in volta l’arco di costo minimo in tempo $O(1)$
>- verifico che l’arco $(x,y)$ non formi ciclo in $T$ controllando se $y$ è raggiungibile da $x$ in $T$ !!!
>```python
>de kursal(G):
>	E = [(c, u, v) for u in range (len(G)) for v, c in G[u] if u<v]
>	E.sort()
>	T = [[] for _ in G]
>	for c, u, v in E:
>		if not connessi(u, v, T):
>			T[u].append(v)
>			T[u].append(u)
>	return T
>	
>def connessi(x, y, T);
>	visitati = [0] * len(T)
>	return DFSr(x, y, T)
>
>def DFSr(a, b, T):
>	visitati[a] = 1
>	for z in T[a]:
>		if z == b: return True
>		if not visitati[z] and connessi(z, b, T): return True
>	return False	
>```
> complessità temporale:
>- l’ordinamento costa $O(m\log n) = O(m\log n^2) = O(m\log n)$
>- il `for`-loop viene iterato $m$ volte:
>	- controllare che un arco non crei ciclo richiede il costo di una visita di un grafo aciclico, quindi $O(n)$(un grafo aciclico conesso ha $n-1$ nodi). il `for` richiede quindi $O(n\cdot m)$
>
>la complessità dell’algoritmo è quindi $O(m \cdot n)$

per migliorare l’implementazione, non possiamo permetterci di pagare tempo $O(n)$ per ogni iterazione del `for` a causa della visita per testare la raggiungibilità.
## algoritmo di Kruskal con UNION-FIND
ricorriamo quindi alla struttura dati **UNION-FIND** (anche conosciuta come **disjoint-set** o **DSU**), che permette di testare efficientemente se due nodi appartengano o meno alla stessa componente connessa
è quindi una struttura dati $C$ che contiene le componenti connesse di un grafo di $n$ nodi, in modo tale che sia possibile **”efficientemente”** effetturare:
- `UNION(a, b, C)`: fonde due componenti connesse $a$ e $b$ in $C$ in tempo $O(1)$
- `FIND(x, C)`: trova in $C$ la componente connessa in cui si trova il nodo $x$, in tempo $O(\log n)$
studieremo più a fondo **UNION-FIND** ([[11 - union-find|qui]]), per ora implementiamo l’algoritmo di Kruskal usando la struttura dati union-find
### implementazione
>[!info] implementazione dell’algoritmo di kruskal con union-find
>```python
>def kruskal(G):
>	E = [(c, u ,v) for u in G for v,c in G[u] if u < v] # damn....
>	E.sort()
>	T = [[] for _ in G]
>	C = crea(T)
>	for c, u ,v in E:
>		cu = find(u, C)
>		cv = find(v, C)
>		if cu != cv:
>			T[x].append(y)
>			T[y].append(x) # grafo non diretto
>	return T
>
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
>calcoliamo la complessità temporale:
>- l’ordinamento costa $O(m\log n)$
>- il `for`-loop viene iterato $m$ volte:
>	- l’estrazione dell’arco minimo costa $O(1)$, in quanto iteriamo su $E$
>	- eseguire `FIND` costa $O(\log n)$
>	- eseguire `UNION` costa $\Theta(1)$, e viene eseguito esattamente $n-1$ volte (sono necessari $n-1$ archi)
>
>il costo del `for` è quindi $O(m\log n)$, che è la complessità totale dell’algoritmo

>[!info]