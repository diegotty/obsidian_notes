---
created: 2024-10-27
related to: "[[partizionamento e paginazione]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [conseguenze](#conseguenze)
>- [memoria virtuale](#memoria%20virtuale)
>- [terminologia](#terminologia)
>- [thrashing](#thrashing)
>- [supporto hardware](#supporto%20hardware)
>- [traduzione degli indirizzi](#traduzione%20degli%20indirizzi)
>	- [page table entry](#page%20table%20entry)
>- [problema delle PTE](#problema%20delle%20PTE)
>- [TLB](#TLB)
>- [process switch](#process%20switch)

fino ad ora abbiamo come costanti, attraverso i vari modi di gestire la memoria, che:
- i riferimenti alla memoria avvengono tramite indirizzi logici, che vengono tradotti ad indirizzi fisici a tempo di esecuzione
- un processo può essere spezzato in più parti, che non necessariamente occupano una zona contigua di memoria
se queste due caratteristiche sono vere, allora non è necessario che tutte le pagine(o segmenti) di un processo siano in memoria principale, per far poter eseguire il processo: in RAM servono solamente la prossima istruzione e i dati di cui ha bisogno
grazie a questa intuizione si può cambiare il modo in cui si gestisce la memoria:
- il SO porta in memoria principale solo alcune pagine del processo: queste pagine si chiamano **resident set** del processo
- viene generato un interrupt (**page fault**) quando al processo serve un indirizzo che non si trova in RAM
- visto che l’interrupt lanciato è una richiesta di I/O a tutti gli effetti, il SO mette il processo nello stato`blocked`
- mentre il pezzo di processo che contiene l’indirizzo logico viene caricata in memoria principale(il SO effettua una richiesta di lettura su disco, quindi I/O a tutti gli effetti), un altro processo va in esecuzione
- quando l’operazione I/O viene completata, un interrupt fa in modo che il processo torni `ready` (non necessariamente in esecuzione)
- quando il processo verrà eseguito, occorrerà eseguire nuovamente la stessa istruzione che aveva causato il **page fault**, questa volta però, l’indirizzo necessario è caricato nella RAM
## conseguenze
- più processi possono essere in memoria pricipale, visto che non devono essere caricati per intero
- visto che ci sono più processi in memoria principale, è più probabile che ci sia sempre un processo `ready` **aumenta il grado di multiprogrammazione**
- si possono gestire processi che richiedono più memoria di quella disponibile nella memoria principale
# memoria virtuale
uno schema che usa memoria virtuale è quindi uno schema di allocazione di memoria, in cui la memoria secondaria può essere usata come se fosse principale (nel senso che vengono tenute pagine di processi, mentre prima venivano tenuti processi per intero)
le sue caratteristiche sono:
- gli indirizzi usati nei programmi e quelli usati dal sistema sono diversi, e c’è una fase di traduzione automatica dai primi ai secondi
- la dimensione della memoria virtuale è limitata dallo schema di indirizzamento e dalla disponibilità di memoria secondaria (la RAM non influisce a riguardo)
## terminologia 
**memoria virtuale**: memoria secondaria (su disco)
**memoria reale**: memoria principale (la RAM)
**indirizzo virtuale**: l’indirizzo associato ad una locazione nella memoria virtuale, che fa sì che si possa accedere ad essa come se fosse parte della memoria principale
>[!figure] ![[Pasted image 20241027175025.png]]

**spazio degli indirizzi virtuali**: la quantità di memoria virtuale assegnata ad un processo
**spazio degli indirizzi**: la quantità di memoria assegnata ad un processo
**indirizzo reale**: indirizzo di una locazione in memoria principale
## thrashing
avviene quando il SO impiega la maggior parte del suo tempo a swappare pezzi di processi, anzichè eseguire istruzioni (cioè quando quasi ogni richiesta di pagina dà luogo ad un **page fault**)
per evitare il trashing, il SO cerca di indovinare quali pezzi di processo saranno usati con maggiore probabilità nel futuro (nella prossima istruzione da eseguire), e lo fa usando un principio a noi già noto: il principio di località.
- per il principio di località, i riferimenti che fa un processo tendono ad essere vicini, quindi saranno necessari solo pochi pezzi del processo di volta in volta. in questo modo si può prevedere abbastanza bene quali pezzi di processo saranno necessari nelle istruzioni a seguire, permettendo alla memoria virtuale di evitare il thrashing e quindi di funzionare bene
# supporto hardware
paginazione e segmentazione hanno bisogno di essere supportati dall’hardware, poichè alcune operazioni sarebbero troppo lunghe se fatte in software dal SO
## traduzione degli indirizzi
### page table entry
è la tabella delle pagine: ogni processo ne ha una ed il suo PCB punta ad essa
ogni entry della tabella contiene:
- **P**: un bit per indicare se la pagina è caricata in RAM o meno
- **M**: un bit per indicare se la pagina è stata modificata o meno, in seguito all’ultima volta che è stata caricata in memoria principale (simile alla cache)
- **other control bits**: not relevant rn
- **frame number**: il numero di frame in RAM
per accedere ad una entry, basta usare il numero di pagina (moltiplicato per la dimensione di una entry)
- la tabella è indicizzata per numero di pagina
>[!figure] traduzione degli indirizzi
>![[Pasted image 20241027172509.png]]
la traduzione è fatta dall’hardware.
precisazione sulla somma: il **page #**, prima di essere sommato al **page table Ptr**, che punta all’inizio della page table, va moltiplicato per la dimensione in byte di una entry della page table

affinchè lo schema funzioni, ad ogni process switch il SO deve caricare la tabella delle pagine, del processo che andrà in esecuzione, in un registro dipendente dall’hardware
## problema delle PTE
le page tables potrebbero avere molte entry !  e quando un processo è in esecuzione, viene assicurato che almeno un parte della sua page table sia in RAM(in verità alla fine serve sempre che tutta la page table sia in ram (il primo livello))
>[!example]
supponiamo di avere 8GB di spazio virtuale, e che ogni pagina pesi 1kB. ogni page table \\\QUE>STION

# TLB
ogni riferimento alla memoria virtuale può generare due accessi alla memoria: 
- uno per la tabella delle pagine (se la tabella ha un solo livello)
- uno per prendere il dato
il TLB (**transation lookaside buffer**) è una cache veloce che contiene le entry delle page table(PCB ?) che sono state usate più di recente
quindi, dato un indirizzo virtuale, il procesore controlla prima il TLB, e si possono verifcare due casi:
- **TLB hit**: l’entry è presente, si prende il frame number e si ricava l’indirizzo reale
- **TLB miss**: l’elemento non è presente, si prende la entry dal PT del processo
può capitare di avere un TLB miss e non trovare la pagina in memoria principale: si gestisce il page fault (guarda esempio sotto)
dopodichè, il TLB viene aggiornato includendo la pagina appena acceduta (si usa un algortimo di rimpiazzamento tipo LRU per gestire la TLB piena)
>[!figure]  memoria virtuale con TLB
![[Pasted image 20241028135724.png]]
come si vede nell’immagine, le “query” al TLB, che è un supporto hardware, si possono fare in parallelo

>[!example]
![[Pasted image 20241028140037.png]]
## process switch
il SO deve poter resettare il TLB
per far un po meglio, alcuni processori (es. Pentium) permettono di etichettare con il PID ciascuna entry del TLB (e una entry del TLB è presa come valida se il PID del TLB coincide con un PID attuale)

in ogni caso(anche senza TLB), come abbiamo visto, a ogni process switch è necesario dire al processore dove è la nuova PT
- nel caso sia a 2 livelli, basta la page directory
- ciò fa parte del process switch

>[!figure] ![[Pasted image 20241028141114.png]]
>dato che il TLB non è indicizzato nello stesso modo delle PT(il TLB contiene solo alcuni elementi del PT), **l’associative mapping** ci permette di questionare tutte le entry del TLB allo stesso tempo (sempre grazie al supporto hardware)

inoltre, bisogna fare in modo che il TLB contenga solo pagine presenti in RAM: dato che quando avviene una TLB hit non controlliamo la PT del processo, potremmo non accorgerci se la pagina che cerchiamo è stata swappata, e quindi non gestiremmo il page fault
- se il SO swappa una pagina, deve istruire anche il TLB di eliminarla !
- tornano qui utili le istruzioni hardware di reset parziale del TLB
>[!figure] TLB + cache
![[Pasted image 20241028141854.png]]
la cache è presente anche senza il TLB !!
