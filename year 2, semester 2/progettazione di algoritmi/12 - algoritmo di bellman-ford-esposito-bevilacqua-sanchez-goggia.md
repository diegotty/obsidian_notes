---
related to: "[[09 - algoritmo di dijkstra]]"
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [algoritmo di bellman-ford](#algoritmo%20di%20bellman-ford)
>	- [cicli negativi](#cicli%20negativi)
>	- [algoritmo di bellman-ford](#algoritmo%20di%20bellman-ford)
>		- [implementazione](#implementazione)
>	- [variazione: dal costo ai cammini](#variazione:%20dal%20costo%20ai%20cammini)
# algoritmo di bellman-ford
>[!info] problema
>dato un grafo diretto e pesato $G$, in cui i pesi degli archi possono essere anche **negativi** e fissato un suo nodo $s$, vogliamo determinare il costo minimo dei cammini che conducono da $s$ a tutti gli altri nodi del grafo. (se non esiste un cammino verso un determinato nodo, il costo sarà considerato infinito)

>[!warning] ricordiamo !!
>se il grafo è un DAG, per trovare le distanze (minime) mi basta un sort topologico (anche se ha pesi negativi). abbiamo fatto un esercizio a riguardo !

>[!info] lessico
>se i costi degli archi possono essere negativi, non ha senso parlare di distanze, in quanto la distanza è una metrica (e come tale non può essere negativa). si parla quindi di costo dei cammini

## cicli negativi
si nota subito come, affichè esista un cammino negativo, non può esistere un **ciclo negativo**, cioè un ciclo diretto in un grafo in cui la soma dei pesi degli archi che lo compongono è negativa
>[!example]- esempio di ciclo negativo
![[Pasted image 20250330095306.png]]
> il ciclo evidenziato in figura è negativo, di costo -2

infatti, se in un cammino tra i nodi $s$ e $t$ è presente un nodo che appartiene ad un ciclo negativo $W$, allora non esiste un cammino minimo tra $s$ e $t$: ripassando più volte attraverso il ciclo $W$, possiamo abbassare arbitrariamente il costo del cammino da $s$ a $t$ !
affinchè esista un cammino minimo, non devono esistestere cicli negativi (percorro molteplici volte il ciclo negativo e il costo del cammino diminuisce all’infinito)

>[!info] dijkstra
il problema affrontato è lo stesso problema che viene risolto dall’[[09 - algoritmo di dijkstra|algoritmo di dijkstra]], che però non prevede l’esistenza di archi negativi
>- questo perchè l’algoritmo di dijkstra non permette di aggiornare i costi una volta decisi, e tale assunzione si rivela errata se esistono archi di peso negativo
## algoritmo di bellman-ford
vediamo allora un algoritmo più adatto, basato sulla tecnica della **programmazione dinamica**(uno dei due *sledgehammers* della creazione di algoritmi, applicabili su una vasta categoria di problemi, con compromesso un maggiore costo computazionale)

partiamo dall’intuizione di una proprietà: 
>[!dimostrazione] proprietà
>se il grafo $G$ non contiene cicli negativi, allora per ogni nodo $t$ raggiungibile dalla sorgente $s$ esiste un cammino di costo minimo che attraversa al più $n-1$ archi.
>
>infatti, se un cammino avesse più di $n-1$ archi, allora almeno un nodo verrebbe ripetuto, formando un ciclo. ma il ciclo deve essere per forza positivo, quindi rimuovere eventuali cicli dal cammino non può aumentare il suo costo complessivo.
>di conseguenza, esiste sempre un cammino ottimale di lunghezza (massimo ?) $n-1$.
>- questo garantisce che il costo minimo può essere calcolato considerando solo cammini di questa lunghezza !

questa proprietà suggerisce di considerare sottoproblemi che si ottengono limitando la lunghezza dei cammini (aumentandola iterativamente, fino ad arrivare ad $n-1$). definiamo così la seguente tabella, di dimensione $n \cdot n$:
$$
\text{T[i][j]=costo di un cammino minimo da $s$ al nodo $j$, di lunghezza al più $i$}
$$
popolando la tabella ad ogni riga, la soluzione sarà data dagli $n$ valori che troviamo nell’ultima riga:
$$
\text{T[n-1][0], \, T[n-1][1], \, T[n-1][2], \, $\dots$  \,T[n-1][n-1]}
$$
ci resta ora da definire la regola che permette di calcolare i valori delle celle $\text{T[i][j]}$ con $j \neq s$ della riga $i > 0$, in funzione delle celle già calcolate dalla riga $i-1$ 
- ($T[i][s] = 0 \,\forall i>0$, e $T[0][j] = \infty$). 
distinguiamo i due casi:
1. il cammino di lunghezza al più $i$ da $s$ a $j$ ha lunghezza esattamente $i$
	 $T[i][j] = T[i][j-1]$.
2.  il cammino di lunghezza al più $i$ da $s$ a $j$ ha lunghezza inferiore ad $i$
	nel secondo caso, invece, deve esistere un cammino minimo di lunghezza al più $i-1$ ad un nodo $x$, e poi un arco $(x,j)$. quindi:
	$$
	\text{T[i][j] = $min_{(x,j) \in E}$} \bigg(\text{ T[i-1][x] + costo(x,j)} \bigg)
	$$
>[!figure] illustrazione del secondo caso
![[Pasted image 20250330103330.png]]

non sapendo a priori in quale dei due casi siamo, la formula giusta è:
$$
\text{T[i][j]=} \Bigg(\text{min(T[i-1][j]), $min_{(x,j) \in E}$} \bigg( \text{T[i-1][x] + costo(x,j)}\bigg)\Bigg)
$$
love me some comically large parenthesis. oversized parenthesis.
>[!info] ottimizzazione
per un’implementazione più efficiente, poichè nel calcolo della formula è necessario più volte conoscere gli archi entranti nel generico nodo $j$, conviene precalcolare il grafo trasposto $G^T$ di $G$. questo permette di accedere rapidamente agli archi entranti di un nodo, migliorando l’efficienza
### implementazione
>[!info] implementazione dell’algoritmo di bellman-ford
>```python
>def CostoCammini(G, s):
>	n = len(G)
>	inf = float('inf')
>	T = [ [inf]*n for _ in range(n)]
>	T[0][s] = 0
>	GT = Trasposto(G)
>	for i in range(1, n): #righe della matrice
>		for j in range(n): #nodi per ogni riga
>			T[i][j] = T[i-1][j]	
>			for x, costo in GT[j]:
>				T[i][j] = min(T[i][j], T[i-1][x] + costo)
>	return T[n-1]
>
>def Trasposto(G):
>	n = len(G)
>	GT = [ [] for _ in G]
>	for i in range(n):
>		for j, costo in G[i]:
>			GT[j].append((i, costo))
>	return GT
>```
>calcolo della complessità temporale:
>- l’inizializzazione della tabella T richiede $O(n^2)$
>- la costuzione del grafo traposto, $G^T$ richiede $O(n+m)$
>- per i tre `for`-loop annidati, è ovvio l’upper bound di $O(n^3)$. tuttavia è possibile, con un’analisi più attenta, arrivare ad un limite più stretto:
> 	- i due `for` interni hanno un costo totale di $O(m)$. sostanzialmente il tempo richiesto è quello di scorrere tutte le liste di adiacenza del grafo $G^T$, che hanno lunghezza totale $m$ (immagino sia $O(m+n)$)
>
>la complessità totale è quindi di $O(n^2 + n \cdot m)$

## variazione: dal costo ai cammini
per trovare anche i cammini oltre che al loro costo, con la tabella $T$ bisogna calcolare anche l’albero $P$ dei cammini minimi. questo si può fare facilmente mantenendo per ogni nodo $j$ il suo predecessore, cioè il nodo $u$ che precede $j$ nel cammino. il valore di $P[j]$ andrà aggiornato ogni volta che il valore di $\text{T[i][j]}$ cambia, in quanto abbiamo trovato un cammino migliore
>[!info] implementazione dell’algoritmo per i cammini minimi
>```python
>def CostoCammini(G, s):
>	n = len(G)
>	inf = float('inf')
>	T = [ [inf]*n for _ in range(n)]
>	T[0][s] = 0
>	P = [-1]*n
>	P[s] = s
>	GT = Trasposto(G)
>	for i in range(1, n): #righe della matrice
>		for j in range(n): #nodi per ogni riga
>			T[i][j] = T[i-1][j]	
>			for x, costo in GT[j]:
>				if T[i-1][x] + costo < T[i][j]:
>					T[i][j] = T[i-1][x] + costo
>					P[j] = x
>	return T[n-1]
>
>def Trasposto(G):
>	n = len(G)
>	GT = [ [] for _ in G]
>	for i in range(n):
>		for j, costo in G[i]:
>			GT[j].append((i, costo))
>	return GT
>```
>a fine algoritmo:
>- $\text{T[n-1][j]}\neq \infty$: $j$ è raggiungibile da $s$, e $P[j]$ conterrà il nodo che precede $j$ nel cammino minimo da $s$ a $j$
>- $\text{T[n-1][j]} = \infty$: $j$ non è raggiungibile da $s$, e $P[j]$ conterrà -1
(in pratica calcoliamo il vettore dei padri x i cammini minimi, non so se si può chiamare vettore dei padri visto che non è un albero)

>[!tip] ottimizzazioni
>il contenuto di una cella della riga $k$ dipende dal contenuto delle celle alla riga $k-1$, quindi:
>- se la riga $k$ di $T$ è uguale alla riga $k-1$, anche le righe seguenti non varieranno, e si può terminare l’algoritmo (questo accorgimento non modifica la complessità asintotica, ma in pratica può contare molto)
>- non serve memorizzare l’intera tabella $T$, ma bastano le ultime 2 righe. perciò l’algoritmo può essere facilmente modificato in modo da utilizzare memoria $O(n)$ anzichè $O(n^2)$

>[!info] ps
a priori noi non sappiamo se un albero ha cicli negativi o no, ma possiamo modificare l’algoritmo di bellman-ford per scoprire se il grafo contiene cicli negativi raggiungibili da $s$:
>- calcola una riga in più della tabella: la riga $n$:
>
>e righe $n$ ed $n-1$ sono uguali $\iff$ non ci sono cicli negativi raggiungibili da $s$
