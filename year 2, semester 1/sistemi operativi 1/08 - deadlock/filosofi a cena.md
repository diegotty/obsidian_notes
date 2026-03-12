---
created: 2024-12-22
related to: "[[gestione del deadlock]]"
updated: 2024-12-22T13:54
---

>[!index]
>
>- [prima soluzione](#prima%20soluzione)
>- [seconda soluzione](#seconda%20soluzione)
>- [terza soluzione](#terza%20soluzione)
>- [quarta soluzione](#quarta%20soluzione)
>- [quinta soluzione](#quinta%20soluzione)
# filosofi a cena
>[!info] rappresentazione del problema dei filosofi
![[Pasted image 20241217162733.png]]
>- $n$ forchette, $n$ sedie, $n$ filosofi 
>- ogni filosofo, per mangiare, ha bisogno di 2 forchette
il problema è far mangiare il numero di filosofi più alto senza che ci sia deadlock
## prima soluzione
```c
semaphore fork[5] = {1};

void philosopher(int i) {
	while(true) {
		think();
		wait(fork[i]);
		wait(fork[(i+1)%5]);
		eat();
		signal(fork[(i+1)%5]);
		signal(fork[i]);
	}
}

void main() {
	parbegin(philosopher[0], philosopher[1], philosopher[2], philosopher[3], philosopher[4])
}
```
questa soluzione ammette deadlock: se tutti i filosofi arrivano alla rispettiva `wait(fork[i])`, tutti ottengono una forchetta e nessuno riesce a mangiare
## seconda soluzione
```c
semaphore fork[5] = {1};
semaphore room = {4}

void philosopher(int i) {
	while(true) {
		think();
		wait(room)
		wait(fork[i]);
		wait(fork[(i+1)%5]);
		eat();
		signal(fork[(i+1)%5]);
		signal(fork[i]);
		signal(room)
	}
}

void main() {
	parbegin(philosopher[0], philosopher[1], philosopher[2], philosopher[3], philosopher[4])
}
```
penso al fatto che il problema è che tutti i filosofi vogliono mangiare contemporaneamente: creo un semaforo che inizializzo a 4.
- cambiamo un po i parametri del problema (nel problema tradizionale, i filosofi rimangono sempre seduti sulle sedie)
## terza soluzione
```c
semaphore fork[N] = {1, 1, ..., 1};

philosopher(int me) {
	int left, right, first, second;
	left = me;
	right = (me+1)%N;
	first = right < left ? right : left;
	second = right < left ? left : right;
	
	while(true) {
		think();
		wait(fork[first]);
		wait(fork[second]);
		eat();
		signal(fork[first]);
		signal(fork[second]);
	}
}
```
mentre nella prima soluzione si prende sempre prima la forchetta di sinistra e poi la forchetta di destra, in questo caso $P_{n-1}$ prende prima la forchetta di destra e poi quella di sinistra 
- con questa soluzione, anche se tutti i filosofi arrivano ai rispettivi `wait(fork[first])`, il filosofo $n-1$ chiederà `fork[0]`, che è già occupata, e quindi il filosofo $n-2$ potrà mangiare 
## quarta soluzione
```c
mailbox fork[N];

init_forks() {
	int i;
	for(i=0; i<N; i++) {
		nbsend(fork[i], "fork");
	}
}

philosopher(int me) {
	int left, right;
	message fork1, fork2;
	left = me;
	right = (me+1)%N;
	first = right < left ? right : left;
	second = right < left ? left : right;
	
	while(true) {
		think_for_a_while();
		receive(fork[first], fork1);
		receive(fork[second], fork2);
		eat();
		nbsend(fork[first], fork1);
		nbsend(fork[second], fork2)
	}
}
```
come soluzione 3 ma con mailbox
## quinta soluzione
```c
philosopher(int me) {
	int left, right;
	message fork1, fork2;
	left = me;
	right = (me+1)%N;
	
	while(true) {
		think_for_a_random_time();
		if(nbreceive(fork[left], fork1)) {
			if(nbreceive(fork[right], fork2)) {
				eat();
				nbsend(fork[right], fork1);
			}
			nbsend(fork[left], fork2)
		}
	}
}
```
con i messaggi ho la possibilità di usare `nbreceive`, quindi di fare una richiesta non bloccante (non possibile con i semafori: `wait` è bloccante)
non c’è deadlock, ma ci possono essere:
- livelock(tutti i filosofi prendono la rispettiva forchetta sinistra, nessuno riesce a prendere la destra. quindi tutti rilasciano la sinistra,e si ricomincia da capo)
	-se `think_for_a_random_time()` è veramente random, è difficile che ciò accada
- starvation(alcuni filosofi non riescono mai a mangiare)