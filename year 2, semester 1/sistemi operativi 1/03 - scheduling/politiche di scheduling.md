---
created: 2024-10-16
related to: "[[intro allo scheduling]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [FCFS](#FCFS)
>	- [downsides:](#downsides:)
>- [round-robin](#round-robin)
>	- [misura del quanto di tempo per la preemption](#misura%20del%20quanto%20di%20tempo%20per%20la%20preemption)
>	- [round-robin virtuale](#round-robin%20virtuale)
>- [SPN](#SPN)
>	- [problemi dell’SPN](#problemi%20dell%E2%80%99SPN)
>	- [stima del tempo di esecuzione](#stima%20del%20tempo%20di%20esecuzione)
>- [SRT](#SRT)
>- [HRRN](#HRRN)
>- [confronto tra tutte le politiche](#confronto%20tra%20tutte%20le%20politiche)

useremo uno scenario comune di esempio per valutare le diverse politiche di scheduling:
>[!figure] ![[Pasted image 20241014212633.png]]

# FCFS
**first come, first serve** :)
tutti i processi sono aggiunti alla coda dei processi ready, e quando un processo smette di essere eseguito, si passa la processo che ha aspettato di più nella coda ready finora
- non preemptive
>[!figure] ![[Pasted image 20241016083505.png]]
>visualizzazione della politica FCFS
## downsides:
- un processo corto dovrebbe poter aspettare molto prima di essere eseguito
- favorisce i processi CPU-bound, che una volta che si prendono la CPU, non la rilasciano più finchè non hanno finito
# round-robin
anche chiamato **time slicing**, si basa un un clock per usare la preemption e quindi ogni processo ha una fetta di tempo
>[!figure] ![[Pasted image 20241016083813.png]]
round robin con slice = 1 unità di tempo

viene quindi generata un’interruzione di clock ad intervalli periodici, e quando l’interruzione arriva, il processo attualmente in esecuzione viene rimesso nella coda dei ready, e il processo seguente viene selezionato
>[!example] 
![[Pasted image 20241016085037.png]]

## misura del quanto di tempo per la preemption
>[!figure]
![[Pasted image 20241022080229.png]]

per essere ottimale, il quanto di tempo deve essere poco più lungo del “tipico” tempo di interazione per un processo, ma non troppo lungo, altrimenti si degenera in FCFS
## round-robin virtuale
con il round-robin, i processi CPU-bound sono favoriti, in quanto usano tutto il loro quanto di tempo, mentre gli I/O bound ne usano solo una porzione (fino alla richiesta di I/O)
- ciò, oltre ad essere non equo, aumenta la variabilità della risposta e quindi diminuisce la predicibilità
il **round-robin virtuale** mira a risolvere questi problemi:
- dopo un completamento di I/O, il processo non va in coda ai ready, ma va in una nuova coda che ha priorità su quella dei ready
- quando un processo viene scelto dalla nuova coda, però, va in esecuzione solo per la porzione di quanto che ancora gli rimaneva da completare
in questo modo, viene migliorata la fairness del round-robin semplice
>[!figure] ![[Pasted image 20241022080958.png]]

# SPN
**shortest process next**
la politica di scheduling SPN gestisce l’allocazione del tempo di esecuzione in questo modo: **il prossimo processo da mandare in esecuzione è quello più breve**
(con breve, si intende il processo ready in cui il tempo di esecuzione stimato è minore)
- in questo modo, i processi corti scavalcano quelli lunghi
- se il tempo di esecuzione stimato si rivela inesatto, il sistema operativo può abortire il processo
l’SPN  è non-preemptive
>[!figure]
![[Pasted image 20241022085156.png]]
## problemi dell’SPN
- la predicibilità dei processi lunghi è ridotta
- i processi lunghi potrebbero soffrire di starvation
## stima del tempo di esecuzione
se il processo non nasce fornendo una stima del tempo di esecuzione stimato, si può effettuare una stima
dato che alcuni processi sono eseguiti varie volte, posso usare il passato ($T_{i}$), per predire il futuro($S_{i}$)
intuitivamente, si potrebbe usare la formula:
$$S_{n+1}=\frac{1}{n}\sum_{i=1}^{n}T_{i}$$

che può essere ottimizzata: la seguente formula ottiene lo stesso risultato, ma ricordando solo l’ultima stima e il tempo di esecuzione dell’ultima istanza del processo(e con molti meno calcoli):
$$S_{n+1}=\frac{1}{n}T_{n}+\frac{n-1}{n}S_{n}$$
ma la stima sopra può essere ancora ottimizzata, cambiando approccio:
si usa l’**exponential averaging**, cioè si fa pesare di più le istanze più recenti

la formula sopra può essere riscritta in questo modo:
$$S_{n+1}=\alpha T_{n}+(1-\alpha)S_{n}, 0<\alpha<1$$

sviluppando la formula(sostituendo $S_{n}$ con la formula stessa), si ottiene:
$$S_{n+1}=\alpha T_{n}+\dots \alpha(1-\alpha)^i\,\,T_{n-i}+\dots+(1-\alpha)^n\,S_{1}$$
dato che $(1-\alpha$) (che vale tra 0 e 1) viene elevato ogni volta ad un esponente più grande, le istanze precedenti valgono(nel senso che sono considerate) sempre di meno. ecco l’exponential averaging!
>[!figure] ![[Pasted image 20241022083941.png]]
si può vedere che al cambiare degli $\alpha$, i processi precedenti vengono considerati sempre meno

>[!example]
![[Pasted image 20241022084008.png]]
# SRT
**shortest remaining time**
l’SRT utilizza la stessa politica dell’SPN, ma usa la preeemption
- non utilizza il quanto come il round-robin, ma un processo può essere interrotto solo quando ne arriva uno nuovo, appena creato ( o se il proceso fa un I/O bloccante)
- in quel momento, si prende il processo con il tempo rimanente richiesto per l’esecuzione (stimato)  è più breve
la starvation è ancora possibile !
>[!figure] ![[Pasted image 20241022085113.png]]
# HRRN
**highest response ratio next**
non preemptive, mira a risolvere i problemi di starvation di SPN e SRT, massimizzando il seguente rapporto:
$$\frac{w+s}{s} = \frac{\text{tempo trascorso in attesa + tempo totale richiesto}}{\text{tempo totale richiesto}}$$
>[!figure] ![[Pasted image 20241022085405.png]]
# confronto tra tutte le politiche
>[!figure] ![[Pasted image 20241022085431.png]]

>[!figure] ![[Pasted image 20241016081525.png]]
overview delle politiche di scheduling