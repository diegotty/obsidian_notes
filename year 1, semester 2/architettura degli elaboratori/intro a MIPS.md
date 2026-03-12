## architettura CISC vs RISC
in era moderna, possiamo individuare 2 tipologie principali di architetture di calcolatori:

| architettura CISC                                                                                                                               | architettura RISC                                                                                                         |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **istruzioni di dimensione variabile**<br>-per il fetch della successiva serve capire(decodificare) la dimensione di quella prima               | **istruzioni di dimensione fissa**<br>-fetch della successiva senza decodifica della precedente                           |
| **formato variabile**<br>-decodifica complessa                                                                                                  | **formato uniforme**<br>-decodifica ez                                                                                    |
| **operandi in memoria**<br>-bisogna accedere spesso alla ram                                                                                    | **operazioni ALU solo tra registri**<br>-no accesso in memoria                                                            |
| **pochi registri interni**<br>- più accessi in memoria                                                                                          | **molti registri interni**<br>-risultati parziali senza accesso in memoria (?)                                            |
| **modi di indirizzamento complessi**<br>-più accessi in memoria<br>-durata variabile della istruzione<br>-conflitti tra istruzioni + complicati | **modi di indirizzamento semplici**<br>-1 solo accesso in memoria<br>-durata fissa dell’istruzione<br>-conflitti semplici |
| **istruzioni complesse**                                                                                                                        | **istruzioni semplici**                                                                                                   |
>[!tuff] MIPS è RISC !

quindi, CISC risulta più complessa ma ottimizzata per singoli scopi, mentre RISC, in quanto più semplice, risulta adatta a scopi generici
***
# MIPS
Microprocessor without Interlocked Pipelined Stages

>[!tuff] MIPS è indicizzata al byte !!
>le istruzioni sono word(lunghe 32 bit), quindi se sono all’indirizzo t e devo leggere l’istruzione successiva, incremento di 4 byte (t+4)
## operandi mips

- registri
	permettono accesso veloce ai dati. nel MIPS gli operandi devono essere contenuti nei registri per poter eseguire le operazioni ! alcuni registri sono riservati, non tutti e 32 sono accessibili o modificabili
- parole di memoria
	lo spazio in cui si possono memorizzare strutture dati, vettori, o il contenuto dei registri. sono accessibili 2^30 parole di memoria(4gb)

***
## istruzioni
### tipi di istruzioni
#### aritmetiche
- somma(add)
- sottrazione(sub)
- somma immediata (addi)
#### trasferimento dati
permettono di leggere dati(da memoria a registro), di memorizzare dati(da registro a memoria)
#### logiche
permettono di usare gli operatori logici(and, or, nor, shift dx o sx)
#### salti
- salti condizionati
	salti con test(uguaglianza, disuguaglianza, comparazione con numeri)
- salti incondizionati
	salta a : *costante, indirizzo in registro*

****
## rappresentazione dell’istruzione
#### R-type (register type)
![[Pasted image 20240317130603.png]]
arithmetic istruction format !(add, sub, …)
	no accesso alla memoria
opcode: [[#tipi di istruzioni]]
rs e rt: primo e secondo operandi 
rd: registro destinazione
shamt: shift amount
funct: istruzione
```armasm
add $t2, $s1, $s2
```
#### I-type (immediate type)
![[Pasted image 20240317131544.png]]
data transfer format !
	load/store
	salti condizionati
2 byte usati per rd, shamt e funct non servono più e vengono usati per un indirizzo o una costante
```armasm
addi $t2, $s2, 4
```

#### J-type (jump type)
![[Pasted image 20240317132229.png]]
salti non condizionati