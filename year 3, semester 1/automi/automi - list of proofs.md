---
related to:
created: 2025-12-26, 07:11
updated: 2025-12-30T10:12
completed: false
---
*- automi* (13 dimostrazioni)
*--- linguaggi regolari*
1. $REG$ è chiuso per unione
	- stati sono coppie dei due automi da unire, scrivi bene funzione di transizione
2. $REG$ è chiuso per complemento
3. $REG$ è chiuso per intersezione
4. $REG$ è chiuso per concatenazione 
	- DFA in serie
5. $REG$ è chiuso per potenza 
	- run the DFA back when at stato finale

6. pumping lemma
	- lavoriamo sulla sequenza di stati attraversata dall’automa (intuizione pigeon hole principle). find $y$
*--- NFA*
7. $L(NFA) = L(DFA) (= REG)$
	- una inclusione banale, per l’altra costruiamo DFA, dividiamo in 2 casi e usiamo $E(\delta(q,a))$
*--- espressioni regolari*
8. $REG = L(RE)$
		- $L(RE)$ = insieme dei linguaggi associati a espressioni regolari
	- $L(RE) \subseteq REG$: uso induzione (numero di operazioni per costruzione di $r$) e chiusura di $REG$
	- $REG \subseteq L(RE)$ : definiamo `convert()` su $G$ GNFA in forma canonica, e dimostriamo per induzione che $G'$=`convert(G)` ($L(G) = L(G')$)
*-- context-free grammars*
9. correttezza dell’unione di grammatiche ($\bigcup_{i}L(Gi) = L(G)$)
	- $\bigcup_{i}L(Gi) \subseteq L(G)$: troviamo $G_{i}$ t.c. $w \in L(G_{i})$, notiamo che $L(G)$ lo genera
	- $L(G) \subseteq \bigcup_{i}L(Gi)$: usiamo disguinzione di $V$ (c’è solo un linguaggio che porta $S_J$ a $w$)
10. correttezza del passaggio da DFA a CFG
	- $L(D) \subseteq L(G)$: usiamo la struttura di $G$ (che abbiamo costruito noi)
	- $L(G) \subseteq L(D)$: usiamo induzione su lunghezza di $w$ e funzione di transizione estesa

11. ogni CFG ammette una CFG equivalente in forma normale (chomsky)
	- aggiungo variabile iniziale
	- elimino gli $\varepsilon$-archi (aggiungendone altri, se necessario)
	- elimino regole unitarie
	- trasformo le regole che conivolgono + di 3 letterali
		- le rendo di max 2 letterali
		- se sono 2 e + di 0 sono termini, rendo i termini accessibili solo da nuove variabili attraverso una regola

12. $L$ è riconosciuto da un PDA $\iff$ L è CFG
	 - L è CFG $\implies \exists$ M $\in$ PDA t.c. L=$L(M)$:
		 - creiamo PDA ($\$S$ $q_{\text{loop}}$) e definiamo $\delta$. BASTA
	 - $\exists$ M $\in$ PDA t.c. L=$L(M) \implies$ L è CFG
		 - usiamo PDA ganzo, genero CFG con proprietà e stato inziale ganzo
		 - $A_{pq}$ genera x $\iff$ x porta $M$ da $p$ a $q$ con pila vuota (inizio, fine)
			 - 2 induzioni sul numero di passi, lavoro sui 2 casi

13. pumping lemma per CFG
	- affermazione sulla dimensione delle stringhe da lunghezza del cammino (+ dim (induzione))
	- sceglo stringa con ripetizione. scelgo $A_{i}, A_{j}$ e verifico condizioni
*- calcolabilità* (14 dimostrazioni)
14. per ogni TM multinastro esiste una TM a nastro singolo equivalente
	- creo TM che simula i molteplici nastri in uno solo
15. per ogni NTM esiste una TM equivalente
	- assumo TM con 3 nastri e li uso per simulare NTM
16. $A_{DFA}$ è decidibile
	- codifica di M. simulo M su TM
17. $A_{NFA}$ è decidibile
18. $A_{rex}$ è decidibile
19. $E_{DFA}$ è decidibile
20. $EQ_{DFA}$ è decidibile
21. $A_{CFG}$ è decidibile (pg. 67)
22. $A_{TM}$ è indecidibile
	- creiamo TM $H$ e la TM $D$. la definizione di $D$ ci porterà ad una contraddizione
23. $L$ è decidibile $\iff$ L è turing-ric e coturing-ric
24. $A \leq_{m}B$ e B è decidibile $\implies$ A è decidibile
25. $A \leq_{m}B$ e A è indecidibile $\implies$ B è indecidibile
26. $HALT_{tm}$ è indecidibile
	- $A_{TM} \leq_{m} HALT_{TM}$, definisco funzione $f$ e verifico correttezza della riduzione
27. $E_{TM}$ è indecidibile
	- $A_{TM} \leq_{m} E_{TM}$, credo $S$ decisore di $A_{TM}$ basandomi su $R$ decisore (per assurdo) di $E_{TM}$
28. $REGULAR_{TM}$ è indecidibile
	- $A_{TM} \leq_{m} REGULAR_{TM}$
29. $\overline{A}$ non turing-ric e $A \leq_{m} B \implies \overline{B}$ non turing-ric
30. $EQ_{TM}$ non è turing-ric (+ $EQ_{TM}$ non è decidibile)
	- usiamo $A \leq_{m} B \implies \overline{A} \leq_{m} \overline{B}$, dimostrando la riduzione $A_{TM} \leq_{m} \overline{EQ}_{TM}$
*-- göd-el *
31. $\pi$ non può essere sia valido che completo
	- creo $R_{\pi}$ e la uso per decidere $HALT_{TM}$
32. primo teorema di incompletezza di gödel
- creiamo $D$ e gli diamo come input $D$. lavoriamo su $\phi_{D}$ e $\neg\phi_{D}$ (claim)
13. secondo teorema di incompletezza di gödel
- dimostriamo per assurdo una contraddizione (usando il claim di sopra)