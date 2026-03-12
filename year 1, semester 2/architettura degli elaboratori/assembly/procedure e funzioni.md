frammento di codice che riceve degli argomenti e calcola un risultato (utile per rendere il codice riusabile e modulare !)
- ha un indirizzo di partenza
- riceve uno o o più argomenti
- svolge un calcolo
- ritorna un risultato
- continua la sua esecuzione dall’istruzione seguente a quella che l’ha chiamata ( a livello di program counter)

>[!tuff] usiamo jal(jump and link) to “call” functions

# istruzioni necessarie

## jal
ci permette di saltare ad un indirizzo, ma salva in `$ra` l’address della prossima istruzione **del chiamante**, quindi a fine funzione basta saltare all’indirizzo in `$ra` (usando `jr`) per tornare alla riga giusta del chiamante

## parametri
per passare valori alla funzione usiamo i registri `$a0, $a1, $a2, $a3, $a4` se ci bastano 4 parametri. altrimenti possiamo usare diversi [[pezzi del funzionamento di MIPS#modi di indirizzamento|modi di indirizzamento]]

## valori di torno
i valori di ritorno vanno salvati, per convenzione (?), nei registri `$v0, $v1`

### convenzioni
`$t0, $t1, …` possono cambiare tra una chaiamta e l’altra(sono temporary)
`$s0, $s1, ….` non cambiano tra una chiamata  e l’altra(saved)
more about this in [[#preservare il contenuto dei registri]]

# preservare il contenuto dei registri
una delle limitazioni della struttura delle funzioni è la non-possibilità di avere più di 128bit di parametri e avere 64 bit di ritorno.

quando avvengono chiamate a funzioni nidificate, bisogna gestire i contenuti (soprattuto di `$ra` !!, che viene sovrascritto quando viene chiamata un’altra funzione)

conviene quindi preservare il precedente contenuto dei registri usati dalla funzione e ripristinarlo (al contenuto prima della chiamata !). ciò garantisce meno vincoli alla funzione chiamante :)

## chiamate nidificate
ciclo di vita caratteristico delle informazioni :
```
-salvo stato prima di chiamata 1
	-salvo stato prima di chiamata 2
		- salvo stato prima di chiamata n
			....
		-ripristino stato prima di chiamata n
	-ripristino stato prima di chiamata 2
-ripristino stato prima di chiamata 1
```
quello illustrato sopra è il comportamento di uno stack (struttura LIFO)
lo stack viene realizzato con un vettore di cui si tiene l’indirizzo dell’ultimo elemento occupato nel registro `$sp` 
![[Pasted image 20240331213146.png|150]]
in questo snapshot della memoria, `$sp` = 980
lo stack cresce verso il basso ! quando viene aggiunto qualcosa, `$sp` va decrementato
### come salvare un elemento
si decrementa lo `$sp` della dimensione dell’elemento (in byte !!!!)
si memorizza l’elemento nella posizione 0 (in questo caso `$ra`)
```armasm
subi $sp, $sp, 4
sw $ra, 0($sp)
```
### come recuperare un elemento
```armasm
lw $ra, 0($sp)
addi $sp, $sp, 4
```
quindi:
## come usare lo stack in una funzione
all’inizio della funzione:
- allocare su stack abbastanza word da contenere i registri da preservare
- salvare su stack i registri, ad offset multipli di 4 rispetto ad `$sp`
all’uscita della funzione:
- ripristinare da stack i registri salvati, agli stessi offset usati precedentemente
- disallocare da stack lo stesso spazio allocato in precedenza
- tornare alla funzione chiamante

inoltre lo stack viene usato anche per:
- comunicare ulteriori argomenti oltre a `$a0, .., $a3`
- comunicare ulteriori risultati oltre a `$v0, $v1`
- allocare variabili locali alla procedura
![[Pasted image 20240331220300.png|150]]
questo blocco viene chiamato **stack frame** o **activation record**
- lo stack pointer punta alla fine dello stack frame
- il frame pointer punta all’inizio dello stack frame(ridondante ma comodo, non molto usato)((ridondante perchè su assembly siamo noi a hard-codare la dimensione dello stack frame di una funzione, quindi sappiamo quanto è grande e dove inizia se guardiamo allo stack pointer))

![[Pasted image 20240331214612.png|500]]