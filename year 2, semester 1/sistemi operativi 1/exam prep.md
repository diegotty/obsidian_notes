---
created: 2025-01-18T14:10
updated: 2025-02-20T09:38
---
# chiarimenti
## dma
permette lo scambio diretto di dati tra periferiche e RAM, senza passare per la CPU, che si limita a dare a dare avvio al trasferimento. viene generato un signolo interrupt per blocco di trasferimento
## segnali
il PCB ha un campo per i segnali ! quando il processo va in esecuzione, il kernel controlla se ci sono segnali pendenti


# domande
## non aperte
dove si trova il dispatcher ? di cosa fa parte ?
tipi di suspend ?
## aperte


## passwords
dove si trovano le informazioni sugli utenti ? sui gruppi ?
cosa vuol dire :x: ?
un utente può avere uid 754 ?
cosa è il modular crypt format
describe funzione hash, e quando una funzione hash è crittografica. perchè la funzione hash è deterministica ?

describe i 2 attacchi
a cosa serve il salt ?


## buffer overflow
non me ne frega nulla …. non me ne frega nulla ……………. stack smashing …. how about i smash your mom ……. 

come funzionano gli stack frame ?
whats stack smashing
shellcode ? libc ?

## gestione io
what the fuck is a driver
dove si trova il buffer in buffering i/o ? 

## filesystem
allocation table
cos’è un blocco ? blocco vs porzione

## concorrenza
le soluzioni hw funzionano anche su più processori ?


TLB non completamente hardware in quanto il SO deve poter resettarlo