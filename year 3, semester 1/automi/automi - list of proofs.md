---
related to:
created: 2025-12-26, 07:11
updated: 2025-12-26T11:48
completed: false
---
*--  DFA*
*--- linguaggi regolari*
$REG$ è chiuso per unione
- stati sono coppie dei due automi da unire, scrivi bene funzione di transizione
$REG$ è chiuso per complemento (*da fare*)
$REG$ è chiuso per concatenazione 
- DFA in serie
$REG$ è chiuso per potenza 
- run the DFA back when at stato finale

pumping lemma
- lavoriamo sulla sequenza di stati attraversata dall’automa (intuizione pigeon hole principle). find $y$
*--- NFA*
$L(NFA) = L(DFA) = REG$
- una inclusione banale, per l’altra dividiamo in 2 casi e usiamo $E(\delta(q,a))$
*--- espressioni regolari*
$REG = L(RE)$
	- $L(RE)$ = insieme dei linguaggi associati a espressioni regolari
- $L(RE) \subseteq REG$: uso def. induttiva di regex e chiusura di $REG$
- $REG \subseteq L(RE)$ : definiamo `convert()` su $G$ GNFA in forma canonica, e dimostriamo per induzione che $G'$=`convert(G)` ($L(G) = L(G')$)
*-- context-free grammars*
correttezza dell’unione di grammatiche ($\bigcup_{i}L(Gi) = L(G)$)
- $\bigcup_{i}L(Gi) \subseteq L(G)$: troviamo $G_{i}$ t.c. $w \in L(G_{i})$, notiamo che $L(G)$ lo genera
- $L(G) \subseteq \bigcup_{i}L(Gi)$: usiamo disguinzione di $V$ (c’è solo un linguaggio che porta $S_J$ a $w$)