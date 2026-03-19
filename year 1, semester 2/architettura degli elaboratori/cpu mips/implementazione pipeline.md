per implementare la pipeline, e permettere quindi il forwarding, è necessario integrare dei registri tra le varie unità funzionali, in modo tale da poter recuperare un dato se necessario
![[Pasted image 20240509220559.png]]

## modifica write back
in questo “snapshot” della cpu, si nota ci sarebbe un problema con il writeback della prima istruzione, in quanto in quel ciclo di clock verrebbe decodificata l’istruzione 4. per questo motivo il write back della prima istruzione avverrebbe nel registro sbagliato ! (il reg destinazione dell’istr 4)
![[Screenshot 2024-05-09 221907.png]]
![[Pasted image 20240509221854.png]]
fix: il write back viene preso solamente dalla propagazione dei registri, non viene caricata durante la decodifica dell’istruzione nella fase 2. in questo modo non ci possono essere problemi come l’esempio sopra.
![[Pasted image 20240509222902.png]]

## propagazione dei segnali di controllo
possiamo dividere i 9 segnali di controllo delle fasi in 3 gruppi:
![[Pasted image 20240509223255.png]]
in questo modo, possiamo facilmente propagare anche i segnali di controllo. come si vede dall’imagine, dopo ogni fase, non servono più i segnali di controllo di tale fase e non vengono quindi propagati
![[Pasted image 20240509223407.png]]
 
### forwarding in EXE
supponiamo di avere questa sequenza di istruzioni:
```arm-asm
sub $2, $1, $3
and $12, $2, $5
or $13, $6 ,$2
add $14, $2, $2
sw $15, 100($2)
```
In questo caso, nonostante tutte le istruzioni utilizzino il registro `$2` le uniche istruzioni che avranno il risultato corretto di `sub` saranno `add` e `sw` in quanto le altre due leggerebbero solamente il valore precedentemente immagazzinato in `$2`.

- il risultato dell’istruzione sub, è però, già disponibile al termine della fase EXE. 
- inoltre, le istruzioni `and` e `or` hanno bisogno di `$2` solamente all'inizio della loro fase EXE.
di conseguenza, è possibile eseguire questo frammento di codice senza stalli, semplicemente propagando il dato a qualsiasi unità lo richieda non appena è disponibile

Questo veloce esempio ci fa subito capire quali siano le casistiche che ci portano ad un data hazard in EXE:
1a. $\text{EX/MEM.RegistroRd}=\text{ID/EX.RegistroRs}$
1b. $\text{EX/MEM.RegistroRd}=\text{ID/EX.RegistroRt}$
2a. $\text{MEM/WB.RegistroRd}=\text{ID/EX.RegistroRs}$
2b. $\text{MEM/WB.RegistroRd}=\text{ID/EX.RegistroRt}$

il primo hazard generato nell’esempio è quello tra `sub $2, $1, $3` e `and $12, $2, $5`. l’hazard può essere rilevato quando l’istruzione `and` si trova nella fase EXE, e l’istruzione precedente si trova nella fase MEM.
l’hazard è di tipo 1 : $\text{EX/MEM.RegistroRd}=\text{ID/EX.RegistroRs}=\$2$

in questo modo però, potremmo propagare dati in casi non necessario, dato che non tutte le istruzioni scrivono il risulato nel register file.
una possibile soluzione è controllare se il segnale RegWrite è attivo nelle pipeline EXE/MEM e MEM/WB. inoltre, per diminuire i casi di propagazione inutile, si può controllare se il registro destinazione (`rd`) è $0, in quanto se ciò fosse così niente verrebbe veramente scritto in rd.
ecco quindi tutti i casi di data hazard, con controlli:
![[Pasted image 20240515213917.png]]

viene aggiunto anche MemRead == 0 perchè nel caso sotto, una parte dei 16bit di offset risulta, per caso, essere uguale all’`rs` dell’istruzione successiva, e inoltre è nella stessa posizione di un eventuale `rd` se l’istruzione fosse di tipo R
![[Pasted image 20240515214057.png]]

