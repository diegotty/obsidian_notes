---
related to: 
created: 2025-03-02T17:41
updated: 2025-06-19T19:04
completed: false
---
>[!example]+ problema
progettare un algoritmo che prende come parametro un intero $n$ e **stampa** tutte le stringhe binarie lunghe $n$
>>[!info] soluzione
>notiamo che le stringhe da stampare sono $2^n$, e che stampare una stringha lunga $n$ costa $\Theta(n)$ (se immaginiamo la stringa come una lista a cui aggiungere)
>quindi, per l’algoritmo che risolve questo problema, abbiamo $\Omega(n\cdot 2^n)$
>implementando una soluzione naive:
>>```python
>>def bin_stings(n, sol = []):
>>	if len(sol) == n:
>>		print(sol)
>>		return
>>	sol.append(1)
>>	bin_strings(n, sol)	
>>	sol.pop()
>>	sol.append(0)
>>	bin_strings(n, sol)
>>	sol.pop()
>>```
>>questa soluzione genera un albero di chiamate ricorsive alto $n$. l’albero ha quindi 
>>$$
>\sum_{i=0}^h = 2^i=2^{h+1}-1
>>$$
>nodi, che 
>ogni nodo esegue operazioni di costo $O(1)$, ma:
>>- ogni nodo interno richiede (effettivamente) tempo $O(1)$
>>- ciascuna foglia richiede tempo $O(n)$, in quanto deve stampare la stringa
>>dato che esistono $2^n$ nodi foglia, la complessità dell’algoritmo è 
>>$$
>>O(2^n) \cdot n + n \cdot O(1))= O(2^n\cdot n)+O(n)=O(2^n\cdot n)
>>$$

>[!example]+ problema (vincolo sugli zeri)
progettare un algoritmo che prende come parametro due interi $n$ e $k$, con $0\leq k\leq n$, e stampa tutte le stringhe binarie lunghe $n$ che contengono al più $k$ `1`
>>[!info] soluzione
>>è facile modificare la soluzione di sopra per ottenere una soluzione in $Theta(2^n \cdot n)$ (basta aggiungere una condizione che controlla il numero di `1`)
>un buon algoritmo, però, dovrebbe avere una complessità proporzionale alle stringhe da stampare, vale a dire $O(\text{(stringhe da stampare)}\cdot n)$
>si calcola che le stringhe da stampare sono 
>>$$
>\sum_{i=0}^k \binom{n}{i} \approx n^{k}
>>$$
>>introduciamo allora una **funzione di taglio**, che ci permette di **non** esplorare i rami degli alberi le cui fogli non ci interessano ! in modo da ottenere (per esempio) questo tipo di alberi
>>![[Pasted image 20250515120442.png]]
>>in questo caso, ci basta controllare il numero di `1` presenti nella stringa a mano a mano che aggiungiamo le cifre, in modo tale di evitare di non sprecare tempo in chiamate inutili
>>```python
>>def bin_string1(k,n, sol = []):
>>	if len(sol) == n:
>>		print(sol)
>>	if(k > 0):
>>		sol.append(1)
>>		bin_string(k-1, n, sol)
>>		sol.pop()
>>	sol.append(0)
>>	bin_string(k, n, sol)
>>	sol.pop()
>>```
>>testando i tempi di calcolo delle due funzioni, essi sono molto diversi: la soluzione naive impiega 18,1s, mentre `bin_string1()` impiega 0,002s. truly impressive !
>>la complessità dell’algoritmo è:
>>$$
>>n^{k} \cdot O(n) + n^{k+1}\cdot O(1) = O(n^{k+1}) + O(n^{k+1}) = O(n^{k+1})
>>$$

