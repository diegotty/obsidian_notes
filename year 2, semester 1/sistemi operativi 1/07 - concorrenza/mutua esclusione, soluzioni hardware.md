---
created: 2024-12-09
related to: "[[intro alla concorrenza]]"
updated: 2024-12-10T08:15
---
>[!index]
>
>- [istruzioni macchina speciali](#istruzioni%20macchina%20speciali)
>	- [`compare_and_swap`](#%60compare_and_swap%60)
>		- [mutua esclusione con `compare_and_swap`](#mutua%20esclusione%20con%20%60compare_and_swap%60)
>	- [`exchange`](#%60exchange%60)
>		- [mutua esclusione con `exchange`](#mutua%20esclusione%20con%20%60exchange%60)
>	- [vantaggi e svantaggi](#vantaggi%20e%20svantaggi)
# istruzioni macchina speciali
entrambe le seguenti istruzioni sono **atomiche**
- l’hardware garantisce che un solo processo per volta possa eseguire una chiamata a tali istruzioni(/funzioni)
- anche se ci sono più processori ! (thank you hardware, very cool)
## `compare_and_swap`
```c
int compare_and_swap(int word, int testval, int newval){
	int oldval;
	oldval = word;
	if (word == testval) word = newval;
	return oldval;
}
```
### mutua esclusione con `compare_and_swap`
```c
/* program mutualexclusion */
const int n = /* number of processes */
int bolt;
void P(int i) {
	while (true) {
		while (compare_and_swap(bolt, 0, 1) == 1) /* do nothing */
		/* critical section */
		bolt = 0;
		/* remainder */
	}
}

void main() {
	bolt = 0;
	parbegin(P(1), P(2), ..., P(n));
}
```
ciò funziona perchè:
- in `while (compare_and_swap(bolt, 0, 1) == 1)`, se `bolt == 0`, viene modificato in 1 (ricordiamo che `compare_and_swap` è atomica !!!) e viene ritornato il valore 0 da `compare_and_swap`. quindi si esce dal while, e il processo entra nella sezione critica
- se un altro processo esegue `p`, ci sarà `bolt == 1`, e quindi il processo rimarrà nel while, e uscirà solo quando il processo nella sezione critica eseguirà `bolt = 0;`
è fondamentale che `compare_e_swap` sia atomica !!
## `exchange`
```c
void exchange (int register, int memory){
	int temp;
	temp = memory;
	memory = register;
	register = temp;
}
```
### mutua esclusione con `exchange`
```c
/* program mutualexclusion */
const int n = /* number of processes */
int bolt;
void P(int i) {
	while (true) {
		int keyi = 1;
		do exchange(keyi, bolt)
		while (keyi != 0); /* do nothing */
		/* critical section */
		bolt = 0;
		/* remainder */
	}
}

void main() {
	bolt = 0;
	parbegin(P(1), P(2), ..., P(n));
}
```
in questo caso, `keyi` è una variabile locale (ne esiste una per ogni processo)
funziona in modo molto simile alla mutua esclusione con `compare_and_swap`, in questo caso lo swap avviene direttamente e ogni volta
## vantaggi e svantaggi
vantaggi:
- applicabili a qualsiasi numero di processi, sia su un sistema ad un solo processore che multiprocessore con memoria condivisa
- semplici, e quindi facili da verificare
- possono essere usate per gestire sezioni critiche multiple
svantaggi:
 - queste soluzioni sono basate sul **busy-waiting**, cioè eseguono un ciclo all’infinito finchè non hanno il via libera per andare avanti, e in pratica stanno solamente aspettando. il problema è che un ciclo di busy wait non è distinguibile da codice “normale”, cioè codice che effettivamente fa qualcosa di utile. la CPU deve quindi eseguire il processo in busy-wait fino al timeout, anche se, se fosse possibile, non dovrebbe nemmeno essere considerato come eseguibile (invece è `READY` se non `RUNNING`). ciò porta a uno spreco di tempo computazionale
 - possibile la starvation ( se va male, un processo riesce a entrare nella sezione critica, uscire, e ri-entrarci, e quando viene eseguito un altro processo, si trova fermo ad aspettare) (più probabile con tanti processi)
 - possibile il deadlock, se a questi meccanismi viene abbinata la priorità fissa (ormai non usata)