---
related to: "[[13 - problemi di ottimizzazione, algoritmi di approssimazione]]"
created: 2025-05-06T13:13
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [problema della selezione](#problema%20della%20selezione)
>	- [approccio basato su divide et impera](#approccio%20basato%20su%20divide%20et%20impera)
## problema della selezione
>[!info] problema
data una lista $A$ di $n$ interi distinti ed un intero $k$, con $1\leq k\leq n$, vogliamo sapere quale elemento occuperebbe la posizione $k$ se il vettore venisse ordinato
>
> casi particolari:
>- per $k=1$ avremo il minimo di $A$
>- per $k=n$ avremo il massimo di $A$
>- per $k=\left[ \frac{n}{2} \right]$ avremo il mediano di $A$

>[!info] dumb algo
>un semplice algoritmo di complessità $O(n\log n)$ è il seguente:
>```python
>def selezione1(A, k):
>	A.sort()
>	return A[k-1]
>```
>e in caso di $k=1$ o $k=n$, il problema si riduce alla ricerca del minimo o del massimo, problemi risolvibili in $\Theta(n)$

>[!tip] vedremo, con la tecnica del **divide_et_impera** (cool formatting) che il problema può risolversi in $\Theta(n)$ anche nel caso generale
>dimostreremo quindi che il problema della selezione è computazionalmente più semplice di quello dell’ordinamento (che invece richiede tempo $\Omega(n\log n)$)
### approccio basato su divide et impera
>[!info] logica
>- scegli nella lista $A$ l'elemento in posizione $A[0]$ (che chiameremo perno)
>- a partire da $A$, costruisci due liste $A_1$ ed $A_2$, la prima contenente gli elementi di $A$ minori del perno, e la seconda gli elementi di $A$ maggiori del perno
>dove si trova l'elemento di rango $k$ ?
>	- se $|A_1| \geq k$, allora l'elemento di rango $k$ è nel vettore $A_1$
>	- se $|A_1| = k-1$, allora l'elemento di rango $k$ è proprio il perno $x$
>	- se $|A_1| < k-1$, allora l'elemento di rango $k$ è in $A_2$, ed è l'elemento di rango $k-|A_1|-1$ in $A_2$

si nota come con questa logica, dopo aver costruito le due liste $A_{1}$ e $A_{2}$, grazie al test sulla cardinalità di $A_{1}$, il problema della selezione dell’elemento di rango $k$ o risulta risolto **oppure viene ricondotto alla selezione di un elemento in una lista con meno di $n$ elementi** (in quanto $A_{1}$ e $A_{2}$ non sono ordinate !!!)
>[!info] implementazione
>```python
>def selezione2(A, k):
>	if len(A) == 1:
>		return A[0]
>	perno = A[0]
>	A1, A2 = [], []
>	for i range(1, len(A)):
>		if A[i] < perno:
>			A1.append(A[i])
>		else:
>			A2.append(A[i])
>	if len(A1) >= k:
>		return selezione2(A1, k)
>	elif len(A1) == k-1:
>		return perno
>	return selezione2(A2, k - len(A1) - 1)
>```

la procedura tripartisce la lista in $A_{1}$, $A[0]$ ed $A_{2}$, e può restituire una partizione massimamente sbilanciata, in cui si ha, ad esempio, $|A_{1}| = 0$ e $|A_{2}| = n-1$. questo accade quando il perno risulta essere l’elemento minimo nella lista

qualora questo evento **sfortunato** si ripetesse sistematicamente nel corso delle varie partizione eseguite dall’algoritmo, che può succedere quando cerco il massimo in una lista ordinata, allora la complessità dell’algoritmo al caso pessimo viene catturata dalla sequente equazione:
$$
T(n)= T(n-1) + \Theta(n)
$$
(in quanto ad ogni iterazione impiego $\Theta(n)$)
che risolta dà
$$
T(n) = \Theta(n^2)
$$
in generale, la complessità **superiore** della procedura è catturata dalla ricorrenza 
$$
T(n) = T(m) + \Theta(n) \text{   , con  } m = max\{|A_{1}|, |A_{2}|\}
$$
(in quanto consideriamo, per la complessità superiore, che sia necessario fare ricorsivamente una vista, ogni volta nella ripartizione di dimensione maggiore)
>[!tip] fuoco
se avessimo una regola di scelta del perno in grado di garantire una partizione bilanciata, cioè $m=max\{|A_{1}|, |A_{2}|\} \approx \frac{n}{2}$
>allora per la complessità $T(n)$ dell’algoritmo, avremmo
>$$
>T(n) = T\left( \frac{n}{2} \right) + \Theta(n)
>$$
che risolta da $T(n) = \Theta(n)$

chiedere che la partizione sia perfettamente bilanciata è *forse* chiedere troppo. possiamo accontentarci di chiedere che la scelta del perno garantisca partizioni non troppo sbilanciate, ad esempio quelle per cui $m=max\{|A_{1}|, |A_{2}\} \approx \frac{3n}{4}$
in questo caso si ha
$$
T(n) \leq T\left( \frac{3}{4}n \right) + \Theta(n)
$$
che risolta da ancora $T(n) = \Theta(n)$
- in generale, finche $m$ è una frazione di $n$, anche piuttosto vicina ad $n$, come $\frac{99}{100}n$i, la ricorrenza da sempre $T(n) = \Theta(n)$
**IDEA**:
scegliamo il perno $p$ a caso in modo equiprobabile tra gli elementi della lista
- anche se la scelta casuale non produce necessariamente una partizione bilancaita, quanto visto ci fa intuire che la complessità rimane lineare in $n$
>[!info] analisi formale del caso medio
con la randomizzazione introdotta per la scelta del perno, possiamo assumere che uno qualunque degli elementi del vettore, con uguale probabilità $\frac{1}{n}$ diventi perno, e poichè la scelta dell’elemento di rango $k$ produce $|A_{1}|=k-1$ e $|A_{2}|=n-k$, per il tempo atteso dell’algoritmo va studiata la ricorrenza: 
>$$
T(n) \leq \frac{1}{n} \sum^n_{k=1} T\Bigg(max\Big(T(k-1), T(n-k)\Big)\Bigg) + \Theta(n) \leq \frac{1}{n} \sum^{n-1}_{k=\left[ \frac{n}{2} \right]} 2T(k) + \Theta(n)
>$$
e possiamo dimostrare, con il metodo di sostituzione, che questa ricorrenza vale $T(n)=O(n)$
>>[!dimostrazione] dimostrazione per sostituzione
>>$$
>>T(n) = \begin{cases} \\
>\frac{1}{n} \sum^{n-1}_{k= \lfloor\frac{n}{2} \rfloor} 2T(k)+a \cdot n & \text{se }n\geq 3\\
>b & \text{altrimenti}
>\end{cases}
>>$$
>dimostriamo che $T(n) \leq c\cdot n$, per una qualche costane $c>0$ costante.
>>- per $n\leq 3$ abbiamo $T(n)\leq b\leq3c$, che è vera ad esempio per $c\geq b$
>>- sfruttando l’ipotesi induttiva $T(k)\leq c \cdot k$ per $k \leq n$ abbiamo:
>>$$
>>T(n)\leq \frac{2c}{n} \sum^{n-1}_{k= \left\lfloor  \frac{n}{2}  \right\rfloor } k + a \cdot n
>>$$
>>da cui ricaviamo (grazie flavio sperandeo …….)
>> $$
>> \begin{align}
>> T(n)&\leq \frac{2c}{n}\left( \sum^{n-1}_{k=1}k-\sum^{\lfloor n/2 \rfloor -1}_{k=1}k \right)+a\cdot n\leq \frac{2c}{n}\left( \frac{n(n-1)}{2}-\frac{\left( \frac{n}{2}-1 \right)\left( \frac{n}{2}-2 \right)}{2} \right)+a\cdot n \leq\\
>> &\leq \frac{c}{n}\left( \frac{3n^2}{4}+\frac{n}{2}-2 \right)+a\cdot n\leq \frac{3cn}{4}+\frac{c}{2}+a\cdot n=cn-\left( \frac{cn}{4}-\frac{c}{2}-a\cdot n \right)\leq cn
>> \end{align}
>> $$
>> dove l’ultima diseguaglianza segue prendendo $c$ in modo che $\left( \frac{cn}{4}-\frac{c}{2}-a\cdot n \right)\geq 0$
>> basta ad esempio prendere $c\geq 8a$
>>
>onestamente non ci ho capito un cazzo e credo ciò resterà così per il momento

l’analisi rigorosa appena fatta dimostra che, se la scelta del perno avviene in modo equiprobabile a caso tra i vari elementi della lista $A$, il tempo di calcolo dell’algoritmo risulta con alta probabilità lineare in $n$ !
- la complessità dell’algoritmo `sezione2R` (riportato sopra) è quindi $O(n)$ con alta probabilità
ovviamente, nel caso peggiore, quando nelle varie partizioni che si succedono nell’iterazione dell’algorimo si verifica che il perno sia sempre vicino al massimo o al minimo della lista, **la complessità dell’algoritmo rimane $O(n^2)$**. questo accade però con probabilità molto piccola

veidamo ora un algoritmo **deterministico** che garantisce complessità $O(n)$ anche al caso pessimo !
abbiamo visto che riuscire a selezionare un perno in grado di garantire che nessuna delle due sottoliste $A1$ e $A2$ abbia più di $c \cdot n$ elementi, per una qualche costante $0<c<1$ avrebbe come conseguenza una complessità di calcolo $O(n)$. descriviamo ora un metodo, noto come **il mediano dei mediani** per selezionare un perno che garantisce di produrre sempre due sottoliste $A1$ e $A2$, ciascuna delle quali ha non più di $\frac{3}{4}n$ elementi !
>[!info] logica
>- dividi l’insieme $A$, contenente $n$ elementi, in gruppi da 5 elementi ciascuno. l’ultimo gruppo potrebbe avere meno di 5 elementi. considera soltanto i primi $\left\lfloor  \frac{n}{5}  \right\rfloor$ gruppi, ciascuno composto esattamente da 5 elementi (se $n \% 5 != 0$, consideriamo tutti tranne l’ultimo)
>- trova il mediano all’interno di ciascuno di questi $l\left\lfloor  \frac{n}{5}  \right\rfloor$ gruppi
>- calcola il mediano $p$ dei mediani ottenuti al passo precedente
>- usa $p$ come elemento pivot per l’insieme $A$

>[!info] proprietà
se la lista $A$ contiene almeno 120 elementi e il perno $p$ con cui partizionarla viene scelto in base alla regola appena scritta sopra, si può esser sicuri che la dimensione di ciascuna delle due sottoliste $A1$ e $A2$ ottenute sarà limitata da $\frac{3}{4}n$
>>[!dimostrazione] prova
>il perno scelto $p$ ha proprietà di trovarsi in posizione $\lceil  \frac{n}{10}  \rceil$ (cioè $\left\lfloor  \frac{n}{5} \cdot \frac{1}{2}  \right\rfloor$) nella lista degli $\left\lfloor  \frac{n}{5}  \right\rfloor$ mediani selezionati in $A$.
>ci sono dunque $\left\lceil  \frac{n}{10}  \right\rceil-1$. mediani di valore inferiore a $p$ e $\left\lfloor  \frac{n}{5}  \right\rfloor - \left\lceil   \frac{n}{10} \right\rceil$ mediani di valore superiore a $p$
>>
>proviamo ora che: 
>>$|A_{2}| < \frac{3}{4}n$:
>>- consideriamo i $\left\lceil  \frac{n}{10}  \right\rceil-1$ mediani di valore inferiore a $p$. ognuno di questi mediani appartiene ad un gruppo di 5 elementi in $n$. ci sono dunque in $A$ altri 2 elementi inferiori a $p$ per ogni mediano. in totale abbiamo 
>>$$
>>3\Big(\left \lceil \frac{n}{10} \right\rceil -1 \Big) \geq 3 \frac{n}{10} - 3
>>$$
>>elementi che finiranno in $A_{1}$, di conseguenza
>>$$
>>|A_{2}| \leq n - \Big(3 \frac{n}{10} -3 \Big) = \frac{7}{10}n + 3\leq \frac{3}{4}n
>>$$
>>dove l’ultima diseguaglianza segue dal fatto che $n\geq120$ (anche se per questa disequazione basta che $n\geq60$)
>>
>> $|A_{1}| < \frac{3}{4}n$:
>>-  ci sono 
>> $$
>> \left\lfloor  \frac{n}{5}  \right\rfloor - \left\lceil  \frac{n}{10}  \right\rceil \geq \Big(\frac{n}{5} - 1\Big) - \Big(\frac{n}{10}+1\Big) = \frac{n}{10}-2
>>$$ 
>>mediani di valore superiore a $p$. ognuno di questi mediani appartiene ad un gruppo di 5 elementi in $A$. ci sono dunque in $A$ altri 2 elementi superiori a $p$ per ogni mediano (quindi 3 elementi per ogni gruppo con mediano maggiore di $p$). in totale abbiamo almeno 
>>$$
>>3 \frac{n}{10} -6
>>$$
>elementi di $A$ che finiranno in $A2$, di conseguenza
>>$$
>>|A_{1}| \leq n - \Big(3 \frac{n}{10} -6\Big) =\frac{7}{10}n + 6\leq \frac{3}{4}n
>>$$
>>dove l’ultima diseguaglianza segue dal fatto che $n\geq120$

>[!info] implementazione
>```python
>from math import ceil
>
>def selezione(A, K):
>	if len(A) <= 120:
>		A.sort()
>		return A[k-1]
>	
>	# inizializza B con i mediani di len(A)//5 gruppi di 5 elementi di A
>	# (sorta i gruppi di 5, e prende il terzo elemento (mediano))
>	B = [sorted(A[5*i : 5*i+5])[2] for i in range(len(A)//5)]
>	
>	# individua il perno p con la regola del mediano dei mediani (entra nel primo if, ritorna il mediano)
>	perno = selezione(B, ceil(len(A)/10))
>	A1, A2 = [], []
>	
>	# tripartizione	
>	for x in A:
>		if x < perno: A1.append()
>		elif x > perno: A2.append()
>	if len(A1) >= k:
>		return selezione(A1, k)
>	elif len(A1) == k-1:
>		return perno
>	return selezione(A2, k - len(A1) - 1)
>
>```
>calcoliamo la complessità dell’algoritmo, ricordando che:
>- ordinare 120 elementi richiede tempo $O(1)$
>- ordinare una lista di $n$ elementi in gruppi di 5 richiede tempo $\Theta(n)$ ($n \cdot O(1)$)
>- selezionare i mediani dei mediani di gruppi di 5 da una lista in cui gli elementi sono stati ordinati in gruppi da 5 richiede tempo $\Theta(n)$ (ummmmmmmmmmm)
>
>sappiamo che per $n≥120$, $A_{1} \leq \frac{3}{4}n$ e $A_{2} \leq \frac{3}{4}n$, dunque per la complessità $T(n)$ dell’algoritmo, si ha
>$$
>T(n)\leq
>\begin{cases}
>O(1)&\text{se }n\leq 120 \\
>T\left( \frac{n}{5} \right)+T\left( \frac{3}{4}n \right)+\Theta(n)&\text{altrimenti}
>\end{cases}
>$$

>[!warning] rule of thumb per equazioni di ricorrenza
notiamo che la ricorrenza è del tipo
>$$
>T(n)=T(\alpha \cdot n)+T(\beta \cdot n)+\Theta(n)
>$$
>con $\alpha + \beta = \frac{1}{5} + \frac{3}{4} = \frac{19}{20} < 1$
>mostreremo che le ricorrenze di questo tipo hanno tutte come soluzione $T(n)=\Theta(n)$

>[!info] proprietà
>se $T(n)=T(\alpha \cdot n) + T(\beta \cdot n) + cn$, con $\alpha+\beta <1$, allora $T(n) = \Theta(n)$
>>[!dimostrazione] prova (metodo dell’albero)
>il fatto che $\alpha + \beta <1$ gioca un ruolo fontamentale nella prova: consideriamo l’albero delle chiamate ricorsive generato dalla ricorrenza e analizziamone il costo per livelli:
>![[Pasted image 20250424222730.png]]
>>- al primo livello abbiamo un costo $(\alpha+\beta)\cdot n$, al secondo un costo $(\alpha+\beta)^2\cdot n$, al terzo un costo $(\alpha+\beta)^3\cdot n$ e così via
>>
>il tempo di esecuzione totale è la somma dei contributi dei vari livelli:
>>$$
>>T(n)<c\cdot n+c\cdot(\alpha+\beta)\cdot n+c\cdot(\alpha+\beta)^2\cdot n+\dots=cn\cdot \sum^\infty_{i=0}(\alpha+\beta)^i=cn \frac{1}{1-(\alpha+\beta)}=\Theta (n)
>>$$
>>
>nel calcolare la serie, abbiamo sfruttato il fatto che $\alpha+\beta<1$ e che la serie geometrica $\sum^{\infty}_{i=0}x^i$ con $x<1$ converge a $\frac{1}{1-x}$

il problema della selezione può quindi essere risolto in tempo lineare, in quanto abbiamo un algoritmo che risolve il problema in $O(n)$ **al caso pessimo**
- tuttavia, a causa delle grandi costanti moltiplicative nascoste dall’$O(n)$, nella pratica l’algoritmo randomizzato che ha tempo $O(n)$ con alta probabilità si comporta molto meglio