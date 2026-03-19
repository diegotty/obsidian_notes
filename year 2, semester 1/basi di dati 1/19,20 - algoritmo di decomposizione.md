---
created: 2024-11-29T16:19
updated: 2025-02-20T09:38
related to: "[[17, 18 - copertura minimale di un insieme di dipendenze]]"
---
>[!index]
>- [algoritmo per la decomposizione di uno schema](#algoritmo%20per%20la%20decomposizione%20di%20uno%20schema)
>- [teorema](#teorema)
>- [dimostrazione](#dimostrazione)

mostriamo ora che dato uno schema di relazione $R$ e un insieme di dipendenze funzionali $F$ su $R$, esiste **sempre** una decomposizione(che può essere calcolata in tempo polinomiale) $\rho = \{R_{1}, R_{2},\dots, R_{k}\}$ di $R$ tale che:
- $\forall i, i=1,\dots,k \,\,R_{i}$ è in 3FN
- $\rho$ preserva $F$
- $\rho$ ha un join senza perdita
# algoritmo per la decomposizione di uno schema

```pseudo
	\begin{algorithm}
	\caption{decomposizione di uno schema di relazione}
	\begin{algorithmic}
	\Input uno schema di relazione $R$ e una copertura minimale $F$
	\Output una decomposizione $\rho$ di $R$ che preserva $F$ e t.c. $\forall i, i=1,\dots,k \,\,R_{i}$ è in 3FN
	\State $S := \varnothing$
	\For{ \textbf{every} $A \in R$ t.c. A non è coinvolto in nessuna dipendenza funzionale in $F$}
		\State $S := S \cup \{A\};$
    \EndFor
	\If{ $S \neq \varnothing$}
		\State $R:=R - S;$
		\State $\rho := \rho \cup \{S\};$
    \EndIf
	\If{esiste una dipendenza funzionale in $F$ che coinvolge tutti gli attributi in $R$}
		\State $\rho := \rho \cup \{R\};$
	\Else \For{\textbf{every} $X \to A \in F$}
		\State $\rho := \rho \cup \{XA\}$
    \EndFor
    \EndIf

	\end{algorithmic}
	\end{algorithm}
```
in questo algoritmo definiamo quanti e come sono fatti gli $R_i$ che compongnono $\rho$. in particolare:
1. nel primo for potremmo aggiungere a $\rho$ un sottoschema composto da tutti gli attributi che non sono conivolti in nessuna dipendenza funzionale in $F$
2. nel secondo if possiamo aggiungere un sottoschema composto da $R - S$ (in cui $S$ è l’insieme composto da tutti gli attributi che non sono coinvolti in nessuna dipendenza di $F$, che potrebbe essere vuoto)
3. altrimenti, nell’else del secondo if andiamo ad aggiungere $n$ sottoschemi ad $\rho$, ed ogni sottoschema è $\{XA\}, \forall X \to A \in F$
>[!info] osservazioni
>possiamo avere 1+2 ($R$ residuo), oppure 1+3, oppure solo 3

# teorema
sia $R$ uno schema di relazione ed $F$ un insieme di dipendenze funzionali su $R$, che è una copertura minimale. L’algoritmo di decomposizione permette di calcolare in tempo polinomiale una decomposizione $\rho$ di $R$ tale che:
- ogni schema di relazione $\rho$ è in 3FN
- $\rho$ preserva $F$
# dimostrazione
dimostriamo separatamente le due proprietà della decomposizione:
- $\rho$ preserva $F$
sia $G= \bigcup_{i=1}^k \pi_{R_i}(F)$. poichè per ogni dipendenza funzionale $X \to A \in F$(**proprio per tutte !**) si ha che $XA \in \rho$ (è proprio uno dei sottoschemi), si ha che questa dipendenza di $F$ sarà sicuramente in $G$, quindi $G \supseteq F$, e quindi $G^+ \supseteq F^+$.
l’inclusione $G^+ \subseteq F^+$ è banalmente verificata in quanto, per definizione $G \subseteq F$

- ogni sottoschema di relazione in $\rho$ è in 3FN
**analizziamo i diversi casi che si possono presentare:**
1.  se $S \in \rho$, ogni attributo di $S$ fa parte della chiave(in quanto $S$ è l’inisieme di attributi non determinati da dipendenze in $F$, e quindi dovranno essere per forza nella chiave che li determinerà per riflessività), e quindi, $S$ è in 3FN  (\\QUESTION anche xke non ci sono dipendenze che coinvolgono questi attributi…)
2. se $R \in \rho$, esiste una dipendenza funzionale in $F$ che coinvolge tutti gli atttibuti in $R$. dato che $F$ è una copertura minimale, la dipendenza sarà della forma $R-A \to A$ (in quanto, per il passo 1 della copertura minimale, i dipendenti sono singleton). inoltre, poichè $F$ è una copertura minimale, non ci può essere una dipendenza funzionale $X \to A$ in cui $X \subset R-A$, (in quanto, se ciò fosse vero, la dipendenza $R-A \to A$ sarebbe stata ridotta nel passo 2 della copertura minimale). quindi $R-A$ è chiave in $R$(la sua chiusura è $R$). dimostriamo ora che il sottoschema è in 3FN. Sia $Y \to B$ una qualsiasi dipendenza in $F$. se $B =A$, allora poichè $F$ è una copertura minimale, $Y=R-A$(non può essere + piccola di $R-A$ !!!!), e quindi $Y$ è una superchiave. se $B \neq A$ allora $B \in R-A$, e quindi $B$ è primo.
3. se $XA \in \rho$, poichè $F$ è una copertura minimale, non ci può essere dipendenza funzionale $X’ \to A \in F \,\,\,t.c. \,\ X’ \subset X$, e quindi $X$ è chiave in $XA$. ora dimostriamo che $\{XA\}$ è in 3FN. sia $Y \to B$ una qualsiasi dipendenza in $F$ tale che $YB \subseteq XA$: se $B=A$, allora, poichè $F$ è una copertura minimale, $Y=X$ (e quindi $Y$ è una superchiave). se $B \neq A$, allora $B \in X$ e quindi $B$ è primo.

>[!important] e per avere anche un join senza perdita ?
>basta aggiungere un sottoschema che contente **una** chiave al risultato dell’algoritmo di decomposizione

>[!example] esempio 1
dato il seguente schema di relazione: $R=(A,B,C,D,E,H)$
e il seguente insieme di dipendenze funzionali: $F = \{AB \to CD, C \to E, AB \to E, ABC \to D\}$
**verificare che $ABH$ è una chiave per $R$**
dobbiamo verificare 2 condizioni : che $ABH$ determina funzionalmente l’intero schema, e che nessun sottoinsieme di $ABH$ determina funzionalmente l’intero schema (nessun suo sottoinsieme è chiave).
per verificare la prima condizione, calcoliamo quindi la chiusura di $ABH$, che è $\{ABHCDE\}$, quindi $R$.
per verificare la seconda condizione, calcoliamo la chisura dei sottoinsiemi di $ABH$(prima di fare ciò, notiamo però che $H$ deve per forza apparire nella chiave, in quanto non è determinato in nessuna dipendenza, quindi ha senso calcolare solo $(AH)^+_{F}, (BH)^+_{F}$): $(AH)^+_{F}= \{AH\}, (BH)^+_{F} = \{BH\}$. quindi anche le seconda condizione è verificata
>
> **sapendo che $ABH$ è l’unica chiave per $R$, verificare che $R$ non è in 3FN**
> per verificare che lo schema non è in 3FN, basta osservare la dipendenza funzionale $AB \to CD$ ($AB$ non è superchiave, $CD$ non è primo)
>
> **trovare una copertura minimale $G$ di $F$**
>nel passo 1 decomponiamo tutte le parti destre delle dipendenze, ottentendo $F=\{AB \to C, AB \to D, C \to E, AB \to E, ABC \to D\}$.
>nel passo 2, riduciamo la dipendenza $ABC \to D$ in $AB \to D$ che però è un duplicato, quindi possiamo eleminarla, ottenendo $G = F=\{AB \to C, AB \to D, C \to E, AB \to E\}$ 
>nel passo 3, posso eliminare la dipendenza $AB \to E$, ottentendo quindi $G = \{AB \to C, AB \to D, C \to E\}$
>
> **trovare una decomposizione $\rho$ di $R$ tale che preserva $G$ e ogni schema in $\rho$ è in 3FN**
> applichiamo l’algoritmo di decomposizione: otteniamo $\rho = \{\{H\},\{ABC\}, \{ABD\},\{CE\}\}$
>
**trovare una decomposizione $\sigma$ di $R$ tale che preserva $G$, ha un join senza perdita e ogni schema in $\sigma$ è in 3FN**
per ottenere una decomposizione con join senza perdita, basta aggiungere un sottoschema che contiene gli attributi della chiave. otteniamo quindi $\rho = \{\{H\},\{ABC\}, \{ABD\},\{CE\}, \{ABH\}\}$




