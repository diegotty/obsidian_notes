---
created: 2024-12-18
related to: 
updated: 2025-02-20T09:38
---
>[!index]
>
>- [stack smashing](#stack%20smashing)
>- [esecuzione codice arbitrario](#esecuzione%20codice%20arbitrario)
>- [shellcode](#shellcode)
>	- [esempio](#esempio)
>- [return-to-libc](#return-to-libc)
>- [contromisure](#contromisure)
>- [difese a tempo di compilazione](#difese%20a%20tempo%20di%20compilazione)
>- [difese a tempo di esecuzione](#difese%20a%20tempo%20di%20esecuzione)

l’area di memoria di un processo caricato in memoria (principale) è diviso nelle sezioni seguenti:
>[!figure] area di memoria di un processo
![[Pasted image 20241218131014.png]]

lo stack è costituito da stack frames, e ciascun frame contiene:
- parametri passati alla funzione
- variabili locali
- indirizzo di ritorno
- instruction pointer
esistono poi lo stack pointer, che punta all’inizio dello stack, e il frame pointer, che punta alla base del frame corrente

in particolare, la chiamata di funzione prosegue in questo modo:
- se ci sono parametri passati alla funzione, sono aggiunti allo stack
- l’indirizzo di ritorno (return address) è aggiunto allo stack
- il puntatore allo stack frame viene salvato sullo stack
- viene allocato spazio ulteriore sullo stack per le variabili locali della funzione chiamata
>[!example] esempio di stack
vediamo uno stack di 2 funzioni: G (funzione corrente) viene chiamata da F
![[Pasted image 20241218132032.png]]

```c
void foo(char *s) {
	char buf[10];
	strcpy(buf, s);
	printf("buf is %s\n", s);
}

foo("stringatroppolungaperbuf");
```
in questo caso, mandiamo come parametro una stringa troppo lunga, che non entra in `buf[10]`. ma il computer non sa la dimensione di `buf`, in quanto vede solo indirizzi di memoria, quindi continua a copiare la stringa negli indirizzi successivi a quelli allocati per `buf`, andando a sovrascrivere qualsiasi cosa trovi, fino a che non completa l’operazione richiesta
>[!example] esempio di evoluzione stack
>ottieniamo quindi questa situazione (tra parentesi troviamo i valori delle aree di memoria dopo `strcpy`)
![[Pasted image 20241218132436.png]]
>
>in realtà, un indirizzo conterrà più lettere, in base alla dimensione delle parole di memoria. ottieniamo quindi una situazione di questo tipo:
![[Pasted image 20241218132617.png]]

## stack smashing
di solito, fare overflow di un buffer in questo modo porta alla terminazione del programma (segmentation fault)
tuttavia, se i dati che sono usati nell’overflow del buffer sono preparati in modo accurato, è possibile eseguire del codice arbitrario:
```c
void foo(char *s) {
	char buf[10];
	strcpy(buf, s);
	printf("buf is %s\n", s);
}

foo("stringatroppolun\xda\x51\x55\x55\x55\x55\x00\x00");
```

con questo codice, possiamo sovrascrivere l’indirizzo di ritorno a piacere:
>[!figure] rappresentazione
![[Pasted image 20241221103308.png]]
# esecuzione codice arbitrario
modificare l’indirizzo di ritorno arbitrariamente è utile, ma come eseguiamo il codice arbitrario ?
1. shellcode
2. return-to-libc
3. stack frame replacement (solo nominato)
4. return-oriented programming (solo nominato)
## shellcode
lo shellcode è un piccolo pezzo di codice che viene eseguito quando si sfrutta una vulnerabilità (es: buffer overflow) per attaccare un sistema
- il pezzo di codice è piccolo perchè deve rientrare nelle dimensioni del buffer
- è chiamato shellcode perchè solitamente avvia una command shell, dalla quale l’attaccante può prender controllo della macchina
>[!warning] l’idea è inserire codice eseguibile arbitrario nel buffer, e camabiare il return address con l’indirizzo del buffer !

### esempio
assumendo che l’indirizzo di `buf` sia `0x00005555555551da`, possiamo effettuare così l’attacco:
```c
void foo(char *s) {
	char buf[10];
	strcpy(buf, s);
	printf("buf is %s\n", s);
}

foo("<shellcode>\xda\x51\x55\x55\x55\x55\x00\x00");
```

così una volta completata la chiamata a `foo()`, il processore salterà all’indirizzo `0x00005555555551da` ed eseguirà il codice che trova (lo shellcode)
>[!figure] rappresentazione
![[Pasted image 20241221103902.png]]
## return-to-libc
non è sempre possibile inserire shellcode arbitrario (buffer piccoli, o meccanismi di difesa possono impedirlo). tuttavia, esiste del codice utile ad attacchi, che è sempre presente in RAM ed è sempre raggiungibile dal nostro processo: le librerie dinamiche e di sistema
- invece di usare shellcode, possiamo quindi usare come indirizzo di ritorno l’indirizzo di una funzione di sistema utile per un attacco (es: system)
- l’attacco è chiamato return-to-libc perchè modifica l’indirizzo di ritorno solitamente con l’indirizzo di una funzione standard della libreria C

asumendo di conoscere l’indirizzo di `system()`, possiamo effettuare così l’attacco:
```c
void foo(char *s) {
	char buf[10];
	strcpy(buf, s);
	printf("buf is %s\n", s);
}

foo("AAAAAAAAAAAAAAAA<indirizzo di system>AAAA’bin/sh'");
```

completata la chiamata a `foo()`, il processore salterà all’indirizzo di `system()` e ne eseguirà il codice usando come parametro `bin/sh`
>[!figure] rappresentazione
![[Pasted image 20241221104636.png]]
# contromisure
esistono 2 tipi di contromisure:
## difese a tempo di compilazione
- uso di linguaggi di programmazione e funzioni sicure (l’overflow è possibile perchè in C ci sono alcune funzioni che spostano dati senza limiti di dimensione)
- stack smashing protection
	- il compilatore inserisce del codice per generare un valore casuale (**canary**) a runtime
	- il valore canary viene inserito tra il frame pointer e l’indirizzo di ritorno, se il valore canary viene modificato prima che la funzione ritorni, l’esecuzione va interrotta perchè è stato sovrascritto da un possibile attacco
## difese a tempo di esecuzione
- executable space protection
	- stack e heap generalmente non contegono codice eseguibile (che si trova nella sezione .text), quindi il SO marca le pagine/segmenti dello stack e heap come non eseguibili, e se un attaccante cerca di eseguire codice nello stack (shellcode), il sistema terminerà il processo con un errore (in questo caso return-to-libc funziona ancora)

- address space layout randomization
	- ad ogni esecuzione, randomizzare gli indirizzi dove sono caricati i diversi segmenti del programma (stack, heap, …), in questo modo è molto più difficile per l’attaccante indovinare l’indirizzo del buffer contenente lo shellcode (in quando l’attaccante non sa dove inizia lo stack)
	- inoltre, anche indovinare l’indirizzo delle librerie standard  per un attacco return-to-libc è più difficile

//honestly didnt undersand much but i am very much done with this stuff for now