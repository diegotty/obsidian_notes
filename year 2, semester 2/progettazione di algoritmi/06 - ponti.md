---
related to: "[[02 - visita DFS]]"
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [ponti](#ponti)
>- [punti di articolazione](#punti%20di%20articolazione)

# ponti
un **ponte** è un arco la cui eliminazione disconnette il grafo
- i ponti rappresentano criticità del grafo ed è quindi utile identificarli

un grafo può non avere neanche un ponte così come avere tutti i suoi archi come ponti (come un albero !)
>[!example] grafi con ponti
![[Pasted image 20250313161103.png]]
>a sinistra un grafo senza ponti, a destra un grafo dove tutti gli archi sono ponti (albero)

>[!info] problema
dato un grafo connesso $G$, determinare l’insieme dei ponti del grafo

si può arrivare ad una prima soluzione usando la **ricerca esaustiva**: proviamo per ogni arco del grafo se esso è un ponte o meno
- verificare se un arco ${a,b}$ è un ponte per $G$ richiede $O(m)$ (basta eliminare l’arco e fare una ricerca DFS a partire da $a$ e vedere se si raggiunge $b$)
quindi, la complessità dell’algoritmo è:
$$
m\cdot O(m) = O(m^2) = O(n^4)
$$
in quanto $m = O(n^2)$ se il grafo non è sparso
>[!warning] è però possibile risolvere il problema in tempo lineare nella dimensione del grafo $O(m)$
basta infatti arrivare all’intuizione che devo controllare solo gli archi che vengono attraversati durante una visita ! in quanto sono quelli che bastano per un albero DFS e sono quelli che ci servono per visitare tutti i nodi ( gli altri sono “ridondanti”)
>- e ovviamente un arco non presente nell’albero DFS non può essere ponte, in quanto se lo elimino, gli archi dell’albero DFS continuano a garantire la connessione

quindi i ponti in un grafo non possono essere più di $n-1$ (numero di archi in un albero di $n$ nodi) (con questa ottimizzazione arriviamo a $O(n^3)$, ma si può fare molto di meglio !)

ci serve una caratterizzazione facile da calcolare, che ci consenta, durante la visita, di determinare se un arco dell’albero DFS è ponte o meno: notiamo che gli archi che non sono ponti sono **coperti** da archi non attraversati nella visita !
arriviamo allora alla seguente proprietà:
>[!warning] **proprietà**
> sia ${u,v}$ un arco dell’albero DFS con $u$ padre di $v$. 
> l’arco $u-v$ è ponte $\iff$ non ci sono archi tra i nodi del sottoalbero radicato in $v$ e il nodo $u$ o antenati di $u$
>>[!dimostrazione] dimostrazione
>$\implies$
>assumiamo per assurdo che $u-v$ sia ponte e che ci siano archi tra il sottoalbero radicato in $u$ e il nodo $u$ o suoi antenati, e che quindi esista un arco $x-y$, con $x$ antenato di $u$ e $y$ discendente di $v$ 
>dopo l’eliminazione di $u-v$, tutti i nodi dell’albero resteranno comunque collegato grazie all’arco $x-y$
>$\impliedby$
>l’eliminazione dell’arco $u-v$ disconnette i nodi dell’albero radicato in $v$ dal resto del grafo. infatti, in questo caso, tutti gli archi che non appartengono all’albero e che pardono da nodi del sottoalbero radicato in $v$, andrebbero verso $v$ o suoi discendenti

basta quindi fare in modo che il nodo $u$, dopo aver visitato $v$ e i suoi discendenti, sappia se esitono nodi che partono da $v$ o discendenti verso antenati di $u$. con questa informazione, si può capire se l’aco $u-v$ è ponte
>[!info] logica dell’algoritmo
per ogni arco **padre-figlio** $\{u,v\}$ presente nell’albero DFS di $G$, il nodo $u$ è in grado di scoprire se l’arco $\{u,v\}$ è o meno un ponte usando la seguente strategia:
per ogni nodo $v$(figlio di $u$):
>1. $v$ calcola la sua altezza nell’albero
>2. $v$ calcola e restituisce al padre ($u$) l’altezza **minima** che si può raggiungere con archi che partono dai nodi del suo sottoalbero diversi da ${v,u}$(che è l’arco da testare)
>
il nodo $u$, una volta ricevuta l’informazione dal figlio $v$, confronta la sua altezza con l’altezza minima restituita da $v$. se l’altezza minima è maggiore dell’altezza di $u$, allora l’arco ${u,v}$ è ponte.

>[!example] esempio
![[Pasted image 20250315211518.png]]

>[!info] algoritmo per individuazione di archi ponte
>```python
>def trova_ponti(G): #grafo connesso indiretto
>	altezza = [-1]*len(G)
>	ponti = []
>	dfs(0, -1, altezza, ponti)
>	return ponti
>def dfs(x, padre, altezza, ponti):
>	if padre == -1: #vero solo per root !
>		altezza[x] = 0
>	else:
>		altezza[x] = altezza[padre] + 1
>	min_raggiungibile = altezza[x]
>	for y in G[x]:
>		if altezza[y] == -1: #nodo non ancora visitato
>			b = dfs(y, x, altezza, ponti)
>			if b > altezza[x]:
>				ponti.append((x,y))
>			min_raggiungibile = min(min_raggiungibile, b) 
>		elif y != padre: #nodo già visitato, (x,y) è arco 
># all'indietro,il suo min_raggiungibile è sicuramente <= altezza[y]>
>			min_raggiunbile = min(min_raggiungibile, altezza[y])
>	return min_raggiungibile
>```
la complessità dell’algoritmo è $O(n+m)$, in quanto sto solamente modificando una visita DFS
 
# punti di articolazione
un **punto di articolazione** è un nodo la cui rimozione è in grado di sconnettere il grafo
- albero ha tutti punti di articolazione tranne le foglie ! 