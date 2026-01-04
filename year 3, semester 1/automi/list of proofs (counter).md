---
created: 2026-01-04T10:52
updated: 2026-01-04T11:03
---
*- automi*

| #   | dimostrazione                                                   | ripetizioni (n°) | hint                                                                                                    |
| :-- | :-------------------------------------------------------------- | :--------------: | :------------------------------------------------------------------------------------------------------ |
| 1   | $reg$ è chiuso per unione                                       |        1         | stati sono coppie dei due automi da unire, scrivi bene funzione di transizione                          |
| 2   | $reg$ è chiuso per complemento                                  |        1         |                                                                                                         |
| 3   | $reg$ è chiuso per intersezione                                 |        1         |                                                                                                         |
| 4   | $reg$ è chiuso per concatenazione                               |        1         | dfa in serie                                                                                            |
| 5   | $reg$ è chiuso per potenza                                      |        1         | run the dfa back when at stato finale                                                                   |
| 6   | pumping lemma                                                   |        1         | lavoriamo sulla sequenza di stati attraversata dall’automa (intuizione pigeon hole principle). find $y$ |
| 7   | $l(nfa) = l(dfa) (= reg)$                                       |        1         | una inclusione banale, per l’altra costruiamo dfa, dividiamo in 2 casi e usiamo $e(\delta(q,a))$        |
| 8   | $reg = l(re)$                                                   |        1         | $l(re) \subseteq reg$: uso induzione (numero di operazioni per costruzione di $r$) e chiusura di $reg$  |
| 9   | correttezza dell’unione di grammatiche                          |        1         | $\bigcup_{i}l(gi) \subseteq l(g)$: troviamo $g_{i}$ t.c. $w \in l(g_{i})$, notiamo che $l(g)$ lo genera |
| 10  | correttezza del passaggio da dfa a cfg                          |        1         | $l(d) \subseteq l(g)$: usiamo la struttura di $g$ (che abbiamo costruito noi)                           |
| 11  | ogni cfg ammette una cfg equivalente in forma normale (chomsky) |        1         | aggiungo variabile iniziale                                                                             |
| 12  | $l$ è riconosciuto da un pda $\iff$ l è cfg                     |        1         | creiamo pda ($\$s$ $q_{\text{loop}}$) e definiamo $\delta$. basta                                       |
| 13  | pumping lemma per cfg                                           |        1         | affermazione sulla dimensione delle stringhe da lunghezza del cammino (+ dim (induzione))               |

---

## ⚙️ calcolabilità
| # | dimostrazione | ripetizioni (n°) | hint |
| :--- | :--- | :---: | :--- |
| 13b | per ogni tm multinastro esiste una tm a nastro singolo equivalente | 1 | creo tm che simula i molteplici nastri in uno solo |
| 14 | per ogni ntm esiste una tm equivalente | 1 | assumo tm con 3 nastri e li uso per simulare ntm |
| 15 | $a_{dfa}$ è decidibile | 1 | codifica di m. simulo m su tm |
| 16 | $a_{nfa}$ è decidibile | 1 | |
| 17 | $a_{rex}$ è decidibile | 1 | |
| 18 | $e_{dfa}$ è decidibile | 1 | |
| 19 | $eq_{dfa}$ è decidibile | 1 | |
| 20 | $a_{cfg}$ è decidibile | 1 | |
| 21 | $e_{cfg}$ è decidibile | 1 |