il forwarding su EXE viene implementato così: 
![[Pasted image 20240515214318.png]]
i 5 bit di `rs` e `rd` dell’istruzione in ID vengono confrontati con i 5 bit di `rd` di una e due istruzioni prima !

**Modifiche al data path** → inserire MUX prima della ALU per selezionare i 3 casi:
- *non c’è forwarding*
	il valore per la ALU viene dal registro **ID/EX** della pipeline
- *forwarding dall’istruzione precedente*
	il valore per la ALU viene dal registro **EX/MEM** della precedente
- *forwarding da 2 istruzioni precedenti*
	il valore per la ALU viene dal registro **MEM/WB** della precedente

è possibile realizzare il forwaring anche:
- nella fase ID (necessario solo se `beq` viene anticipata in ID)
- nella fase di MEM (necessario solo se `lw $rd...`, è subito seguita da `sw $rd...`, se `sw` è preceduta da tipo R il forwarding avviene in fase EXE )

l’unità di propagazione produce i seguenti segnali di controllo:

| Segnale multiplexer | Sorgente | Spiegazione                                                                                             |
| ------------------- | -------- | ------------------------------------------------------------------------------------------------------- |
| PropagaA = 00       | ID/EX    | Il primo operando della ALU proviene dal register file                                                  |
| PropagaA = 10       | EX/MEM   | Il primo operando della ALU viene propagato dal risultato della ALU nel ciclo di clock precedente       |
| PropagaA = 01       | MEM/WB   | Il primo operando della ALU viene propagato dalla memoria dati o da un precedente risultato della ALU   |
| PropagaB = 00       | ID/EX    | Il secondo operando della ALU proviene dal register file                                                |
| PropagaB = 10       | EX/MEM   | Il secondo operando della ALU viene propagato dal risultato della ALU nel ciclo di clock precedente     |
| PropagaB = 01       | MEM/WB   | Il secondo operando della ALU viene propagato dalla memoria dati o da un precedente risultato della ALU |

## forwarding in MEM
un data hazard in MEM avviene solamente quando vengono caricate, in squenza, un `lw` e un `sw` su uno stesso registro `$rd`

![[Pasted image 20240515215329.png]]

>[!tuff] sintassi simile ma diversa !!
>è importante ricorda che $t0 in lw è la destinazione in cui scrivere, mentre in sw è da dove leggere !!!

riconoscere questo hazard è molto facile: basta controllare se l’istruzione precedente sta cercando di leggere dalla memoria e poi scrivere nel registro (e quindi l’istruzione è una lw), e l’istruzione presente sta provando a scrivere in memoria (ed è quindi una sw)
![[Pasted image 20240515220219.png]]

il forwarding su MEM viene implementato così:
![[Pasted image 20240515220321.png]]

## stallo dell’istruzione
Talvolta però risulta necessario che l’istruzione debba attendere che sia pronto il dato prima di poter effettuare un forwarding. 
```armasm
lw $2, 20($1)
and $4, $2, $5
or $8, $2, $6
add $9, $4, $2
slt $1, $6, $7
```
in questo caso l’`and` usa un dato che sarà pronto solo dopo la fase MEM. è quindi necessario introdurre uno stallo.
per effettuare uno stallo, basta impedire la modifica del PC-

lo stallo viene eseguito attraerso l’ausilio di istruzioni che non producono effetti dette NOP(not operation). una delle nop consiste nell’impostare tutti i campi a 0 !
cpu con pipeline e stallo (semplificata):
![[Pasted image 20240515224013.png]]
l’unità di rilevamento degli hazard manda una linea di selezione nel mux che decide se caricare l’istruzione o la NOP, e inoltre ha 2 linee, `PCWrite` e `IF/IDWrite`, la prima per evitare l’avanzamento del PC  e la seconda per azzerare i segnali di controllo e IF/ID.Istruzione.

stallo in azione:
![[Pasted image 20240515224400.png]]