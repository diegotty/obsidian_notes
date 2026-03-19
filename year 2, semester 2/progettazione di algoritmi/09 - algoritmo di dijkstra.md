---
related to: "[[08 - grafi pesati]]"
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [algoritmo di dijkstra](#algoritmo%20di%20dijkstra)
>	- [tecnica greedy](#tecnica%20greedy)
>	- [correttezza](#correttezza)
>	- [implementazione](#implementazione)
# algoritmo di dijkstra
>[!info] problema
> dato un grafo pesato, vogliamo trovare i cammini minimi e quindi anche le distanze da un certo nodo $s$(sorgente) a tutti gli altri nodi del grafo
>**esempio:**
![[Pasted image 20250320111744.png]]

**l’algoritmo di dijkstra** è un algoritmo iterativo, che risolve il problema procedendo per passi(iterazioni) e prendendo una decisione ad ogni passo:
>[!info] logica dell’algoritmo
>costruisci l’albero dei cammini minimi un arco alla volta, partendo dal nodo sorgente:
>- ad ogni passo aggiungi all’albero l’arco che produce il nuovo cammino più economico (valutando tutti i possibili cammini da un nodo già visitato ad un nodo non visitato tramite un solo arco)
>- alla nuova destinazione assegna come distanza il costo del cammino
>
> a fine algoritmo, ogni nodo avrà la sua distanza minima dalla sorgente !
>- è quindi una visita, ma più intelligente di DFS e BFS, in quanto non prende sempre una decisione scelta a priori  

## tecnica greedy
l’algoritmo è il primo esempio che affrontiamo del **paradigma della tecnica greedy**:
- **si prendono una sequenza di decisioni irrevocabili**: ad ogni passo si decide il cammino dal nodo sorgente ad un nuovo nodo, e una volta deciso il cammino, non si può più tornare indietro sulla decisione !
- **le decisioni vengono prese in base ad un criterio “locale”**: tra tutti i nuovi cammini che si possono trovare estendendo i vecchi cammini di un arco, si sceglie quello che costa meno
>[!warning] svantaggi della tecnica greedy
l’applicazione di queste due regole porta ad algoritmi molto efficienti, infatti la tecnica greedy è infatti la prima tecnica che dovremmo provare ad applicare, di fronte ad un problema. 
>spesso però, produce una soluzione **subottimale**, in quanto non capita sempre che la scelta di una soluzione “locale” ottimale porti ad una soluzione globale ottimale
>- gli algoritmi greedy sono infatti spesso usati se non esistono algoritmi che trovano una soluzione corretta in tempo polinomiale, e si può dimostrare che l’algoritmo greedy ha un margine di errore piccolo

>[!tip] in questo caso l’algoritmo in porta alla soluzione **ottima** nei casi in cui l’algoritmo è corretto.
> infatti bisogna subito notare che l’algoritmo di dijkstra non è corretto nel caso di grafi con pesi anche negativi ! (può sbagliare, ma non è detto che sbagli sempre !)
## correttezza
dimostriamo la correttezza dell’algoritmo di dijkstra ! introduciamo lo pseudocodice dell’algoritmo:
```
Dijkstra(s, G):
- P[0...n-1] vettore dei padri inizializzato a -1
- D[0...n-1] vettore delle distanze inizializzato a +inf
- D[s], P[s] = 0, s
- while esistono archi {x, y} con P[x] != -1 e P[y] == -1:
	- sia {x,y} quello per cui è minimo D[x] + peso(x,y)
	- D[y], P[y] = D[x] + peso(x,y), x
return P, D
```
ad ogni iterazione del while viene assegnata una nuova distanza ad un nodo. per induzione sul numero di iterazioni, mostreremo che la distanza assegnata è quella minima
>[!dimostrazione] dimostrazione
caso base: $i=0$
>- i pesi sono non-negativi, quindi non esiste un cammino minimo tra $s$ ed $s$ minore di 0, di conseguenza il cammino minimo è 0 (non ci si muove)
>
>ipotesi induttiva: $i$
>- assumiamo che i cammini scelti dall’algoritmo per i primi $i$ passi siano cammini minimi
>
>passo induttivo: $i+1$
>- sia $T_{i}$ l’albero dei cammini minimi costruito fino al passo $i>0$, e sia $(u,v)$ l’arco aggiunto all’albero al passo $i+1$. faremo vedere che $D[v]$ è la distanza minima da $s$ a $v$. per fare ciò, basta mostrare che il costo di un eventuale cammino alternativo è sempre superiore o uguale a $D[v]$
>	- sia $C$ un qualsiasi cammino da $s$ a $v$ alternativo a quello presente nell’albero, e $(x,y)$ il primo arco che incontriamo percorrendo tale cammino $C$ all’indietro, tale che $x$ è nell’albero $T_{i}$ e $y$ no (tale arco deve esistere perchè $s$ è in $T_{i}$ mentre $v$ no). (prendiamo quindi in considerazione cammini che l’algoritmo non avrebbe potuto scegliere alla $i+1$-esima iterazione, in quanto $y$ non è stato ancora visitato.)
>	- per ipotesi induttiva, $\text{costo(C)} \geq \text{Dist(x) + peso(x,y)}$. (**questa affermazione è vera perchè i pesi del grafo sono tutti negativi**) (se non ci fosse stata una menzione del fatto che i pesi devono essere per forza positivi, la dimostrazione sarebbe stata sbagliata !)
>	- l’algoritmo ha preferito estendere l’albero $T_{i}$ con l’arco $(u,v)$ anzichè l’arco $(x,y)$, e in base alla regola con cui l’algorimo sceglie l’arco con cui estende l’ablero, deve quindi aversi: $D[x] + p(x,y) >= D[u]+p(u,v)$
>	- da cui segue che $\text{costo(C)} >= D[x] + \text{peso(x,y)} >= D[u] + p(u,v) = D[v]$
>	- quindi il cammino alternativo ha costo superiore a $D[v]$
![[Pasted image 20250320120024.png]]


## implementazione
>[!info] rappresentazione di grafi pesati
rappresenteremo il grafo pesato tramite lista di adiacenza, in cui: nella lista di adiacenza di $x$, invece di trovare solo il nodo di destinazione $y$, ci sarà la coppia $(y,c)$ dove $c$ è il peso dell’arco

>[!info] implementazione con lista
**IDEA**:
>nel vettore `lista`, per ogni nodo memorizziamo una terna nella forma `(definitivo, costo, origine)`, in cui, per un nodo $x$:
>- **definitivo**: è un flag che assume il valore 1 se il costo per raggiungere $x$ è stato stabilito “definitivamente”, cioè è stato scelto come nuovo nodo da raggiungere ad un dato passo
>- **costo**: rappresenta il costo corrente minimo noto per raggiungere $x$ dalla sorgente $s$. all’inizio, per ogni nodo diverso da $s$, questo valore sarà inizializzato a $+\infty$, e per $s$ a 0. durante l’esecuzione dell’algoritmo, i valori possono essere aggiornati quando si trova un percorso migliore
>- **origine**: indica l’ultimo predecessore di $x$ lungo il cammino dalla sorgente $s$ a $x$. se ancora non è stato trovato un percorso per $x$ oppure $x$ non ha predecessore, questo valore è inizialmente impostato a -1
>
>all’inizio l’unico nodo nell’albero è la sorgente, e di conseguenza la lista è inizializzata come segue:
>$$
>\text{Lista}[x]=
>\begin{cases}
>(1,0,s)&\text{se } x=s \\
>(0, costo, s)&\text{se }(costo,x)\in G[s] \\
>(0,+\infty,-1)&\text{altrimenti}
>\end{cases}
>$$
>```python
>def dijkstra(s, G):
>	n = len(G)
>	lista = [0, float('inf'), -1] * n
>	lista[s] = (1, 0, s)
>	for (y, costo) in G[s]: # aggiorno i nodi vicini di s
>		lista[y] = (0, costo, s)
>	while True:
>		minimo, x = float('inf'), -1
>		for i in range(n):
>			if lista[i][0] == 0 and lista[i][1] < minimo:
>				minimo, x = min(lista[i][1]), i
>		if minimo == float('inf'): #non ci sono nuovi nodi raggiungibili
>			break
>		definitivo, costo_x, origine = lista[x]
>		lista[x] = (1, costo_x, origine) #setto solo definitivo
>		for y, costo_arco in G[x]: #aggiorno eventuali vicini di x (n.d)
>			if lista[y][0] == 0 and minimo+costo_arco < lista[y][1]:
>				lista[y] = (0, minimo + costo_arco, x)	
>	D, P = [costo for _, costo, _ in lista], [origine for _, _, origine in lista]
>	return D, P
>```
>costo computazionale:
>- il costo delle istruzioni al di fuori del `while` è $\Theta(n)$
>- il `while` viene eseguito al più $n-1$ volte, e all’interno del while c’è:
>	- un primo `for` loop che viene iterato esattamente $n$ volte
>	- un secondo $for$ che viene eseguito al più $n$ volte
>
> il costo del `while` è quindi $\Theta(n^2)$, che è la complessità dell’algoritmo

se si potesse evitare di scorrere ogni volta il vettore `lista` alla ricerca della posizione in cui è presente il minimo, eviteremmo di pagare $O(n)$ ad ogni iterazione del while.
sostituendo il vettore `lista`  con un **heap minimo**, potremmo estrarre l’elemento in tempo logaritmico nel numero di elementi presenti nell’heap !

>[!info] implementazione con heap
>**IDEA**:
>manteniamo un **heap minimo** contenente triple $(\text{costo}, u, v)$ dove $u$ è un nodo già inserito nell’albero dei cammini minimi e $\text{costo}$ rappresenta la distanza che si avrebbe qualora il nodo $y$ venisse inserito nell’albero dei cammini minimi attraverso il nodo $x$
>in questo modo, a ogni estrazione dall’heap possiamo individuare in tempo logaritmico nella dimensione dell’heap il nodo $v$ da inserire nell’albero, il costo da assegnargli come distanza da $s$ e il padre $u$ a cui collegarlo
>- ogni volta che aggiungiamo un nodo $x$ all’albero, aggiorniamo anche l’heap inserendo, per ogni vicino $y$ di $x$, una nuova tripla $\text{(distanza\_aggiornata, x, y)}$. poichè ogni inserimento ha costo logaritmico nella dimensione dell’heap, il tempo complessivo rimange gestibile. inoltre, dato che non rimuoviamo elementi già presenti nell’heap, possono esistere più entri dello stesso nodo $y$ con distanze differenti, e dopo aver inserito per la prima volta $y$, gli altri cammini possono essere ignorati
>```python
>def dijkstra1(s, G):
>	n = len(G)
>	D = [float('inf')] * n
>	P = [-1] * n #vettore dei padri
>	D[s] = 0 #vettore delle distanze
>	H = []
>	for y, costo in G[s]:
>		heappush(H, (costo, s, y))
>	while H:
>		costo, x, y = heappop(H)
>		if P[y] = -1:
>			P[y] = x
>			D[y] = costo
>			for v, peso in G[y]:
>				if P[v] == -1:
>					heappush(H, (D[v] + peso, y, v))
>	return D, P
>```
>costo computazionale:
>nell’heap ci possono essere anche $O(m)$ elementi, e quindi i costi di inserimento ed estrazione saranno $O(\log m) = O(\log n^2) = O(\log n)$ (proprietà dei logaritmi !)
>- l’inizializzazione di $D$ e $P$ costa $\Theta(n)$, e l’inserimento dei vicini di $s$ nell’heap ha un costo di $O(n\log n)$
>
>abbiamo poi un `while`-loop con dentro un `for`-loop:
>- ad ogni iterazione del `while`, si elimina un elemento da $H$ e si potrebbe scorrere la lista di adiacenza di un nodo per aggiungere elementi ad $H$. ogni lista di adiacenza può essere scorsa al massimo una volta, quindi ad $H$ possono essere aggiunti al più $O(m)$ elementi. quindi il numero di iterazioni del while è $O(m)$
>- senza tener conto del `for` annidato, ogni iterazione costa $O(\log n)$ a causa dell’estrazione da $H$, portando il costo del while a $O(m\log n)$
>- il tempo totale richiesto dalle varie iterazioni del `for` annidato è $O(m\log n)$, in quanto in totale scorrerò $O(m)$ archi e per ogni arco pagherò $O(\log n)$ per l’inserimento in $H$
>la complessità di questa implementazione è dunque $O(n\log n) + O(m\log n) + O(m\log n)= O((n+m)\log n)$

>[!warning] qualunque implementazione dell’algo di dijkstra è $\Omega(n+m)$ (in quanto devo arrivare a tutti i nodi e guardare tutti gli archi x forza)
implementazione con lista è $O(n^2)$ (senza uso di strutture particolari)
>- se il grafo non è sparso (m=$O(n^2)$), questa implementazione è ottima !
>
implementazione con heap : $O((n+m) \log n)$
>- se il grafo è sparso, questa è la soluzione ottima ! se è denso, questa costa $O(n^2\log n)$, quindi non ottima !
>
terza implementazione: $O(n\log n + m)$: utilizza l’heap di fibonacci, che ha prestazioni migliori. 
>- è l’algoritmo usato dal dijkstra di python (no ? non esiste pre-build dijkstra in python )

>[!info] lower bound più preciso
>esiste un lower bound più preciso di $\Omega(n+m)$ per dijkstra: $\Omega(n\log^*n + m)$, dove $\log^*n$ è il logaritmo iterato: cresce lentissimamente, è quasi una costante(come funzione di ackermann (??)) 