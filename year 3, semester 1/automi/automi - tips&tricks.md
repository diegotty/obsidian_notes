---
related to:
created: 2025-12-26, 11:29
updated: 2026-01-12T06:11
completed: false
---
*- way to think about reductions*
se avessi un decisore per $B$, e $A \leq_{m}B$ allora $A$ sarebbe decidibile
controllare se anche i casi in cui $M(w) \neq ACC$ sono mappati bene !

*- blind riduzioni*
posso fare blind riduzioni: ridurre un linguaggio riducibile $A$ ad un linguaggio non-riducibile $B$, se ci interessa dimostrare la *non-decidibilità* di $B$, in quanto useremo teoremi relativi alla decidibilità ($A$ non-decidibile $\implies$ $B$ non decidibile).
può capitare che, per motivi a noi ancora non noti (riguardo a gerarchie / nature dei linguaggi), una riduzione del tipo di sopra non sia possibile (e ce ne accorgeremmo perchè non riusciamo a trovarla) *per il fatto che $B$ non è riconoscibile*. in quel caso, ci è necessario maneggiare con i linguaggi complementari per trovare una riduzione soddisfacente

*- paletti logici per riduzioni*
$f$ non può ritornare il risultato di cose (es: TM $M'$)che f stessa crea.
- può ritornare $M’$, che $f$ crea, ma non il risultato di $M’$ *se* $M’$ simula $M$. ciò implicherebbe che $f$ deve aspettare la fine di $M'$, che simula $M(w)$, e quindi anche $f$ lo farebbe.
ma $f$ deve solo scrivere (dare una definizione), non deve simulare nulla

ricordiamo che una $TM$ accetta/rifiuta come output, non può ritornare cose. $f$ invece si in quanto è una funzione

*- il caso $M(w) = loop$*
non posso contare, in $M'$ (TM creata dalla funzione $f$), il caso $M(x) = loop$ come favorevole (cioè che $M'$ segue quello che io voglio che faccia). per esempio, se abbiamo (nella definizione di $M'$)
- $M(w) = ACC$, $M'$ accetta
- altrimenti, $M'$ rifiuta
in caso $M(w)$ vada in loop, non possiamo aspettarci che $M'$ rifiuti ($M'$ a sua volta andrà in loop).
- bisogna stare attenti a ciò quando si creano riduzioni !

*- teorema di rice*: 
qualsiasi proprietà non banale del linguaggio riconosciuto da una TM è indecidibile
- proprietà non banale: proprietà che non sia vera per tutti i programmi o per nessun programma. se alcuni programmi la soddisfano e altri no, è non banale.
- proprietà semantica: proprietà che riguarda il comportamento del programma (cosa fa, input-output) e non la sua struttura sintattica (come è scritto, quante righe ha).
se una proprietà semantica è vincolata a un limite di tempo o spazio, allora la proprietà diventa *decidibile*, altrimenti è *indecidibile*
- es: la macchina M scrive il simbolo '1' entro i primi 100 passi di computazione

*- pumping lemma*
dato un linguaggio, devo scegliere una stringa $w$ (che usa $p$) che, data qualunque decomposizione di $w$, falsifica le condizioni del pumping lemma.
- non possiamo definire $p$
- per dimostrare che falsifica le condizioni, possiamo usare l’artimetica sulle cardinalità delle cifre. è ottimale quindi definire per esteso $x$, $y$, $z$.
*ricorda che puoi fare pumping up and pumping down !!!*

contare in una TM multinastro non ha costo temporale costante:
- se rappresento i numeri in decimale, fare +1 costa $O(n)$
- se rappresento i numeri in binario, fare +1 costa $O(\log n)$
il modo migliore per contare è scrivere la rappresentazione unaria (scrivere una sequenza di simboli uno dopo l’altro)

*- certificati*
i certificati sono una possibile soluzione per il problema.

*- grafi*
$<G>$ occupa di solito $|V|^2$ (matrice di adiacenza)


*ricordiamo che possiamo hard-codare TM e delta dentro altre TM*, ed è quello che facciamo per savitch, qualunque riduzione in cui creiamo una TM in cui simuliamo $M(w)$

*in una TM il nastro di input è read-only, ma non read-once !* l’esistenza di un nastro di input implica che stiamo usando una TM multinastro con 2 nastri (lo standard per il calcolo della complessità di spazio)
- il nastro di input ci permette inoltre di definire classi di complessità di spazio come $LOGSPACE$, in quanto la sola lettura dell’i
- inoltre, possiamo avere anche un nastro *write-once*, che ci permette di non dover rispettare il limite di spazio imposto per il nastro (se $L \in SPACE(f(n))$, l’output può essere tranquillamente $O(f(n)^2)$)

| simulatore | simulato | complessità di spazio    | complessità di tempo |
| ---------- | -------- | ------------------------ | -------------------- |
| TM         | TM       | <br>$O(f(n))$            |                      |
| TM         | NTM      | (savitch)<br>$O(f^2(n))$ | $O(2^{O(f(n))})$     |
| NTM        | TM       | <br>$O(f(n))$            | $O(f(n))$            |
| NTM        | NTM      | $O(f(n))$                | $O(f(n))$            |

| **Simulatrice**   | **Simulata**        | **Tempo Utilizzato** |
| ----------------- | ------------------- | -------------------- |
| **TM (1 nastro)** | **TM ($k$ nastri)** | $O(f(n)^2)$          |
| **TM (2 nastri)** | **TM ($k$ nastri)** | $O(f(n) \log f(n))$  |
| **NTM**           | **NTM**             | $O(f(n))$            |
| **TM**            | **NTM**             | $2^{O(f(n))}$        |

di solito in complessità spaziale si usa TM multinastro con nastro read-only per input (altrimenti non possiamo definire classi come LOGSPACE)


POLYL = (log^k n)

dimensione di spazio precisa di PATH è log(sqrt(n))