---
created: 2025-01-16T06:07
updated: 2025-02-20T09:38
---
>[!index]
>
>- [ordine lessicografico](#ordine%20lessicografico)
>- [file con indice (sparso)](#file%20con%20indice%20(sparso))
>- [file ISAM](#file%20ISAM)
>- [ricerca](#ricerca)
>- [ricerca binaria](#ricerca%20binaria)
>- [ricerca per interpolazione sul file indice](#ricerca%20per%20interpolazione%20sul%20file%20indice)
>- [inserimento](#inserimento)
>- [cancellazione](#cancellazione)
>- [modifica](#modifica)
>- [file con record puntati](#file%20con%20record%20puntati)
>- [ricerca](#ricerca)
>- [cancellazione](#cancellazione)
>- [modifica](#modifica)
>- [indice secondario](#indice%20secondario)

quando le chiavi ammettono un ordinamento significativo per l’applicazione, e più conveniente utilizzare un’organizzazione fisica dei dati che ne tenga conto

- interi e stringhe ammettono i consueti ordinamenti (lessicografico per le stringhe)
- se la chiave ha campi multipli, si ordina sul primo campo, poi sul secondo, e così via
>[!important] le chiavi possono sempre essere ordinate !
## ordine lessicografico
un alfabeto finito **totalmente ordinato** di simboli è un insieme $\sum = ( \delta_{1}, \delta_{2}, \dots, \delta_{n})$ dotato di un ordine totale (relazione d’ordine totale !!! mmi) $\delta_{1} < \delta_{2}< \dots<\delta_{n}$

date due sequenze di simboli $$I = \delta_{i1} \,\delta_{i2} \dots \delta_{in} \,\,\,\text{e} \,\,\,\,J = \delta_{j1} \, \delta_{j2}\dots\delta_{jm}$$
diciamo che $I < J$ se esiste un numero $k \in \mathbb{N}$ per cui $$\delta_{i1} \,\delta_{i2} \dots \delta_{ik} = \delta_{j1} \,\delta_{j2} \dots \delta_{jk}$$e vale una delle seguenti relazioni:
$$\delta_{i(k+1)} < \delta_{j(k+1)} \,\,\text{oppure} \,\, n = k < m$$
(quindi, se $I$ è più corta di $J$, $I < J$)

# file con indice (sparso)
## file ISAM
**ISAM**: indexed sequential access method
>[!important] caratteristica principale !
file principale ordinato + indice

il file principale (la tabella del nostro DB) viene ordinato in base al valore della **chiave** di ricerca, che in questo caso è univoca (e chiamiamo primary key)
- in genere viene lasciata una certa percentuale di spazio libero ogni blocco, per facilitare operazioni di inserimento, cancellazione e modifica che potrebbero occorrere
viene inoltre creato un nuovo file: il **file indice**, che contiene un record per ogni blocco del file principale, e ogni record del file indice ha 2 campi:
- un puntatore ad un blocco del file principale
- il più piccolo valore della chiave presente nel blocco (il valore della chiave nel primo record del blocco a cui punta, visto che il file principale è ordinato)
	- il valore delle chiavi nell’indice è strettamente maggiore del valore del record precedente nel file ( e strettamente minore del successivo, se presente), e in questo modo viene rispettata la **proprietà di copertura** 
>[!warning] il valore del primo record del primo blocco del file indice è $- \infty$
e il puntatore punta al primo blocco del file principale
>- non è necessario mettere un valore, in quanto sapremo che dovremo seguire il puntatore del primo record se la chiave di ricerca è $<$ del valore del secondo record dell’indice

>[!info] rappesentazione
![[Pasted image 20241213090504.png|350]]
## ricerca
per ricercare un record con valore della chiave $k$, occorre cercare sul file indice un valore $k’$ della chiave che **ricopre $k$**, cioè tale che:
- $k' \leq k$
- se il record $k’$ non è l’ultimo record del file indice e $k’’$ è il valore della chiave nel record successivo, $k < k''$
la ricerca di un record con chiave $k$ richiede:
- 1 ricerca sul file indice ($n$ accessi per caricare l’$n$ esimo blocco, che contiene $k’$, in quanto il file indice ha più blocchi)
- 1 accesso in lettura sul file principale
## ricerca binaria
poichè il file indice è ordinato in base al valore della chiave, la ricerca di un valore che ricopre la chiave può essere fatta in modo efficiente mediante la **ricerca binaria**
la ricerca è fatta in questo modo:
$m$ è il numero totale di blocchi per il file indice
- si fa un accesso in lettura al blocco $\left( \frac{m}{2} \right)+1$ e si confronta $k$ con $k1$(la prima chiave del blocco)
	- se $k = k1$ abbiamo finito!
	- se $k < k1$ allora si ripete il procedimento sui blocco i da $1$ a $(\frac{m}{2})$
	- altrimenti si ripete il procedimento sui blocchi da $\left( \frac{m}{2} \right)+1$ ad $m$ (il blocco $\left( \frac{m}{2} \right)+1$ va riconsiderato, perchè abbiamo controllato solo la prima chiave !)
- ci si ferma quando lo spazio di ricerca è ridotto ad un unico blocco, quindi dopo $[\log_2 a]$ accessi
>[!info] ricerca sveglia che puoi fare 
se $k>k1$, prima di ripetere la ricerca binaria, controlliamo tutti i valori del blocco che abbiamo caricato (che contiene $k1$).
>- se troviamo la chiave che copre $k$, abbiamo finito.
>- però, se $k>km$, con $km$ l’ultima chiave del blocco, non possiamo sapere se $k$ è coperta da $km$ o se è coperta da una chiave nei blocchi successivi. quindi si deve continuare con la ricerca binaria
## ricerca per interpolazione sul file indice
la ricerca per interpolazione è basata sulla conoscenza della distribuzione dei valori della chiave:
- deve essere disponibile una funzione $f$, che dati tre valori $k1, k2, k3$ della chiave, fornisce un valore che è la frazione dell’intervallo di valori della chiave compresi tra $k2$ e $k3$ in cui deve trovarsi $k1$($k1$ chiave di ricerca)
	- nella ricerca binaria, questa frazione è sempre $\frac{1}{2}$
la ricerca per interpolazione richiede circa $1 + \log_2 \log_2 m$ accessi, rendendola quindi molto più veloce, ma è molto difficile conoscere $f$ e poi la distribuzione dei dati potrebbe cambiare nel tempo
// non ci siamo soffermati molto su questa ricerca se ricordo bene
## inserimento
esistono diverse situazioni che influenzano il costo dell’insierimento di un record.
l’ inserimento richiede
- costo della ricerca
- 1 accesso per scrivere il blocco modificato(c’è spazio nel blocco)
- altrimenti, si controlla se c’è spazio nel blocco successivo, (se c’è non basta inserirlo, bisogna rispettare l’ordine del file principale, e quindi spesso spostare diversi record tra i 2 blocchi)
se non c’è spazio nè nel blocco precedente nè nel successivo, occorre richiedere un nuovo blocco al file system, ripartire i record tra il vecchio e il nuovo blocco(quando alloco un nuovo blocco, non metto un singolo record, ma ne metto diversi, per lasciare dello spazio libero) e riscrivere tutti i blocchi modificati
>[!example]- esempio di inserimento con richiesta di nuovo blocco
>![[Pasted image 20241213102439.png]]
>![[Pasted image 20241213102507.png]]
>![[Pasted image 20241213102541.png]]
## cancellazione
la cancellazione richiede:
- costo della ricerca
- 1 accesso per scrivere il blocco modificato, e in più:
	- se il record cancellato è il primo di un blocco, va modificato anche l’indice (1 accesso in scrittura)
	- se il record cancellato è l’unico del blocco, il blocco viene restituito al sistema e viene modificato anche l’indice (1 accesso in scrittura)
## modifica
la modifica richiede:
- costo della ricerca
- 1 accesso in scrittura sul blocco modificato
>[!important] se la modifica coinvolge la chiave, la modifica diventa cancellazione + inserimento
# file con record puntati
	- in questo modo, ogni record del file indice punta al primo blocco **di un bucket**(e i blocchi oltre al primo sono chiamati **liste di overflow**) e il file indicie non viene mai modificato (a meno che le dimensioni del bucket non siano diventate tali da dover richiedere una riorganizzazione dell’intero file)

consideriamo ora il caso in cui il file principale contiene dei record puntati (ovvero se, per mantenere l’ordine (logico, non fisico), ogni record puntasse ad un altro record, il successivo seguendo l’ordinamento in base alla chiave)

in questo caso, nella fase di inizializzazione è preferibile lasciare più spazio libero nei blocchi per successivi inserimenti, visto che poichè i record sono puntati, **non possono essere spostati** per mantenere l’ordinamento quando si inseriscono nuovi record (principalmente perchè vengono gestiti in un altro modo, non perchè è impossibile)
- se non c’è spazio sufficiente in un blocco B per l’inserimento di un nuovo record, occorre chiedere al sistema un nuovo blocco(**di overflow**) che viene collegato a B **tramite un puntatore** ( bisogna quindi tenere conto dello spazio del puntatore nei blocchi del file principale !)
## ricerca
la ricerca di un record con chiave $v$ richiede la ricerca di una chiave nel file principale che ricopre $v$, e poi la scansione del bucket corrispondente (**il file principale non è più ordinato !!**: è ordinato all’inizio, ma facendo operazioni non viene mantenuto l’ordine fisico, ma solo quello logico con i puntatori)
## cancellazione
la cancellazione di un record richiede la ricerca del record e poi la modifica dei bit di cancellazione nell’intestazione del blocco 
>[!info] conspiracy theory
>non credo abbia spiegato questa cosa, ma immagino che nell’itestazione del blocco (nel caso file con record puntati), visto che non è possibile veramente cancellare record(in quanto avremmo puntatori che puntano ai record sbagliati), esista un’area usata per tenere dei flag, tra cui se un dato record dovrebbe apparire cancellato
> edit: è scritto nelle slide di 2 powerpoint fa, dummy
>in questo caso, nella modifica avrebbe senso fare quello che è scritto nelle slide
## modifica
la modifica di un record richiede la ricerca del record, poi:
- se la modifica non coinvolge campi chiave, il record viene modificato
- altrimenti, la modifica equivale ad una cancellazione seguita da un inserimento (in questo caso, non è sufficiente modificare il bit di cancellazione del record cancellato, ma è necessario inserire in esso un puntatore al nuovo record inserito in modo che questo sia raggiungibile da qualsiasi record che contenga un puntatore al record cancellato(certo !!! molto meglio che modificare il puntatore di ogni record che puntava al record modificato/ cancellato !!))
>[!important] poichè non è possibile mantenere il file principale ordinato, se si vuole avere la possibilità di esaminare il file seguendo l’ordinamento della chiave, occorre inserire in ogni record un puntatore al record successivo nell’ordinamento
## indice secondario / denso
l’indice secondario è un **indice denso** (cioè esiste un record nell’indice secondario per ogni record del file principale) su un’altra chiave(**sempre univoca** ?)
- viene usato in caso si vuole ordinare anche su un’altra chiave
- anche queto indice è fatto a blocchi
- è possibile fare la ricerca binaria

>[!example] esempio1
supponiamo di avere un file con 150000 record. ogni record occupa 250 byte, di cui 50 per il campo chiave. ogni blocco contiene 1024 byte. un puntatore a blocco occupa 4 byte.
**a) se usiamo un indice ISAM sparso, e assumiamo che i record non siano puntati e che il fattore di utilizzo dei blocchi del file principale sia 0,7 (cioè i blocchi non sono completamente pieni, ma pieni al più 70%), quanti blocchi dobbiamo utilizzare per l’indice ?**
per sapere quanti blocchi sevono per l’indice, dobbiamo sapere quanti blocchi occupa il file:
$\frac{70}{100}\cdot 1024 = 716$ spazio massimo di un blocco
$\frac{716}{250} = 2,86 = 2$ (parte intera inferiore) (2 record per blocco)
$\frac{150.000}{2} = 75.000$ blocchi per file principale
ogni record del file indice ha dimensione $50 + 4 = 54$ byte.
$\frac{1024}{54} = 18,96 = 18$ record del file indice in un blocco
$\frac{75.000}{18}=4166,6 = 4167$ blocchi per il file indice
>
**b) se usiamo un indice ISAM sparso, e assumiamo che i record siano puntati e che i blocchi del file principale siano pieni, quanti blocchi dobbiamo utilizzare per l’indice ?**
$\frac{1024 -4}{250} = 4.08 = 4$ record del file principale per blocco ($1024 -4$ perchè record puntati, dobbiamo tenere in conto lo spazio per il puntatore in al prossimo blocco del bucket)
>$\frac{150.000}{4} = 37.500$ blocchi per file principale
ogni record del file indice ha dimensione $54$ byte
>$\frac{1024}{54} = 18,96 = 18$
> $\frac{37.500}{18} = 2083.3 = 2084$ blocchi per file indice
>
**c)se utilizziamo la ricerca binaria, quale è il numero massimo di accessi a blocco per ricercare un record presente nel file nei casi a) e b), supponendo nel caso b) di non avere liste di overflow ?**
 dobbiamo trovare $n \,\,\,\, \text{t.c.} \,\,\, 2^{n-1} < \text{numero di blocchi per file indice} \leq 2^{n}$, e poi aggiungere l’accesso in lettura del blocco del file principale
>nel caso a), notiamo che $2^{13} = 8912 > 4167  >2^{12} = 4096)$
>quindi, il numero massimo di accessi è $13 + 1= 14$
nel caso b), non avere liste di overflow signfica che non esistono bucket con 2 blocchi (credo)(cioè, i blocchi putatati dal file indice, pur avendo lo spazio per un puntatore, non puntano ad un altro blocco)
>il numero massimo di accessi è $12 + 1 = 13$


>[!info] spoken words
>- se non specificato diversamente, i blocchi sono pieni per intero
>- al più il 70%: in questo caso devo prendere la parte intera inferiore dopo aver calcolato qual’è il 70% dello spazio.
>- non abbiamo liste di overflow: ogni blocco non punta ad altri blocchi !
>- se non abbiamo liste di overflow: dobbiamo solo riservare spazio per un puntatore
>- se abbiamo snumero di liste di overflow medio: aggiungiamo quel numero ad ogni 
>- esercizio carino: senza modificare i tempi di accesso, qualè il massimo numero di record che posso memorizzzare ? in questo caso $2^{13} \cdot 18 \cdot 4$ (numero di blocchi possibili per il file indice per il numero di entrare per il file indice( ottengo il numero totale di blocchi in cui sono stored dei record del file principale), per il numero di record di ogni blocco)