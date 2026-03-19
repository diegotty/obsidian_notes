---
related to: "[[01 - grafi]]"
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [BFS](#BFS)
>	- [albero BFS](#albero%20BFS)
>	- [vettore delle distanze](#vettore%20delle%20distanze)

# BFS
la **BFS** (breath-first-search) ci permette di visitare un albero con una logica diversa (e opposta) alla DFS:
la BFS esplora i nodi del grafo partendo da quelli a distanza 1 dalla sorgente $s$. poi visita quelli a distanza 2, e così via.
- l’algoritmo visita quindi tutti i vertici a livello $k$ prima di passare a quelli di livello $k+1$
>[!example] esempio di BFS
![[Pasted image 20250316171554.png]]

>[!info] logica dell’implementazione
per effettuare questo tipo di visita, manteniamo in una **coda** i nodi esaminati i cui adiacenti non sono stati ancora esaminati. ad ogni passo, preleviamo il primo nodo dalla coda, esaminiamo i suoi adiacenti e se scopriamo un nuovo nodo, lo aggiungiamo alla coda

>[!info] prima implementazione della BFS (naive)
>```python
>def BFS(x, G):
>	visitati = [0]*len(G)
>	visitati[x] = 1
>	coda = [x]
>	while coda:
>		u = coda.pop(0)
>		for y in G[u]:
>			if visitati[y] == 0:
>				visitati[y] = 1
>				coda.append(y) # y va in coda solo se non visitato
>	return visitati	
>```
la complessità di questo algoritmo è $O(n^2) !!!! perche:
>- un nodo finisce in coda al più una volta, quindi il while verrà eseguito $O(n)$ volte
>- allo stesso modo, le liste di adiacenza verrano scorse al più una volta, quindi il costo totale dei `for` loop sarà $O(m)$
>- il problema però è l’implementazione della coda: l’`append` in coda costa $O(1)$, mentre il `pop(0)` ha un costo proporzionale alla dimensione della lista, e può quindi arrivare a costare $O(n)$, per una complessità totale:
>$$
> \Theta(n) + \Theta(1) + O(m) + O(n^2) = O(n^2)
> $$

>[!example]- caso pessimo dell’algoritmo di sopra
![[Pasted image 20250316172631.png]]

>[!dimostrazione]- dimostrazione della correttezza dell’algoritmo
alla fine dell’esecuzione dell’algoritmo, `visitati[i]` contiene 1 $\iff$ il nodo $u$ è raggiungibile da $x$
>- **se $u$ è raggiungibile da $x$, allora `visitati[u]`=1**: esiste quindi un cammino $P$ da $x$ a $u$. supponiamo per assurdo che al termine dell’algoritmo, `visitati[u]`=0. uhhhh cba ngl
>- 

>[!info] implementazione con cancellazioni logiche
>```python
>def BFS(x, G):
>	visitati = [0]*len(G)
>	visitati[x] = 1
>	coda = [x]
>	i = 0
>	while len(coda) > i:
>		u = coda[i]
>		i++
>		for y in G[u]:
>			if visitati[y] == 0:
>				visitati[y] = 1
>				coda.append(y) # y va in coda solo se non visitato
>	return visitati	
>```
in questa implementazione, effettuiamo solo cancellazioni logiche: usiamo un puntatore che che indica l’inizio della coda ! in questo modo la complessità di questo algoritmo è $O(n+m)$

>[!warning] le visite BFS e DFS, se implementate nel modo giusto, hanno la stessa complessità
>si sceglie quindi l’una al posto dell’altra in base al tipo di problema che si affronta

>[!info] implementazione con uso di `deque`
possiamo importare, dal modulo `collections` di python, la struttura dati `deque`(double ended queue), che consente di effettuare inserimenti e cancellazioni da entrambi i lati in $O(1)$
>- la `deque` è implementata da python tramite una double linked list, ottimizzata per operazioni efficienti in entrambi gli estremi
![[Pasted image 20250316174218.png]]
>```python
>def BFS(x, G):
>	visitati=[0]*len(G)
>	visitati[x] = 1
>	from collections import deque
>	coda = deque([x])
>	while coda:
>		u = coda.popleft()
>		for y i G[u]:
>			if visitati[y] == 0:
>				visitati[y] = 1
>				coda.append(y)
>	return visitati
>
>```

## albero BFS
modifichiamo la procedura in modo che restituisca in $O(n+m)$ l’albero di vista BFS, rappresentato tramite il [[02 - visita DFS#vettore dei padri|vettore dei padri]]
>[!example]- esempi di alberi BFS
![[Pasted image 20250316174703.png]]

>[!info] implementazione di BFS che ritorna albero BFS
>```python
>def BFSpadri(x, G):
>	P = [-1]*len(G)
>	P[x] = x
>	coda = [x]
>	i = 0
>	while len(coda) > i:
>		u = coda[i]
>		i++
>		for y in G[u]:
>			if P[y] == -1:
>				P[y] = u
>				coda.append(y)
>	return P
>```

>[!warning] proprietà
>la **distanza minima** di un vertice $x$ da $s$(sorgente) nel grafo $G$ equivale alla profondità di $x$ nell’albero BFS. è per questo che l’albero BFS è anche detto **albero dei cammini minimi**
>>[!dimostrazione]- dimostrazione
>> you caught me lacking. i aint got time for this ngl
## vettore delle distanze 
dati due nodi $a$ e $b$ di un grafo $G$, definiamo **distanza(minima)** in $G$ di $a$ da $b$ il numero minimo di archi che bisogna attraversare per raggiungere $b$ partendo da $a$.
- la distanza è posta a $+\infty$ se $b$ non è raggiungibile da $a$
>[!example]- distande di ogni nodo dal nodo $0$
![[Pasted image 20250316171248.png]]

il **vettore delle distanze** $D$ contiene quindi, in $D[y]$ la distanza di $y$ da $a$
modifichiamo quindi la visita BFS per far ritornare il vettore delle distanze:
>[!info] visita BFS che ritorna vettore delle distanze
>```python
>def BFSdistanze(x, G):
>	D = [-1]*len(G)
>	D[x] = 0
>	coda = [x]
>	i = 0
>	while len(G) > i:
>		u = coda[i]
>		i++
>		for y in G[u]:
>			if D[y] == -1:
>				D[y] = D[u] + 1
>				coda.append(y)
>	return D
>```
