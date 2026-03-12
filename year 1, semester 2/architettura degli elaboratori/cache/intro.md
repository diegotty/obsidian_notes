## principio della località
- principio di località temporale: un programma tende ad accedere allo stesso elemento in momenti temporali vicini tra loro
- principio di località spaziale: un programma tende ad accedere successivamente a elementi di memoria vicini tra loro
per sfruttare al massimo questi due principi, interponiamo una memoria piccola, la **cache** tra la CPU e la memoria, in cui conserveremo:
- i dati più usati (principio di località temporale)
- i dati vicini a quelli più usati (principio di località spaziale)


## schema e terminologia
- la memoria RAM è divisa in blocchi, e ogni blocco a X word

- la cache è divisa in blocchi di dimensioni uguali
- la cache contiene un numero N di linee ( o set)

## hit e miss
quando la CPU richiede un indirizzo di memoria, appartenente ad un blocco (????), le possibilità sono 2:
- **MISS**: il blocco è stato caricato nella cache, dunque il dato all’indirizzo richiesto viene restituito immediatamente
- **HIT**: il blocco non è presente nella cache, il dato viene richiesto alla RAM, caricando all’interno della cache **l’intero blocco** a cui esso appartiene

## cache direct-mapped
poichè una cache deve contenere solo i dati più richiesti, utilizzando dimensioni limitate, è necessario che più blocchi di memoria vengano salvati nello stesso spazio, sovrascrivendosi a vicenda
la cache direct-mapped viene strutturata in questo modo:
![[Pasted image 20240603095007.png]]
- N linee, corrispondenti agli spazi occupabili dai blocchi. ogni linea è composta da:
	- un bit di validità: indicante se i dati contenuti nella linea siano validi o meno.
	- un campo tag: **in grado di distinguere quale blocco della memoria sia caricato nella linea**. tale campo risulta fondamentale poichè più blocchi di memoria vengono mappati sulla stessa linea. grazie al tag si previene la lettura del blocco sbagliato
	- il blocco stesso, memorizzato all’interno della linea
inoltre: 
- per praticità, realizziamo la cache di 2^n linee, associando ad ognuna un indice. per selezionare uno di tali indici, servono quindi n bit.
- la memoria viene scomposta in blocchi da 2^m word, dove. la dimensione di ogni blocco risulta quindi essere 2^m * 4 * 8 bit.
- abbiamo bisogno di un valore, l’**offset di word**, che possa indicare quale word all’interno del blocco corrisponde alla richiesta dall’indirizzo di memoria. ci serviranno m bit per selezionare tra 2^m word.
- abbiamo bisogno di un valore, l’**offset di byte**, che vada a selezionare quale dei 4 byte componenti la word selezionata dall’offset di word, corrisponde al byte(ma non dovrei quasi sempre caricare word ???) specifico richiesto dall’indirizzo di memoria. poichè ogni word è sempre composta da 4byte, saranno necessari 2 bit.
![[Pasted image 20240603105341.png]]

partendo dall’indirizzo di memoria, possiamo quindi scomporlo in questo modo:
![[Pasted image 20240603100037.png]]
possiamo reverse-engineer-are che:
- la cache ha 2^5 linee
- ogni blocco ha 16 word
- la dimensione di un blocco è: blocchi * 4 * 8 = 512bit
- la dimensione del tag è:  32 - n - m - 2 = 21bit
- la dimensione di una linea è: 



![[Pasted image 20240603101944.png]]
**i blocchi in viola sono gli indirizzi richiesti dalla CPU.**
- (l’indirizzo 128, dovrebbe stare nel blocco 4, linea 0 e il tag dovrebbe essere 1.)
la cache viene inizializzata con tutti i valdity bit posti su 0.
![[Pasted image 20240603102442.png]]


>[!tuff] IL NUMERO DI BLOCCO, NELLA CACHE DIRECT-MAPPED, è L’UNIONE DI LINEA E TAG ! OGNI LINEA HA SOLO UN BLOCCO !!!!
>puoi pensarla come la “““somma””” di tag e indice di linea, e infatti per trovare tag e indice di linea si fanno operazioni sul numero di blocco. non serve un numero di blocco in quanto sarebbe uguale all’indice di linea

### pro
è facile determinare in quale linea cercare il dato: \#linea = \#blocco % N(numero di linee) 
### contro
blocchi diversi sono mappati(sovrascritti) sulla stessa linea → se gli accessi a quei blocchi si alternano, si verificano molti miss (si sovrascrivono reciprocamente dato che il tag sarà diverso ma la linea no)
## cache fully-associative
- un blocco può essere posto in una linea qualsiasi
## cache set-associative
l’uso di una cache direct-mapped è in grado di ridurre la quantità di accessi alla memoria svolti da un programma. purtroppo, data la struttura rigorosa, ogni linea può contenere un solo blocco, generando una continua sovrascrittura dei dati per rimpiazzare i blocchi.
![[Pasted image 20240603105429.png]]

la **cache set-associative**, permette di salvare più blocchi sulla stessa linea (che viene chiamata set), le quali sono divise in S vie, dove ogni via può contenere un blocco.
>[!tuff] se una cache set-associative ha 1 sola via, è come una cache direct-mapped !
>le vie indicano il numero di blocchi che possono essere caricati INSIEME(senza doverne sovrascrivere) in una sola linea

![[Pasted image 20240603105326.png]]

circuito della cache set-associative:
![[Pasted image 20240603110034.png]]
## politiche di rimpiazzo e scrittura
nel caso in cui si debba andare a inserire un nuovo blocco in una linea di una cache set-associative e tale linea sia piena, è necessario selezionare quale blocco andrà ad essere rimpiazzato.
vengono utilizzate 3 politiche di rimpiazzo:
- rimpiazzo random, dove viene rimpiazzato un blocco casuale
- least recently used (LRU), dove viene rimpiazzato il blocco il cui ultimo accesso risulta più vecchio
- least frequently used (LFU), dove viene rimpiazzato il blocco cui ultimo accesso risulta il meno frequente
oltre al rimpiazzo, è necessario utilizzare una politica di scrittura in caso un dato della memoria venga modificato nella cache:
…….
per indicare se un dato è stato modificato nella cache, viene associato ad ogni blocco un **dirty bit**(1 se il blocco è stato modificato, 0 se non ha subito modifiche)
# tipi di miss
nel caso si verifichi un miss in qualsiasi tipologia di cache (anche direct-mapped), possiamo identificare tre tipologie di MISS:
- il blocco richiesto da un accesso non è mai stato richiesto prima ( cold miss)
- il miss non si sarebbe verificato con una cache fully-associative il cui numero di vie corrisponde al prodotto tra il numero di vie e il numero di linee della cache utilizzata (conflict miss)
- il miss si sarebbe verificato anche su una cache fully-associative (capacity miss)
