---
related to:
created: 2025-12-26, 07:11
updated: 2025-12-27T12:17
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
correttezza del passaggio da DFA a CFG
- $L(D) \subseteq L(G)$: usiamo la struttura di $G$ (che abbiamo costruito noi)
- $L(G) \subseteq L(D)$: usiamo induzione su lunghezza di $w$ e funzione di transizione estesa

ogni CFG ammette una CFG equivalente in forma normale (chomsky)
- aggiungo variabile iniziale
- elimino gli $\varepsilon$-archi (aggiungendone altri, se necessario)
- elimino regole unitarie
- trasformo le regole che conivolgono + di 3 letterali
	- le rendo di max 2 letterali
	- se sono 2 e + di 0 sono termini, rendo i termini accessibili solo da nuove variabili attraverso una regola

$L$ è riconosciuto da un PDA $\iff$ L è CFG
 - L è CFG $\implies \exists$ M $\in$ PDA t.c. L=$L(M)$: creiamo PDA e definiamo $\delta$
 - $\exists$ M $\in$ PDA t.c. L=$L(M) \implies$ L è CFG
	 - $A_{pq}$ genera x $\iff$ x porta $M$ da $p$ a $q$ con pila vuota (inizio, fine)
		 - 2 induzioni sul numero di passi, lavoro sui 2 casi

pumping lemma per CFG
- affermazione sulla dimensione delle stringhe da lunghezza del cammino (+ dim (induzione))