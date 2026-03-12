---
related to: "[[09 - threads]]"
created: 2025-03-02T17:41
updated: 2025-05-15T09:55
completed: false
---
>[!index]
>- [flussi di esecuzione concorrente](#flussi%20di%20esecuzione%20concorrente)
>	- [race condition](#race%20condition)
>	- [sezione critica](#sezione%20critica)
>		- [semafori](#semafori)
>- [POSIX mutex](#POSIX%20mutex)
>	- [$\verb |int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *mutexattr)|$](#$%5Cverb%20%7Cint%20pthread_mutex_init(pthread_mutex_t%20*mutex,%20const%20pthread_mutexattr_t%20*mutexattr)%7C$)
>- [barriera](#barriera)
>	- [$\verb |int pthread_barrier_init(pthread_barrier_t *restrict barrier, const pthread_barrierattr_t *restrict attr, unsigned int count)|$](#$%5Cverb%20%7Cint%20pthread_barrier_init(pthread_barrier_t%20*restrict%20barrier,%20const%20pthread_barrierattr_t%20*restrict%20attr,%20unsigned%20int%20count)%7C$)
>- [condition](#condition)

## flussi di esecuzione concorrente
come abbiamo studiato, la fonte di complicazione maggiore nei SO è costituita dall’esistenza di flussi di esecuzione concorrenti, in quanto:
- la coerenza delle strutture dati private di ciascun flusso di esecuzione **è garantita** dal meccanismo di cambio del flusso
- la coerenza delle strutture dati condivise tra i vari flussi di esecuzione **non è garantita** da tale meccanismo !
### race condition
abbiamo già visto che se due o più flussi di esecuzione hanno una struttura dati in comune, la concorrenza dei flussi può determinare uno stato della struttura **non coerente** con la logica di ciascuno dei flussi ! 
- possono infatti accadere **race condition**, situazioni in cui lo stato della memoria condivisa tra due o + flussi di esecuzione concorrenti **dipende dall’ordine esatto degli accessi in memoria** (grave !)
>[!tip] operazioni atomiche
come abbiamo visto in precedenza, le uniche operazioni atomiche sono quelle effettivamente atomiche in linguaggio assembly (es: gli assegnamenti in C non sono operazioni atomiche)

>[!example] esempio di race condition
![[Pasted image 20250515090247.png]]

### sezione critica
una **sezione critica** è una sequenza di istruzioni di un flusso di esecuzione che accede ad una struttura di dati condivisa, e che quindi non deve essere eseguita in modo concorrente ad un’altra regione critica
- per rendere utilizzabile una sezione critica, ovvero per avere l’accesso esclusivo ad una risorsa condivisa, si può usare il **semaforo**, inventato dar Dijkstra 
#### semafori
i **semafori** si basano su una variabile intera che agisce da contatore, e grazie a due primitive atomiche `wait()` e `signal()` garantiscono la **mutua esclusione** ad una risorsa condivisa
- citiamo i **semafori contatore**, in cui una risorsa può essere acquisita da $n>1$ flussi di esecuzione concorrentemente, e i **semafori binari**, in cui $n=1$
## POSIX mutex
il **POSIX mutex** (**MUTual EXclusion device**) viene utilizzato per proteggere strutture dati condivise e realizzare sezioni critiche. li studieremo nell’ambito dei thread !
### $\verb |int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *mutexattr)|$
la funzione `pthread_mutex_init()` inizializza un mutex e imposta gli attributi a `mutex_attr`
- gli attributi determinano il comportamento del semaforo quando il thread invoca un `lock/unlock` più volte consecutivamente
	- `PTHREAD_MUTEX_NORMAL` (fast): un lock blocca il thread finchè il lock attuale (da parte di un altro thread) non è stato rilasciato (può creare stallo), mentre un unlock rilascia il semaforo e ritorna subito
	- `PTHREAD_MUTEX_RECURSIVE`: permette allo stesso thread di mettere più lock (un contatore tiene conto del numero di lock messi da un thread), mentre un unlock derementa il contatore ma non rilascia il semaforo finchè il contatore non è 0
	- `PTHREAD_MUTEX_ERRORCHECK`: genera un errore in caso il thread cerchi di mettere un lock su un mutex sul quale già detiene un lock, mentre un unlock ritorna errore se il thread non aveva fatto un lock precedentemente (sulla sezione critica su sui si sta provando a fare l’unlock)

>[!info] altre funzioni per mutex
>- $\verb |int pthread_mutex_lock(pthread_mutex_t *mutex)|$:
>	- acquisisce il mutex, se non è già bloccato da un altro thread, altrimenti rimante in attesa. ritorna `0` in caso di successo
> - $\verb |int pthread_mutex_trylock(pthread_mutex_t *mutex)|$:
> 	- `pthread_mutex_lock` non bloccante: in caso il mutex sia bloccato, non aspetta, ma ritorna il valore `BUSY`
> - $\verb |int pthread_mutex_unlock(pthread_mutex_t *mutex)|$:
> 	- rilascia il mutex precedentemente acquisito. ritorna `0` in caso di successo, altrimenti il valore di ritorno rappresenta il corrispettivo errore
> - $\verb |int pthread_mutex_destroy(pthread_mutex_t *mutex)|$:
> 	- distrugge un mutex, liberando le risorse. ritorna `0` in caso di successo, altrimenti ritorna `-1` e viene impostato `errno`
## barriera
la **barriera** è un metodo di sincronizzazione per processi o thread. fa sì che un set di processi o thread possa continuare il proprio flusso di esecuzione solo se tutti hanno raggiunto la barriera
### $\verb |int pthread_barrier_init(pthread_barrier_t *restrict barrier, const pthread_barrierattr_t *restrict attr, unsigned int count)|$
la funzione `pthread_barrier_int` crea una nuova barriera con attributi `attr`, a cui parteciperanno `count` thread
- se `attr=NULL`, viene impostato l’attributo di default

>[!info] altre funzioni per barriere
>- $\verb |int pthread_barrier_destroy(pthread_barrier_t *barrier)|$:
>	- ogni thread che invoca questo comando si blocca fino a che `count` thread non sono arrivati alla barriera. l’ultimo thread ad arrivare alla barriera riceverà il valore `PTHREAD_BARRIER_SERIAL_THREAD` (gli altri riceveranno `0`)
>- $\verb |int pthread_barrier_wait(pthread_barrier_t *barrier)|$:
>	- distrugge una barriera, liberando le risorse. ritorna `0` in caso di esito positivo, altrimenti viene restituito un numero per indicare l’errore
## condition
la **condition** è un metodo di sincronizzazione che permette ad un thread di sospendere la sua esecuzione finchè un predicato su di un dato condiviso non è verificato
>[!warning] imp
una variabile condition deve essere sempre associata ad un mutex per evitare una race condition dove un thread fa una `wait` su una condizione, ed un altro thread invia un `signal` alla condizione (e sblocca la condizione) prima che il primo thread si metta in attesa

>[!info] sfilza di funzioni per le condition
>- $\verb |int pthread_cond_init(pthread_cond_t *cond, pthread_condattr_t *cond_attr)|$
>	- inzializza una condition variable su `cond` con `attr` attributi. se `attr=NULL`, vegono utilizzati gli attributi di default. ritorna `0` in caso di successo, altrimenti codice di errore
>- $\verb |int pthread_cond_signal(pthread_cond_t *cond)|$
>	- risveglia **uno solo** dei thread in attesa sulla condition variable `cond`
>- $\verb |int pthread_cond_broadcast(pthread_cond_t *cond)|$
>	- risveglia tutti i thread in attesa su `cond`
>- $\verb |int pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex)|$
>	- fa unlock del mutex `mutex` associato alla condizione `cond`, e attende che un altro thread esegua `pthread_cond_signal` sulla condizione.
>- $\verb |int pthread_cond_timedwait(pthread_cond_t *cond, pthread_mutex_t *mutex, const struct timespec *abstime)|$
>	- come `pthread_cond_wait`, ma attende al massimo fino a `abstime`. ritorna `ETIMEOUT` se scade il tempo
>- $\verb |int pthread_cond_destroy(pthread_cond_t *cond)|$:
>	- distrugge una condition variable, liberando le risorse. ritorna `0` se successful, altrimenti un errore se ci sono ancora thread in attesa

>[!warning] sulle slide non c’è scritto neanche cosa sono queste strutture viene solo vagamente spiegato come si usano il che è fuori di testa
>quando sarà necessarie usarle aggiungerò più roba i need to move on from os2 rn im sorry