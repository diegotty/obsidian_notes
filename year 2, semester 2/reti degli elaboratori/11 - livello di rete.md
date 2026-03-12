---
created: 2025-05-06T13:13
updated: 2025-06-19T19:04
---
>[!index]
>- [funzioni chiave del livello di rete](#funzioni%20chiave%20del%20livello%20di%20rete)
>- [switching](#switching)
>	- [reti a circuito virtuale](#reti%20a%20circuito%20virtuale)
>		- [ATM (lore)](#ATM%20(lore))
>	- [reti a datagramma](#reti%20a%20datagramma)
>- [switch e router](#switch%20e%20router)
>- [link-layer switch](#link-layer%20switch)
>- [router](#router)
>	- [porte d’ingresso](#porte%20d%E2%80%99ingresso)
>	- [tecniche di commutazione](#tecniche%20di%20commutazione)
>	- [porte d’uscita](#porte%20d%E2%80%99uscita)
>	- [capacità dei buffer](#capacit%C3%A0%20dei%20buffer)
>- [protocolli del livello di rete](#protocolli%20del%20livello%20di%20rete)
>- [IPv4](#IPv4)
>- [frammentazione](#frammentazione)
>	- [bit di intestazione](#bit%20di%20intestazione)

abbiamo visto, durante una prima visione della pila TCP/IP, che il livello di rete si occupa dell’instradamento dei datagrammi dall’origine al destinatario. approfondiamo !
>[!example] esempio di funzionamento del livello rete
![[Pasted image 20250409185452.png]]
>- il livello di rete di H1 prende i segmenti dal livello di trasporto, li incapsula in un datagramma, e li trasmette al router più vicino
>- il livello di rete di H2 riceve i datagrammi da R7, estrae i segmenti e li consegna al livello di trasporto
>- il livello di rete dei nodi intermedi inoltra verso il prossimo router
## funzioni chiave del livello di rete
il livello di rete si occupa di capire, quando un router riceve un pacchetto, a chi inviarlo per farlo arrivare al destinatario. le sue funzioni chiave sono 2:
- **instradamento** (routing): determina il percorso seguito dai pachetti dall’origine alla destinazione (costruisce le rotte)
- **inoltro** (forwarding): decide su quale porta di uscita deve essere immesso il pacchetto in base a quanto stabilito dal routing (utilizza il percorso definito dal routing)

>[!info] routing e forwarding
![[Pasted image 20250409190036.png]]
>le **forwarding table** vengono quindi generate dal **routing algorithm**, e vengono consultate per capire a chi inoltrare il pacchetto
>- la porta di uscita viene scelta in base all’IP di destinazione
## switching
esistono 2 approcci per lo **switching** (word that sounds like a sexual practice)
### reti a circuito virtuale
nell’approccio a **circuito virtuale**, prima che i datagrammi fluiscano, i due sistemi terminali e i router intermedi stabiliscono una connessione virtuale
un circuito virtuale consiste in:
1. un percorso tra gli host di origine e destinazione
2. numeri VC, uno per ciascun collegamento (link)
3. righe nella tabella d’inoltro in ciascun router
ogni pacchetto di un circuito virtuale ha un **numero VC** (chiamata anche etichetta di circuito) nella propria intestazione, ed ogni router sostituisce il numero VC con un nuovo numero.

>[!info] tabella d’inoltro
![[Pasted image 20250410074142.png]]
oltre a questi campi, i router mantengono le informazioni sullo stato delle connessioni ! aggiungono alla tabella una nuova riga ogni volta che stabiliscono una nuova connessione, e la cancellano quando viene rilasciata (connessione tra un router e un terminale/altro router)

>[!example] rete a circuito virtuale
![[Pasted image 20250409192031.png]]
#### ATM (lore)
la **ATM** (asynchronous transfer mode) è una rete orientata alla connessione progettata nei primi anni 90, con lo scopo di unificare voce, dati, televisione via cavo, etc.
- viene attualmente usata nella rete telefonica per trasportare (internamente) i pacchetti IP
- le connessioni vengono chiamate **circuiti virtuali** (in analogia con quelli telefonoci, che sono circuiti fisici)

### reti a datagramma
le reti a datagramma **non** sono orientate alla connessione, ed ogni datagramma viaggia indipendente dagli altri
- **Internet** è una rete a datagramma !
non esiste un concetto di “connessione” a livello di rete, ed i router non conservano informazioni sullo stato dei circuiti virtuali
- i pacchetti vengono inoltrati utilizzando l’indirizzo dell’host destinatario, e passano attraverso una serie di router, che utilizzano gli indirizzi di destinazione per inviarli e possono intraprendere percorsi diversi !
>[!info]- tabella di inoltro
![[Pasted image 20250410075354.png]]
la tabella di inoltro è gestita creando dei bucket per gli indirizzi (che sappiamo avere dimensione di 4 byte), con questa logica:
![[Pasted image 20250410075515.png]]
ma in modo più efficiente: confrontando il prefisso dell’indirizzo:
![[Pasted image 20250410080138.png]]
>- se si verificano corrispondenze multiple, si prende la corrispondenza a prefisso più lungo

>[!example] rete a datagramma
![[Pasted image 20250410075303.png]]
>i pacchetti possono arrivare fuori ordine !
# switch e router
**packet switch** (commutatore di pacchetto): dispositivo che si occupa del trasferimento dall’interfaccia di ingresso a quella di uscita, in base al valore del campo dell’intestazione del pacchetto.
noi studieremo (per ora ? ) 2 tipi di packet switch:
- **router**: stabiliscono l’inoltro in base al valore del campo (indirizzo IP) nel livello di rete (livello 3)
- **link-layer switch** (commutatore a livello di collegamento): stabiliscono l’inoltro in relazione al valore del campo (indirizzo MAC) nel livello di collegamento (link / livello2)
>[!example] esempio !
![[Pasted image 20250409191012.png]]
>immagino che un link-layer switch sia più veloce (in quanto deve risalire meno pila TCP/IP) 

## link-layer switch
viene utilizzato per collegare singoli computer all’interno di una rete LAN, ed instrada pacchetti al livello 2
>[!info] idk what this image is trying to depict but definitely aesthetic
![[Pasted image 20250409191220.png]]
>in pratica è un switch collegato ad un ethernet e tanti host (?)
## router
instrada i pacchetti al livello 3, da uno dei suoi link entranti ad uno dei suoi link uscenti: al **next hop** nel percorso origine-destinazione
>[!info] autoesplicativo
![[Pasted image 20250409191709.png]]

>[!info] architettura del router
![[Pasted image 20250410080457.png]]

### porte d’ingresso
>[!info] porte d’ingresso
![[Pasted image 20250410081344.png]]
la **commutazione decentralizzata** determina la porta d’uscita dei pacchetti utilizzando le informazioni della tabella d’inoltro (**ogni porta d’ingresso ha una copia della tabella !**)
>- l’obiettivo è quello di completare l’elaborazione allo stesso **tasso** della linea (evitando quindi colli di bottiglia). l’accodamento accade se il tasso di arrivo dei datagrammi è superiore a quello di inoltro !
>una volta determinata la porta di uscita, il pacchetto verrà inoltrato alla struttura di commutazione

la ricerca nella tabella di inoltro deve essere quindi veloce (sempre per evitare accodamenti). implementa una **struttura ad albero**: ogni livello dell’albero corrisponde ad un bit dell’indirizzo di destinazione
- per cercare un indirizzo si comincia quindi dalla radice e si sceglie sottoramo sinistro se il bit è 0 e destra se il bit è 1. la ricerca finirà in $N$ passi, con $N$ il numero di bit dell’indirizzo
>[!warning] gli IP address lookup algorithms è un argomento molto studiato ! 
### tecniche di commutazione
studiamo ora i modi per far attraversare un pacchetto dalla porta di ingresso alla porta di uscita:
>[!info] commutazione in memoria
utilizzata dall prima generazione di router: il pacchetto veniva copiato nella memoria del processore (il router ha un processore) e veniva trasferito dalla porta d’ingresso alla porta d’uscita
![[Pasted image 20250410082409.png]]

>[!info] commutazione tramite bus
>le porte d’ingresso trasferiscono un pacchetto direttamente alle porte d’uscita su un bus condiviso, senza intervento del processore di instradamento
>- si può trasferire solo un pacchetto alla volta, e i pacchetti che arrivano e trovano il bus occupato vengono accodati alla porta d’ingresso
>
in questo modo, **la larghezza della banda di commutazione è limitata da quella del bus**
> - per esempio, cisco 5600 opera con bus da 32gbps, ed è sufficiente per router che operano in reti d’accesso o aziendali
>
![[Pasted image 20250410082452.png]]

>[!info] commutazione attraverso rete d’interconnessione
>questo modo di commutare i pacchetti supera il limite di banda di un singolo bus condiviso: usa un **crossbar switch**, una rete d’interconnessione che consiste in $2n$ bus che collegano $n$ porte d’ingresso a $n$ porte d’uscita
>- inoltre, si tende a frammentare i pacchetti IP a lunghezza variabile in celle di lunghezza fissa (vengono poi riassemblati nella porta di uscita) (nn capisco bene cosa c’entri ngl)
![[Pasted image 20250410083053.png]]

### porte d’uscita
>[!info] porte d’uscita
![[Pasted image 20250410083444.png]]
le porte d’uscita gestiscono:
>- **funzionalità d’accodamento**: necessarie quando la struttura di commutazione consegna pacchetti alla porta d’uscita a una frequenza che supera quella del collegamento uscente
>- **schedulatore di pacchetti**: stabilisce in quale ordine trasmettere i pacchetti accodati

l’accodamento si può verificare sia nelle porte d’ingresso che nelle porte d’uscita:
- **accodamento nelle porte d’ingresso**: quando la velocità dei commutazione è inferiore a quella delle porte d’ingresso (per non avere accodamento, la velocità di commutazione dovrebbe essere $n \cdot(\text{velocità della linea d'ingresso})$)
- **accodamento nelle porte d’uscita**: quando la struttura di commutazione ha un rate superiore alla porta d’uscita (o quando troppi pacchetti vanno sulla stessa porta d’uscita !)
>[!info] accodamento sulle porte di ingresso
**head-of-the-line blocking**: un pacchetto nella coda d’ingresso deve attendere il trasferimento (anche se la propria destinazione è libera) in quanto risulta essere bloccato da un altro pacchetto in testa alla fila
![[Pasted image 20250410152830.png]]
>- in questo caso, i due pacchettti rossi all’inizio delle due code si contendono la porta d’uscita: il pacchetto verde subisce **HOL blocking** !

>[!info] accomodamento sulle porte di uscita
se la struttura di commutazione (switch fabric) ha un rate superiore a quello della porta di uscita, si può verificare un accodamento !
può succedere ance se troppi pacchetti vanno sulla stessa uscita
![[Pasted image 20250410164600.png]]

### capacità dei buffer
per diversi anni si è seguita la regola definita in RFC 3439: la quantità di buffering dovrebbe essere uguale a una media del tempo di andata e ritorno (RTT) per la capacità del collegamento c

attuali raccomandazioni dicono che la quantità di buffering recesssaria per $N$ flussi TCP è:
$$
\frac{RTT \cdot c}{\sqrt{ N }}
$$

>[!warning] **se le code diventano troppo lunghe, i buffer si possono saturare e quindi causare una perdita di pacchetti !**
vale sia per l’accodamento in entrata che in uscita
# protocolli del livello di rete
>[!info] immagine canonica
![[Pasted image 20250410093426.png]]
>- **DHCP**: Dynamic Host Configuration Protocol (implementa funzioni del livello di rete, ma viene implementato a livello applicazione)
>- **IP**: Internet Protocol (v4 o v6)
> - **IGMP**: Internet Group Management Protocol (multicasting)
>  - **ICMP**: Internet Control Message Protocol (gestione errori)
>- **ARP**: Adress Resolution Protocol (associazione indirizzo IP - indirizzo collegamento (?))

## IPv4
il protocollo **IP** è responsabile della suddivisione in pacchetti, del forwarding, e della consegna dei datagrammi al livello di rete (host to host)
- è inaffidabile, senza connessione, e basato su datagrammi
- offre un servizio di consegna best effort
>[!info] formato dei datagrammi
![[Pasted image 20250410095450.png]]
>- **numero di versione**: 4 o 6 (IPv6 o IPv6)
>- **lunghezza dell’intestazione**: poichè un datagramma IP può contenere un numero variabile di opzioni, questi bit indicano dove inzia il campo dati (un intestazione senza opzioni ha dimensione 20byte)
>- **tipo di servizio**: serve per distinguere diversi datagrammi con requisiti di qualità del servizio diverse (?)
>- **lunghezza del datagramma**: rappresenta la lunghezza totale in byte del datagramma IP, inclusa l’intestazione (in genere, non superiore a 1500byte). serve per capire se il pacchetto è arrivato completamente  !
>- **identificatore, flag e offset**: sono usati per gestire la frammentazione dei pacchetti
>- **TTL/tempo di vita**: è incluso per assicurare che i datagrammi non restino in circolazione per sempre nella rete (per esempio, in caso di instradamento ciclico). il campo viene infatti decrementato ad ogni hop e se `TTL == 0` il datagramma viene eliminato
>- **protocollo**: indica il protocollo a livello di trasporto al quale va passato il datagramma, e viene utilizzato solo quando il datagramma raggiunge la destinazione finale
>	- `6: TCP`, `17: UDP`, `1: ICMP`, `2: IGMP`, `89: OSPF`
>- **checksum dell’intestazione**: consente ai router di rilevare errori sui datagrammi ricevuti. viene calcolato solo sull’intestazione, e ricalcolata nei router intermedi (checksum TCP/UDP viene invece calcolato sull’intero segmento)
>- **indirizzi IP di origine e destinazione**: inseriti dall’host che crea il datagramma, **dopo aver effettuato una ricerca DNS**
>- **opzioni**: campi che consentono di estendere l’intestazione IP (usate per test o debug della rete)
>- **dati**: contiene il segmento di trasporto da consegnare alla destinazione
## frammentazione
un datagramme IP può dover viaggiare attraverso varie reti, ognuna con caratteristiche diverse. sappiamo inoltre che ogni router estrae il datagramma dal frame, lo elabora e lo incapsula in un nuovo frame
la **MTU** (maximum transfer unit) è la massima quantità di **dati** (payload) che un frame al **livello di collegamento** può trasportare, e varia in base alla tecnologia usata
>[!info] MTU
![[Pasted image 20250410100736.png]]

quindi diversi tipi di link possono comportare differenti MTU
in questo caso, i datagrammi IP grandi vengono **frammentati**, cioè suddivisi in datagrammi IP più piccoli.
- i frammenti del datagramma verranno riassemblati solo una volta raggiunta la destinazione (devono infatti essere riassemblati prima di raggiungere il livello trasporto)
- i bit dell’intestazione IP sono usati per identificare e ordinare i frammenti 
>[!example]- esempio
![[Pasted image 20250410101123.png]]

### bit di intestazione
quando un host di destinazione riceve una serie di datagrami dalla stessa origine, deve:
- individuare i frammenti
- determinare quando ha ricevuto l’ultimo
- stabilire come debbano essere riassemblati
per fare ciò usa:
**identificatore a 16bit**: identificativo associato a ciascun datagramma al momento della creazione (unico per tutti i frammenti)
- IP + identificatore a 16bit identificano in modo univoco un datagramma
**3 bit di flag**:
- riservato
- do not fragment: 1 non frammentare, 0 si può frammentare
- more fragments (M): settato ad 1 nei frammenti intermedi, settato a 0 per l’ultimo frammento
**offset** (scostamento laterale): specifica l’ordine del frammento all’interno del datagramma originario
>[!info] offset
![[Pasted image 20250410180527.png]]
![[Pasted image 20250410180858.png]]
dato che vengono trasferiti 2 pacchetti in più, vengono trasferiti 40 byte in più (i due header aggiuntivi)

>[!example] esempio di frammentazione e riassemblaggio
![[Pasted image 20250410181116.png]]
>- il primo frammento ha un valore del campo offset pari a 0
>- l’offset del secondo segmento si ottiene dividendo per 8 la lunghezza del primo frammento (esclusa l’intestazione)
>- il valore del terzo frammento si ottiene dividendo per 8 la somma della lunghezza del primo e del secondo frammento (escluse se intestazioni)
>- …..
>- l’ultimo frammento ha il bit M impostato a 0

protocolli ICMP, IGMP, OSPF usano tutti il protocollo IP anche se sono a livello di rete