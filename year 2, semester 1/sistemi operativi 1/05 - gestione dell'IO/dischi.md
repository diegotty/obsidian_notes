---
created: 2024-11-17
related to: intro
updated: 2025-02-20T09:38
---
>[!index]
>
>- [prestazioni del disco](#prestazioni%20del%20disco)
>- [politiche di scheduling per il disco](#politiche%20di%20scheduling%20per%20il%20disco)
>- [FIFO](#FIFO)
>- [priorità](#priorit%C3%A0)
>- [LIFO](#LIFO)
>- [minimo tempo di servizio](#minimo%20tempo%20di%20servizio)
>- [SCAN](#SCAN)
>- [C-SCAN](#C-SCAN)
>- [FSCAN](#FSCAN)
>- [N-step-SCAN](#N-step-SCAN)
>- [confronto prestazionale](#confronto%20prestazionale)
>- [SSD](#SSD)
>- [cache del disco](#cache%20del%20disco)
>- [politiche di rimpiazzo](#politiche%20di%20rimpiazzo)
>	- [LRU](#LRU)
>	- [LFU](#LFU)
>	- [sostituzione basata su frequenza](#sostituzione%20basata%20su%20frequenza)
>	- [sostituzione basata su frequenza a 3 segmenti](#sostituzione%20basata%20su%20frequenza%20a%203%20segmenti)
>- [dischi RAID](#dischi%20RAID)
>- [LVM](#LVM)
>- [gerarchia dei dischi RAID](#gerarchia%20dei%20dischi%20RAID)
>- [page cache in Linux](#page%20cache%20in%20Linux)
# HDD
>[!warning] ciò che verrà visto vale per gli HDD, non per gli SDD (hanno problemi diversi, non trattati in questo corso)
anche se vengono fatti dei cenni sugli SDD 

>[!info] costruzione del disco
![[Pasted image 20241117171021.png]]
>- i dischi sono divisi in tracce, che sono divise da spazi vuoti
>- ogni traccia è diviso in settori
>- nelle tracce, i settori sono divisi da degli spazi vuoti

per leggere/scrivere dati, serve sapere su quale traccia si trovano i dati, e per selezionare una traccia bisogna:
- spostare una testina, se il disco ha testine mobili (quindi magari ha una sola testina)
- selezionare una testina, se il disco ha testine fisse (quindi ha più testine)
per selezionare il settore invece, bisogna aspettare che il disco ruoti ( a velocità costante)
se i dati sono tanti, potrebbero essere su più settori o addirittura più tracce !! 
- la tipica misura di un settore è 512 bytes

## prestazioni del disco
>[!info] fasi del trasferimento
![[Pasted image 20241117173234.png]]
>- esistono dischi con più canali (hanno più dischi fisici, e bisogna quindi anche selezionare il disco: wait for channel)

- il tempo di accesso (**access time**) è quindi la somma di:
	- **seek time**: tempo necessario perchè la testina si posizioni sulla traccia desiderata
	- **rotational delay**: tempo necessario affinchè l’inizio del settore raggiunga la testina
- **transfer time**: tempo necessario a trasferire di dati che scorrono sotto la testina
a parte (non fanno parte delle effettive prestazioni del disco):
- **wait for device**: attesa che il dispositivo sia assegnato alla richiesta
- **wait for channel**: attesa che il sottodispositivo sia assegnato alla richiesta
	- se ci sono più dischi che condividono un unico canale di comunicazione

# politiche di scheduling per il disco
come nella RAM, sono stati pensati diversi algoritmi per ottimizzare lo scheduling delle richieste di trasferimento per i dischi
per confrontare i vari algoritmi, usiamo un esempio comune:
>[!example] esempio comune
>- all’inizio, la testina si trova sulla traccia numero 100
>- ci sono 200 tracce
>- vengono richieste le seguenti tracce nel seguente ordine:
>$$55, 58, 39, 18, 90, 160, 150, 38, 184$$
>- considereremo solo il **seek time**, che è il parametro più importante per le prestazioni
>- il nostro scheduling baseline sarà il random, che è lo scheduling peggiore

>[!figure] prospetto
![[Pasted image 20241117182258.png]]
## FIFO
- le richieste vengono servite in modo sequenziale, rendendo lo scheduling equo nei confronti dei processi
- però, se ci sono molti processi in esecuzione, le prestazioni sono simili allo scheduling random
>[!figure] FIFO graph
![[Pasted image 20241117174523.png]]
## priorità
- l’obiettivo non è ottimizzare il disco, ma rispettare le priorità
- impossibile fare il grafico in quanto manca l’infomazione sulla prorità di chi ha richiesto le informazioni
## LIFO
- ottimo per DBMS con transazioni (sequenze di richieste che vanno eseguite tutte insieme)
- LIFO si riferisce all’utente! il dispositivo viene dato all’utente più recente (quindi è possibile la starvation per gli utenti !)
- motivazione: se si tratta dello stesso utente, probabilmente sta accedendo sequenzialmente ad un file, e quindi è più efficiente mandare avanti lui (e bisogna far finire la transazione)
impossibile fare il grafico perchè non sappiamo quale utente fa la richiesta
## minimo tempo di servizio
>[!warning] da qui in poi occorre conoscere la posizione della testina
- sceglie la richiesta che minimizza il movimento della testina (dalla posizione attuale)
- possibile la starvation di richieste! ( se arrivano continuamente richieste più vicine)
>[!figure] minimo tempo di servizio graph
![[Pasted image 20241117175826.png]]
## SCAN
- si scelgono le richieste in modo tale che la testina si muova sempre in un verso, e poi torni indietro
- fixa la starvation delle richieste, ma non è equo:
	- favorisce le richieste “ai bordi”: vicine a dove la testina cambia direzione (risolto con CSCAN)
	- potrebbe favorire le richieste appena arrivate (risolto con N-step-SCAN)

>[!figure] SCAN graph
>![[Pasted image 20241117175908.png]]
## C-SCAN
- come SCAN, ma quando la testina fa “marcia indietro”, non si scelgono richieste
- serve richieste solo quando si muove in una delle due direzioni
- quindi i bordi non vengono visitati 2 volte in poco tempo !
>[!figure] C-SCAN graph
![[Pasted image 20241117180000.png]]
## FSCAN
- fixa il problema di possibile favoritismo verso nuove richieste arrivate (che seguono il percorso che sta facendo la testina) della politica SCAN
- usa due code, anzichè una: F(**front**) e R(**rear**)
	- quando SCAN inizia, tutte le richieste sono nella coda F, e l’altra coda R è vuota, e viene riempita con le richieste che arrivano mentre SCAN sta servendo tutta F
	- quando SCAN finisce di servire F, si scambiano F ed R
- in questo modo, ogni nuova richiesta deve aspettare che tutte le precedenti vengano servite, eliminando il favoritismo !
## N-step-SCAN
- generalizzazione di FSCAN a N > 2 code: si accodano le richieste nella i-esima coda, finche non si riempie: si passa poi alla (i+1) mod N
- niente viene aggiunto alla coda attualmente servita
- se N è alto, le prestazioni sono quelle di SCAN (ma con fairness)
- se N=1, allora si usa il FIFO per evitare di essere unfair
##  confronto prestazionale
>[!figure] confrontos
>![[Pasted image 20241117182014.png]]

# SSD
struttura degli SSD:
- ad alto livello, sono costituiti da stack (flash chips) di **die** (matrici)
	- il controller dell’SSD gestisce gli stack di die
- ogni die ha un certo numero di **planes**
- le planes sono divise in **blocks** (blocchi)
- ciascun block è composto da un numero variabile di **pages** (pagine, di circa 4KB)
- ogni page è composta da **cells** (celle): le celle sono le unità più piccole, e possono immagazzinare un solo bit (2 per le multi-level cells)
>[!info] image 
>![[Pasted image 20241119093947.png]]
![[Pasted image 20241119094004.png]]

le operazioni sugli SSD hanno granularità diversa in base al tipo di operazione: 
- lettura: l’unità di accesso minima sono le pagine
- scrittura: l’unità di accesso minima sono sempre le pagine, ma un pagina può essere scritta solo se vuota (non è possibile la sovrascrittura)
sovrascrivere un pagina implica dover **azzerare** l’intero blocco che la contiene, in questo modo: 
1. si fa una copia dell’intero blocco
2. si azzera il blocco
3. si scrive la nuova pagina
4. si copiano le pagine rimanenti dalla copia effettuata in precedenza

gli SSD sono estremamente veloci, infatti:
- nessun tempo richiesto per effettuare seek come negli HDD (non c’è necessità di preoccuparsi di dove siano i dati)
- consentono accesso parallelo ai diversi flash chip
- esistono algoritmi di accesso e file system progettati per massimizzare la performance di SSD, e tutti i maggiori sistemi operativi implementano ottimizzazioni specifiche per SSD (esistono addirittura file system dedicati, come F2FS)
# cache del disco
spesso chiamata **page cache**, è buffer in memoria principale che contiene una copia di alcuni settori del disco:
- quando si fa una richiesta di I/O per dati che si trovano su un certo settore, si vede prima se tale settore è nella cache
- se il settore non c’è, il settore letto viene anche copiato nella cache
- è quindi una cache software non hardware
>[!warning] da non confondere con la cache spesso presente direttamente sui dischi !
>una cache hardware che è quindi trasparente al SO

ci sono svariati modi per gestire questa cache:
## politiche di rimpiazzo
### LRU
se occorre rimpiazzare qualche settore nella cache piena, si prende quello nella cache da più tempo senza referenze
- la cache viene costruita con uno “stack” di puntatori che puntano ai diversi settori: il settore riferito più recentemente sarà quindi in cima allo stack, e quello riferito meno recentemente sarà in fondo allo stack. (anche se la cache non è propriamente uno stack, in quanto NON viene acceduta utilizzando le funzioni push, pop e top in quanto si poppa anche dal basso)
### LFU
si rimpiazza il settore con meno frequenze (quindi, il settore che è stato riferito meno di recente potrebbe non essere quello con meno frequenza)
- LRU si basa sul tempo, mentre LFU sulla frequenza !
- serve un contatore per ogni settore(inizialmente 1, incrementato ad ogni riferimento
- può sembrare intuitivamente corretto: meno vieni usato, meno servi. però, di solito un settore viene acceduto svariate volte di fila, perchè contiene dati acceduti secondo il principio di località. dopoichè, però, non serve più, e andrebbe quindi sostituto. invece, secondo LFU, esso avrà una frequenza abbastanza alta
### sostituzione basata su frequenza
- viene usato uno stack di puntatori come LRU, ma è spezzato in 2: una parte nuova, e una parte vecchia: ogni settore ha un contatore come in LFU, ma vengono incrementati solo i contatori nella parte vecchia 
- i settori che vengono referenziati vanno in cima allo “stack”, come in LRU (anche se presi dalla parte vecchia)
- si rimpiazza comunque il settore con il contatore di frequenza più basso, ma solo tra i puntatori nella parte vecchia (quindi un settore meno usato, con meno riferimenti)
- c’è ancora un problema: può capitare che un settore appena inserito venga subito rimosso perchè non ha avuto abbastanza riferimenti in poco tempo (ed è quindi sceso nella parte vecchia, con un contatore basso), anche se in futuro sarebbe stato usato molto
>[!figure] ![[Pasted image 20241118095225.png]]
### sostituzione basata su frequenza a 3 segmenti
viene aggiunta una nuova parte nella coda, in modo che:
- se un settore si trova nella parte **nuova**, non è eleggibile per il rimpiazzamento, e quando viene referenziato il suo contatore non viene incrementato
- se un settore si trova nella parte **media**, non è ancora eleggibile per il rimpiazzamento, ma quando viene referenziato il suo contatore viene incrementato
- se un settore si trova nella parte **vecchia**, è eleggibile per il rimpiazzamento, e quando viene referenziato il suo contatore viene incrementato
ciò risolve i problemi visti sopra !
>[!figure] ![[Pasted image 20241118095243.png]]
# dischi RAID
RAID sta per **reduntant array of indipendent disks**
in alcuni casi, si hanno a disposizione più dischi fisici, e abbiamo di trattarli separatamente
- windows li mostrerebbe esplicitamente come dischi diversi, con etichette diverse
- Linux ci permette di dire che alcune directory sono su un disco, altre su altro (mount)
oppure, si possono considerare i diversi dischi fisici come un unico disco
i dischi RAID permettono: 
- **parallel access**: se faccio un’operazione sul RAID(cioè un’operazione su un sottoinsieme dei suoi dischi), tutti quei dischi effettuano in sincrono quell’operazione
- **data availability**(da RAID 1 in su): capacità di recupero in caso di fallimento
- **small I/O request rate**: velocità nel rispondere a piccole richieste di I/O
## LVM
il Linux LVM (**logical volume manager**) permette di gestire diversi dischi come disco unico (boring stuff)

esistono device composti da più dischi fisici gestiti da un RAID direttamente a livello di dispositivo (il sistema operativo fa solo read/write, ci pensa il dispositivo stesso a gestire internamente il RAID)
## gerarchia dei dischi RAID
>[!info] RAID 0: non ridondanti
![[Pasted image 20241118100351.png]]
>- ogni disco (in questo caso 4 dischi) è diviso in **strip** (ogni strip contiene un certo numero di settori)
>- una riga di strip (across i vari dischi) si chiama **stripe**
>- nel RAID 0, distribuisco i dati tra i vari dischi per maggiore efficienza nell’accesso: posso leggere i vari dischi in parallelo, e quindi posso leggere un dato (across i vari dischi) più in fretta che se fosse su un solo disco

>[!info] RAID 1: mirrored
![[Pasted image 20241118100942.png]]
>- come RAID 0, ma duplicando ogni dato
>- fisicamente si hanno 2N dischi, ma la capacità di memorizzazione è quella di N dischi
>- in questo modo, se si rompe un disco, posso sicuramente recuperare i dati di tale disco. se se ne rompono 2, ciò dipende da quali dischi si sono rotti

>[!info] RAID 2: ridondanza con codice di Hamming
![[Pasted image 20241118101155.png]]
>- utilizzabile nei casi rari in cui gli errori non sono il fallimento di un intero disco, ma magari il flip di qualche bit
>- invece di replicare l’intera informazione, posso usare codici particolari (es: Hamming), che correggono errori su bit singoli 
>- in questo modo non ho più N dischi di overhead, ma tanti quanti ne servono per memorizzare il codice di Hamming (proprozionale al logarimo della capacità dei dischi)
>- non usato (lame)

>[!info] RAID 3 
![[Pasted image 20241118101455.png]]
>- utilizza solo un disco di overhead
>- memorizza, per ogni bit, la parità dei bit che hanno la stessa posizione (per la posizione 1 su ognuno dei dischi, controllo la parità dei bit e la scrivo nel disco di overhead, per la posizione 2 su ognuno dei dischi, …etc)
>- ogni strip è un byte (?\\QUESTION)
>- resta quindi possibile recuperare i dati se muore solo un disco
>- se muore il disco di parità, e finita

>[!info] RAID 4
![[Pasted image 20241118101844.png]]
\\HUH
>- ogni scrittura ha effetto sul disco di parità (se ci sono tante scritture, si può creare un bottleneck)

>[!info] RAID 5
![[Pasted image 20241118102054.png]]
>- come RAID 4, ma le informazioni di parità non sono tutte su un disco unico, ma vengono distribuite tra tutti i dischi
>- ciò evita il collo di bottiglia del disco di parità, infatti in RAID 5 non c’è un disco privilegiato

>[!info] RAID 6
![[Pasted image 20241118102320.png]]
> - come RAID 5, ma le informazioni di parità vengono memorizzate su 2 dischi indipendenti
>- ciò permete di recuperare anche 2 fallimenti di disco
>- per le operazioni di scrittura, dato che vanno scritte in 2 dischi diversi, il RAID 6 ha un 30% di penalità in più rispetto al RAID 5. per la lettura invece, si equivalgono

>[!example] riassunto
![[Pasted image 20241118102631.png]]
# page cache in Linux
esiste una unica page cache per tutti i trasferimenti tra disco e memoria principale, compresi quelli dovuti alla gestione della memoria virtuale
- è nell’area della memoria virtuale destinata ai processi utenti, quindi combatte con essi (si amplia e si restringe a seconda di quanti processi sono presenti, e non può occupare tutto lo spazio disponibile)
- il page buffering ricade nella page cache
si scrive su disco quando: 
- è rimasta poca memoria
- quando l’età delle pagine “sporche” va sopra una certa soglia
non esiste una politica separata di replacement ! è la stessa usata per il rimpiazzamento delle pagine (la cache è paginata, e le sue pagine sono rimpiazzate con l’algoritmo visto per la gestione della memoria)