>[!warning] un modo semplice per calcolare il tempo dei propri **progammini** :)
usare la libreria `time` di pythons
## backtracking
si consideri un algoritmo di enumerazione basato sul **backtracking** dove l’albero di ricorsione ha altezza $h$, il costo di una foglia è $g(n)$ e il costo di un nodo interno è $f(n)$. se l’algoritmo gode della seguente proprietà:
$$
\text{un nodo viene generato solo se ha la possibilità di portare ad una foglia da stampare}
$$
allora la complessità dell’algoritmo è proporzionale al numero di cose da stampare $S(n)$. più precisamente, la complessità dell’algoritmo è:
$$
O(S(n)\cdot g(n) + S(n)\cdot h\cdot f(n))
$$
in quanto i nodi dell’albero che verranno effetivamente generati saranno $O(S(n)\cdot h)$, in quanto ogni nodo generato apparterrà ad un cammino che parte dalla radice e arriva ad una delle $S(n)$ foglie da enumerare (e worst case ogni foglia ha un cammino con tutti nodi diversi)
>[!example]+ problema (esame settembre 2020)
progettare un algoritmo che, dato un intero $n$, stampi tutte le stringhe di lunghezza $n$ sull’alfabeto dei simboli $\{a,b,c\}$ in cui il numero delle $b$ supera quello di ciascuno degli altri due simboli
>>[!info]- soluzione
>l’algoritmo deve avere complessità proporzionale alle stringhe da stampare
>risolviamo l’esercizio allo stesso modo dell’ultimo esercizio precedente, ma teniamo traccia di 2 cose: il numero di $a$ e il numero di $c$ (in questo modo ci possiamo ricavare il numero di $b$). quindi rispettivamente `n_a` e `n_c`
>>
>>utilizziamo quindi una semplice funzione di taglio in cui:
>>- **inseriamo il simbolo $b$**: sempre, in quanto può sempre essere inserito
>>- **inseriamo il simbolo $a$**: solo se `n_a + 1 < n - (n_c + n_a + 1) && n_c < n - (n_c + n_a + 1)` 
>>- **inseriamo il simbolo $c$**:  solo se `n_c + 1 < n - (n_a + n_c + 1) && n_a < n - (n_c + n_a + 1)`
>>```python
>>def abc(n, n_a = 0, n_c = 0, sol = []):
>>	if len(sol) == n:
>>		print(sol)
>>		return
>>	sol.append(b)
>>	abc(n, n_a, n_c, sol)
>>	sol.pop()
>>	if n_a + 1 < n - (n_c + n_a + 1) and n_c < n - (n_c + n_a + 1):
>>		sol.append(a)
>>		abc(n, n_a + 1, n_c, sol)
>>		sol.pop()
>>	if n_c + 1 < n - (n_a + n_c + 1) and n_a < n - (n_a + n_c + 1):
>>		sol.append(c)
>>		abc(n, n_a, n_c + 1, sol)
>>		sol.pop()
>>```
>>l’albero prototto da questo algoritmo gode della proprietà che **un nodo viene generato solo se porta ad una foglia da stampare**, quindi la sua complessità è 
>>$$
O(D(n)\cdot h\cdot f(n) + D(n) \cdot g(n))
>>$$
>con
>>- $D(n)$ è il numero di stringhe da stampare
>>- $h = n$
>>- $f(n) = O(1)$
>>- $g(n) = O(n)$
>>quindi il costo di `abc()`  è $\Theta (n\cdot D(n))$


