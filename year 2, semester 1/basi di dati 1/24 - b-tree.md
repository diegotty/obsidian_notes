---
created: 2025-01-18T12:27
updated: 2025-02-20T09:38
---
>[!index]
>
>- [ricerca](#ricerca)
>	- [altezza di un b-tree](#altezza%20di%20un%20b-tree)
>- [inserimento](#inserimento)
>- [cancellazione](#cancellazione)
>- [modifica](#modifica)
# b-tree
anche in questo caso, si lavora su dati ordinabili per chiave univoca.
il b-tree nasce dalla generalizzazione della struttura di indice, creando più di livelli del file indice, in modo da poter accedere al file principale attraverso una gerarchia di indici. l’indice a livello più alto nella gerarchia, la **radice**, è **costituito da un unico blocco**, e quindi può risiedere in memoria principale durante l’utilizzo del file.

ogni blocco di un file indice è costituito di record contenenti una coppia $(v,b)$ dove $v$ è il valore della chiave del primo record della porzione del file principale che è accessibile attraverso il puntatore $b$
- $b$ può essere un puntatore ad un blocco del file indice a livello immediatamente più basso, oppure ad un blocco nel file principale
- il primo record indice di ogni blocco indice contiene solo un puntatore ad un blocco (le cui chiavi sono minori di quelle del blocco puntato dal secondo record indice)
- un blocco del file principale è memorizzato come quello di un ISAM
- ogni blocco di un b-tree (indice o file principale), deve essere **pieno almeno al 50%** (quindi per metà della taglia)
	- la radice non ha questo vincolo, l’importante è che sia in un unico blocco

>[!info] rappresentazione b-tree
![[Pasted image 20241213114903.png]]
> questo disegno è fatto proprio con i piedi, capiamo:
> - il primo quadrato di ogni blocco è per il puntatore
> - ogni altro quadrato fa parte di un rettangolo (di lunghezza 2 quadrati), che infatti comprende valore e puntatore.
> - anche questa spiegazione è scritta con i piedi però vabbè

>[!important] ogni record di un file indice, ha una chiave che ricopre quelle del sottoalbero che parte dal blocco puntato
![[Pasted image 20241213115342.png]]
## ricerca
durante la ricerca di un record con un dato valore della chiave, si accede agli indici a partire da quello più alto, e si segue il puntatore del record con la chiave che copre il valore di ricerca, findo ad arrivare ad un unico blocco, del file principale.
per la ricerca sono necessari $h+1$ accessi, dove $h$ è **l’altezza dell’albero**

### altezza di un b-tree
l’altezza minima del b-tree è ottenuta quando tutti i blocchi sono pieni, mentre l’altezza massima è ottenuta quando ho il minimo numero di record per ogni blocco.
- se i blocchi, però, sono completamente pieni, un inserimento può richiedere una modifica dell’indice ad ogni livello e in ultima ipotesi può far crescere l’altezza dell’albero di un livello !!! (that would suck, man)
>[!example]- esempio catastrofico di inserimento
 si vuole inserire il record con chiave 40 in questo b-tree
 ![[Pasted image 20241213170159.png]]
 per forza di cose, arriviamo a questa forma del b-tree:
 ![[Pasted image 20241213170228.png]]

qual’è il valore massimo $k$ che può assumere l’altezza $h$ ?
$\log_{d}\left( \frac{N}{e} \right)$
ngl non mi andava di scrivere tutto il ragionamento
\\TODO
## inserimento
l’inserimento richiede:
- $h+1$ accessi (costo di una ricerca per ricercare il blocco in cui deve essere inserito il record)
- +1 accesso per riscrivere il blocco del file principale
- altrimenti, se nel blocco **non c’è** spazio sufficiente per inserire il record: $+s$ accessi ($s≤2h+1$) 
	- nel caso peggiore, per ogni livello dobbiamo sdoppiare un blocco: il che vuol dire  effettuare 1 accesso sul blocco presente, e 1 sul blocco nuovo richiesto(entrambi gli accessi in scrittura), più 1 alla fine per la nuova radice
## cancellazione
la cancellazione richiede:
- $h+1$ accessi (costo di una ricerca per trovare il blocco in cui si trova il record)
- +1 accesso per riscrivere il blocco, se il blocco **rimane pieno almeno per metà dopo la cancellazione**, altrimenti sono necessari ulteriori accessi
>[!example]- esempio catastrofico di cancellazione
si vuole cancellare il record con chiave 28
![[Pasted image 20241213172042.png]]
l’operazione, conclusa correttamente, modifica il b-tree in questo modo:
![[Pasted image 20241213172117.png]]
## modifica
la modifica richiede: 
- $h+1$ (costo di una ricerca)
- +1 accesso per riscrivere il blocco se la modifica non coinvolge campi della chiave
- altrimenti modifica = costo cancellazione + costo inserimento
>[!info] osservazioni
per il file principale:
>- se il numero di record massimo che possiamo memorizzare è dispari, quindi esprimibile nella forma $2E-1$, possiamo direttamente considerare $E$ come occupazione minima !
>- se invece il numero di record massimo è pari, quindi esprimibile nella forma $2E$, possiamo direttamente considerare $E+1$ come occupazione minima **TRANNE** nel caso in cui ogni record occupa $t$ byte, ed  $E \cdot t$, è esattamente la metà dei byte disponibili nel blocco. in quel caso, l’occupazione minima è $E$
>**x sicurezza, verificare !!!**

>[!info] osservazioni 2
per il file indice:
>- valgono grosso modo le stesse considerazioni, ma bisogna considerare il fatto che nei file indice il primo record ha sempre solo la dimensione di un puntatore.

>[!example] esempio1
supponiamo di avere un file di 170.000 record. ogni record occupa 200 byte, di cui 20 per il campo chiave. ogni blocco contiene 1024 byte. un puntatore a blocco occupa 4 byte.
se usiamo un b-tree e assumiamo che sia i blocchi indice che i blocchi del file principale sono pieni al **minimo**:
**quanti blocchi vengono usati per il livello foglia (file principale) e quanti per l’indice, considerando tutti i livelli non foglia ?**
$\frac{1024}{200} = 5$ quindi il minimo numero di record in un blocco è 3 (foglia)
$\frac{170.000}{3} = 56.666.6666 = 56.667$ blocchi usati per livello foglia
il primo livello di indice contiene un record per ogni blocco del file principale:$1024$
calcoliamo la capacità dei blocchi indice:
$20 + 4 = 24$ byte per record nel file indice
$\frac{{1024 -4}}{24}+1=43$ max entry per indice (calcoliamo il numero di entry senza contare la prima (e quindi togliendo lo spazio che occupa, 4 byte), e poi la aggiungiamo al calcolo, in quanto è sempre una entry !)
quindi $43 = (2 \cdot 22)-1$, e il numero di record minimo è $23$
al primo livello di indice avremo un record per ogni blocco del file principale, quindi:
$\frac{56.667}{23}=2463,7 = 2464$
al secondo livello avremo un record per ogni blocco del primo livello di indice, quindi:
>$\frac{2464}{23} = 107,13 = 108$
al terzo livello avremo un record per ogni blocco del secondo livello indice, quindi:
$\frac{108}{23} = 5$
al quarto livello avremo un record per ogni blocco del terzo livello di indice, e visto che $5<23$, tutti i record entrano in un blocco, e il quarto livello è la radice
>
>**qual è il costo di una ricerca in questo caso ?**
il costo della ricerca sarà $4+1=5$(1 accesso per ogni livello indice + 1 per il blocco del file principale)

