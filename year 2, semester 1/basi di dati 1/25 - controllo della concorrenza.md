---
created: 2024-12-19
related to: "[[intro alla concorrenza]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [transazione](#transazione)
>	- [proprietà della transazioni](#propriet%C3%A0%20della%20transazioni)
>- [schedule](#schedule)
>	- [schedule seriale](#schedule%20seriale)
>	- [problemi](#problemi)
>	- [serializzabilità](#serializzabilit%C3%A0)
>		- [equivalenza di schedule](#equivalenza%20di%20schedule)
>	- [garantire la serializzabilità](#garantire%20la%20serializzabilit%C3%A0)
>		- [item](#item)

in sistemi di calcolo con una sola CPU, i programmi sono eseguiti concorrentemente in modo **interleaved**: la CPU esegue alcune istruzioni di un programma, sospende quel programma, esegue istruzioni di altri programmi, ritorna ad eseguire istruzioni del primo, etc.
- questo perchè l’esecuzione concorrente permette un uso efficiente della CPU
in un DBMS la principale risorsa a cui i programmi accedono in modo concorrente è la base di dati
- se sulla BD vengono effettuate **letture** (la BD non viene mai modificata), l’accesso concorrente non crea problemi
- se sulla BD vengono effettuate anche **scritture** (la BD viene modificata), l’accesso concorrente può creare problemi e deve essere quindi **controllato**
# transazione
una transazione è l’esecuzione di una parte di programma che rappresenta un’unità logica di acceso o modifica del contenuto della base di dati

## proprietà della transazioni
le transazioni sono dotate di proprietà **ACID** (Atomicity, Consistency, Isolation, Durability)

- **atomicità**: una transazione è **indivisibile** nella sua esecuzione, e la sua esecuzione deve essere **o totale, o nulla**, non sono ammesse esecuzioni parziali.

- **consistenza**: quando inizia una transazione, la BD si trova in uno stato consistente, e quando la transazione termina la BD deve **essere in un altro stato consistente**, ovver non deve violare eventuali [[02 - modello relazionale#vincoli di integrita’|vincoli di integrità]], quindi non devono verificarsi contraddizioni (inconsistenza) tra i dati archiviati nella BD
 
 - **isolamento**: ogni transazione deve essere eseguita in modo isolato ed indipendente dalle altre transazioni, e l’eventuale fallimeno di una transazione non deve interferire con le altre transazioni in esecuzione
	 - una transazione ben progettata non deve dipendere da altre transazioni (il risultato non deve dipendere dal fatto che altre transazioni vengano eseguite prima o dopo (il risultato può cambiare, )) se ho 3 transazioni $T_1,T_2, T_3$, qualunque permutazione delle transazioni deve essere eseguibile
 
 - **durabilità**: anche chiamata persistenza, si riferisce al fatto che una volta che una transazione abbia richiesto un **commit work**, i cambiamenti apportati non dovranno essere più persi. per evitare che nel lasso di tempo fra il momento in cui la base di dati si impegna a scrivere le modifiche, e quello in cui le modifiche vengono effettivamente scritte si verifichino perdite di dati dovuti a malfunzionamenti, **vengono tenuti dei registri di log** dove sono annotate tutte le operazioni sulla BD
# schedule
uno schedule è un piano di esecuzione di un insieme $T$ di transizioni
lo schedule è un ordinamento **delle operazioni delle transazioni** in $T$ che conserva l’ordine che le operazioni hanno all’interno delle singole transazioni
>[!example] esempio
>se l’operazione $O1$ precede l’operazione $O2$ nella transazione $T$, sarà così anche in ogni schedule in cui compare $T$ (le due operazioni saranno eventualmente separate da operazioni di altre transazioni, ma il loro ordine non verrà mai invertito)
## schedule seriale
schedule ottenuto permutando le transazioni di $T$. uno schedule seriale corrisponde ad una esecuzione **sequenziale**(senza interlaving) delle transazioni
- una transazione che prende la CPU non la rilascia finchè non ha finito le sue operazioni
- lo schedule seriale è il nostro punto di riferimento
## problemi
>[!important] quando una transazione legge un item, esso viene preso dalla memoria secondaria e caricato in una parte privata, della singola transazione, di memoria principale

quali sono i problemi che possono sorgere a causa dell’esecuzione concorrente dei programmi ?
>[!example] dati
>date le transazioni $T_1, T_2$:
![[Pasted image 20241219093135.png]]

>[!example] esempio 1: ghost update
consideriamo il seguente schedule:
>se il valore iniziale di $X$ è $X_0$, al termine dell’esecuzione dello schedule il valore di $X$ è $X_0+M$ invece di $X_0-N+M$
![[Pasted image 20241219093217.png]]
quindi in questo schedule, l’aggiornamento di $X$ prodotto da $T_1$ viene perso

>[!example] esempio 2: dato sporco
consideriamo il seguente schedule: se il valore iniziale di $X$ è $X_0$, al termine dell’esecuzione dello schedule, il valore di $X$ è $X_0-N+M$ invece di $X_0 + M$
![[Pasted image 20241219094444.png]]
il valore di $X$ letto da $T_2$ è un **dato sporco**(temporaneo), in qunto è prodotto da una transazione fallita. per atomicità quindi bisogna pulire i dati e viene fatto attraverso un rollback a cascata

>[!example] esempio 3: aggregato non corretto
consideriamo il seguente schedule: se il valore inziale di $X$ è $X_0$ e il valore iniziale di $Y$ è $Y_0$, al termine dell’esecuzione dello schedule il valore di somma è $X_0 - N + Y_0$ invece di $X_0 + Y_0$
![[Pasted image 20241219094643.png]]
il valore di `somma` è un dato **aggregato non corretto**(abbiamo preso un valore aggiornato di X e non aggiornato di Y)
>- ricordiamo che il nostro punto di riferimento è sempre lo schedule seriale: le permutazioni possibili sono $T_1, T_3$, $T_3,T_1$, e in entrambi i casi `somma` all fine dello schedule vale $X_{0} + Y_{0}$, invece di $X_0 - N + Y_0$ 
## serializzabilità
>[!important] tutti gli schedule seriali sono corretti

uno schedule **non seriale** è corretto se è serializzabile, cioè se è “equivalente” ad uno schedule seriale
- equivalente non è da intendere con lo stesso significato che ha per 2 insiemi di dipendenze funzionali, in cui l’equivalenza era data dal fatto di avere la stessa chiusura
capiamo quindi cosa vuold dire essere equivalenti:
prendiamo per ipotesi che, due schedule sono equivalenti se, per ogni dato modificato, producono valori uguali
>[!example] controesempio
![[Pasted image 20241219095648.png]]
in questo caso, i due schedule producono gli stessi valori **solo** se il valore iniziale di $X$ è 10 !
> quindi l’ipotesi non basta
### equivalenza di schedule
due schedule sono equivalenti se, per ogni dato modificato, producono valori uguali, **dove** due valori sono uguali **solo se sono prodotti dalla stessa sequenza di operazioni**
>[!info] osservazione
in questo caso, i seguenti schedule non sono equivalenti, in quanto, pur dando lo stesso risultato su $X$, $X$ non è prodotto dalla stessa sequenza di operazioni. però, visto che sono entrambi schedule seriali, sono entrambi schedule corretti
![[Pasted image 20241219100258.png]]

## garantire la serializzabilità
testare la serializzabilità per un dato schedule, a livello pratico, è molto difficile in quanto:
- è difficile stabilire quando comincia uno schedule e quando finisce
- è praticamente impossibile determinare in anticipo in quale ordine le operazioni verranno eseguite, in quanto l’ordine è determinato da vari fattori che non conosciamo a runtime
- se prima si eseguono le operazioni e poi si testa la serializzabilità dello schedule, i suoi effetti devono essere annullati se lo schedule risulta non serializzabile (scomodo)

l’approccio seguito nei sistemi è quello di determinare dei **metodi che garantiscono la serializzabilità** di uno schedule, eliminando così la necessità di dover testare ogni volta la serializzabilità di uno schedule

i 2 metodi che studieremo sono:
- imporre dei protocolli, cioè delle regole, alle transazioni in modo da garantire la serializzabilità di ogni schedule
- usare i [[30 - timestamp|timestamp]] delle transazioni, cioè degli identificatori delle transazioni che vengono generati dal sistema, e in base ai quali le operazioni delle transazioni possono essere ordinate in modo da garantire la serializzabilità
### item
entrambi i metodi fanno usato del concetto di **item**, cioè un’unità della BD a cui l’accesso è controllato 
- può essere una tupla, un campo di una tupla, una intera tabella
le dimensioni degli item devono essere definite in base all’uso che viene fatto dalla base di dati in modo tale che, in media, una transazione acceda a pochi item
- le dimensioni degli item usate da un sistema sono dette la sua **granularità**, e quella degli item va dal singolo campo all’intera tabella e oltre
	- una granularità grande permette una gestione efficiente della concorrenza
	- una granularità piccola può sovraccaricare il sistema, ma aumenta il **livello di concorrenza** (multiprogrammazione) , cioè consente l’esecuzione concorrente di molte transazioni)