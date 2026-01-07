---
created: 2026-01-04T10:52
updated: 2026-01-07T21:12
---
## coste che dovrei fare per migliorare le mie probabilità di passare l’esame
- [ ] lista di teoremi complessità
- [ ] lista linguaggi in P, NP, decidibili, indecidibili, t-ric, non ti-ric
## automi

| #   | dimostrazione                                                   | ripetizioni (n°) | hint                                                                                                    |
| :-- | :-------------------------------------------------------------- | :--------------: | :------------------------------------------------------------------------------------------------------ |
| 1   | $reg$ è chiuso per unione                                       |        1         | stati sono coppie dei due automi da unire, scrivi bene funzione di transizione                          |
| 2   | $reg$ è chiuso per complemento                                  |        1         |                                                                                                         |
| 3   | $reg$ è chiuso per intersezione                                 |        1         |                                                                                                         |
| 4   | $reg$ è chiuso per concatenazione                               |        1         | dfa in serie                                                                                            |
| 5   | $reg$ è chiuso per potenza                                      |        1         | run the dfa back when at stato finale                                                                   |
| 6   | pumping lemma                                                   |        3         | lavoriamo sulla sequenza di stati attraversata dall’automa (intuizione pigeon hole principle). find $y$ |
| 7   | $l(nfa) = l(dfa) (= reg)$                                       |        1         | una inclusione banale, per l’altra costruiamo dfa, dividiamo in 2 casi e usiamo $e(\delta(q,a))$        |
| 8   | $reg = l(re)$                                                   |        1         | $l(re) \subseteq reg$: uso induzione (numero di operazioni per costruzione di $r$) e chiusura di $reg$  |
| 9   | correttezza dell’unione di grammatiche                          |        1         | $\bigcup_{i}l(gi) \subseteq l(g)$: troviamo $g_{i}$ t.c. $w \in l(g_{i})$, notiamo che $l(g)$ lo genera |
| 10  | correttezza del passaggio da dfa a cfg                          |        1         | $l(d) \subseteq l(g)$: usiamo la struttura di $g$ (che abbiamo costruito noi)                           |
| 11  | ogni cfg ammette una cfg equivalente in forma normale (chomsky) |        1         | aggiungo variabile iniziale                                                                             |
| 12  | $l$ è riconosciuto da un pda $\iff$ l è cfg                     |        2         | creiamo pda ($\$s$ $q_{\text{loop}}$) e definiamo $\delta$. basta                                       |
| 13  | pumping lemma per cfg                                           |        1         | affermazione sulla dimensione delle stringhe da lunghezza del cammino (+ dim (induzione))               |
## calcolabilità

| #   | dimostrazione                                                      | ripetizioni (n°) | hint                                                                                                                              |
| :-- | :----------------------------------------------------------------- | :--------------: | :-------------------------------------------------------------------------------------------------------------------------------- |
| 13b | per ogni tm multinastro esiste una tm a nastro singolo equivalente |        1         | creo tm che simula i molteplici nastri in uno solo                                                                                |
| 14  | per ogni ntm esiste una tm equivalente                             |        1         | assumo tm con 3 nastri e li uso per simulare ntm                                                                                  |
| 15  | $a_{dfa}$ è decidibile                                             |        1         | codifica di m. simulo m su tm                                                                                                     |
| 16  | $a_{nfa}$ è decidibile                                             |        1         |                                                                                                                                   |
| 17  | $a_{rex}$ è decidibile                                             |        1         |                                                                                                                                   |
| 18  | $e_{dfa}$ è decidibile                                             |        1         |                                                                                                                                   |
| 19  | $EQ_{DFA}$ è decidibile                                            |        1         |                                                                                                                                   |
| 20  | $a_{cfg}$ è decidibile                                             |        1         |                                                                                                                                   |
| 21  | $e_{cfg}$ è decidibile                                             |        1         |                                                                                                                                   |
| 22  | $a_{tm}$ è indecidibile                                            |        1         | creiamo tm $h$ e la tm $d$. la definizione di $d$ ci porterà ad una contraddizione                                                |
| 23  | $l$ è decidibile $\iff$ l è turing-ric e coturing-ric              |        1         |                                                                                                                                   |
| 24  | $a \leq_{m}b$ e b è decidibile $\implies$ a è decidibile           |        1         |                                                                                                                                   |
| 25  | $a \leq_{m}b$ e a è indecidibile $\implies$ b è indecidibile       |        1         |                                                                                                                                   |
| 26  | $halt_{tm}$ è indecidibile                                         |        1         | $a_{tm} \leq_{m} halt_{tm}$, definisco funzione $f$ e verifico correttezza della riduzione                                        |
| 27  | $e_{tm}$ è indecidibile                                            |        1         | $a_{tm} \leq_{m} \overline{e}_{tm}$, creo $s$ decisore di $a_{tm}$ basandomi su $r$ decisore (per assurdo) di $\overline{e}_{tm}$ |
| 28  | $regular_{tm}$ è indecidibile                                      |        1         | $a_{tm} \leq_{m} regular_{tm}$                                                                                                    |
| 29  | $eq_{tm}$ non è turing-ric (+ $eq_{tm}$ non è decidibile)          |        3         | usiamo $a \leq_{m} b \implies \overline{a} \leq_{m} \overline{b}$, dimostrando la riduzione $a_{tm} \leq_{m} \overline{eq}_{tm}$  |
| 30  | $\pi$ non può essere sia valido che completo                       |        1         | creo $r_{\pi}$ e la uso per decidere $halt_{tm}$                                                                                  |
| 31  | primo teorema di incompletezza di gödel                            |        2         | creiamo $D$ e gli diamo come input $D$. lavoriamo su $\phi_{D}$ e $\neg\phi_{D}$ (claim)                                          |
| 32  | secondo teorema di incompletezza di gödel                          |        1         | dimostriamo per assurdo una contraddizione (usando il claim di sopra)                                                             |

