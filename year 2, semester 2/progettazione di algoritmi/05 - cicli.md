---
related to: "[[02 - visita DFS]]"
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [cicli](#cicli)
>	- [archi verso nodi già visitati](#archi%20verso%20nodi%20gi%C3%A0%20visitati)

>[!info] problema
dato un grafo $G$ (diretto o non diretto), ed un suo nodo $u$, vogliamo sapere se da $u$ è possibile raggiungere un ciclo in $G$
![[Pasted image 20250311095011.png]]
# cicli
partiamo da un’idea intuitiva ma sbagliata: visitiamo il grafo, e se nel corso della visita incontriamo un nodo che è già stato visitato, vuol dire che esiste un ciclo: interrompiamo la ricerca e restituiamo `True`
- banalmente, questa idea non funziona per i grafi non diretti: essendo ogni arco bidirezionale, questo algoritmo interpreta ogni arco come un ciclo di lunghezza 2!
- inoltre, è scorretto anche per i grafi diretti !! (che casino). in quanto in un grafo diretto, incontare un nodo già visitato non vuol necessariamente dire che si è in presenza di un ciclo (guarda immagine)
>[!example]- grafo diretto senza ciclo
>![[Pasted image 20250311100214.png]]

## archi verso nodi già visitati
(grafi diretti)
**archi in avanti**:archi che collegano un antenato ad un suo discendente (non suo figlio, ma almeno il grado dopo)
>[!info] in archi non diretti è impossibile trovare archi in avanti, in quanto si troverebbe prima un arco all’indietro (visiterò il nodo discendente attraverso un altro cammino, e arrivato al nodo troverò l’arco all’indietro !)

**archi all’indietro**: il contario di un arco in avanti
**archi di attraversamento**: archi $(a,b)$ in cui cui il padre di $a$ arriva a $b$ anche senza l’arco $(a,b)$, con un altro cammino
>[!example] esempi di archi verso nodi già visitati
![[Pasted image 20250311101130.png]]

>[!warning] solo la presenza di archi all’indietro testimonia la presenza di un ciclo !

quindi, per risolvere il problema, durante la visita DFS devo poter distinguere la scoperta di nodi già visitati grazie ad un arco all’indietro dagli altri.
posso fare ciò notando che solo nel caso di archi all’indietro **la visita del nodo già visitato non ha terminato la sua ricorsione**

uso quindi un sistema a 3 valori per distinguere lo stato di ogni nodo
- $V[i] = 0$ → il nodo non è stato ancora visitato
- $V[i] = 1$ → il nodo è stato visitato ma la sua ricorsione non è ancora finita
- $V[i] = 2$ → il nodo è stato visitato e la sua ricorsione è finita
in questo modo, scopro un ciclo quando trovo un arco diretto verso un nodo che si trova nello stato 2

>[!info] algoritmo per verifica dell’esistenza di un ciclo a partire da un nodo $u$
>```python
>def cicloD(u, G):
>	visitati = [0]*len(G)
>	return DFSr(u, G, visitati)
>
>def DFSr(u, G, visitati):
>	visitati[u] = 1
>	for v in G[u]:
>		if visitati[v] == 1:
>			return True # arco all'indietro
>		if visitati[v] == 0:
>			if DFSr(v, G, visitati):
>				return True
>	visitati[u] = 2
>	return False
>```
la complessità di questo algoritmo è $O(n+m)$


>[!info] algoritmo per la verifica dell’esistenza di un ciclo
per verificare l’esistenza di un ciclo, devo visitare tutto il grafo, non importa il punto da cui parto. è possibile modificare l’algoritmo di sopra senza alterarne la complessità
>```python
>def cicloD(u, G):
>	visitati = [0]*len(G)
>	for u in range (len(G)):
>		if visitati[u] == 0:
>			if DFSr(u, G, visitati):
>				return True
>	return False
>
>def DFSr(u, G, visitati):
>	visitati[u] = 1
>	for v in G[u]:
>		if visitati[v] == 1:
>			return True # arco all'indietro
>		if visitati[v] == 0:
>			if DFSr(v, G, visitati):
>				return True
>	visitati[u] = 2
>	return False
>```
>la complessità rimane $O(n+m)$ in quanto anche se ripetiamo la visita al massimo $n$ volte, la visita sarà sempre su parti diverse del grafo
