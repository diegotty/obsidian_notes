---
related to:
created: 2025-03-02T17:41
updated: 2026-01-29T17:38
completed: false
---
*-- intro*
il corso studia la semantica dei linguaggi di programmazione
- cenciarelli mi ha promesso che seguendo questo corso, avrei potuto facilmente capire il funzionamento di un linguaggio di programmazione semplicemente guardando le sue caratteristiche (tipato o non tipato, come gestisce le funzioni, etc …)

*- algebre induttive*
siamo partiti dalla definizione di Peano dei *numeri naturali*, e abbiamo notato come essa sia un caso speciale della definizione di *algebra* (in particolare, un monoide). abbiamo studiato come l’ultimo assioma che definisce i numeri naturali è equivalente al *principio di induzione*.
per le algebre, abbiamo studiato la *chiusura* di un insieme rispetto ad un’operazione (anche per *algebre eterogenee*)
, gli *isomorfismi*, e ilabbiamo definito le *algebre induttive*, e abbiamo studiato le algebre induttive con la stessa segnatura.
in particolare, abbiamo visto che tra due algebre con la stessa segnatura, $A$ e $B$, in cui $A$ è un’algebra induttiva,  esiste un unico *omomorfismo*
inoltre, per il *teorema di Lambek*, se $A$ e $B$ sono entrambe induttive e con la stessa segnatura, allora sono necessariamente isomorfe.

*- paradigma funzionale*
studiamo il paradigma funzionale (usato dai linguaggi funzionali), un paradigma che si basa sulla valutazione di espressioni e l’uso di funzioni matematiche.
- in poche parole, semplice, puro, senza effetti collaterali

*-- linguaggio EXP*
abbiamo introdotto le *espressioni* (in *backus-naur form*), le abbiamo definite come algebre e ci siamo soffermati sul linguaggio $EXP$.
- del linguaggio $EXP$, abbiamo abbiamo definito le *variabili libere* e le *variabili legate* di un’espressione, e il loro *scope*. abbiamo quindi definito ricorsivamente la funzione `free()`
abbiamo introdotto la valutazione dei termini del linguaggio $EXP$, e per farlo sono stati definiti gli *ambienti*, funzioni parziali che associano un insieme finito di variabili ai propri valori. 
grazie agli ambienti, abbiamo definito la *semantica operazionale* (il significato dei termini di $EXP$), attraverso delle *regole di inferenza*

[durante l’applicazione delle regole di inferenza, abbiamo notato come per determinati termini, sarebbe più veloce applicare un metodo diverso per valutare i tali.]

*---  approcci di valutazione*
sono stati quindi introdotti gli *approcci* alla valutazione:
- *approccio eager*: i termini vengono calcolati indistintamente, anche in modo scomodo, appena vengono incontrati
- *approccio lazy*: i termini vengono calcolato solo quando è veramente necessario (quindi non alla loro “definizione”)
e le varianti di *scoping* di entrambi:
- *scoping dinamico*: quando viene calcolato un termine, esso viene calcolato nell’ambiente in cui ci si trova al momento del calcolo
- *scoping statico*: quando viene calcolato un termine, esso viene calcolato nell’ambiente in cui è stato incontrato
la differenza è sostanziale in situazioni in cui una variabile viene dichiarata molteplici volte in termini e sottotermini (e il suo valore quindi cambia durante l’esecuzione del programma)
infatti
nel linguaggio $EXP$, data la sua semplicità, abbiamo notato come:
- *eager statico e lazy statico sono equivalenti*, è differente solo l’implementazione
- *eager statico e eager dinamico sono equivalenti*
[inoltre, l’approccio lazy con scoping dinamico non viene usato, in quanto [boh tipo non funziona]]

*-- linguaggio FUN*
abbiamo introdotto un linguaggio più articolato, per dare un peso più rilevante agli approcci scelti nella valutazione dei termini: il linguaggio $FUN$, che aggiunge le funzioni ($fn \,x \implies M$ e $(M)N$).
abbiamo definito le regole d’inferenza per entrambe le soluzioni di scoping dell’approccio eager, e per l’approccio lazy con scoping statico.
- grazie alle funzioni, abbiamo introdotto $\Omega = (fn\,x \implies xx)(fn \,x \implies xx)$, il primo esempio di *espressione che non termina*

abbiamo terminato introducendo 2 linguaggi funzionali: *SML* (eager statico), e *LISP/Haskell* (lazy statico)

*-- lambda calcolo*
abbiamo dimostrato che è possibile eliminare alcuni costrutti presenti nel linguaggio $EXP$ se ci troviamo nel linguaggio $FUN$, in quanto tali costrutti possono essere espressi come funzioni. 
- per dimostare ciò per la somma ($M+N$), abbiamo introdotto il *currying*.
- per dimostrare ciò per le costanti (0,1,…) abbiamo introdotto i *numeri di church* (e di conseguenza il lambda-calcolo)
abbiamo studiato *church()*, *dechurch()*, e le operazioni *succ*, *plus* e *times* nel lambda-calcolo.

*- paradigma imperativo*
*-- IMP*
per studiare il paradigma imperativo, iniziamo introducendo il linguaggio $IMP$,  che a sua volta introduce i concetti di *locazione* (astrazioni degli indirizzi di memoria) e *store* (astrazione delle celle di memoria), assieme a diversi costrutti: `if`, `while`, `p;q`, `var`, e l’assegnamento “puro”
- abbiamo quindi introdotto 2 diverse funzioni di valutazione semantica e regole di inferenza per l’approccio eager statico
*-- ALL*
per studiare gli interessanti *meccanismi del passaggio di parametri a procedure*, (meccanismi presenti in molti linguaggi della famiglia `Algol`) è però necessario ampliare il linguaggio $IMP$ per ottere il linguaggio $ALL$, che introduce i concetti di *procedura* e *array*, modifica la gestione delle variabili con la separazione di *L-EXP* da *R-EXP* e introduce i costrutti che permettono tali cambiamenti.
- nelle regole di inferenza, oltre alle regole per i nuovi costrutti, si nota come viene introdotto un meccanismo di `[ref]` + `[loc]` per accedere al valore di una variabile

*--- passaggio di parametri*
studiamo quindi, nel linguaggio $ALL$, i meccanismi di
- *call-by-value*: viene dato *il valore* in input, e nella funzione viene creata una copia della variabile data
- *call-by-reference*: viene dato *l’indirizzo di memoria della variabile* in input. la reference (*location*) viene “valutata” al momento di chiamata della funzione, e qualunque modifica cambia la variabile originale data in input
- *call-by-name*: l’equivalente del meccanismo call-by-reference ma in versione *lazy*: viene data in input la reference della varabile, ma tale reference non viene valuta fino a quando non viene “usata” all’interno della funzione.
## correttezza di programmi