---
## complessità
| #   | dimostrazione                                                                                               | ripetizioni (n°) | hint                                                                                         |
| :-- | :---------------------------------------------------------------------------------------------------------- | :--------------: | :------------------------------------------------------------------------------------------- |
| 33  | $2-sat \in p$                                                                                               |        1         | traduco or in and di 2 formule. creo grafo. dimostro doppia implicazione                     |
| 34  | $3-col \in \text{verifier}np$                                                                               |        1         |                                                                                              |
| 35  | $p \subseteq \text{verifier}np \subseteq exp$                                                               |        1         |                                                                                              |
| 36  | $3-sat \in np$                                                                                              |        1         |                                                                                              |
| 37  | $\text{verifier}np = np$                                                                                    |        1         |                                                                                              |
| 38  | $a \leq^p_{m}b$, $b \in p \implies a \in p$                                                                 |        1         |                                                                                              |
| 39  | $4-col \leq_m^p sat$                                                                                        |        3         | codifico colori e faccio formula per forzare colori diversi                                  |
| 40  | $3-col \leq_m^p 4-col$                                                                                      |        3         | aggiungimento nodo                                                                           |
| 41  | se $s$ è $np-\text{completo}$, allora $s \in p \implies p = np$                                             |        1         |                                                                                              |
| 42  | $sat$ è $np-\text{completo}$ (*cook-levin*)                                                                 |        1         | definiamo tableau                                                                            |
| 43  | $\text{k-clique}$ è $np-\text{completo}$                                                                    |        1         | $3-sat \leq_m^p k-clique$                                                                    |
| 44  | $sat \in p \iff unsat \in p$                                                                                |        1         |                                                                                              |
| 45  | $p \subseteq conp$                                                                                          |        1         |                                                                                              |
| 46  | $p =np \implies p = conp(= np)$                                                                             |        1         | dimostro $conp \subseteq p$. $p \subseteq conp$ dimostrato sopra                             |
| 47  | $NP = coNP \iff unsat \in np$                                                                               |        1         |                                                                                              |
| 48  | $\text{TIME}(f(n)) \subseteq \text{SPACE(f(n))}$                                                            |        1         |                                                                                              |
| 49  | $NP \subseteq PSPACE$ (savitch ma si può anche dimostrare diversamente …)                                   |        1         | usiamo verifierNP                                                                            |
| 50  | $\forall f(n) \geq \log(n),SPACE(f(n)) \subseteq DTIME(2^{f(n)})$                                           |        1         |                                                                                              |
| 51  | $PATH \in SPACE(\log^2n)$                                                                                   |        1         |                                                                                              |
| 52  | $a \in NL \implies a \in P$                                                                                 |        1         | uso una $tm$ per trasformare $a$ in un grafo e risolvere path su di esso, tutto in $poly(n)$ |
| 53  | $a \in NL \implies SPACE(\log^2(n))$                                                                        |        1         | non mi serve avere tutto $g_{n,x}$ per usare $path?$                                         |
| 54  | se $P$,$Q$ sono funzioni calcolabili in log-space, allora $R(x) = Q(P(x))$ anche è calcolabile in log-space |        1         |                                                                                              |
| 55  | $PATH$ è $NL-\text{completo}$                                                                               |        1         | è facile trovare una riduzione per dimostare che $path$ è $nl-\text{hard}$                   |
| 56  | time hierarchy theorem                                                                                      |        1         |                                                                                              |
| 57  | space hierarchy theorem                                                                                     |        2         |                                                                                              |
