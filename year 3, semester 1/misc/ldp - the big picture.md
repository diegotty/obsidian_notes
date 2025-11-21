---
related to:
created: 2025-03-02T17:41
updated: 2025-11-21T11:32
completed: false
---
il corso studia la semantica dei linguaggi di programmazione
siamo partiti dalla definizione di Peano dei *numeri naturali*, e abbiamo notato come essa sia un caso speciale della definizione di *algebra*
per le algebre, abbiamo studiato la *chiusura* di un insieme rispetto ad un’operazione (anche per *algebre eterogenee*)
abbiamo definito le *algebre induttive*, e abbiamo studiato le algebre induttive con la stessa segnatura, per definire gli *omomorfismi*, gli *isomorfismi*, e il *teorema di Lambek*

abbiamo introdotto le *espressioni* (in *backus-naur form*), le abbiamo definite come algebre e ci siamo soffermati sul linguaggio $EXP$.
- del linguaggio $EXP$, abbiamo abbiamo definito le *variabili libere* e le *variabili legate* di un’espressione, e il loro *scope*
abbiamo introdotto la valutazione dei termini del linguaggio $EXP$, e per farlo sono stati definiti gli *ambienti*. grazie agli ambienti, abbimo definito la *semantica operazionale* (il significato dei termini di $EXP$), attraverso delle *regole di inferenza*

durante l’applicazione delle regole di inferenza, abbiamo notato come per determinati termini, sarebbe più veloce applicare un metodo diverso per valutare i tali.
sono stati quindi introdotti gli *approcci* alla valutazione:
- *approccio eager*: i termini vengono calcolati indistintamente, anche in modo scomodo, appena vengono incontrati
- *approccio lazy*: i termini vengono calcolato solo quando è veramente necessario (quindi non alla loro “definizione”)
e le varianti di *scoping* di entrambi:
- *scoping dinamico*: quando viene calcolato un termine, esso viene calcolato nell’ambiente in cui ci si trova al momento del calcolo
- *scoping statico*: quando viene calcolato un termine, esso viene calcolato nell’ambiente in cui è stato incontrato
la differenza è sostanziale in situazioni in cui una variabile viene dichiarata molteplici volte in termini e sottotermini (e il suo valore quindi cambia durante l’esecuzione del programma)
infatti
nel linguaggio $EXP$, data la sua semplicità, abbiamo notato come:
- *eager e lazy statico sono equivalenti*, è differente solo l’implementazione
- *eager statico e eager dinamico sono equivalenti*

abbiamo introdotto un linguaggio più articolato, per dare un peso più rilevante agli approcci scelti nella valutazione dei termini: il linguaggio *FUN*, e abbiamo definito le regole d’inferenza per entrambe le soluzioni di scoping dell’approccio eager
