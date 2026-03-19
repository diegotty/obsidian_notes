---
created: 2024-12-10
related to: "[[mutua esclusione, soluzioni hardware]]"
updated: 2025-02-20T09:38
---
`1>[!index]
>
>- [semafori deboli e forti](#semafori%20deboli%20e%20forti)
>- [mutua esclusione con i semafori](#mutua%20esclusione%20con%20i%20semafori)
# semafori
i semafori sono strutture dati, usate dai processi per scambiarsi segnali, forniti con tre operazioni definite, tutte e 3 atomiche (stavolta l’atomicità è garantita dal SO):
- `intialize`
- `decrement/semWait`: può mettere il processo in `BLOCKED` : niente CPU sprecata come con il busy-waiting
- `increment/semSignal`: può mettere un processo `BLOCKED` in `READY`
queste 3 operazioni sono syscall, quindi eseguite in kernel mode e possono agire direttamente sui processi
```c
**implementazione di semafori
struct semaphore {
	int count;
	queueType queue;
};
void semWait(semaphore s) {
	s.count--;
	if (s.count < 0) {
		/* place this process in s.queue */;
		/* block this process */
	}
}
void semSignal(semaphore s) {
	s.count++;
	if (s.count <= 0) {
		/* remove a process P from s.queue */;
		/* place process P on ready list */;
	}
}
```
la particolarità di questa implementazione è che se `count` è negativo, il suo valore assoluto è uguale al numero di processi in `queue`

```c
**implementazione di semafori binari
struct binary_semaphore {
	enum {zero, one} value;
	queueType queue;
};
void semWait(binary_semaphore s) {
	if (s.value == one)
		s.value = zero;
	else {
		/* place this process in s.queue */;
		/* block this process */;
	}
}
void semSignalB(binary_semaphore s) {
	if (s.queue is empty())
		s.value = one;
	else {
		/* remove a process P from s.queue */;
		/* place process P on ready list */;
	}
}
```
la particolarità di questa implementazione è che se `value == 1`, allora non ci sono processi in `queue`
>[!warning] rimane fondamentale che `initialize`, `semWait` e `semSignal` siano operazioni atomiche !!

>[!important] IL SEMAFORO È SOLO UNO !!! NON UNO A PROCESSO !!!!

```c
***implementazione di semafori con compare_and_swap
semWait(s){
	while(compare_and_swap(s.flag, 0, 1) == 1) /* do nothing */;
	s.count--;
	if (s.count < 0){
		/* place this process in s.queue */;
		/* block this process (must also set s.flag to 0) */;
	}
	s.flag = 0;
}

semSignal(s){
	while(compare_and_swap(s.flag, 0, 1) == 1) /* do nothing */;
	s.count++;
	if (s.count <= 0){
		/* remove a process P from s.queue */;
		/* place process P on ready list */;
	}
	s.flag = 0;
}
```

>[!example] esempio
consideriamo 3 processi A, B, C
> 1. A ha già completato la `semWait` e sta eseguendo codice in sezione critica. `s.count = 0`
> 2. B entra in `semWait`, `s.count` va a -1 e B diventa `BLOCKED`. `s.flag = 0`
> 3. tocca ad A, che esegue sezione critica e `semSignal`. `s.count = 0`. il sistema dunque sposta B che era in wait sul semaforo, da `BLOCKED` a `READY`. A completa `semSignal`. `s.flag = 0`
> 4. C entra in `semWait`, passa il `while compare_and_swap` e viene interrotto immediatamente dallo scheduler. `s.flag = 1`
> 5. B riprende l’esecuzione, imposta `s.flag = 0`, esegue la sua sezione critica e chiama `semSignal`. passa il `while compare_and_swap`. `s.flag = 1`.  imposta `s.count = 1`, termina `semSignal` ed imposta `s.flag = 0`(in questo momento, C è fermo prima di `s.count--;`, `s.count == 1` e `s.flag == 0`)
> 6. arriva un nuovo processo D, che entra in `semWait`. passa il `while`, e `s.flag = 1`
> 7. D esegue `s.count--;`. legge `s.count` da memoria e lo porta in `eax`. `eax == 1`. scheduler interrompe D ed esegue C
> 8. C continua da dov’era:’ esegue `s.count--;`quindi `s.count == 0`, quindi non va in `BLOCKED`
> 9. C viene interrotto mentre è nella sezione critica
> 10. tocca a D, che continua il calcolo di prima: salva `eax - 1` in `s.count`, che rimane 0. 
> 11. D non va in `BLOCKED`, e continua nella sezione critica
> **RACE CONDITION**

```c
***implementazione di semafori con disabilitazione di interrupts(sistema monoprocessore)
semWait(s){
	inhibit interrupts;
	s.count--;
	if (s.count < 0){
		/* place this process in s.queue */;
		/* block this process and allow interrupts */;
	}else
		allow interrupts;
}

