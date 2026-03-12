---
related to: 
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
---
>[!index]
>- [theta-notation](#theta-notation)
>- [algoritmi efficienti](#algoritmi%20efficienti)
>	- [problemi sub-esponenziali](#problemi%20sub-esponenziali)
>		- [test di primalità](#test%20di%20primalit%C3%A0)

lil ripasso
# theta-notation
$$\Theta(f(n))=\{g(n) | \exists k_{1},k_{2}, n_{0}\,\,\,t.c. \,\, k_{1}f(n)\leq g(n)\leq k_{2}f(n), \forall n \geq n_{0}\}$$
# algoritmi efficienti
un algoritmo si dice **efficiente** se la sua complessità è di ordine polinomiale nella dimensione $n$ nell’input, **ovvero** di complessità $O(n^c)$ per una qualche costante $c$

di conseguenza, un algoritmo è **inefficiente** se la sua complesssità è di ordine **superpolinomiale**:
- **esponenziale**:  è una funzione di ordine $\Theta(c^n) = 2^{\Theta(n)}$
>[!example] lil spiegazione
>$c=2^{\log_{2}c} \implies c^n=(2^{\log_{2}c})^n = 2^{n\log_{2}c}$
poichè $\log_{2}c$ è una costante, possiamo dire che $n\log_{2}c \in \Theta(n)$
e quindi $\Theta(c^n) = 2^{\Theta(n)}$
- **super-esponenziale**: è una funzione che cresce più velocemente di un esponenziale, ad esempio $2^{\Theta(n^2)}$, ma anche $2^{\Theta(n\log n)}$
- **sub-esponenziale**: è una funzione che cresce più lentamente di un esponenziale, cioè $2^{O(n)}$ (= $O(c^n)$)
	- as esempio, $n^{\Theta(\log n)}=2^{\Theta(\log^2n)}$ oppure $2^{\Theta(n^c)}$ dove $c$ è una costante inferioe ad 1.
## problemi sub-esponenziali
i problemi di cui si conoscono algoritmi sub-esponenziali e non polinomiali (quindi precisamente in mezzo), sono pochi e proprio per questo molto studiati.
- per esempio, per i problemi della fattorizzazione e dell’isomorfismo tra grafi, sono noti da tempo algoritmi superpolinomiali di complessità $2^O(n^{(1/3)})$ 
### test di primalità
l’algoritmo banale è esponenziale perchè ha complessità $O(n)$, e dato che la dimensione dell’input è $\log n$, l’algoritmo ha dimensione $O(2^{\log n})$
>[!example] spiegazione
>ogni operazione di divisione ha un costo che è proporzionale al numero di bit in $n$, che è $O(\log n)$, poichè il numero di bit di un numero $n$ è proporzionale $\log_{2}n$ 
quindi:
$$T(n)=O(n \cdot\log n)$$


un algoritmo efficiente per questo problema dovrebbe avere complessità $O(\log^c n)$ !

nella ricerca dell’eventuale divisore, fermarsi alla radice velocizza l’algoritmo ma non ne cambia la complessità asintotica che resta esponenenziale
>[!example] spiegazione
>potremmo fermarci a $\sqrt{ n }$ perchè, se consideriamo $n=ab$, se $a > \sqrt{n}\,\,\land b > \sqrt{n} \implies ab > n$, e quindi $n$ sarebbe primo

>[!example] spiegazione 2
$$ O(\sqrt{ n })=O(2^{\log \sqrt{ n }})=O(2^{\frac{1}{2}\log n})=2^{\theta(\log n)} $$

fin dagli anni 70 erano noti algoritmi sub-esponenziali, o algoritmi probabilistici (che possono sbagliare con una probabilità che si può rendere piccola a piacere), ma solo nel 2004 si è trovato un algoritmo polinomiale deterministico di tempo $O(\log^{12}n)$ che è stato poi velocizzato a $O(\log^3n)$ ,anche se con costanti moltiplicative molto alte che non lo rendono competitivo con i ben noti algoritmi probabilistici. !