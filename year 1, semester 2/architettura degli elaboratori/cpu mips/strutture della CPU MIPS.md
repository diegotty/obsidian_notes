## fetch della istruzione / aggiornamento PC
il seguente blocco, gestisce l’avanzamento del PC e la lettura dell’istruzione dalla memoria delle istruzione
note:
- le connessioni sono da 32bit
- mentre viene letta l’istruzione viene già calcolato il nuovo PC
![[Pasted image 20240420123000.png|400]]
## operazioni ALU e accesso a MEM
decodifica facilitata: i formati I ed R sono quasi uguali
il secondo argomento dell’istruzione può essere o un registro o un campo immediato. per gestire ciò si usa un MUX: la linea di controllo `ALUSrc` seleziona  **dato letto 2** o **l‘output del blocco di estensione del segno**

note: 
nel blocco di estensione del segno entrano i 16bit non letti dal blocco dei registri(che corrispondono all’indirizzo del valore immediato delle istruzioni di tipo I)
## esempi
![[Pasted image 20240420125612.png]]

## aggiungere salti condizionati (beq)
struttura per poter effettuare salti condizionati:
![[Pasted image 20240421140628.png|400]]

parte della struttura completa (senza la linea di controllo `PCSrc`)
![[Pasted image 20240421140430.png|550]]
struttura completa: 
viene usata una porta and per controllare se:
- l’istruzione è un branch (la linea viene presa dal blocco [[#unità di controllo]])
- i due registri sono uguali (siamo implementando un `beq`)
l’uscita della porta and viene poi usata come linea di selezione per il mux
![[Pasted image 20240421140936.png|500]]

## unità di controllo
fino ad ora abiamo considerato i 4 bit che decidono l’operazione(la linea di selezione dell’ALU) come delle incoginte. L’ALU in realtà fa un totale di 6 operazioni in base alla seguente codifica:

| ALU control lines | function         |
| ----------------- | ---------------- |
| 0000              | AND              |
| 0001              | OR               |
| 0010              | add              |
| 0110              | subtract         |
| 0111              | set on less than |
| 1100              | NOR              |
si hanno 2 livelli di codifica:
il primo lo fa la control unit, che prende in input i 6 bit di opcode, e ricava tutti i segnali di controllo necessari, tra cui ALUOp.
![[Pasted image 20240421141924.png|400]]
in qualche modo entrano 6 bit e escono 9 bit ??? decodificatore ????
 guardando l’`ALUOp` che esce dalla Control Unit, si può notare immediatamente che tipo di operazione bisogna fare: infatti se l’`ALUOp` inizia per 0, si tratterà di `lw`, `sw`, oppure `beq`(e non sarà necessario i 6 bit di funct), altrimenti di operazioni di tipo R.
 
 per questo motivo si hanno 2 livelli di decodifica:
 ![[Pasted image 20240421143222.png]]
 la ALU Control Unit prende in ingresso i 6 bit di funct e ha come linee di selezione di ALUOp. speculo che funzioni come un misto tra decoder e mux, poichè essa genererà i 4 bit che serviranno come linea di controllo alla ALU.
 
| Codice operativo istruzione | ALUOp | Operazione eseguita dall’istruzione | Campo funzione(funct) | Operazione dell’ALU | Ingresso di controllo alla ALU |
| :-------------------------: | :---: | :---------------------------------: | :-------------------: | :-----------------: | :----------------------------: |
|            `lw`             |  00   |          load di 1 parola           |        XXXXXX         |        somma        |              0010              |
|            `sw`             |  00   |          store di 1 parola          |        XXXXXX         |        somma        |              0010              |
|        Branch equal         |  01   | salto condizionato all’uguaglianza  |        XXXXXX         |     sottrazione     |              0110              |
|           Tipo R            |  10   |                somma                |        100000         |        somma        |              0010              |
|           Tipo R            |  10   |             sottrazione             |        100010         |     sottrazione     |              0110              |
|           Tipo R            |  10   |                 AND                 |        100100         |         AND         |              0000              |
|           Tipo R            |  10   |                 OR                  |        100101         |         OR          |              0001              |
|           Tipo R            |  10   |            set less than            |        101010         |    set less than    |              0111              |
### tabella di verità per operazione ALU
![[Pasted image 20240421143818.png]]

## datapath completo
![[Pasted image 20240421144032.png]]il mux cui linea di selezione è `RegDst` permette di scegliere quando prendere come registro di scrittura `rd`( istruzione di tipo R), o `rt` istruzione di tipo I
### esempi
esecuzione di un istruzione di tipo R
![[Pasted image 20240421144753.png]]

## segnali di controllo

| Nome del segnale | Effetto quando non asserito                                                                  | Effetto quando asserito                                                                                                            |
| ---------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `RegDst`         | il numero dei registri in scrittura proviene dal campo rt (bit 20-16)                        | il numero del registro di scrittura proviene dal campo rd (bit 15-11)                                                              |
| `RegWrite`       | nulla                                                                                        | il dato viene scritto nel register file nel registro individuato dal numero del registro di scrittura                              |
| `ALUSrc`         | il secondo operando della ALU proviene dalla seconda uscita del register file (Dato letto 2) | il secondo operando della ALU proviene dall’estensione del segno dei 16 bit meno significativi dell’istruzione                     |
| `MemRead`        | nulla                                                                                        | il dato della memoria nella posizione puntata dall’indirizzo viene inviato in uscita sulla linea “dato letto”                      |
| `MemWrite`       | nulla                                                                                        | il contenuto della memoria nella posizione puntata dall’indirizzo viene sostituito con il dato presente sulla linea “dato scritto” |
| `MemtoReg`       | il dato viene inviato al register file per la scrittura, proviene dalla ALU                  | il dato inviato al register file per la scrittura proviene dalla Memoria Dati                                                      |
l’ALU deve seguire 4 tipi di comportamento:
- se l’istruzione è di tipo R, eseguire l’operazione indicata dal campo `funct`
- se l’istruzione accede alla memoria(`lw, sw`), svolgere la somma che calcola l’indirizzo
- se l’istruzione è un `beq`, deve svolgere una differenza
per codificare 3 comportamenti bastano 2bit. quindi la CU dovrà produrre 4 combinazioni di bit per 4 casi diversi:

| istruzione | regDst | ALUSrc | MemtoReg | RegWrite | MemRead | MemWrite | Branch | ALUOp1 | ALUOp0 |
| ---------- |:------:|:------:|:--------:|:--------:|:-------:|:--------:|:------:|:------:|:------:|
| Tipo R     |   1    |   0    |    0     |    1     |    0    |    0     |   0    |   1    |   0    |
| `lw`       |   0    |   1    |    1     |    1     |    1    |    0     |   0    |   0    |   0    |
| `sw`       |   X    |   1    |    X     |    0     |    0    |    1     |   0    |   0    |   0    |
| `beq`      |   X    |   0    |    X     |    0     |    0    |    0     |   1    |   0    |   1    |

## tempi di esecuzione
se conosciamo il tempo necessario a produrre i risultati delle diverse unità funzionali, possiamo calcolare il tempo totale di ciascuna istruzione (basta fare la somma di esse)

| istruzione | regDst | ALUSrc | MemtoReg | RegWrite | MemRead | MemWrite | Branch | ALUOp1 | ALUOp0 |
| ---------- | :----: | :----: | :------: | :------: | :-----: | :------: | :----: | :----: | :----: |
| Tipo R     |   1    |   0    |    0     |    1     |    0    |    0     |   0    |   1    |   0    |
| `lw`       |   0    |   1    |    1     |    1     |    1    |    0     |   0    |   0    |   0    |
| `sw`       |   X    |   1    |    X     |    0     |    0    |    1     |   0    |   0    |   0    |
| `beq`      |   X    |   0    |    X     |    0     |    0    |    0     |   1    |   0    |   1    |
