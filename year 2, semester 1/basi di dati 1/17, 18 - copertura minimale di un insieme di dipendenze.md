---
created: 2024-11-21
related to: "[[10 - decomposizione]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [$F^{min}$](#$F%5E%7Bmin%7D$)
>- [come calcolare $F^{min}$](#come%20calcolare%20$F%5E%7Bmin%7D$)
>- [esempi](#esempi)

affrontiamo ora il problema di come ottenere una decomposizione che soddisfi le nostre condizioni.
>[!warning] è possibile sempre ottenerla ? si !
> ed esiste un algoritmo che raggiunge questo scopo
# $F^{min}$
dato un insieme di dipendenze funzionali $F$, una copertura minimale di $F$ è un insieme $G$ di dipendenze funzionali equivalente a F ($F \equiv G$), tale che:
-  per ogni dipendenza funzionale in $G$, la parte destra è un **singleton** (cioè è costitutita da un solo attributo)
- per nessuna dipendenza $X \to A \in G$, esiste $X’ \subset X$ tale che $G \equiv G - \{X \to A\} \cup \{X’ \to A\}$
- per nessuna dipendenza funzionale $X \to A \in G$, $G \equiv G - \{X \to A\}$ (ogni dipendenza non è ridondante)
# come calcolare $F^{min}$
1. usando la regola della decomposizione, si riducono a singleton le parti destre delle dipendenze funzionali
2. $\forall X \to A \in F$, verifichiamo se $\exists X’ \subset X \,\,t.c. \,\ F \equiv G$, dove $G = \{X \to A\} \cup \{X’ \to A\}$
	- per dimostare che $F \equiv G$, dobbiamo verificare se  $F^+ \subseteq G^+ \land G^+ \subseteq F^+$, cioè per il lemma 2, dobbiamo dimostare $F \subseteq G^+ \land G \subseteq F^+$
	- inoltre, sappiamo che $G$ e $F$ differiscono solo perchè $X \to A \in F$, mentre $X \to A \not\in G, X' \to A \in G$
	- quindi dobbiamo controllare solo se: 
		- $X \to A \in G^+$, quindi usando il lemma 1, dobbiamo verifcare se $A \in X^+_G$
		- $X’ \to A \in F^+$, quindi usando il lemma 1, dobbiamo verificare se $A \in X’^+_F$
	- $X \to A \in G^+$ non è necessario da calcolare, in quanto $X’ \subseteq X$, quindi per come è costruito l’algoritmo per il calcolo della chiusura, $A$ viene inserito subito ! prima ancora di inziare il while.
	- quindi devo solo controllare se $A \in X’_F$, e se ciò è vero, allora posso ridurre $X \to A$ a $X’ \to A$, e considerare $G$ come l’insieme di riferimento per le verifiche successive
3. $\forall  X \to A$, verificare se $F \equiv F - \{X \to A\} = G$
$X^+_F$ dovrebbe essere uguale a $X^+_G$, in particolare dobbiamo controllare se $X \to A \in G^+$, cioè per il lemma 1, se $A \in X^+_G$. se ciò è vero, $X \to A$ viene eliminata
>[!info] osservazione
>nel passo 2, se $F$ contiene sia $AB \to C$ che $A \to C$, allora $AB \to C$ non solo si può ridurre, ma si può anche eliminare
nel passo 3, se $X \to A$ ma **non esiste** $Y \to A \in F$ con $Y \not= X$, allora **è inutile provare a eliminare** $X \to A$ !!

>[!info] osservazione 2: il cacolo delle chiusure di attributi
>- nel passo 2, se calcoliamo le chiusure di attributi e dopo riduciamo o eliminiamo delle dipendenze, non c’è bisogno di ri-calcolare le chiusure di tali attributi, in quanto $G$ è equivalente a $F$
>- nel passo 3 invece, se calcoliamo la chiusura di degli attributi(es :$B$) a un certo punto del passo (mentre proviamo ad eliminare una certa dipendenza), stiamo cambiando $G$ in modo che esso potrebbe non essere equivalente ad $F$ (stiamo appunto rimuovendo una dipendenza $G$ per verificare se è ridondante). quindi, la prossima volta che bisognerà calcolare la chiusura di tali attributi (es :$B$), non potremo usare la chiusura che abbiamo calcolato in precedenza, ma dovremo ri-calcolarla perchè avremo temporaneamente eliminato una dipendenza diversa da $G$, che potrebbe quindi essere non equivalente ad $F$
>


>[!warning] il secondo passo va fatto rigorosamente prima del terzo !!!!!

>[!info] possono esserci + coperture minimali 
>se $AB \to C \in F$ e trovo sia $B \to C$ che $A \to C$ in $F^+$, posso ridurla in una delle due dipendenze, e la scelta porta 2 chiusure minimali diverse !
proprio perchè non esiste **LA** decomposizione giusta, ma ci sono diverse possibilità, potrebbe succedere che la decomposizione da verificare **non sia stata ottenuta** tramite l’algoritmo. ciò non ci autorizza a concludere che la decomposizione da verificare non possegga le proprietà richieste !!
>
> può anche succedere che $F$ sia già in forma minimale, e quindi non ci sia da fare alcuna riduzione
# esempi
>[!example] esempio 1
dato il seguente schema di relazione : $R = (A,B,C,D,E,H)$
e il seguente insieme di dipendenze funzionali $F = \{AB \to CD, C \to E, AB \to E, ABC \to D\}$
trovare una copertura minimale $G$ di $F$
>
> per trovare la copertura minimale, prima di tutto riduciamo le parti destre a singleton (**passo 1**)
> $F = \{AB \to C, AB \to D, C \to E, AB \to E, ABC \to D\}$
>
>ora dobbiamo verificare se nelle dipendenze ci sono ridondanze nelle parti sinistre (**passo 2**)
>per la dipendenza $AB \to C$, controliamo se $A \to C$ appartiene a $F$, cioè se $C$ appartiene a $(A)_F^+$ e controlliamo se $B \to C$ appartiene a $F$ . in questo caso entrambe le chiusure contengono solo l’attributo di partenza, quindi la parte sinistra della dipendenza non può essere ridotta
>lo stesso si verifica per le le dipendenze $AB \to D, AB \to E$. invece, provando a ridurre $ABC \to D$, notiamo che nell’insieme di dipendenze esiste $AB \to D$. quindi, in questo caso, oltre a eliminare l’attributo $C$ da $ABC \to D$, possiamo eliminare tutta la dipendenza risultante che è un duplicato.
>alla fine di questo passo, quindi abbiamo $G = \{AB \to C, AB \to D, C \to E, AB \to E\}$, che è equivalente ad $F$, e quindi diventa il nostro nuovo $F$
>
>vediamo ora se questo insieme contiene dipendenze ridondanti (**passo 3**)
>possiamo considerare che $C$ è determinato unicamente da $AB$, quindi elminando la dipendenza $AB \to C$ non riusciremmo più ad inserirlo nella chiusra di $AB$ rispetto al nuovo insieme di dipendenze, e lo stesso ragionamento vale per $D$. 
>proviamo allora ad eliminare la dipendenza $C \to E$, e calcolando $(C)_G^+$ con $G =\{AB \to C, AB \to D, AB \to E\}$, abbiamo che $(C)_G^+ = \{C\}$, in cui non compare $E$. la dipendenza deve dunque rimanere.
>proviamo infine ad elminare $AB \to E$. calcolando $(AB)^+_G =\{A,B,C,D,E\}$ con $G = \{AB \to C, AB \to D, C \to D\}$, notiamo che $E$ è presente. ciò significa che $E$ **rientra comunque** nella chiusura di $AB$ perchè la dipendenza $AB \to E$, pur non comparendo in $G$, si trova in $G^+$, e quindi può essere eliminata.
>
> la **copertura minimale** di $F$ è $G = \{AB \to C, AB \to D, C \to D\}$