>[!example]+ problema
progettare un algoritmo che prende come parametro un intero $n$ e stampa tutte le matrici binarie $n \times n$
>>[!info]- soluzione
>sappiamo che le matrici da stampare sono $2^{n \cdot n}$ (basti pensare alla matrici come stringhe di dimensione $n \cdot n$)
>>l’albero di ricorsione è binario e di altezza $n^2$ (un livello per ogni elemento della matrice), e ha $2^{n^2}-1$ nodi interni e $2^{n^2}$ foglie foglie (per un totale di $2^{n^2+1}-1$ nodi)
>> - ciascun nodo interno richiede tempo $O(1)$
>> - ciascuna foglia richiede tempo $O(n^2)$
>>```python
>>def all_matrixes():
>>	sol = [[0]*n for _ in range(n)]
>>	es1(n, sol)
>>
>>def es1(n, sol, i = 0, j = 0):
>>	if i == n: # non n-1 !!!!!!
>>		for k in range(n):
>>			print(sol[k])
>>		print()
>>		return
>>	sol[i][j] = 0
>>	i1, j1 = i, j+1
>>	if j1 == n:
>>		i1, j1 = i+1, 0
>>	es1(n, sol, i1, j1)
>>	sol[i][j] = 1
>>	es1(n, sol, i1, j1)
>>```
>>l’algoritmo gode della proprietà per cui **ogni nodo viene generato se porta ad una matrice da stampare**,quindi la complessità dell’algoritmo è
>>$$
>>O(D(n)\cdot g(n)+ D(n)\cdot h\cdot f(n))
>>$$
>in cui 
>> - $D(n) = 2^{n^2}$
>> - $g(n)= O(n^2)$
>> - $h = n^2$
>> - $f(n) = O(1)$
>>
>quindi $O(2{n^2}\cdot n^2) + O(2^{n^2})$
>dato che qualunque algoritmo ha $\Omega(2^{n^2}\cdot n^2)$, l’algoritmo è ottimo

>[!warning] numero di nodi
ricordiamo, che, in un albero binario completo di altezza $n$:
>- il numero totale di nodi è $2^{n+1}-1$
>- il numero di nodi interni è $2^{n}-1$
>- il numero di foglie è $2^{n}$
>
(e un albero con solo la radice ha altezza 0)
>


>[!example]+ problema
progettare un algoritmo che prende un intero $n$ e stampa tutte le matrici binarie di dimensioni $n\times n$, in cui le righe e le colonne risultano ordinate in modo non-decrescente
la complessità dell’algoritmo deve essere $O(n^2S(n))$ dove $S(n)$ è il numero di matrici da stampare
>>[!info]- soluzione
>>- **inserisco un `1`**: sempre, in quanto posso sempre inserire un `1`
>>- **inserisco un `0`**: posso inserire uno `0` nella cella `sol[i][j]` solo se sol`[i][j-1] == sol[i-1][j] == 0` (con `i > 0, j > 0`)
>>```python
>>def es(n):
>>	sol = [[0]*n for _ in range(n)]
>>	matrici_ordinate(n, 0, 0, sol)
>>
>>def matrici_ordinate(n, i, j, sol):
>>	if i == n:
>>		for i in range(n):
>>			print(sol[i])
>>		print()
>>		return
>>	sol[i][j] = 1
>>	i1, j1 = i, j+1
>>	if j1 == n:
>>		i1, j1 = i+1, 0
>>	matrici_ordinate(n, i1, j1, sol)
>>	
>>	if (j == 0 or sol[i][j-1] == 0) and (i == 0 or sol[i-1][j] == 0):
>>		sol[i][j] = 0
>>		matrici_ordinate(n, i1, j1, sol)
>>```
>>l’algoritmo gode della proprietà per cui **ogni nodo viene generato se porta ad una matrice da stampare**,quindi la complessità dell’algoritmo è
>>$$
>>O(D(n)\cdot g(n)+ D(n)\cdot h\cdot f(n))
>>$$
>in cui 
>> - $D(n) = O(2^{n^2})$
>> - $g(n)= O(n^2)$
>> - $h = n^2$
>> - $f(n) = O(1)$
>>
>quindi $O(2{n^2}\cdot n^2) + O(2^{n^2})$
>dato che qualunque algoritmo ha $\Omega(2^{n^2}\cdot n^2)$, l’algoritmo è ottimo

