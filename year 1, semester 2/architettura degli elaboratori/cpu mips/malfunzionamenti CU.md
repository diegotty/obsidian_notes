se la CU genera segnali errati, bisogna individuare: 
- quale combinazione di segnali venga generata
- quali istruzioni vengano influenzate dalle nuove combinazioni e cosa facciano
una volta individuate le nuove funzionalità, si può scrivere un breve programma che evidenzia se la CPU sia malfunzionante o meno
## regWrite ← Branch
si ha il dubbio che, per difetto di progettazione della CU:
- il segnale RegWrite sia determinato dal segnale Branch(RegWrite == Branch)
si assume che:
- MemToReg = 1 solo per lw ed altrimenti valga 0
- RegDest = 1 solo per le istruzioni di tipo R e altrimenti valga 0
le istruzioni affette sono:
- tutte le istruzioni in cui si va a modificare in un registro (tipo R e lw(anche lw scrive su un registro oltre a leggere dalla memoria !)))
- i branch, che oltre a saltare, scriveranno anche in un registro
	- il valore scritto sarà la differenza tra i 2 termini del branch
	- e il registro sovrascritto sarà rt (RegDest = 0)

![[Pasted image 20240508100750.png|600]]

per individuare se la CPU sia malfunzionante, creiamo un programma che lasci il valore 0 nel registro $s0 se lo è, e scriva 1 se funziona correttamente, tenendo conto che non possiamo scrivere un valore in un registro perchè RegWrite = 0
```armasm
addi $s0, $zero 1 # = 1 ma se è malfunzionante non verrà salvato 1
```

## MemWrite ← not(RegWrite)
si ha il dubbio che:
- il segnale di controllo MemWrite sia attivo solo se non è attivo il segnale RegWrite
si assume che:
- MemToReg = 1 solo per la lw ed altrimenti rimanga 0
- RegDest = 1 solo per le istruzioni di tipo R ed altrimenti valga 0
le istruzioni affette sono:
- le istruzioni cui RegWrite e MemWrite dovrebbero essere entrambe a 0 o 1:
- j e beq, in cui oltre a saltare si scriverà anche in memoria
```armasm
li $s0, 0
li $s1, 1
beq $s1, $s1, On //1-1 = 0 (indirizzo zero), e salva il contenuto di $s1 che è 1
On:
lw $s0,0 
```