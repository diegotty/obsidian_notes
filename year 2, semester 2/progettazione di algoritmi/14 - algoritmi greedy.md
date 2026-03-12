---
related to: "[[13 - problemi di ottimizzazione, algoritmi di approssimazione]]"
created: 2025-03-02T17:41
updated: 2025-06-19T19:04
completed: true
---
>[!index]
>- [algoritmi greedy](#algoritmi%20greedy)
>	- [selezione di attività](#selezione%20di%20attivit%C3%A0)
>	- [assegnazione di attività](#assegnazione%20di%20attivit%C3%A0)
>	- [selezione di file](#selezione%20di%20file)
# algoritmi greedy
per illustrare la progettazione e l’analisi di un algoritmo **greedy**, consideriamo un problema piuttosto semplice chiamato **selezione di attività**:
## selezione di attività
>[!info] problema
>abbiamo una lista di $n$ attività da eseguire:
>- ciascuna attività è caratterizzata da una copia: (tempo_inizio, tempo_fine)
>- due attività sono **compatibili** se non si sovrappongono
>
>vogliamo trovare un sottoinsieme di **massima cardinalità** di attività compatibili 
>>[!example] esempio
>![[Pasted image 20250407163452.png]]
>in generale possono esistere diverse soluzione ottime, ma in questo caso è facile convincersi che l’unico sottoinsieme massimale è $\{b,e,h\}$

volendo utilizzare il paradigma **greedy**, dovremmo trovare una regola, semplice da calcolare, che ci permetta di effettuare ogni volta la scelta giusta

per questo problema ci sono diverse potenziali regole di scelta:
- prendi l’attività compatibile che inizia prima
- prendi l’attività compatibile che dura di meno
- prendi l’attività compatibile che ha meno conflitti con le rimanenti
(esistono controesempi per tutte queste)
**la regola giusta sta nel prendere sempre l’attività compatibile che finisce prima** !!
>[!example]- esempio con regola giusta
![[Pasted image 20250407164028.png]]

>[!dimostrazione] dimostrazione della correttezza della regola
supponiamo per assurdo che la soluzione greedy $SOL$, trovata con questa regola, non sia ottima. le soluzioni ottime differiscono dunque da $SOL$ ! 
>nel caso dci fossero più di una soluzione ottima, prendiamo quella che differisce nel minor numero di attività da $SOL$: sia $SOL*$. dimostreremo che esiste un’altra soluzione ottima $SOL'$ che differisce ancora meno da $SOL$, il che è assurdo (stesso tipo di dimostrazione dello spanning tree)
>
>siano $A_{1}, A_{2}, \dots$, le attività nell’ordine in cui sono state selezionate dall’algoritmo. sia $A_{i}$ la prima attività scelta dal greedy e non dall’ottimo (che deve esistere, in quanto tutte le attività non prese dal greedy sono incompatibili con le attività scelte dal greedy, e se la soluzione avesse preso tutte le attività scelte dal greedy, non potrebbe averne prese di più: quindi il greedy deve avere attività diverse).
>nell’ottimo deve esserci un’altra attività $A'$ che va in conflitto con $A_{i}$, altrimenti $SOL*$ non sarebbe ottima in quanto potrei aggiungerci $A_{i}$.
>a questo punto, posso sostituire in $SOL*$ l’attività $A'$ con l’attività $A_{i}$, senza creare conflitti (in quanto per la regola di scelta greedy, $A_i$ termina prima di $A'$(e l’attività prima è uguale per entrambe le soluzioni)).
>ottengo in questo modo una soluzione ottima $SOL'$ con la stessa cardinalità di $SOL*$, che differisce da $SOL$ di un’attività in meno rispetto a $SOL*$.
>![[Pasted image 20250407165234.png]]

>[!info] implementazione
pseudocodice:
>```
>def selezione_a(lista):
>	SOL = []
>	while lista:
>		estrai da lista l'attività (a,b) che termina prima
>		if (a,b) non va in conflitto con le attività in SOL: 
>			SOL.append((a,b))
>	return SOL
>```
**IDEE**
>- per l’implementazione, conviene fare un preprocessing ordinando gli eventi per tempo di fine crescente, pagando $\Theta(n\log n)$ per l’ordinamento ma poi avendo l’estrazione delle attività in $\Theta(1)$
>- per eseguire efficientemente il test richiesto dall’if, conviene mantere una variabile con il tempo di fine dell’ultima attività inserita in SOL. in questo modo il test richiederà $\Theta(1))$
>```python
>def selezione_a(lista):
>	lista.sort(key = lambda x: x[1])
>	libero = 0
>	sol = []
>	for inizio, fine in lista:
>		if libero < inizio:
>			sol.append((inizio, fine))
>			libero = fine
>	return sol
>```
>il costo totale dell’algoritmo è $\Theta(n\log n)$

affrontiamo ora un nuovo prolema !
## assegnazione di attività
>[!info] problema
abbiamo una lista di attività, ciascuna caratterizzata da un tempo di inizio ed un tempo di fine. le attività **vanno tutte eseguite** e vogliamo assegnarle al minor numero di aule, tenendo conto che in una stessa aula non possono eseguirsi più attività in parallelo
>>[!example] esempio
>![[Pasted image 20250424074713.png]]

>[!info]- possibile algoritmo greedy (non corretto)
un possibile algoritmo **greedy** si basa sull’idea di occupare aule finchè ci sono attività da assegnare, e ad ogni aula, un volta inaugurata, assegnare il maggior numero di attività non ancora assegnate che è in grado di contere
>```python
>def assegnazione_a(lista):
>	i, sol = 0, []
>	while lista:
>		i += 1
>		lista1 = selezione_a(lista)
>		sol.append(lista1)
>		elimina da lista le attività in lista1
>	return sol
>```
>ma si può notare che l’algoritmo non è corretto: 
![[Pasted image 20250424075329.png]]

arriviamo allora alla soluzione corretta:
```
def assegnazione_a(lista):
	inizializza la soluzione con una aula senza attività
	while lista != []:
		estrai da lista l'attività (a,b) che inizia prima
		if c'è nella soluzione un'aula in cui è possibile eseguirla:
			assegna (a,b) a quell'aula
		else:
			inserisci nella soluzione una nuova aula ed assegnagli (a,b)
	return la soluzione con le aule e le attività assegnate
```

>[!dimostrazione] correttezza dell’algoritmo
sia $k$ il numero di aule utilizzate dalla soluzione: faremo vedere che ci sono nella lista $k$ attività incompatibili a copiia, e questo ovviamente implica che $k$ aule sono necessarie
>
>sia $(a,b)$ l’attività che ha portato all’introduzione nella soluzione della $k-esima$ aula. in quel momento nelle altre $k-1$ aule era impossibile eseguire l’attività $(a,b)$, ma per il criterio di scelta greedy posso anche dire che nell’istante di tempo $a$ tutte le aule erano occupate (le attività a loro assegnate iniziavano prima del tempo $a$ e non erano ancora finite), quindi nell’istante di tempo $a$ a due a due tutte queste $k$ attività sono incompatibili
![[Pasted image 20250424075950.png]]

>[!info] implementazione
**IDEA**
>- per individuare efficientemente l'attività che inizia prima, effettuiamo un pre-processing in cui ordiniamo le attività per tempo di inizio
>- per individuare efficientemente se una delle aule è in `sol` è in grado di eseguire un certo lavoro $(a,b)$, uso una **heap** minima in cui metto le coppie `(libera,i)` dove `libera` indica il tempo in cui si libera l’aula $i$. in questo modo, in tempo $O(1)$ posso sapere qual’è l’aula che si libera prima semplicemente verificando `H[0][0]` (fuoco)
>	- se nell’aula che si libera prima si può eseguire l’attività, allora dovrò assegnargliela e aggiornare il valore `libera` della coppia che la rappresenta nell’heap. se al contrario l’aula non può accogliere l’attività, allora non sarà possibile farlo in nessuna delle altre aule e bisognerà assegnare all’attvità un nuova aula, ed inserire nella heap la coppia che rappresenta questa nuova aula
>
inserimenti e cancellazioni dall’heap costeranno $O(\log n)$
>```python
>def assegnazioneAule(lista):
>	from heapq import heappop, heappush
>	sol = [[]]
>	H=[(0,0)]
>	lista.sort()
>	for inizio, fine in lista:
>		libera, aula = H[0]
>		if libera <= inizio:
>			sol[aula].append((inizio, fine))
>			heappop(H) # pop dalla testa
>			heappush(H, (fine, aula))
>		else:
>			sol.append([(inizio, fine)])
>			heappush(H, (fine, len(sol)-1))
>	return sol
>```
>complessità dell’algoritmo:
>- ordinare la lista costa $O(n\log n)$
>- il `for-loop` viene eseguito $n$ volte, e all’interno del `for`, nel caso pessimo, può essere eseguito un heappop **e** un heappush, entrambe operazioni di costo $O(\log n)$. 
>
>il costo complessivo dell’algoritmo è quindi $\Theta(n\log n)$

## selezione di file
>[!info] problema
abbiamo $n$ file di dimensioni $d_{0}, d_{1}, \dots d_{n-1}$ che vorremmo memorizzare su un disco di capacità $k$. tuttavia la somma delle dimensioni di questi file eccede la capacità del disco. vogliamo dunque selezionare un sottoinsieme degli $n$ file che abbia **cardinalità massima** (non che occupa la dimensione massima !!!!!) e che possa essere memorizzato sul disco
>
>descrivere un algoritmo **greedy** che risolve il problema in tempo $O(n\log n)$ e provarne la correttezza
>>[!example] esempio
>$D=[5,6,3,5,4,7,3], k=11$
>la risposta deve essere la tripla di file $[2,4,6]$ che occupa spazio 10

un algoritmo greedy per questo problema è quello che si presenta naturalmente: consideriamo i file per **dimensione crescente**, e se c’è spazio per memorizzare il file su disco allora facciamolo

>[!info] implementazione
>```python
>def file(D, k):
>	n = len(D)
>	lista = [(D[i], i) for i in range(n)]
>	lista.sort()
>	spazio, sol = 0, []
>	for d, i in lista:
>		if spazio + d <= k:
>			sol.append(i)
>			spazio += d
>		else:
>			return sol
>```
la complessità di questo algoritmo è $\Theta(n\log n)$ (sort di una lista)

>[!dimostrazione] prova di correttezza dell’algoritmo
assumiamo per assurdo che la soluzione $sol$ prodotta dal greedy non sia ottima: devono quindi esistere insiemi con più cardinalità maggiore di $sol$ che rispettano la capacità del disco. tra questi insiemi  prendiamo quello con più elementi in comune a $sol$, e lo denotiamo con $sol*$
>
>si nota che:
>- esiste un file $a$ che appartiene a $sol*$ e non a $sol$, e che occupa più spazio di qualunque file in $sol$ (questo perche tutti gli elementi in $sol$ occupano meno spazio di quelli non presenti nello stesso $sol$)
>- esiste un file $b$ che appartiene a $sol$ e non a $sol*$ (questo perchè $sol \not \subset sol*$, infatti l’aggiunta di un qualunque elemento a $sol$ porterebbe a superare la capacità del disco)
>
>possiamo dunque eliminare da $sol*$ il file $a$ ed inserire il file $b$ ottenendo un nuovo insieme che rispetta ancora le capacità del disco ed ha un elemento in più in comune con $sol$, contraddicendo le nostre ipotesi (il file $sol*$ è quello con più elementi in comune con $sol$)

## esercizio

>[!example]+ esercizi04.pdf
![[Pasted image 20250519162809.png]]

>[!info]- soluzione
assumiamo per assurdo che la soluzione ottenuta con l’algoritmo fornito , $S$, non sia corretta.  esiste allora una soluzione $S*$ diversa da $S$ più corretta di essa (usa meno flaconi). prendiamo allora il primo flacone nella soluzione $S$ che non viene usato in $S*$. vuol dire che in $S*$, per contenere tutte le pillole senza il flacone, viene usato un flacone più grande di quelli usati in $S$, ma dato il criterio con cui vengono scelti i flaconi nell’algoritmo, ciò è impossibile. contraddizione

>[!example] problema
![[Pasted image 20250519170421.png]]

>[!soluzione]