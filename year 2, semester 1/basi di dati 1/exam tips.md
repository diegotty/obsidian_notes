---
created: 2025-01-05T12:53
updated: 2025-02-20T09:38
---
## esercizio 1
theta join: dell’attributo su cui si fa il theta join rimane solo una copia, quella di sinistra (?, per il noome è importante)

## esercizio 2
### chiavi schema, verifica 3FN, trovare decomp
chiavi dello schema : [[12 - identificazione delle chiavi di uno schema]]
>[!info]- osservazioni
>1. conviene partire dai sottoinisiemi di $ABH$ di cardinalità maggiore: se la loro chiusura non contiene $R$, è inutila calcolare la chiusura dei loro sottoinsiemi
>2. gli attributi che **non compaiono mai a destra delle dipendenze funzionali di F**, non sono determinati funzionalmente da nessun attributo, quindi **dovranno essere sicuramente in ogni chiave** (perchè rimarebbero fuori da qualunque chiusura transitiva, e una chiave deve determinare l’intero schema)
>3. gli attributi che compaiono sempre e solo come dipendenti non potranno stare in una chiave
>4. gli attributi che non compaiono mai( nè determinante, nè dipendente) nelle dipendenze funzionali in $F$, devono stare per forza nella chiave

definizioni formali: 
- chiave: insieme di campi la cui chiusura contiene l’intera relazione, e tale insieme non contiene al suo interno altre chiavi (insiemi la cui chiusura è $R$)
- 3FN: forma normale. determinante superchiave, dipendente primo (oppure). dipendenze prese da $F^+$. basta una dipendenza non in 3FN e tutta la tabella è in non 3FN
- per trovare decomposizione, si applica algoritmo per trovarla. per applicare algoritmo, serve una chiusura minimale, delle dipendenze funzionali, cioè un insieme di dipendenze funzionali equivalente ad F. per trovarla si applicano le 3 caratteristiche della copertura minimale, in ordine.
### verificare integrità dipendenze di decomp
applicare algoritmo di decomposizione
### verificare se è join senza perdita
tabella 
## esercizio 3
### file hash
quando chiede spazio per blocchi, parti da quanti blocchi possono entrare in ogni bucket, e poi trova blocchi totali ! non trovare blocchi necessare direttamente e poi dividere per numero di bucket
### b-tree
file indice a più livelli ! ogni livello ha $n$ record, con $n$ = numero di blocchi nel livello inferiore. il livello più altro del b-tree deve entrare in un blocco
ogni blocco deve essere pieno almeno al 50%