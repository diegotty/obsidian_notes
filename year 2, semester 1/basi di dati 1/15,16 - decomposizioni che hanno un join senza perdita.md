---
created: 2025-01-16T17:08
updated: 2025-02-20T09:38
---
>[!index]
>
>- [teorema](#teorema)
>- [verifica di $\rho$ senza perdita](#verifica%20di%20$%5Crho$%20senza%20perdita)
>- [teorema sulla correttezza dell’algoritmo per la verifica di ‘$\rho$ ha join senza perdita’](#teorema%20sulla%20correttezza%20dell%E2%80%99algoritmo%20per%20la%20verifica%20di%20%E2%80%98$%5Crho$%20ha%20join%20senza%20perdita%E2%80%99)
>- [dimostrazione](#dimostrazione)
>- [esempi](#esempi)

come abbiamo visto nelle [[10 - decomposizione#condizioni della decomposizione| condizioni per una decomposizione corretta]], l’ultima condizione, che non sappiamo anche verificare in una decomposizione, è che deve permettere di **ricostruire mediante join naturale** ogni **istanza legale dello schema originario**(senza aggiunta di informazione estranea)

inoltre, nell [[10 - decomposizione|esempio 2 della decomposizione]] abbiamo visto cosa signfica, e come capita, di avere perdita di informazioni in una decomposizione
>[!info] definizione
>sia $R$ uno schema di relazione. Una decomposizione$\rho = \{R_{1}, R_{2}, \dots, R_{k}\}$ di $R$ ha un join senza perdita se **per ogni istanza legale $r$** di $R$ si ha $r=\pi_{R_{1}}(r) \bowtie \pi_{R_{2}}(r) \bowtie \dots \bowtie \pi_{R_{k}}(r)$

>[!warning] ricordiamo che per $\pi_{R_i}(r)$, si intende la proiezione di $r$ sugli attributi presenti in $R_i$
# teorema 
Sia $R$ uno schema di relazione e $\rho = \{R_{1}, R_{2}, \dots, R_{k}\}$ una decomposizione di $R$. per ogni istanza legale $r$ di $R$, le seguenti proprieta valgono per $r$ e $m_{\rho}(r)=\pi_{R_{1}}(r) \bowtie \pi_{R_{2}}(r) \bowtie \dots \bowtie \pi_{R_{k}}(r)$ (join naturale delle proiezioni di $r$ su ogni sottoschema di $\rho$):
>[!info] **a)** $r \subseteq m_{\rho}(r)$
**dimostrazione**
sia $t$ una tupla di $r$. $\forall i, i=1,…,k, \,\,t[R_{i}] \in \pi_{R_{i}}(r)]$, e quindi $t \in m_{\rho}(r)$
cioè:
>- il sottoinsieme dei suoi valori su attributi di $R_i$ sarà sicuramente in una tupla della proiezione $\pi_{R_{i}}(r)$
>- quindi **OGNI** sottoinsieme dei valori di $t$ corrispondente agli attributi presenti in un sottoschema $R_i$ della decomposizione di $R$, comparirà in $\pi_{R_{i}(r)}$
>- inoltre sappiamo che se ci dovessero essere duplicati del sottoinsieme dei valori di $t$ in $\pi_{R_i}(r)$, tali valori apparirebbero solo una volta in $R_i$, in quanto la proiezione segue le regole insiemistiche ed elimina i duplicati
>- quindi ogni tupla potrà essere ricostruita tramite il join naturale, in quanto per ogni sottoinsieme di tale tupla, esiste un sottoschema che contiene i suoi valori
>- anzi, il join naturale potrebbe ottenere tuple che non erano in r ricomponendo pezzi di tuple diverse

>[!info] **b)** $\pi_{R_{i}}(m_{\rho}(r))= \pi_{R_{i}}(r)$
**dimostrazione**
per **a)**, si ha che $r \subseteq m_{\rho}(r)$, e quindi $\pi_{R_{i}}(r) \subseteq \pi_{R_{i}}(m_{\rho}(r))$
è sufficiente quindi dimostrare che $\pi_{R_{i}}(m_{\rho}(r))\subseteq \pi_{R_{i}}(r)$ (uguaglianza di insiemi dimostrata con doppia inclusione)
- per ogni tupla $t \in m_{\rho}(r)$ , e per ogni $i,i=1,…,k$, deve esistere un tupla $t’ \in r$ tale che $t[R_i]=t'[R_{i}]$. in quanto, se tale tupla $t’$ non esistesse, non troveremmo i valori di $t$ su $R_i$ nella proiezione $\pi_{R_{i}(r)}$, e di conseguenza non li avremmo nel join naturale

>[!info]  **c)** $m_{\rho}(m_{\rho}(r)) = m_{\rho}(r)$
per **b)** si ha $\pi_{R_{i}}(m_{\rho}(r))= \pi_{R_{i}}(r)$
pertanto, applicando la definizione dell’operatore $m_{\rho}$ (join delle proiezioni), avremo:
$$m_{\rho}(m_{\rho}(r))= \pi_{R_{1}}(m_{\rho}(r)) \bowtie \pi_{R_{2}}(m_{\rho}(r)) \bowtie \dots \bowtie \pi_{R_{k}}(m_{R_{k}}(r)) =$$ 
$$\pi_{R_{1}}(r) \bowtie \pi_{R_{2}}(r) \bowtie \dots \bowtie \pi_{R_{k}}(r) = m_{\rho}(r)$$

# verifica di $\rho$ senza perdita
```pseudo
	\begin{algorithm}
	\caption{verifica che una decomposizione abbia join senza perdita}
	\begin{algorithmic}
	\Input uno schema di relazione $R$, un insieme di dipendenze funzionali $F$ su $R$, una decomposizione $\rho = \{R_1, R_2, ..., R_k\}$ di $R$
	\Output tabella per decidere se $\rho$ ha un join senza perdita
	\State costruire una tabella \textbf{r} di $|R|$ colonne e $|\rho|$ righe, dove:
	\State all'incrocio della i-esima riga e della j-esima colonna inserire $a_j$ se l'attributo $A_j \in R_i$, altrimenti $b_{ij}$
	\\
	\textbf{do}
	\For{ \textbf{every} $X \to Y \in F$}
	\If{$\exist$ due tuple $t_1, t_2$, t.c. $t_1[X]=t_2[X] \land t_1[Y]\neq t_2[Y]$}
	\For{$\forall A_J \in Y$}
	\If{$t_1[A_j]='a_j'$}
	\State $t_2[A_J] := t_1[A_j]$
	\Else 
	\State $t_1[A_j]=t_2[A_j]$
    \EndIf
    \EndFor
    \EndIf
	\State
    \EndFor
	\State
	\textbf{while} $r$ non ha una riga con tutte '$a$' $\land$ $r$ è cambiato
	\If{$r$ ha una riga con tutte '$a$'}
	\State $\rho$ ha un join senza perdita
	\Else
	\State $\rho$ non ha un join senza perdita
    \EndIf
	\end{algorithmic}
	\end{algorithm}
```
- la tabella viene costruita con questa logica: ogni colonna è un’attributo dello schema $R$, e ogni riga rappresenta un sottoschema di $\rho$. all’inizio, inseriamo $a_j$ se l’attributo $A$ nella colonna $j$-esima appartiene all sottoschema $i$-esimo ($R_i$).
- immaginiamo che, i valori $a_j, b_{ij}$ sono valori particolari appartententi al dominio dell’attributi $A_j$, e consideriamo tutti i valori $a_j$ uguali tra loro, mentre il valore $b_{ij}$ è diverso da $a_j$ e da un altro valore $b_{kj}$, anche se tutti e 3 appartengono al dominio di $A_j$
- con queste considerazioni, la tabella $r$ appena creata è un’istanza dello schema $R$
- **per i nostri scopi (?)**, trasformiamo questa istanza $r$ di $R$ in una istanza legale: per fare ciò dobbiamo far rispettare ad $r$ tutte le dipendenze di $F$
- quindi, iteriamo per ogni dipendenza $X \to Y \in F$ e ogni volta che troviamo 2 tuple $t_1, t_2 \in R \,\,\, t.c. t_1[X]=t_{2}[X] \land t_{1}[Y] \neq t_{2}[Y]$ ( che quindi non rispettano la dipendenza $X \to Y$), facciamo in modo che siano uguali anche su $Y$ (modificando la tabella $r$)
- per rendere $t_1[Y]= t_{2}[Y]$, controlliamo ogni attributo $\in Y$, e sovrascriviamo i valori delle due tuple in questo modo: se una delle due tuple ha come valore una ‘$a$’, allora tale $a$ verrà usata per sovrascrivere l’altra tupla, altrimenti entrambe le tuple hanno un valore $b$ distinto per quell’attributo, e scegliamo una delle due tuple e usiamo il suo valore per sovrascrivere il valore nell’altra tupla
>[!warning] ricordiamo che tutti i  valori $a_j$ sono considerati uguali
- ripetiamo l’iterazione su ogni $X \to Y \in F$ finchè $r$ non è un’istanza legale, cioè quando, dopo aver iterato su ogni $X \to Y \in F$ la tabella non è cambiata (se è cambiata, potrebbero essere cambiati i valori che prima verificando una data dipendenza, e bisogna quindi ricontrollare)
>[!warning] perchè entra in gioco $F$ ?
>perchè la proprietà $m_{\rho}(r)=r$ deve valere per ogni istanza legale di $R$, cioè ogni istanza che soddisfa tutte le dipendenze in $F$. l’algoritmo costruisce proprio una istanza legale che ci permette la verifica, soddisfando tutte le dipendenze in $F$
# teorema sulla correttezza dell’algoritmo per la verifica di ‘$\rho$ ha join senza perdita’
>[!info] teorema
>sia $R$ uno schema di relazione, $F$ un insieme di dipendenze funzionali su $R$ e $\rho=\{R_{1}, R_{2}, \dots, R_{k}\}$ una decomposizione di $R$. 
>l’algorimo di verifica decide correttamente se $\rho$ ha un join senza perita.

per dimostrare il teorema, occorre dimostare che:
$\rho$ ha un join senza perdita ($m_{\rho}(r) = r$ per ogni $r$ istanza legale) $\iff$ quando l’algoritmo termina, la tabella $r$ ha una tupla con tutte ‘$a$’

# dimostrazione
>[!info] dimostrazione
occorre dimostrare che: 
$$\rho \text{ ha un join senza perdita} \iff \text{quando l'algoritmo termina } r \text{ha una tupla con tutte} 'a'$$
$\implies$
la tabella può essere interpretata come un’istanza legale di $R$ ( basta sostituire i simboli $’a’$ e $’b’$ con valori presi dai domini dei corrispondenti attributi in modo tale che ad uno stesso simbolo venga sostituito lo stesso valore) in quanto l’algoritmo termina quando non ci sono più violazioni delle dipendenze in $F$.
>
>la tabella $r$ (iniziale) contiene $’a’$ in ogni riga per gli attributi che appartengono al sottoschema a cui fa riferimento quella riga
> quindi ogni proiezione $\pi_{R_i}(r)$ della tabella su un sottoschema avrà una tupla di tutte $’a’$, cioè la riga che corrisponde ad $R_i$
> quando si fa il join naturale tra 2 proiezioni $\pi_{R_i}(r)$ e $\pi_{R_j}(r)$ , si ottengono 2 possibili casi:
>- $R_i$ e $R_j$ condividono (almeno) un attributo, quindi il risultato del join naturale sarà un’istanza con un’unica tupla contenente sole $’a’$(in quanto facciamo un join tra 2 tuple che hanno solo $’a’$, e se hanno almeno un attributo in comune, verrà effettuato il join su quell’attributo e il resto degli attributi sono $’a’$)
>- $R_i$ e $R_j$ non condividono alcun attributo, quindi il join naturale degenera in un prodotto cartesiano, che conterra, tra tutte le tuple, quella con sole $’a’$ ($t_i$, $t_j$
>in entrambi i casi, il join naturale ci poterà ad unire $t_i$ e $t_j$ in una tupla con sole $’a’$
>visto che $m_{\rho}(r)$ è il join naturale di tutte le proiezioni, esso contiene anche una tupla con tutte $’a’$ contraddicendo quindi l’ipotesi per assurdo


# esempi
>[!example] esempio 1
>dato il seguente schema di relazione: $R =(A,B,C,D,E)$
>e il seguente insieme di dipendenze funzionali $F = \{C \to D, AB \to E, D \to B\}$,
>dire se la decomposizione $\rho = \{AC,ADE,CDE,AD,B\}$ ha un join senza perdita
>
>cominciamo costruendo la tabella:
>![[Pasted image 20241116111847.png]]
>
**prima iterazione**
$C \to D$: la prima e terza riga coincidono su $C$, ma non su $D$. dato che una delle due tuple ha un valore $a$, usiamo tale valore per sovrascrivere l’altra tupla in $D$
$AB \to E$: non ho bisogno di fare cambiamenti (la dipendenza è gia soddisfatta)
$D \to B$: la seconda, terza e quarta riga coincidono su $D$, ma non su $B$. nessuna delle 3 tuple ha un valore $a$ in $B$, quindi rendiamo le 3 tuple uguali su uno dei valori $b$ in $B$
>![[Pasted image 20241116113233.png]]
a fine iterazione notiamo che la tabella è stata modificata, quindi re-iteriamo sulle dipendenze di $F$
>
**seconda iterazione**
$C \to D$: non ho bisogno di fare cambiamenti (la dipendenza è già soddisfatta)
$AB \to E$: la prima, seconda e quarta riga hanno coincidono su $AB$, ma non su $E$: cambiamo $E$, e visto che abbiamo una tupla con una $a$, usiamo tale $a$ per modificare il resto delle tuple
$D \to D$: la prima e la seconda riga concidono su $D$, ma non su $B$. nessuna delle due tuple ha un valore $a$ in $B$, quindi rendiamo le 2 tuple uguali su uno dei valori $b$ in $B$
>
>![[Pasted image 20241116113254.png]]
a fine iterazione notiamo che la tabella è stata modificata, quindi re-iteriamo sulle dipendenze di $F$
>
**terza iterazione**
$C \to B$: non ho bisogno di effettuare cambiamenti (la dipendenza è gia soddisfatta)
$AB \to E$: non ho bisogno di effettuare cambiamenti (la dipendenza è gia soddisfatta)
$D \to B$: non ho bisogno di effettuare cambiamenti p(la dipendenza è gia soddisfatta)
![[Pasted image 20241116112407.png]]
la tabella non cambia più e l’algoritmo termina. occorre verificare la presenza di una tupla con tutte $a$: **poichè tale tupla non è presente, il join NON È senza perdita**
