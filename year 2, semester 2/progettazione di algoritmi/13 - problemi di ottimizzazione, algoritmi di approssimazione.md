---
related to: 
created: 2025-03-02T17:41
updated: 2025-04-07T16:27
completed: false
---
>[!index]
>- [problemi di ottimizzazione](#problemi%20di%20ottimizzazione)
>	- [algoritmi di approssimazione](#algoritmi%20di%20approssimazione)
>		- [valutare il rapporto d’approssimazione di un algoritmo](#valutare%20il%20rapporto%20d%E2%80%99approssimazione%20di%20un%20algoritmo)
# problemi di ottimizzazione
un **problema di ottimizzazione** è un tipo di problmea in cui l’obiettivo è trovare la **migliore** soluzione possibile tra un insieme di soluzioni ammissibili
- ogni soluzione ammissibile, cioè una soluzione che soddisfa tutte le condizioni imposte dal problema, ha un valore assoiato che può essere un “costo” o un “beneficio”, e a seconda del tipo del problema, l’obiettivo può essere minimizzare o massimizzare questo valore
>[!info] complessità dei problemi di ottimizzazione
sebbene esistono problemi di ottimizzazione per cui trovare la soluzione ottima è possibile in tempo polinomiale, nella maggior parte dei problemi di ottimizzazione trovare una soluzione ottima risulta essere un compito molto più difficile. in molti casi, trovare una soluzione ottima può esser un problema **NP-difficile**, dove la complessità cresce esponenzialmente con la dimensione del problema
>
>quindi,  sebbene determinare se una soluzione è ammissibile può essere fatto in tempo polinomiale, trovare la soluzione ottime richiede spesso algoritmi molto più complessi

## algoritmi di approssimazione
>[!info] problema della copertura tramite nodi
> dato un grafo non diretto $G$, una sua **copertura tramite nodi** e un sottoinsieme $S$ dei suoni nodi tale che tutti gli archi di $G$ almeno un estremo in $S$. trovare la copertura tramite nodi **di minima cardinalità**

>[!example] esempio di soluzione greedy non ottimale
un’approccio greedy sarebbe il seguente:
finchè ci sono archi non coperti, inserisci in $S$ il nodo che copre il **massimo** numero di archi ancora scoperti
>- ma questo algoritmo non produce sempre la soluzione ottimale. anzi, è molto facile “ingannarlo”
![[Pasted image 20250405174512.png]]

per questo problema (e moltissimi altri), definiti **computazionalmente difficili**, non si conoscono algoritmi neanche lontanamente efficienti (== non esistono algoritmi subesponenziali)
- in questi casi, potrebbe esser già soddisfacente ottenere una soluzione **ammissibile** che sia soltanto **”vicina”** ad una soluzione ottima, e ovviamente, più vicina e meglio è.
>[!warning] algoritmi di approssimazione ed euristiche
> fra gli algoritmi che non trovano sempre una soluzione ammissibile **ottima**, è importante distinguere due categorie piuttosto differenti: **algoritmi di approssimazione** ed **euristiche**
>- **gli algoritmi di approssimazione** sono algoritmi per cui si dimostra che la soluzione ammisibile prodotta approssima entro un certo grado una soluzione ottima !
>- le **euristiche**, invece, sono algoritmi per cui **non** si riesce a dimostrare che la soluzione ammissibile prodotta ha sempre una certa vicinanza ad una soluzione ottima. sono infatti l’ultima spiaggia, quando non si riesce a trovare nè algoritmi corretti nè algoritmi di approssimazione efficienti
>
>per una gran parte dei problemi computazionalmente difficili infatti, non si conoscono neanche buoni algoritmi di approssimazione. non è quindi sorprendente che fra tutti i tipi di algoritmi, gli algoritmi euristici costituiscano la classe più ampia e che ha dato luogo ad una letteratura **sterminata**

specifichiamo ora cosa si intende per “approssimazione entro un certo grado” (quando ci riferiamo ad algoritmi di approssimazione !)
>[!info] problemi di minimizzazione
>per i **minimizzazione**, dove ad ogni soluzione ammissibile è associato un costo, cerchiamo la soluzione ammissibile di costo minimo: il modo usuale di misurare il grado di approssimazione è il rapporto al **caso pessimo** tra il costo della soluzione prodotta dall’algoritmo e il costo della soluzione ottima.
>
formalmente: si dice che $A$ approssima il problema di minimizzazione entro un fattore di approssimazione $\rho$ se **per ogni istanza** $I$ del problema, vale:
>$$
>\frac{A(I)}{OPT(I)} \leq \rho
>$$
dove $OPT(I)$ è il costo di una soluzione ottime per l’istanza $I$, e $A(I)$ il costo della soluzione prodotta dall’algoritmo $A$ per quell’istanza
>
>rattandosi di un problema di minimizzazione, risulta sempre che $A(I) \geq OTT(I)$, quindi $\rho \geq 1$ (ed ovviamo quando più il rapporto di approssimazione è vicino ad 1, tanto più l’algoritmo di approssimazione è buono)
>- se $A$ approssima $P$ entro un fattore 2, allora $A$ trova sempre una soluzione di costo al più doppio di quello della soluzione ottima

>[!info] problemi di massimizzazione
>per i problemi di massimizzazione, dove ad ogni soluzione ammissibile è associato un valore, si considera il rapporto inverso, ovvero:
>$$
>\frac{OTT(I)}{A(I)} \leq \rho
>$$

### valutare il rapporto d’approssimazione di un algoritmo
dall’esempio che abbiamo visto in precedenza, algoritmo greedy per il problema della copertura minimale tramite nodi ha un fattore di approssimazione di almeno $\frac{5}{4}>1$
- infatti abbiamo trovato un’istanza per cui l’algoritmo produce una soluzione con 5 nodi mentre la soluzione ottima ha 4 nodi
>[!example] un’altra istanza di P. … . .
![[Pasted image 20250405181849.png]]

si nota infine come per ogni costante $R$, si possono esibire grafi per cui l’algoritmi sbaglia di un fattore superiore ad $R$, **QUINDI** l’algoritmo greedy in esame non garantisce nessun fattore di approssimazione costante
>[!dimostrazione]- dimostrazione
dimostriamo che per ogni intero $l$, possiamo costruire un grafo $G_l$ su cui l’algoritmo greedy avrà rapporto di approssimazione $\Omega(\log l)$. 
>il grafo $G_{l}$ è definito come segue:
DO YOU REALLY CARE ? do you really actually want to know how it works ? do you think your brain is capable enough to comprehend the madness that goes behind this proof ? you are a sick man. you should reconsider. there is no going back. 

ovviamente, il fatto d’aver dimostrato che per un problema, un certo algoritmo d’approssimazione ha un cattivo rapporto d’approssimazione non impedisce che per il problema possano esistere altri algoritmi d’approssimazione con un fattore d’approssimazione costante.
>[!example] algoritmo d’approssimazione
consideriamo il seguente algoritmo **greedy** per la copertura di nodi:
>considera i vari archi del grafo uno dopo l’altro, e ogni volta che ne trovi uno non coperto (nessuno dei suo estremi è in $S$), aggiungi entrambi gli estremi dell’arco alla soluzione $S$
>```
>def copertura1(G):
>	inizializza la lista E con gli archi di G
>	S = []
>	while E != []:
>		estrai da E un arco (x,y)
>		if nè x nè y sono in S:
>			S.append(x)
>			S.append(y)
>	return S
>```
l’algoritmo produrrà sicuramente una copertura, ma non è detto che sia minima, infatti l’algoritmo ha rapporto d’approssimazione almeno 2 (basta pensare ad un grafo con 2 nodi ed un arco)

>[!dimostrazione] dimostrazione
dimostriamo che il rapporto d’approssimazione è limitato da 2:
siano $e_{1}, e_{2}, \dots e_{k}$ gli archi di $G$ che vengono trovati non coperti durante l’esecuzione dell’algoritmo.
>1. per come funziona l’algoritmo, deduciamo che $A(I) = 2K$
>- i $k$ archi non coperti sono tra loro disgiunti (infatti i due estremi di ciascuno di questi archi vengono incontrati per la prima volta quando viene esaminato l’arco). questo significa che in una qualunque delle soluzioni ottime, almeno un estremo di ciascuno di questi $k$ archi deve essere presente
>2. ne deduciamo che $k \leq OTT(I)$
>quindi $A(I)=2k \leq 2\cdot OTT(I) \implies \frac{A(I)}{OTT(I)} \leq 2$
![[Pasted image 20250407161313.png]]

>[!info] implementazione dell’algoritmo
>```python
>def copertura1(G):
>	n = len(G)
>	E = [(x, y) for x in range(n) for y in G[x] if x < y]
>	presi = [0]*n
>	sol = []
>	for a,b in E:
>		if presi[a] == presi[b] == 0:
>			S.append(a)
>			S.append(b)
>			presi[a] = presi[b] = 1
>	return sol
>```
>la complessità dell’algoritmo è $O(n+m)$

>[!tip] non sono noti algoritmi d’approssimazione con rapporto inferiore a 2 !