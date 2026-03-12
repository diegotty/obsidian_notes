---
created: 2024-12-19
related to: "[[25 - controllo della concorrenza]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [schedule legale](#schedule%20legale)
>- [lock binario](#lock%20binario)
>	- [equivalenza](#equivalenza)
>- [testare la serializzabilità](#testare%20la%20serializzabilit%C3%A0)
>- [algoritmo 1](#algoritmo%201)
>- [ordinamento topologico](#ordinamento%20topologico)
>- [teorema sulla correttezza dell’algoritmo del grafo di serializzazione](#teorema%20sulla%20correttezza%20dell%E2%80%99algoritmo%20del%20grafo%20di%20serializzazione)
>- [locking a 2 fasi](#locking%20a%202%20fasi)
>- [teorema sul lock a 2 fasi](#teorema%20sul%20lock%20a%202%20fasi)
>- [dimostrazione](#dimostrazione)
# lock
**lock**: privilegio di accesso ad un singolo item, realizzato mediante una variabile associata all’item (**variabile lucchetto**), il cui valore descrive lo stato dell’item rispetto alle operazioni che possono essere effettuate su di esso
- un lock viene richiesto da una transazione mediante un’operazione di **locking** (`lock(X)`): se il valore della variabile è `unlocked`, la transazione può accedere all’item e alla variabile viene assegnato il valore `locked`
- un lock viene rilasciato da una transazione mediante un’operazione di **unlocking** (`unlock(X)`), che assegna alla variabile il valore `unlocked`
- fra l’esecuzione di un’operazione di locking su un dato item $X$ e l’operazione di unlocking su tale $X$, la transazione **mantiene un lock** su $X$
il locking agisce quindi come primitiva di sincronizzazione !
## schedule legale
uno schedule è detto **legale** se una transazione effettua un locking ogni volta che deve leggere o scrivere un item, e ciascuna transazione rilascia ogni lock che ha ottenuto
## lock binario
un lock binario può assumere solo 2 valori: `locked` e `unlocked`
le transazioni fanno uso di due operazioni: 
- `lock(X)` per chiedere l’accesso all’item $X$
- `unlock(X)` per rilasciare l’item $X$ consentendone l’accesso ad altre transazioni

consideriamo di nuovo l’esempio introdotto in [[25 - controllo della concorrenza#problemi]]
>[!example] dati con lock
riscriviamo le transazioni utilizzando le primitive di lock binario
![[Pasted image 20241219105813.png]]

>[!example] esempio 1: ghost update
>questo schedule, che replica lo schedule dell’esempio 1 senza lock binario, è legale, e risolve il problema dell’aggiornamento perso
![[Pasted image 20241219105847.png]]

### equivalenza
vedremo che la proprietà di equivalenza degli schedule dipende dal protocollo di locking adottato
nel caso semplice del lock binario a 2 valori, formalizziamo il concetto di equivalenza adottando un modello delle transazioni che astrae dalle specifiche operazioni e si basa su quelle rilevanti per valutare le sequenze degli accessi, cioè in questo caso, `lock()` e `unlock()`
>[!info] modello per transazioni
>![[Pasted image 20241219110236.png]]
>in questo modello, una transazione è quindi una sequenza di operazioni di `lock()` e `unlock()`, in cui:
>- ogni `lock(X)` implica la lettura di $X$
>- ogni `unlock(X)` implica la scrittura di $X$

in corrispondenza di una scrittura, viene associato un nuovo valore all’item coinvolto, che viene calcolato come una funzione che:
- è associata in modo univoco ad ogni coppia di `lock-unlock`
- ha per argomenti **tutti** gli item **letti**(`locked`) dalla transazione prima dell’operazione di `unlock` (perchè magari i loro valori hanno contribuito all’aggiornamento dell’item corrente)
date queste nozioni:
>[!important] equivalenza
due schedule sono equivalenti se le formule che danno i valori finali per ciascun (e tutti) item sono le stesse 

>[!important] serializzabilità
uno schedule è **serializzabile** se è equivalente ad uno schedule seriale (basta trovarne uno)

>[!example] esempio 
consideriamo le transizioni:
![[Pasted image 20241219111131.png]]
e lo schedule con interleaving:
![[Pasted image 20241219111201.png]]
in questo caso il valore finale di $X$ è $f_{4}(f_{1}(X_{0}), Y_{0})$ e il valore finale di $Y$ è $f_{2}(X_{0}, f_{3}(Y_{0}))$
>
>calcoliamo ora gli schedule sequenziali, per vedere se lo scheduling sopra è serializzabile:
>schedule $T_{1},T_{2}$
![[Pasted image 20241219111414.png]]
>in questo caso, il valore finale di $X$ è $f_{4}(f_{1}(X_{0}),f_{2}(X_{0},Y_{0}))$, e il valore finale di $Y$ è $f_{3}(f_{2}(X_{0},Y_{0})$
>
>schedule $T_{2},T_{1}$
>![[Pasted image 20241219111727.png]]
>in questo caso, il valore finale di $X$ è $f_{1}(f_{4}(X_{0},Y_{0}))$, e il valore finale di $Y$ è $f_{2}(f_{4}(X_{0},Y_{0}),f_{3}(Y_{0}))$
pertanto, lo schedule non è serializzabile, in quanto produce per $X$ un valore finale diverso da entrambi gli schedule seriali, e lo stesso vale per $Y$

>[!info] osservazione
>basta concludere che le formule siano diverse anche per un solo item per concludere che gli schedule non sono equivalenti

# testare la serializzabilità
# PORCODIO
## algoritmo 1
dato uno schedule $S$:
**passo 1**: crea un grafo diretto(con archi diretti) $G$ (**grafo di serializzazione**)
- nodi: transazioni
- archi: $T_{i} \to T_{j}$ (con etichetta $X$) se in $S$, $T_i$ esegue un `unlock(X)` e $T_j$ esegue il successivo `lock(X)` (non un successivo, ma **IL** successivo, cioè $T_j$ è la prima transazione che effettua il `lock` di $X$ dopo che $T_j$ ha effettuato l’`unlock`, and se le due operazioni non sono di seguito)
**passo 2**: se $G$ ha un cliclo allora $S$ non è serializzabile, altrimenti applicando a G l’**ordinamento topologico** si ottiene uno schedule seriale $S’$ **equivalente** ad $S$

>[!example]- esempio 
consideriamo il seguente schedule d $T_1,T_2$
![[Pasted image 20241220200100.png|300]]
esso genera il seguente grafo:
![[Pasted image 20241220200149.png]]
in questo caso il grafo è ciclico, in quanto esiste un percorso, **seguendo la direzione delle frecce**, che crea un ciclo
>
>invece, uno schedule diverso di $T_1,T_2$:
![[Pasted image 20241220200305.png|300]]
genera un grafo diverso:
![[Pasted image 20241220200318.png]]
questo grafo invece è aciclico (non ciclico)
## ordinamento topologico
l’ordinamento topologico si ottiene eliminando ricorsivamente un nodo che non ha archi entranti, eliminando insieme ad esso anche i suoi archi uscenti
>[!important] osservazioni
>- un grafo può ammettere più ordinamenti topologici, ed ognuo di essi è uno schedule seriale equivalente ad $S$
>- in particolare, quando ad una data iterazione della ricorsione si ha una scelta tra 2 nodi da eliminare, visto che si possono prendere 2 strade, si raddoppiano (sdoppiano ? aumentano di uno ? ) i possibili schedule

>[!info] rappresentazione di ordinamento topologico
![[Pasted image 20241220200827.png]]
in questo esempio, un ordinamento topologico può essere:
$$T_{4},T_{7},T_{5},T_{1},T_{8},T_{9},T_{2},T_{3},T_{6}$$
## teorema sulla correttezza dell’algoritmo del grafo di serializzazione
uno schedule $S$ è **serializzabile** $\iff$ il suo grafo di serializzazione è **aciclico**
- non lo dimostriamo :)))
>[!example] esempio
prendiamo uno schedule di 5 transizioni, e applichiamo l’algoritmo, segnando sulla tabela le relazioni tra le transazioni che produrranno archi nel grafo
![[Pasted image 20241220201829.png]]
la rappresentazione del grafo è la seguente:
![[Pasted image 20241220201942.png]]
notiamo che il grafo presenta il ciclo $T_{1},T_{2},T_{3},T_{4}$, e possiamo quindi concludere che lo schedule dato non è serializzabile
inoltre si nota che $T_{1},T_{2},T_{5}$ e $T_{2},T_{5},T_{3}$ **non** sono cicli in quanto i sensi delle frecce non descrivono cicli

# locking a 2 fasi
una transazioni obbedisce al protocollo di locking a 2 fasi (è a 2 fasi) se:
- prima effettua tutte le operazioni di `lock` (**fase di locking**)
- poi effettua tutte le operazioni di `unlock` (**fase di unlocking**)
>[!warning] NON CONFONDERE il lock a 2 fasi con il lock a 2 valori. 
>il fatto di essere a 2 fasi è una caratteristica in più, e non è una caratteristica propria del lock a 2 valori. esistono protocolli a 2 fasi e 3 valori, per esempio.
## teorema sul lock a 2 fasi
sia $T$ un insieme di transazioni
se ogni transazione in $T$ è a due fasi allora ogni schedule di $T$ è serializzabile (damn !)
## dimostrazione
>[!info] dimostrazione per assurdo
per assurdo, diciamo che ogni transazione in $S$ è a 2 fasi, ma nel grafo di serializzazione c’è un ciclo
![[Pasted image 20241221074850.png]]
ciò vuol dire che esiste una transazione che ha effettutato prima un `unlock`, e poi un `lock`
in questo caso per comodità chiamiamo $T_{1}$ la prima transazionei del ciclo che compare nello schedule (il seguente), che esegue un’operazione che genera un arco del ciclo
![[Pasted image 20241221080201.png|150]]

>[!warning] questo teorema non è una doppia implicazione !
esistono schedule che, pur non essendo a 2 fasi, sono serializzabili
>- inoltre se una transazione non è a 2 fasi, esiste sempre un’altra transazione a 2 fasi e uno schedule delle 2 transazioni che non è serializzabile 

quindi, solo se **tutte** le transazioni sono a 2 fasi possiamo avere la certeza che ogni schedule è serializzabile

>[!important]  **TUTTI** i protocolli di lock a 2 fasi (a prescindere dal numero di valori di lock) risolvono il problema **dell’aggregato non corretto**