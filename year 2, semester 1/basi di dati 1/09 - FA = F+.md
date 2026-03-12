---
created: 2024-10-18
related to: "[[08 - chiusure di dipendenze funzionali]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [dimostrazione](#dimostrazione)
>	- [$F^+ \supseteq F^A$](#$F%5E+%20%5Csupseteq%20F%5EA$)
>	- [$F^+ \subseteq F^A$](#$F%5E+%20%5Csubseteq%20F%5EA$)
>- [note](#note)
>- [a cosa ci serve conoscere $F^+$](#a%20cosa%20ci%20serve%20conoscere%20$F%5E+$)
# teorema
>[!note] teorema
Siano R uno schema di relazione ed F un insieme di dipendenze funzionali su R. si ha $F^A = F^+$, cioè
$$F^A \subseteq F^+ \land F^+ \subseteq F^A$$

dimostriamo quindi il teorema dimostrando la doppia inclusione di sopra, che singifica:
- ogni dipendenza ottenibile dagli assiomi di Armstrong deve essere necessariamente soddisfatta da ogni istanza legale
- tutte le dipendenze che devono essere soddisfatte da un’istanza legale si possono ricavare con gli assiomi di Armstrong
# dimostrazione
## $F^+ \supseteq F^A$
data una dipendenza $X \to Y \in F^A$ dimostriamo che $X \to Y \in F^+$ per induzione sul numero $i$ di applicazioni di **uno degli assiomi di Armstrong**
caso base: $i=0$ 
- $X \to Y \in F$, quindi, visto che $F \subseteq F^+$, $X \to Y \in F^+$
ipotesi induttiva: $i-1$
- $X \to Y \in F^A \implies X \to Y \in F^+$, quindi $X \to Y$ è soddisfatta da ogni istanza legale
passo induttivo, $i$:
- $X \to Y \in F^A$
- diciamo che $X \to Y$ non è altro che la dipendenza funzionale ottenuta applicando uno degli assiomi di Armstrong $i-1$ volte(la dipendenza funzionale dell’ipotesi induttiva), a cui applichiamo uno degli assiomi di Armstrong.
- abbiamo quindi 3 casi, uno per ogni assioma che potremmo aver applicato alla dipendenza funzionale dell’ipotesi induttiva.

1. **assioma della riflessività**
	- ipotizziamo di aver usato l’assioma della riflessività sull’ipotesi induttiva: sappiamo che $Y \subseteq X$ 
	- verifichiamo che $X \to Y$ sia verificata per ogni istanza legale.
		- $\forall r \text{, (r istanza legale di R)}, t_{1}[X]=t_{2}[X] \implies t_{1}[Y]=t_{2}[Y]$
		- per l’ipotesi induttiva, sappiamo che ciò è banalmente verificato (uhhhhhhhh)
		- ciò vale per ogni istanza legale di R, quindi $X \to Y \in F^+$
		
2. **assioma dell’aumento**
	- ipotiziamo di aver usato l’assioma dell’aumento sulla dipendenza funzionale ottenuta in $i-1$ passi, che per comodità chiamiamo $V \to W \in F^A$(che per ipotesi induttiva, $\in F^+$). 
	- possiamo quindi ricavare che $X = VZ , \,\,\, Y=WZ$ (abbiamo moltiplicato i termini dell’ipotesi per un $Z \subseteq R$).
	- verifichiamo che $X \to Y$ sia verificata per ogni istanza legale.
		- $\forall r \text{, (r istanza legale di R)}, t_{1}[X]=t_{2}[X] \implies t_{1}[VZ]=t_{2}[VZ]$
		- possiamo riscriverla in questo modo: $t_{1}[X]=t_{2}[X] \implies t_{2}[V]=t_{2}[V] \land t_{1}[Z]=t_{2}[Z]$
		- per ipotesi induttiva, sappiamo che: $t_{1}[V]=t_{2}[V] \implies t_{2}[W]=t_{2}[W]$
		- sappiamo quindi che $t_{2}[W]=t_{2}[W]$(per ipotesi induttiva) e $t_{1}[Z]=t_{2}[Z]$(per parte sinistra dell’implicazione da dimostrare), quindi $t_{1}[WZ]=t_{2}[WZ]$
		- ciò vale per ogni istanza legale di R, quindi $X \to Y \in F^+$
3. **assioma della transitività**
	- ipotiziamo di aver usato l’assioma dell’additività per ricavare $X \to Y$. ciò vuol dire che abbiamo utilizzato due dipendenze, create in $i-1$ applicazioni di assiomi di Armstrong: $X \to Y \in F^A \,\,\ ,\,\,\,\,Z \to Y \in F^A$, che per ipotesi induttiva $\in F^+$
	- verifichiamo che $X \to Y$ sia verificata per ogni istanza legale.
		- $\forall r \text{, (r istanza legale di R)}$,  per ipotesi induttiva, $t_{1}[X]=t_{2}[X] \implies t_{1}[Y]=t_{2}[Y]$, e sempre per ipotesi induttiva, $t_{1}[Z]=t_{2}[Z] \implies t_{1}[Y]=t_{2}[Y]$

il ragionamento dovrebbe essere di questo tipo: prendendo una istanza legale r, sapendo che l’ipotesi induttiva è vera, la dipendenza del passo induttivo deve essere obbligatoriamente soddisfatta. altrimenti r non sarebbe legale. in questo caso, la dipendenza del passo induttivo belongs in $F^+$
## $F^+ \subseteq F^A$
dimostriamo che $X \to Y \in F^+ \implies X \to Y \in F^A$
supponiamo per assurdo che esista una dipendenza funzionale $X \to Y \in F^+$ tale che $X \to Y \notin F^A$. Usiamo una particolare istanza legale di R per dimostrare che questa supposizione porta ad una contraddizione:
>[!figure] ![[Pasted image 20241022223901.png]]
l’istanza è composta da solo 2 tuple, uguali sugli attributi in $X^+$ e diverse in tutti gli altri attributi ($R-X^+$)

dimostreremo che :
1. r è un’istanza legale di R
2. $X \to Y \in F^+ \implies X \to Y \in F^A$

>[!info] dimostrazione di 1.
>sia $V \to W$ una dipendenza funzionale in $F$
>- se le due tuple sono diverse in V, allora la dipendenza è soddisfatta, e $(V \cap R-X^+) \neq \varnothing$
>- se le due tuple di r hanno gli stessi valori per V, allora $V \subseteq X^+$, perchè le tuple sono uguali solo per $X^+$
>	- inoltre, per il lemma 1, $X \to V \in F^A$, e per l’assioma della transitività, $X \to W \in F^A$
>	- quindi, di nuovo per il lemma 1, $W \subseteq X^+$, quindi le due tuple sono uguali sui valori di $W$, quindi $V \to W$ è soddisfatta, e poichè abbiamo considerato una qualunque dipendenza in F, r le soddisfa tutte, quindi è legale.
funziona che verifichiamo se la dipendenza è rispettata.meh

>[!info] dimostrazione di 2.
supponiamo per assurdo che esista una dipendenza funzionale $X \to Y \in F^+$ tale che $X \to Y \notin F^A$
>- abbiamo dimostrato che r è un’istanza legale, quindi le dipendenze in $F^+$ sono soddisfatte anche da r.
>- inoltre, avendo 2 tuple uguali su X ($X \subseteq X^+$), e sapendo che r soddisfa $X \to Y$, ciò implica che $Y \subseteq X^+$, e per il lemma 1, $X \to Y \in F^A$

# note 
è molto utile notare che la dimostrazione del teorema di basa su due collegamenti molto utili:
- il collegamento che esiste tra l’insieme $F^+$ e le istanze legali: se un’istanza è legale allora soddisfa anche tutte le dipendenze in $F^+$, e $F^+$ è l’insieme di dipendenze soddisfatte da ogni istanza legale (quindi per verificare se una istanza è legale, basta controllare che soddisfi le dipendenze in F (perchè $F^+$ si deriva da F con gli assiomi di Armstrong))
- il collegamento che esiste tra la **chiusura $X^+$** di un insieme di attributi X con insieme di dipendenze funzionali di riferimento F(di cui omettiamo il pedice), e il **sottoinsieme di dipendenze in F$^A$ che hanno X come determinante**, cioè 
 $$ Y \subseteq X^+ \iff X \to Y \in F^A$$
che equivale a dire che 
$$Y \subseteq X^+ \iff X \to Y \in F^+$$, e quindi in particolare che $X \to Y$ **deve essere soddisfatta da ogni istanza legale**
# a cosa ci serve conoscere $F^+$
calcolare $F^A$, e quindi $F^+$, richiede tempo esponenziale  in $|R|\text{\,\,\ cardinalità di R}$ (dato che si applicano ricorsivamente gli assiomi di Armstrong)
infatti basta pensare agli assiomi della riflessività e dell’aumento, o la regola della decomposizione: ogni possibile sottoinsieme di R porta a una o più dipendenze. e visto che i possibili sottoinsiemi di R sono $2^{|R|}$, il calcolo di $|F^+|$ ha complessità esponenziale in $|R|$