---
created: 2024-12-21
related to: "[[26 - lock binario, lock a 2 fasi]]"
updated: 2025-02-20T09:38
---
[!index]
>
>- [soluzioni per il deadlock](#soluzioni%20per%20il%20deadlock)
>- [livelock](#livelock)
>- [abort di una transazione](#abort%20di%20una%20transazione)
>- [punto di commit](#punto%20di%20commit)
>- [roll-back a cascata](#roll-back%20a%20cascata)
>- [locking a 2 fasi stretto](#locking%20a%202%20fasi%20stretto)
>- [classificazione dei protocolli](#classificazione%20dei%20protocolli)
>	- [conservativi](#conservativi)
>	- [aggressivi](#aggressivi)
>	- [quando](#quando)
# deadlock
un deadlock si verifica quando:
- ogni transazione in un insieme $T$ è in attesa di ottenere un lock su un item sul quale qualche altra transazione nell’insieme $T$ mantiene un lock, e quindi:
- ogni transazione rimane bloccata
- nessuna transazione rilascia i lock (essendo bloccata su `lock(X)`, non arriva alla riga di codice `unlock(Y)`(Y item su cui ha il lock))
- ciò può bloccare anche transazioni che non sono in $T$ !

## soluzioni per il deadlock
per verificare la presenza di una situazione di deadlock, si mantiene il **grafo di attesa**:
- nodi: le transazioni
- archi: c’è un arco $T_{1} \to T_{2}$ se la transazione $T_{1}$ è in attesa di ottenere un lock su un item sul quale $T_{2}$ mantiene un lock
se in tale grafo c’è un ciclo, si sta verificando una situazione di stallo che coinvolge **le transazioni nel ciclo**, e va risolta

per risolvere una situazione di deadlock, una transazione nel ciclo viene **rolled-back** e successivamente viene fatta ripartire
quando avviene un **roll-back**:
1. la transazione è abortita
2. i suoi e>ffetti sulla BD vengono annullati, ripristinando i valori dei dati precedenti l’inizio della sua esecuzione
3. tutti i lock mantenuti dalla transazione vengono rilasciati

per evitare il deadlock, si adottano protocolli opportuni
- es: si ordinano gli item e si impone alle transazioni di richiedere i lock necessari seguendo tale ordine (come in [[intro al deadlock#prevenire|SO per evitare l’attesa circolare !]],): in tal modo non ci possono essere cicli nel grafo di attesa (e non si può verificare un deadlock)
>[!info]- dimostrazione
![[Pasted image 20241221082026.png]]
# livelock
un **livelock** si verifica quando una transazione aspetta indefinitivamente che gli venga garantito un lock su un certo item
questo problema può essere risolto:
- con una strategia FCFS (first come, first serve)
- eseguendo le transazioni in base alle loro priorità, e aumentando la priorità di una transazione all’aumentare del tempo in cui rimane in attesa
# abort di una transazione
una transazione può essere abortita perchè:
1. la transazione esegue un’operazione non corretta (divisone per 0, accesso non consentito)
2. lo scheduler rileva un deadlock
3. lo scheduler fa abortire la transazione per garantire la serializzabilità ([[30 - timestamp|timestamp]])
4. si verifica un malfunzionamento hardware o software
## punto di commit
il **punto di commit** di una transazione è il punto in cui la transazione:
- ha ottenuto tutti i lock che gli sono necessari
- ha effettuato tutti i calcoli nell’area di lavoro
e quindi non può più essere abortita a causa dei punti 1-3

i **dati sporchi** sono quindi i dati scritti da una transazione sulla BD prima che abbia raggiunto il punto di commit
## roll-back a cascata
quando una transazione $T$ viene abortita, devono essere annulati gli effetti sulla BD prodotti da $T$, e da qualsiasi transazione che abbia letto dati sporchi

come abbiamo visto:
- l’uso di [[26 - lock binario, lock a 2 fasi#lock binario|lock binario]] permetete di risolvere il problema del ghost update, ma non quello della lettura di un dato sporco, ne quello dell’aggregato
- il protocollo di [[26 - lock binario, lock a 2 fasi#locking a 2 fasi|locking a 2 fasil]] risolve il problema dell’aggregato non corretto, ma non quello della lettura di un dato sporco
>[!info] per risolvere il problema della lettura di dati sporchi occorre che le transazioni obbediscano a regole più restrittive del protocollo di locking a 2 fasi
# locking a 2 fasi stretto
una transazione soddisfa il **protocollo di locking a 2 fasi stretto** se:
1. non scrive sulla BD fino a quando non ha raggiunto il suo punto di commit ( in questo modo, se una transazione è stata abortita, allora non ha modificato alcun item)
2. non rilascia un lock finchè non ha finito di scrivere sulla BD (se una transazione legge un item scritto da un’altra transazione, quest’ultima non può essere abortita)
>[!example]- esempi
>esempi di schedule di transazioni che rispettano il protocollo di locking a 2 fasi stretto:
![[Pasted image 20241221084421.png|200]]
![[Pasted image 20241221084433.png|150]]
## classificazione dei protocolli
### conservativi
i protocolli conservativi cercano di **evitare** il verificari di situazioni di stallo
>[!example] protocollo conservativo 1
>una transazione $T$ richiede tutti i lock che servono **all’inizio**, e li ottiene se e solo se **tutti i lock** sono disponibili, altrimenti, se non li può ottenere tutti, viene messa in una coda di attesa
>- in questo modo si evita il deadlock, ma non il livelock(la starvation)

>[!example] protocollo conservativo 2
>per evitare il verificarsi sia del deadlock che del livelock:
>una transazione $T$ richiede tutti i lock che servono all’inizio e li ottiene se e solo se tutti i lock sono disponibili e nessuna transazione che precede $T$ nella coda è in attesa di un lock richiesto da $T$

vantaggi:
- si evita il verificarsi sia del deadlock che del livelock
svantaggi:
- l’esecuzione di una transazione può essere ritardata
- una transazione è costretta a richiedere un lock su ogni item che potrebbe essergli necessario, anche se poi di fatto non l’utilizza
### aggressivi 
i protocolli aggressivi cercano di processare le transazioni il più rapidamente possibile, anche se ciò può portare a situazioni di stallo
>[!example] protocollo aggressivo
una transazione deve richiedere un lock su un item immediatamente prima di leggerlo o di scriverlo
>- può verificarsi un deadlock

### quando
se la probabilità che due transazioni richiedano un lock sullo stesso item è:
- alta: è conveniente un protocollo conservativo, in quanto evita al sistema il sovraccarico dovuto alla getione dei deadlock (rilevare e risolvere stalli, eseguire transazioni che poi vengono abortite, l’aborto stesso)
- bassa: è conveniente un protocollo aggressivo, in quanto evita al sistema il sovraccarico dovuto alla gestione dei lock (decidere se garantire un lock su un dato item ad una data transazione, gestire la tavola dei lock, mettere le transazioni in una coda e gestirla)