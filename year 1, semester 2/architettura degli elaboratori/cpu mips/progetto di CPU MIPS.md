## introduzione
la cpu è una macchina sequenziale, ovvero uno stato + un cirucito combinatorio
![[Pasted image 20240420115353.png]]
il ciclo di clock è il periodo tra due positive edge del clock. esso è la durata dell’istruzione più lenta !!!
## progettare una CPU MIPS
CPU MIPS semplice non ottimizzata (senza pipeline)
- definire come viene eleborata una istruzione
- scegliere le istruzioni da realizzare
- scegliere le unità funzionali  necessarie
- collegare le unità funzionali
- costruire la CU(control unit) che controlla il funzionamento della CPU
- calcolare il massimo tempo di esecuzione delle istruzioni (che ci da il periodo di clock)

### fase di esecuzione di una istruzione

| fase       | descrizione                                                        |
| ---------- | ------------------------------------------------------------------ |
| fetch      | caricamento di una istruzione dalla memoria alla CU                |
| decodifica | decodifica della istruzione e lettura degli argomenti dai registri |
| esecuzione | esecuzione(attivazione delle unità funzionali necessarie)          |
| memoria    | accesso alla memoria                                               |
| write back | scrittura dei risultati nei registri                               |
altre operazioni necessarie:
- aggiornamento del pc (normale/salti /salti non condizionati)

### istruzioni da realizzare per una CPU

| descrizione                    | istruzioni         | tipo   |
| ------------------------------ | ------------------ | ------ |
| accesso alla memoria           | lw, sw             | tipo I |
| salti condizionati             | beq                | tipo I |
| operazioni aritimetico-logiche | add, sub, sll, slt | tipo R |
| salti non condizionati         | j, jal             | tipo J |
| operazioni con costanti        | li, addi, subi     | tipo I |

### unità funzionali necessarie

| unità              | descrizione                                           |
| ------------------ | ----------------------------------------------------- |
| PC                 | registro che contiene l’indirizzo del la l’istruzione |
| memoria istruzioni | contiene le istruzioni                                |
| adder              | per calcolare il PC (successivo o salto)              |
| registri           | contengono argomenti delle istruzioni                 |
| ALU                | fa le operazioni aritmetico-logiche, confronti, etc   |
| memoria dati       | da cui leggere/in cui scriere i dati (load/store)     |
le unità sono collegate da diversi `datapath` (interconnessioni che definiscono il flusso delle informazioni nella CPU e uniscono i vari componenti)

se un’unità funzionale può ricevere dati da più sorgenti è necessario inserire un `multiplexer(MUX)` per selezionare la sorgente necessaria 

le unità funzionali sono attivate e coordinate dai segnali prodotti dall CU !

# ingredienti
in questa sezione vengono descritti singolarmente i “blocchi” che, messi tutti in insieme, creano una CPU MIPS.
## memoria delle istruzioni, PC, adder
memoria istruzioni : prende in input un indirizzo a 32bit, e da in output l’istruzioni da 32bit situata nell’indirizzo di input

program counter(PC): registro che contiene l’indirizzo dell’istruzione corrente

sommatore: necessario per calcolare il nuovo PC, e le destinazioni dei salti. prende in input 2 valori a 32bit e ne fornisce in output la somma 

![[Pasted image 20240420120852.png|600]]

## registri e ALU
blocco dei registri(register file):
- contiene 32 registri a 32bit, indirizzabili con 5bit ($2^5 = 32$)
- può memorizzare un dato in un registro e contemporaneamente fornirlo in uscita
- 3 porte a 5 bit per indicare quali 2 registri leggere e quale registro scrivere
- 3 porte dati (a 32bit)
	- una in ingresso per il valore da memorizzare e 2 di uscita per i valori letti
- il regnale `regWrite` abilita (se 1) la scrittura nel registro di scrittura !

alu: 
riceve due valori interni a 32bit e svolge una operazione indicata dai segnali `Op. Alu`
- oltre al risultato da 32bit produce un segnale **zero** asserito se il risultato è zero
 ![[Pasted image 20240420121545.png|570]]
## unità di memoria e unità di estensione del segno
unità di memoria: 
- riceve in input un indirizzo da 32bit, che indica quale word della memoria va letta (dove c’è scritto indirizzo)
- riceve il segnale `MemRead` che abilita la lettura dall’indirizzo e la fornitura in output dei 32bit di dato letto (se bisogna fare operazione `lw`)
- riceve un dato da 32bit da scrivere in memoria a quell’indirizzo quando il segnale `MemWrite` è asserito (se bisogna fare operazione `sw`) (dove c’è scritto dato scritto)

unità di estensione del segno:
serve a trasformare un intero relativo (in CA2) da 16bit(in input) a 32bit(in output) 
- copia il bit del segno nei 16bit più significativi della word in output
![[Pasted image 20240420122213.png|600]]