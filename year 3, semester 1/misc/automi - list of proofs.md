---
related to:
created: 2025-12-26, 07:11
updated: 2025-12-26T09:35
completed: false
---
*--  DFA*
*--- operazioni su linguaggi regolari*
$REG$ è chiuso per unione
- stati sono coppie dei due automi da unire, scrivi bene funzione di transizione
$REG$ è chiuso per complemento (*da fare*)
$REG$ è chiuso per concatenazione 
- DFA in serie
$REG$ è chiuso per potenza 
- run the DFA back when at stato finale
*--- NFA*
$L(NFA) = L(DFA) = REG$
- una inclusione banale, per l’altra dividiamo in 2 casi e usiamo $E(\delta(q,a))$
*--- espressioni regolari*
$REG = L(RE)$
	- $L(RE)$ = insieme dei linguaggi associati a espressioni regolari
- $L(RE) \subseteq REG$: uso def. induttiva di regex e chiusura di $REG$
- $REG \subseteq L(RE)$ :