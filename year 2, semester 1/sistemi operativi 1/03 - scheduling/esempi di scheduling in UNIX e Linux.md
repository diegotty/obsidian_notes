---
created: 2024-10-22
related to: "[[politiche di scheduling]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [scheduling tradizionale di UNIX](#scheduling%20tradizionale%20di%20UNIX)
>	- [formula di scheduling](#formula%20di%20scheduling)
>- [architetture multiprocessore](#architetture%20multiprocessore)
>	- [scheduler su architetture multiprocessore](#scheduler%20su%20architetture%20multiprocessore)
>		- [assegnamento statico](#assegnamento%20statico)
>		- [assegnamento dinamico](#assegnamento%20dinamico)
>			- [gestione del SO](#gestione%20del%20SO)
>- [scheduling in Linux](#scheduling%20in%20Linux)
>	- [run queues](#run%20queues)
>	- [wait queues](#wait%20queues)
>	- [tipi di processi in Linux](#tipi%20di%20processi%20in%20Linux)
>		- [interattivi](#interattivi)
>		- [batch(non interattivi)](#batch(non%20interattivi))
>		- [real-time](#real-time)

# scheduling tradizionale di UNIX
lo scheduling di UNIX combina priorità e round-robin
- il quanto di tempo dura 1s
- esistono quindi diverse code, per gestire la priorità, e all’interno di ciasuna si fa round-robin
- le priorità vengono ricalcolate ogni secondo, e più un processo resta in esecuzione, più viene spinto in coda a minore priorità (feedback)
le priorità iniziali sono basate sul tipo di processo:
0. swapper (alta) (gestisce la memoria virtuale)
1. controllo di un dispositivo I/O a blocchi
2. gestione di file
3. controllo di un dispositivo di I/O a caratteri (tastiera o monitor vecchi (?))
4. processi utente (bassa)
## formula di scheduling
$$CPU_{j}(i)= \frac{CPU_{j}(i-1)}{2}$$
$$P_{j}(i)=Base_{j}+ \frac{CPU_{j}(i)}{2} + nice_{j}$$
- $CPU_{j}$ è una misura di quanto il processo $j$ ha usato il processore nell’intervallo $i$, con exponential averaging dei tempi passati $(\alpha = \frac{1}{2})$
	- per i running, $CPU_{j}$ viene incrementato di 1 ogni $\frac{1}{60}$ di secondo
- $Base_{j}$ è la priorità iniziale del processo
- $nice_{j}$ può essere usato dal processo stesso per “autodeclassarsi” come avente bassa priorità (lo usa il sistema per declassare processi che sa essere di minore importanza)
>[!example]
![[Pasted image 20241022092933.png]]
durante ogni quanto: il CPU count del processo in esecuzione viene aumentato di 1 ogni sessantesimo di secondo
a fine quanto: vengono ricalcolate tutte le priorità ($P_{j}(i)$), usando i valori aggiornati di $CPU_{j}(i)$
# architetture multiprocessore
le politiche di scheduling viste in precedenza valgono solo per sistemi con un solo processore. con sitemi multiprocessore (la norma, al giorno d’oggi)
- cluster
	- ogni processore ha la sua RAM, connessione con rete locale superveloce (?)
- processori specializzati
	- ad esempio, ogni I/O device ha un suo processore
- multi-processore e/o multi-core
	- condividono la RAM
	- un solo SO controlla tutto
## scheduler su architetture multiprocessore
avendo più processori/core, bisogna gestire il modo in cui si assegnano i processi ai rispettivi processori. ciò si può fare in due modi:
### assegnamento statico
quando un processo viene creato, gli viene assegnato un processore, e per tutta la sua durata quel processo andrà in esecuzione su quel processore
- in questo modo, si può usare uno scheduler per ogni processore
- vantaggi: semplice da realizzare, poco overhead
- svantaggi: un processore può rimanere idle
### assegnamento dinamico
per migliorare lo svantaggio dello statico, un processo, durante il suo corso di vita, potrà essere eseguito su diversi processori
- più complicato da realizzare
#### gestione del SO
ciò potrebbe andare bene per i processi utente, ma è meglio gestire diversamente i processi del SO
- il SO viene eseguito su un processore fisso
	- più semplice, ma può diventare bottleneck (se il processore è più lento degli altri)
	- anche se il sistema potrebbe funzionare con una failure di un processore, se il processore che fallisce è quello che gestisce il SO, cade tutto
- il SO viene eseguito sul processore che capita
	-  per quanto più flessibile, richiede più overhead per gestire il SO
# scheduling in Linux
cambia “molto spesso”
Linux cerca la velocità di esecuzione, attraverso la semplicità di implementazione: per questo motivo non esistono ne **long-term scheduler** nè **medium-term scheduler**
- in verità un embrione di long-term scheduler esiste, e gestisce il caso limite in cui, alla creazione del processo, non c’è memoria(neanche virtuale) libera per la creazione di esso
anche linux usa le priorità, ed esitono 2 gruppi di code:
## run queues
queue da cui il dispatcher prende i processi da eseguire
- le run queues sono singole per ogni processore (ogni processore ha la propria runqueue)
## wait queues
queue in cui vengono mandati i processi messi in attesa quando fanno una richiesta che implica l’attesa (es: I/O)
- le wait queues sono condivise tra i processori
## tipi di processi in Linux
Linux ha delle heuristics per capire se un processo è interattivo o batch, mentre per quelli real-time, il processo stesso di chiara come tale chiamando l’opportuna syscall
### interattivi
- bisogna dare loro la CPU in 150ms al massimo (se muovo il mouse e il cursore si muove troppo, dopo me ne accorgo)
### batch(non interattivi)
- tipicamente penalizzati dallo scheduler, in quanto l’utente è disposto ad aspettare di più (per compilazioni, computazioni scientifiche, etc)
### real-time
- vengono riconosciuti da Linux come tali perchè il loro codice sorgente usa la syscall `sched_setscheduler`
- usati principalmente da KLT di sistema

lo scheduling di Linux è quindi derivato da UNIX: **preeemptive a priorità dinamica**, ma con importanti correzioni per essere veloce(opera quasi in $O(1)$) e servire in modo appropriato i processi real-time(se ci sono):
>[!warning] Linux istruisce l’hardware di mandare un timer interrupt ogni 1ms (altrimenti si rischia di non dare l’esecuzione in tempo a un processo real time)

ciò vuol dire che il quanto di tempo per ogni proceso sarà un multiplo di 1ms

ci sono 3 classi di scheduling:
`SCHED_FIFO`e `SCHED_RR` , che fanno riferimento ai processi real-time
- hanno un livello di priorità da 1 a 99
`SCHED_OTHER` che contiene tutti gli altri processi
- ha un livello di priorità da 100 a 139
>[!info] prima si eseguono i processi in `SCHED_FIFO` e `SCHED_RR`, e poi quelli su `SCHED_OTHER`
inoltre, si passa da livello $n$ al livello $n+1$ solo se:
>- non ci sono processi in n
>- nessun processo in n è RUNNING(che per linux è ready (non c’è differenza tra ready e running in Linux))

ci sono quindi 140 run queues
la preeemption (che però non vale per `SCHED_FIFO`), oltre all’esaurimento del quanto di tempo, può accadere per un altro motivo: se un altro processo passa da uno degli stati blocked a `RUNNING` (ciò viene fatto per avvantaggiare i processi interattivi(ogni tasto premuto sulla tastiera o movimento del mouse è un interrupt))
- inoltre, molto spesso il processo che è appena diventato eseguibile verrà effettivamente eseguito dal processore, perchè probabilmente è un processo interattivo a cui bisogna dare precedenza 

>[!info] particolarità
>un processo in `SCHED_FIFO` non segue la preemption normale, ma viene rimesso in coda solo se:
>- si blocca per I/O 
>- un altro processo passa da uno degli stati blocked a `RUNNING`, ed ha la priorità più alta del processo in esecuzione
>- altrimenti, **NON LO FERMA NESSUNO!**(stile FCFS)
>questo perchè in `SCHED_FIFO` spesso ci sono solo processi del SO molto importanti, che vanno in esecuzione per poco tempo e rilasciano il processore volontariamente (altrimenti si degradano le prestazioni del SO)
i processi real-time non cambiano mai la priorità, mentre i processi `SCHED_OTHER` sì.

quindi l’assegnamento è statico, ma c’è un KLT che esegue periodicamente una routine periodica che ridistribuisce il carico, se necessario