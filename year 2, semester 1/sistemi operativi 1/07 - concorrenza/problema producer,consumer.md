---
created: 2024-12-10
related to: "[[semafori]]"
updated: 2024-12-10T08:14
---
>[!index]
>
>- [problemi tra processi in cooperazione](#problemi%20tra%20processi%20in%20cooperazione)
>	- [problema del produttore/consumatore](#problema%20del%20produttore/consumatore)
>		- [esempio1](#esempio1)
>			- [implementazione, soluzione sbagliata](#implementazione,%20soluzione%20sbagliata)
>			- [implementazione, soluzione corretta](#implementazione,%20soluzione%20corretta)
>		- [soluzione con semafori generali](#soluzione%20con%20semafori%20generali)
>	- [producer/consumer con buffer circolare](#producer/consumer%20con%20buffer%20circolare)
>		- [implementazione con semafori](#implementazione%20con%20semafori)
>
# problemi tra processi in cooperazione
## problema del produttore/consumatore
situazione generale:
- uno o più processi (produttori) creano dati e li mettono in un buffer
- un consumatore prende dati dal buffer, uno alla volta
- al buffer può accedere solo un processo, sia esso produttore o consumatore
il problema:
- assicurare che i produttori non inseriscano dati quando il buffer è pieno (bloccando i produttori nell’eventualità)
- assicurare che il consumatore non prenda dati quando il buffer è vuoto (bloccando il consumatore nell’eventualità )
- mutua esclusione sull’intero buffer (che diamo per scontato, in quando sarebbe possibile permettere a consumatori e produttori di agire anche in contemporanea)
### esempio1
facciamo finta che il buffer sia infinito: il produttore non ha mai motivo di fermarsi
in questo esempio, `b` è il buffer.
```c
**implementazione produttore
while (true) {
	/* produce item v */
	b[in] = v;
	in++;
}
```

```c
**implementazione consumatore
while (true) {
	while (in <= out) /* do nothing */;
	w = b[out];
	out++;
	/* consume item w */
}
```

non c’è nessun problema se, contemporaneamente, il produttore produce e il consumatore consuma (magari su processori diversi, in un sistema multiprocessore)

>[!figure] rappresentazione buffer
![[Pasted image 20241208172941.png|350]]

#### implementazione, soluzione sbagliata
```c
**implementazione produttore/consumatore, !!SOLUZIONE SBAGLIATA!!
int n; // numero elementi buffer
binary_semaphore s = 1, delay = 0;

void producer() {
	while (true) {
		produce();
		semWaitB(s);
		append();
		n++;
		if(n == 1) semSignalB(delay);
		semSignalB(s);
	}
}

void consumer() {
	semWaitB(delay);
	while (true) {
		semWaitB(s);
		take();
		n--;
		semSignalB(s);
		consume();
		if(n == 0) semWaitB(delay);
	}
}

void main() {
	n = 0;
	parbegin(producer, consumer);
}
```
`s` garantisce la mutua esclusione sul buffer, uso `delay` per garantire che il consumer non legga mai il buffer vuoto
>[!example] esempio di errore della soluzione sopra
![[Pasted image 20241208174228.png]]
come si può vedere, in questa situazione particolare (in cui il consumer viene eseguito per abbastanza tempo da leggere 2 volte di fila il buffer) il consumer finisce a leggere il buffer vuoto
>- questo perchè n ha modificato delay in un momento particolare (e ha mandato a fanculo tutto)
#### implementazione, soluzione corretta
in questa implementazione, uso `m` per salvare `n` che devo veramente considerare (per evitare che il producer modifichi `n` ma il consumer si stia ad un iterazione del while precedente )
```c
**implementazione producer/consumer, !!SOLUZIONE CORRETTA!!
int n; // numero elemnti buffer
binary_semaphore s = 1, delay = 0;

void producer() {
	while (true) {
		produce();
		semWaitB(s);
		append();
		n++;
		if(n == 1) semSignalB(delay);
		semSignalB(s);
	}
}

void consumer() {
	int m; /* a local variable */
	semWaitB(delay);
	while (true) {
		semWaitB(s);
		take();
		n--;
		m = n;
		semSignalB(s);
		consume();
		if(m == 0) semWaitB(delay);
	}
}

void main() {
	n = 0;
	parbegin(producer, consumer);
}
```
è possibile dimostrare matematicamente che la soluzione è corretta (nerd)
### soluzione con semafori generali
nella soluzione precedente sono stati usati i semafori binari. tutto ciò che può essere fatto con i semafori binari può essere implementato con i semafori generali, **e viceversa**
```c
**implementazione producer/consumer
semaphore n = 0, s = 1;

void producer() {
	while (true) {
		produce();
		semWait(s);
		append();
		semSignal(s);
		semSignal(n);
	}
}

void consumer() {
	while (true) {
		semWait(n);
		semWait(s);
		take();
		semSignalB(s);
		consume();
	}
}

void main() {
	parbegin(producer, consumer);
}
```
## producer/consumer con buffer circolare
in questo caso, con `in == out`, il buffer potrebbe essere sia pieno che vuoto (nell’esempio precedente, il buffer era sicuramente vuoto)
per gestire ciò, forziamo la dimensione effettiva del buffer a n-1 invece che n (altrimenti, non si potrebbe capire se `in == out` implichi buffer pieno o vuoto)
>[!figure] rappresentazione buffer circolare
![[Pasted image 20241208181135.png]]

```c
**implementazione producer
while (true) {
	/* produce item v */
	while ((in+1)%n == out) /* do nothing*/;
	b[in] = v;
	in = (in+1)%n;
}
```

```c
**implementazione consumer
while (true) {
	while (in == out) /* do nothing*/;
	w = b[out];
	out = (out+1)%n;
	/* consume item w */
}
```
>[!info] differenze a livello di codice
>- l’incremento non è semplice, avviene un operazione di modulo per gestire la natura circolare del buffer
>- se `(in+1)%n == out`, il buffer è pieno
>- se `in == out`, il buffer è vuoto
### implementazione con semafori
```c
/* program boundedbuffer */
const int sizeofbuffer = /* buffer size */;
semaphore n = 0, s = 1, e = sizeofbuffer;

void producer() {
	while (true) {
		produce();
		semWait(e); // viene decrementato ogni volta finché non si arriva
		semWait(s); // fino a 0 quando il buffer è pieno
		append();
		semSignal(s);
		semSignal(n);
	}
}

void consumer() {
	while (true) {
		semWait(n);
		semWait(s);
		take();
		semSignalB(s);
		semSignalB(e); // viene incrementato e "sveglia" il produttore
		consume();
	}
}

void main() {
	parbegin(producer, consumer);
}
```
i understand this but what the fuck man 