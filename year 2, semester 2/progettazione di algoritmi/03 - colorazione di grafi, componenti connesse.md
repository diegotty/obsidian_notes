---
related to: "[[02 - visita DFS]]"
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [colorazione di grafi](#colorazione%20di%20grafi)
>	- [algoritmo per 2-colorabilità](#algoritmo%20per%202-colorabilit%C3%A0)
>- [componente connessa](#componente%20connessa)
>- [componente fortemente connessa](#componente%20fortemente%20connessa)
>	- [algoritmo per componenti fortemente connesse](#algoritmo%20per%20componenti%20fortemente%20connesse)
>		- [grafo trasposto](#grafo%20trasposto)
# colorazione di grafi
>[!info] il problema: 
>dato un grafo connesso **e indiretto** $G$ ed un intero $k$, vogliamo sapere se è possible colorare i nodi del grafo in modo che i nodi adiacenti abbiano sempre colori distinti. in quel caso, il grafo si dice $k \text{-colorabile}$

>[!example] esempio di grafo 3-colorabile
![[Pasted image 20250307225409.png]]
 
>[!info]- lore: teorema dei 4 colori
il teorema dei 4 colori dice che un [[01 - grafi#grafi planari|grafo planare]] richiede al più 4 colori per essere colorato
>- il problema venne posto per la prima vola nel 1852, e la prima dimostrazione fu proposta solo nel 1879
>- solo nel 1890 si scoprì che la dimostrazione contenteva un sottile errore, con cui però si riuscì a provare che 5 colori sono **sempre** sufficienti per colorare una mappa
>- una dimostrazione effettiva del teorema fu trovata solo nel 1977, e si basava sulla riduzione del numero infinito di grafi planari a 1936 possibili configurazioni, per le quali la validità del teorema viene verificata caso per caso, con l’ausilio di un calcolatore
>- l’utilizzo di un algoritmo per una dimostrazione, però, fece imbestialire i matematici che ne contestarono la validità, sia per l’impraticalità di una verifica manuale di tutti i casi possibili, sia per l’impossibilità di avere la certezza che l’algoritmo sia implementato correttamente
>- nel 2000 è stata trovata una dimostrazione che richiede l’utilizzo della teoria dei gruppi. 

>[!warning] in generale, un grafo può richiedere anche $\Theta(n)$ colori

non è noto nessun algoritmo polinomiale che, dato un grafo planare $G$, determini se $G$ è 3-colorabile. get to work people !!!! 
## algoritmo per 2-colorabilità
non è però difficile progettare un algoritmo che determini se un grafo è 2-colorabile:
$$
\text{un grafo è 2-colorabile} \iff \text{non contiene cicli di lunghezza dispari}
$$
in quanto un grafo di lunghezza dispari rende impossibile la colorazione del grafo con solo 2 colori
>[!info] algoritmo per 2-colorare un grafo
usiamo un algoritmo per 2-colorare il grafo, che per ipotesi non ha cicli dispari:
>1. colora il nodo 0 con il colore 0
>2. effettua una visita DFS a partire dal nodo 0. nel corso della visita, assegna a ciascun nodo $x$ un colore tra 0 e 1, in modo che sia diverso dal colore assegnato al nodo padre di $x$

>[!dimostrazione] prova di correttezza dell’algoritmo di sopra
siano $x$ e $y$ due nodi adiacenti in $G$. consideriamo i due possibili casi e facciamo vedere che in entrambi i casi i due nodi al termine dell’algoritmo avranno colori opposti:
>- l’arco $(x,y)$ viene attraversato durante la visita: in questo caso banalmente i due nodi hanno colori distinti
>- l’arco $(x,y)$ non viene attraversato durante la visita: ciò vuol dire che esiste un cammino in $G$ che da $x$ porta a $y$ (il cammino seguito dalla visita), e questo cammino si chiude a formare un ciclo con l’arco $(x,y)$. per ipotesi, il ciclo è di lunghezza pari, quindi il cammino è di lunghezza dispari. poichè i colori si alternano, il primo nodo ($x$) avrà un colore diverso dall’ultimo nodo ($y$)

>[!info] algoritmo per 2-colorare un grafo **connesso** $G$ senza cicli dispari
>```python
>def Colora(G):
>	Colore = [-1] * len(G)
>	DFSr(0, G, Colore, 0)
>	return Colore
>
>def DFSr(x, G, Colore, c):
>	Colore[x] = c
>	for y in G[x]:
>		if Colore[y] == -1:
>			DFSr(y, G, Colore, 1-c)
>```
(se il grafo contiene cicli dispari, l’algoritmo produce un assegnamento di colori sbagliato)

>[!info] algoritmo che 2-colora un albero se possibile, altrimenti ritorna una lista vuota
>```python
>def Colora(G):
>	Colore = [-1] * len(G)
>	if DFSr(0, G, Colore, 0):
>		return Colore
>	return []
>
>def DFSr(x, G, Colore, c):
>	Colore[x] = c
>	for y in G[x]:
>		if Colore[y] == -1:
>			if not DFSr(y, G, Colore, 1-c):
>				return False
>		elif Colore[y] == Colore[x]:
>			return False	
>	return True
>```
la magia della ricorsione
la complessità dell’algoritmo per testare se un grafo è bicolorabile è quella di una semplice visita del grafo connesso da colorare !! quindi $O(n+m)=O(m)$(in quanto in un grafo connesso $m\geq n-1$)
# componente connessa
una **componente connessa** (anche chiamata semplicemente **componente**) di un grafo (**indiretto**), è un sottografo composto da un insieme massimale di nodi connessi da cammini
>[!warning] un grafo si dice connesso se ha **solo una** componente connessa

per calcolare il vettore $C$ delle componenti connesse di un grafo $G$, $C$ dovrà avere tanti elementi quanti sono i nodi del grafo, e 
$$
C[u]=C[v] \iff  u \text{ e } v \text{ sono della stessa componente connessa}
$$  
>[!example] esempio
![[Pasted image 20250308101529.png]]
per questo grafo, il vettore delle componenti è questo:
![[Pasted image 20250308101940.png]]

>[!info] algoritmo per calcolo del vettore delle componenti
>```python
>def Componenti(G):
>	c = [0] * len(G)
>	c = 0
>	for x in range(len(G)):
>		if C[x] == 0:
>			c += 1
>			DFSr(x, G, C, c)
>	return C
>
>def DFSr(x, G, C, c):
>	C[x]= c
>	for y in G[x]:
>		if C[y] == 0:
>			DFSr(y, G, C, c)
>```
>la complessità della procedura è $O(n+m)$,  perchè pur facendo più volte una visita, ogni visita verrà fatta su parti diverse del grafo !
# componente fortemente connessa
la **componente fortemente connessa** di un grafo diretto è un sottografo composto da un insieme massimale di nodi connessi da cammini
>[!warning] un grafo diretto si dice fortemente connesso se ha **una sola** componente

il vettore $C$ delle componenti fortemente connesse di un grafo ha la stessa struttura del vettore per le componenti connesse di un grafo
>[!example] esempio
![[Pasted image 20250308103454.png]]
![[Pasted image 20250308103735.png]]

si nota come l’algoritmo per trovare le componenti connesse non funziona nel caso di componenti fortemente connesse (basta pensare ad una catena, $0 \to1 \to 2 \to 3 \to 4$)
- questo perchè non basta avere un cammino che da $x$ mi porta ad $y$, ma deve esistere anche un cammino che da $y$ porta ad $x$
## algoritmo per componenti fortemente connesse
dato un grafo diretto $G$, per trovare i nodi della componente fortemente connessa che contiene $u$, strutturiamo l’algoritmo in questo modo:
1. calcola l’insieme $A$ dei nodi di $G$ raggiungibili da $u$
2. calcola l’insieme $A$ dei nodi di $G$ che portano a $u$
3. restituisci l’intersezione dei due insiemi $A$ e $B$

calcoliamo ora la complessità temporale:
- il passo 1 richiede $O(n+m)$, in quanto è una semplice visita DFS da $u$
- passo 2 ?
- il passo 3 costa $O(n)$, in quanto lo facciamo in questo modo: $A$ e $B$ sono due vettori con tanti elementi quanti sono i nodi in $G$. 
	- $A[i] =1 \iff i \text{ è raggiunto da } u$
	- $B[i] =1 \iff u \text{ è raggiunto da } i$

per eseguire efficientemente il passo 2, ricorriamo al **grafo trasposto di G**
### grafo trasposto
dato un grafo diretto $G$, il grafo trasposto di $G$, denotato con $G^T$, ha gli stessi nodi di $G$, ma gli archi hanno direzione opposta
>[!example] esempio di grafo trasposto
![[Pasted image 20250308110502.png]]

>[!warning] i nodi che in $G$ portano ad $u$, sono i nodi che in $G^T$ sono raggiungibili a partire da $u$, e viceversa !

possiamo quindi trovare l’insieme $B$, nel passo 2, cercando i nodi raggiungibili da $u$ in $G^T$(che andrà prima costruito), quindi una visita ($O(n+m)$)
>[!info] algoritmo per componente fortemente connessa contenente $x$
>```python
>def ComponenteFC(x, G):
>	visitati1 = DFS(x, G)
>	G1 = Trasposto(G)
>	visitati2 = DFS(x, G1)
>	componente = []
>	for i in range((lenG)):
>		if visitati1[i] == visitati2[i] == 1:
>			componente.append()
>	return componente
>
>def Trasposto(G):
>	GT = [[] for _ in G] 
>	for i in range (len(G)):
>		for v in G[i]:
>			GT[v].append(i)
>	return GT
>```
l’algoritmo ha complessità $O(n+m)$, in quanto calcolare il grafo traposto di $G$ costa $O(n+m)$, e non va a superare la complessità delle 2 visite.

>[!info] algoritmo per il calcolo del **vettore CF** delle componenti fortemente connesse
>```python
>def compFC(G):
>	FC = [0] * len(G)
>	c = 0
>	for i in range(len(G)):
>		if FC[i] == 0:
>			E = ComponenteFC(i, G)
>			c += 1
>			for x in E:
>				FC[x] = c
>	return FC
>```
>la complessità dell’algoritmo è $n\cdot O(n+m) = O(n^2 + m \cdot n) = O\left( n^2 + \frac{n^2}{2} \cdot n \right) = O(n^3)$

>[!example] caso pessimo
>consideriamo un grafo diretto $G$ avente un arco da $u$ a $v$ per ogni coppia di nodi ($u$, $v$) con $u \leq v$
questo grafo ha $\Theta(n^2)$ archi e $n$ componenti fortemente connesse(ognuna da un singolo nodo)

>[!warning] per il calcolo del vettore CF esistono diversi algoritmi non banali che lavorano in tempo $O(n+m)$ !! (algoritmo di tarjan, o kosaraju)