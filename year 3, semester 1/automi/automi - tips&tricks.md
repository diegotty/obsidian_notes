---
related to:
created: 2025-12-26, 11:29
updated: 2026-01-02T10:27
completed: false
---
*- blind riduzioni*
posso fare blind riduzioni: ridurre un linguaggio riducibile $A$ ad un linguaggio non-riducibile $B$, se ci interessa dimostrare la *non-decidibilità* di $B$, in quanto useremo teoremi relativi alla decidibilità ($A$ non-decidibile $\implies$ $B$ non decidibile).
può capitare che, per motivi a noi ancora non noti (riguardo a gerarchie / nature dei linguaggi), una riduzione del tipo di sopra non sia possibile (e ce ne accorgeremmo perchè non riusciamo a trovarla) *per il fatto che $B$ non è riconoscibile*. in quel caso, ci è necessario maneggiare con i linguaggi complementari per trovare una riduzione soddisfacente
*- il caso $M(w) = loop$*
non posso contare, in $M'$ (TM creata dalla funzione $f$), il caso $M(x) = loop$ come favorevole (cioè che $M'$ segue quello che io voglio che faccia). per esempio, se abbiamo (nella definizione di $M'$)
- $M(w) = ACC$, $M'$ accetta
- altrimenti, $M'$ rifiuta
in caso $M(w)$ vada in loop, non possiamo aspettarci che $M'$ rifiuti ($M'$ a sua volta andrà in loop).
- bisogna stare attenti a ciò quando si creano riduzioni !

*- pumping lemma*
dato un linguaggio, devo scegliere una stringa $w$ (che usa $p$) che, data qualunque decomposizione di $w$, falsifica le condizioni del pumping lemma.
- per dimostrare che falsifica le condizioni, possiamo usare l’artimetica sulle cardinalità delle cifre. è ottimale quindi definire per esteso $x$, $y$, $z$.