semSignal(s){
	inhibit interrupts;
	s.count++;
	if (s.count <= 0){
		/* remove a process P from s.queue */;
		/* place process P on ready list */;
	}
	allow interrupts;
}
```

## semafori deboli e forti
quando rimuovo un processo da `s.queue`, devo sceglierne uno, usando un qualche tipo di criterio
**strong semaphore**: usa la politica FIFO
**weak semaphore**: se la politica non viene specificata
> [!warning] con i semafori forti, si può evitare la starvation, mentre con i deboli no

>[!example] esempio di strong semaphore
![[Pasted image 20241208164921.png]]
con s=1 è inteso che `s.count == 1`
in (1), A è il processo in esecuzione. viene chiamata `semWait` su A, e decrementato `s.count` e visto che `s.count-1 >= 0`, A non diventa `BLOCKED`, ma va solo in `READY`
lo stesso accade in (2), che però manda B in `BLOCKED`
in (3), viene chiamata `semSignal` (si nota come `s.count` viene incrementato), e viene mandato da `BLOCKED` a `READY`
![[Pasted image 20241208165605.png]]
in (5) viene eseguito C, e verrà chiamata `semWait`, e ciò succederà anche quando andranno in esecuzione A e B. (saltiamo quindi alcuni passaggi da (5) a (6))
in (6) vediamo che D è in esecuzione, e gli altri 3 processi sono `BLOCKED`. viene chiamata `semSignal` e viene mandato C da `BLOCKED` a `READY`( un weak semaphore avrebbe potuto sbloccare anche A o B)
## mutua esclusione con i semafori
```c
/* program mutualexclusion */
const int n = /* number of processes */;
semaphore s = 1;

void P(int i) {
	while (true) {
		semWait(s);
		/* critical section */
		semSignal(s);
		/* remainder */
	}
}

void main() {
	parbegin(P(1), P(2), ..., P(n));
}
```
se 2 processi sono eseguiti concorrentemente (P1, P2), dato che `semWait` è un’operazione atomica, solo uno dei due la eseguirà, nella usa interezza, per primo (in questo caso, per esempio P1). P1 non verrà messo in `BLOCKED`, mentre P2, quando eseguirà `semWait`, si (`s.count`diventerà -1), e in questo modo non c’è busy-waiting !!! (pazzesco ngl). inoltre, quando P1 avrà finito la sua sezione critica, chiamerà `semSignal`, che riporterà P2 da `BLOCKED` a `READY`, e quando P2 verrà eseguito finirà la chiamata `semWait`, e farà la sua sezione critica.
- con 2 processi, la starvation è evitata anche usando weak semaphores, mentre con 3+ processi la starvation è sicuramente evitata solo usando strong semaphores, in quanto un weak semaphore potrebbe scegliere sempre uno tra i processi da mandare sempre da `BLOCKED` a `READY`, mandandone in starvation almeno un altro
>[!warning] è fondamentale che il semaforo sia inzializzato con count = 1 !!!

>[!figure] rappresentazione grafica di un esempio
![[Pasted image 20241208171636.png]]