>[!example]+ problema: permutazioni
progettare un algoritmo che prende come parametro l’intero $n$ e stampa tutte le permutazioni dei numeri da `0` da `n-1`
>>[!info]- soluzione
>le permutazioni di $n$ interi diversi è $n!$
>>- le foglie sono $\Theta(n!)$
>>- i nodi interni sono 
>>$$
>1 + n + n(n-1) + n(n-1)(n-2)+ \dots + n! = \frac{n!}{n!} + \frac{n!}{n-1!} + \frac{n!}{n-2!} + \dots $\frac{n!}{0!}$
>>$$
>quindi 
>>$$
>\sum_{i=0}^n \frac{n!}{i!} < n! \cdot\sum_{i=0}^\infty \frac{1}{i!}< n! \cdot \sum_{i=0}^\infty \frac{2}{2^i} = n! \frac{2}{1-\frac{1}{2}} = 4 \cdot n!
>>$$
>quindi i nodi interni sono $\Theta(n!)$
>>
>ngl tosto arrivare a $4\cdot n!$…. . abbiamo usato che :
>>- $i! \geq \frac{2^i}{2} \to \frac{1}{i!} \leq \frac{2}{2^i}$
>>- $\sum^\infty_{i=0}x^i=1-x \text{ \,\,\,\,\,\,\,\,per }x <-1$
>>```python
>>def es(n):
>>	preso = [0]*n
>>	permutazioni(n, preso)
>>	
>>def permutazioni(n, preso, sol = []):
>>	if len(sol) == n:
>>		print(sol)
>>		return
>>	for i in range(n):
>>		if preso[i] == 0:
>>			sol.append(i)
>>			preso[i] = 1
>>			permutazioni(n, sol, preso)
>>			sol.pop(i)
>>			preso[i] = 0
>>```
>>l’algoritmo gode della proprietà per cui **ogni nodo viene generato se porta ad una matrice da stampare**,quindi la complessità dell’algoritmo è
>>$$
>>O(D(n)\cdot g(n)+ D(n)\cdot h\cdot f(n))
>>$$
>in cui 
>> - $D(n) = \Theta(n!)$
>> - $g(n)= O(n)$
>> - $h = n$
>> - $f(n) = O(n)$
>>
quindi l’algoritmo ha complessità $O(n\cdot n!) + O(n!\cdot n) = \Theta(n!\cdot n)$
e dato che l’algorimo ha $\Omega(n\cdot n!)$, l’algoritmo è ottimo

>[!example] problema
progettare un algoritmo che prende come parametro l’intero $n$ e stampa tutte le permutazioni dei numeri da `0` a `n-1` dove nelle posizioni pari compaiono numeri pari e nelle posizioni dispari compaiono numeri dispari
la complessità dell’algoritmo deve essere $O(S(n) \cdot n^2)$, dove $S(n)$ è il numero di permutazioni da stampare

>[!info] soluzione
```python
def es(n):
	preso = [0]*n
	permutazioni(n, preso)

def permutazioni(n, preso, sol = []):
	if len(sol) == n:
		print(sol)
		return 
	for i in range(n):
		if i % 2 == len(sol) % 2 and preso[i] == 0: 
			sol.append(i)
			preso[i] = 1
			permutazioni(n, preso, sol)
			sol.pop()
			preso[i] = 0
```
>>l’algoritmo gode della proprietà per cui **ogni nodo viene generato se porta ad una matrice da stampare**,quindi la complessità dell’algoritmo è
>>$$
>>O(D(n)\cdot g(n)+ D(n)\cdot h\cdot f(n))
>>$$
>in cui 
>> - $D(n) = \Theta(n!)$
>> - $g(n)= O(n)$
>> - $h = n$
>> - $f(n) = O(n)$
>>
quindi l’algoritmo ha complessità $O(S(n) \cdot n) + O(S(n) \cdot n \cdot n) = O(S(n)\cdot n^2)$

>[!example] problema
progettare un algoritmo che prende come parametro un intero $n$ e stampa tutte le matrici binarie $n \times n$ in cui non compaiono `1` adiacenti (in orizzontale, verticale o diagonale)
la complessità dell’algoritmo deve essere $O(n^2S(n))$, dove $S(n)$ è il numero di matrici da stampare