---
related to: "[[02 - visita DFS]]"
created: 2025-03-02T17:41
updated: 2025-03-28T19:16
completed: true
---
>[!index]
>- [ordinamento topologico](#ordinamento%20topologico)
>	- [DAG](#DAG)
>	- [sort topologico con DFS](#sort%20topologico%20con%20DFS)

>[!warning] esattamente ciò che abbiamo fatto a [[26 - lock binario, lock a 2 fasi#ordinamento topologico|bd1]] ! 

>[!example] esempio problema
>abbiamo un lavoro da compiere, che è diviso in $n$ compiti (un nodo per ogni compito). tra certe coppie di compiti esiste una dipendenza: in particolare, un arco indica che per la coppia $(a,b)$, l’esecuzione del compito $b$ richiede la terminazione del compito $a$.
vogliamo sapere se è possibile completare il lavoro e, nel caso la risposta sia positiva, vogliamo un ordinamento con cui eseguire i compiti in modo da rispettare le dipendenze.
# ordinamento topologico
notiamo quindi che un grafo diretto può catturare relazioni di propedeuticità, e potrò rispettare tutte le propedeuticità se riesco ad ordinare i nodi del grafo in modo che gli archi vadano tutti da sinistra verso destra (in generale, in una sola direzione). questo ordinamento è detto **ordinamento topologico** !
>[!figure] ordinamento topologico
![[Pasted image 20250310095216.png]]

un grafo diretto può avere da $0$ fino ad $n!$ ordinamenti topologici, ma un algoritmo **esaustivo** (che genera sistematicamente i differenti ordinamenti dei nodi del grafo, e per ciascuno testa se è topologico) ha complessità $\Omega (n!)$, ed è quindi improponibile.
usiamo quindi un’altra strada per testare se il lavoro è completabile !
## DAG
**DAG**: direct acyclic graph (grafo diretto aciclico)
>[!warning] si nota come affinchè $G$ possa avere un ordinamento topologico, è **necessario** che sia un DAG:
>la presenza di un ciclo nel grafo implica che nessuno dei nodi possa comparire nell’ordine giusto, infatti ognuno di essi richiede di apparire, nell’ordinamento, alla destra di chi lo precede

quindi:
$$
G \text{ ha un ordinamento topologico} \implies G \text{ è un DAG}
$$
mostreremo ora che la condizione che il grafo sia una DAG è anche **sufficiente** perchè l’ordinamento topologico esista. ci basta in fatti notare che:
**un DAG ha sempre un nodo sorgente**(cioè un nodo in cui non entrano archi)

grazie a questa proprietà, possiamo trovare un ordinamento topologico in questo modo:
- inizio la sequenza dei nodi una una sorgente
- cancello dal DAG quel nodo sorgente e le frecce che partono da lui. in questo modo ottengo un nuovo DAG
- itero questo ragionamento finchè non ho sistemato in ordine lineare tutti i nodi
>[!info] algoritmo per un sort topologico
>```python
>def sortTop(G):
>	n = len(G)
>	gradoEnt = [0]*n ##conto quanti archi entranti ha ogni nodo
>	for i in range(n):
>		for j in G[i];
>			gradoEnt[j] += 1
>	sorgenti = [i for i in range(len(G)) if gradoEnt[i] == 0]
>	ST = []
>	while sorgenti:
>		u = sorgenti.pop()
>		ST.append(u)
>		for v in G[u]:
>			gradoEnt[v] -=1
>			if gradoEnt[v] == 0:
>				sorgenti.append(v)	
>	if len(ST) == len(G): return ST
>	return []
>```
il costo dell’algoritmo è $O(n+m)$, in quanto:
>- inizializzare il vettore dei gradi entranti costa $O(n+m)$
>- inizializzare l’insieme delle sorgenti costa $O(n)$ 
 >- il while viene iterato $O(n)$ volte,  e il for-loop al suo interno verrà eseguito al massimo $m$ volte

## sort topologico con DFS
esiste anche un algoritmo alternativo, basato sulla visita DFS del DAG, che si basa sulla seguente logica:
- effettua una visita DFS del DAG a partire dal nodo 0
- man mano **che termina** la visita dei vari nodi, inseriscili in una lista
- restituisci come ordinamento dei nodi, il **reverse** della lista
come fa questa logica a funzionare ?
consideriamo due nodi $a$ e $b$, e un arco tra di loro $(a,b)$. valutiamo i due casi possibili, e noteremo che in entrambi i casi, prima di effettuare il reverse, $b$ si troverà prima di $a$ 
1. l’arco $(a,b)$ viene attraversato durante la visita: in questo caso, banalmente, la visita di $b$ finirà prima della visita di $a$ (se non finisce la visita di $b$, non si può risalire e quindi finire la visita di $a$)
2. l’arco $(a,b)$ non viene attraversato durante la visita: ciò vuol dire che durante la visita, il nodo $b$ è stato già visitato e la sua visita è anche già terminata (in quanto non esiste un arco $(b,a)$, in quanto altrimenti si formerebbe un ciclo (impossible per ipotesi DAG)). quindi anche in questo caso $b$ apparirà nella lista prima di $a$
>[!info] algoritmo alternativo basato sulla visita DFS del DAG
>```python
>def sortTop(G):
>	visitati = [0]*len(G)
>	lista = []
>	for u in range(len(G)): #O(n+m)
>		if visitati[u] == 0:
>			DFSr(u, G, visitati, lista)
>	lista.reverse() #O(n)
>	return lista
>def DFSr(u, G, visitati, lista):
>	visitati[u] = 1
>	for v in G[u]:
>		if visitati[v] == 0:
>			DFSr(v, G, visitati, lista)
>	lista.append(u)
>```
>la complessità dell’algoritmo è $O(n+m) + O(n) = O(n+m)$

>[!info]- perche non appendere in testa ?
>il costo dell’append in testa costa proporzionalmente alla dimensione della lista, quindi l’append dell’ultimo elemento costa $O(n)$(sommatoria di gauss, arriva ad essere $\Theta\left( \frac{n(n-1)}{2}\right) = \Theta (n^2)$. appendere in coda invece costa sempre $O(1)$, il reverse costa $O(n)$

>[!example] esempio di sort topologico con DFS
![[Pasted image 20250311093815.png]]
ordine di fine visita: [4,3,2,1,5,0,6]
sort topologico: [6,0,5,1,2,3,4]
