---
related to: "[[17 - livello di collegamento]]"
created: 2025-05-20T08:58
updated: 2025-06-19T19:04
completed: true
---
>[!index]
>- [indirizzi MAC](#indirizzi%20MAC)
>- [protocollo ARP](#protocollo%20ARP)
>	- [procollo ARP nella stessa sottorete](#procollo%20ARP%20nella%20stessa%20sottorete)
>	- [formato del pacchetto ARP](#formato%20del%20pacchetto%20ARP)
>	- [indirizzamento](#indirizzamento)
>	- [LAN cablate : ethernet](#LAN%20cablate%20:%20ethernet)
>	- [IEEE 802](#IEEE%20802)
>- [ethernet](#ethernet)
>	- [ethernet standard](#ethernet%20standard)
>	- [fasi operative del protocollo CSMA/CD](#fasi%20operative%20del%20protocollo%20CSMA/CD)
>	- [fast ethernet](#fast%20ethernet)
>		- [soluzioni per CSMA/CD](#soluzioni%20per%20CSMA/CD)
>	- [gigabit ethernet](#gigabit%20ethernet)
>- [switch](#switch)
>	- [autoapprendimento](#autoapprendimento)
>- [VLAN](#VLAN)
>	- [VLAN trunking](#VLAN%20trunking)
>
# indirizzi MAC
anche chiamato indirizzo **fisico/ethernet/LAN**, è un indirizzo di 6 byte, che rappresenta **univocamente** ciascun **adattore** (scheda di rete) di una LAN
- quando un datagramma passa dal livello di rete al livello di collegamento, viene incapsulato in un frame con una intestazione che contiene gli **indirizzi di collegamento** (MAC) della sorgente e della destinazione del frame (non del datagramma !!)
>[!tip] differenza con indirizzi IP
gli indirizzi IP sono usati a livello di rete, e individuano con esattezza i punti di internet dove sono connessi gli host sorgente e destinazione

>[!info] indirizzi MAC
![[Pasted image 20250510184554.png]]

>[!info] come funziona il biz
![[Pasted image 20250510185415.png]]
notiamo che:
>- ogni stazione (adattatore/scheda di rete) ha un’indirizzo MAC
>- ogni router(/switch ) ha un indirizzo MAC per ogni interfaccia (porta)
>- l’host inoltra il messaggio all’indirizzo MAC del prossimo hop, non all’indirizzo MAC del destinatario !
>	- ciò accade per ogni hop

la IEEE sovraintende la gestione degli indirizzi MAC:
- quando una società vuole costruire adattatori, compra un blocco di spazio di indirizzi (che sono unici e univoci)
con gli indirizzi MAC è possibile comunicare direttamente tra dispositivi (in una LAN, rete locale) a livello di collegamento, senza passare da un livello superiore
- è una comunicazione peer-to-peer, dove le stazioni utilizzano gli indirizzi MAC per comunicare
- è “orizzontale” perchè non prevede gerarchie: nessun router o server centrale è necessario !
- gli indirizzi IP invece hanno una struttura gerarchica, e deveono essere aggiornati se spostati (?)
# protocollo ARP
il protocollo **ARP** (**address resolution protocol**) permette ad una sorgente di determinare gli indirizzi di collegamento della destinazione
	ogni **nodo IP**  (host, router) nella LAN ha una **tabella ARP**, che contiene la corrispondenza tra indirizzi IP e MAC. i suoi record sono del tipo
$$
<\text{indirizzo IP; indirizzo MAC; TTL}>
$$
in cui $\text{TTL}$ indica quando bisognerà eliminare una data voce nella tabella (il tempo di vita tipico è 20min.)
>[!example] esempio di tabella ARP
![[Pasted image 20250510190812.png]]

## procollo ARP nella stessa sottorete
>[!info] indirizzo mancante nella tabella ARP
![[Pasted image 20250510191003.png]]
>- $A$ vuole inviare un datagramma a $B$, e l’indirizzo MAC di $B$ non è nella tabella ARP di $A$
>- $A$ trasmette in un **pacchetto broadcast** il messaggio di richiesta ARP, contentente l’indirizzo IP di $B$
>	- l’indirizzo MAC del destinatario sarà `FF-FF-FF-FF-FF-FF` (indirizzo MAC di broadcast), e tutte le macchine della LAN riceveranno una richiesta ARP
> - solo il nodo con l’indirizzo IP specificato risponderà, comunicando ad $A$ il proprio indirizzo MAC
> 	- il frame viene inviato all’indirizzo MAC di $A$, in unicast
![[Pasted image 20250510191415.png]]

ARP è “plug-and-play”, in quanto la tabella ARP si costruisce automaticamente e non deve essere configurata dall’amministratore di sistema 
## formato del pacchetto ARP
>[!info]
>![[Pasted image 20250510191520.png]]
> - i protocol address sono indirizzi IP
> - gli hardware address sono indirizzi MAC

>[!example] esempio
![[Pasted image 20250510191545.png]]
## protocollo ARP per host in sottoreti diverse
l’indirizzamento è usato per inviare verso un nodo esterno alla sottorete
>[!info]- flusso di pacchetti dalla sorgente (riassunto corso ngl)
![[Pasted image 20250510191819.png]]
fuoco !!!!!!!!

>[!example] esempio
consideriamo la seguente richiesta HTTP da $A$ verso $B$, `http://dagabriele.biz/prodotti`
![[Pasted image 20250510191828.png]]
>
>il seguente è il flusso di pacchetti nella stazione sorgente: 
![[Pasted image 20250510192234.png]]
>
>il seguente è il flusso di pacchetti nel router $R1$:
![[Pasted image 20250510192122.png]]
>
>il seguente è il flusso di pacchetti nella stazione di destinazione:
![[Pasted image 20250510192432.png]]

>[!warning] comunicazione tra dispositivi in reti diverse
>tldr: l’host fa una ARP request per ottenere il MAC dell’access point (router collegato all’ISP), mette quella nel frame e lo manda al router
>ogni router fino all’access point del destinatario, modificherà l’indirizzo MAC di destinazione e di sorgente (il sorgente diventa il MAC del router), facendo una richiesta ARP sull’interfaccia che porta al next hop (informazione che risiede nelle routing table), ottenendo il MAC del next hop e inserendolo come destinatario
## LAN cablate : ethernet
nel 1985, la **IEEE computer society** (*nerds*) iniziò un progetto chiamato **progetto 802**, con l’obiettivo di definire uno standard per l’interconnessione tra dispositivi di produttori differenti
- lo scopo era di definire le funzioni del livello fisico e di collegamento dei protocolli LAN
il risultato fu il critically acclaimed and grammy nominated **standard IEEE 802**
## IEEE 802
raggruppa gli standard prodotti da IEE per le LAN. include: 
- specifiche generali del progetto (802.1)
- logical link control (LLC, 802.2)
- CSMA/CD (802.3)
- token bust (802.4, destinato a LAN per automazione industriale)
- token ring (802.5)
- DQDB (802.6, destinato alle MAN)
- WLAN (802.11)
i vari standard differiscono a livello fisico e nel [[17 - livello di collegamento#media access control|sottolivello MAC]], ma sono compatibili a livello **data link**
>[!info] rappresentazione
![[Pasted image 20250510194252.png]]

# ethernet
l’ethernet è la tecnologia di rete (un protocollo di livello collegamento) che consente la comunicazione tra dispositivi in una LAN, e detiene una posizione dominante nel mercato delle LAN cablate, ed è stata la prima LAN ad alta velocità, con vasta diffusione
- è più semplice e meno costosa di token ring, FDDI e ATM, ma rimane al passo dei tempi con il tasso trasmissivo: si va dall’ethernet standard (10mpbs) al 10 gigabit ethernet (10gbps)
>[!info] ethernet STANDARD
![[Pasted image 20250510194556.png]]
## ethernet standard
l’ethernet standard è:
- **senza connessione**: non è prevista alcuna forma di handshake preventiva con il destinatario prima di inviare un pacchetto
- **non afidabile** (come IP e UDP): la scheda di rete ricevente non invia un riscontro
>[!info] formato dei frame
![[Pasted image 20250510195137.png]]
> - **preambolo** (7 byte): tutti e 7 i byte hanno i bit `10101010`. serve per attivare le **NIC** (scheda di rete) dei riceventi e sincronizzare i loro orologi con quello del trasmittente, infatti fa parte dell’header del livello **fisico** !
> - **SFD** (**start frame delimiter**) (1 byte): di valore `10101011`, è il flag che definisce l’inizio del frame (è l’ultima possibilità di sincronizzazione, e gli ultimi due bit `11`indicano che inizia l’header MAC)
> - **indirizzi sorgente e destinazione** (6 byte): quando la scheda di rete riceve un pacchetto contenente il proprio indirizzo di destinazione o l’indirizzo broadcast(es: un pacchetto ARP), trasferisce il contenuto del campo dati del pacchetto al livello di rete, altrimenti i pacchetti con altri indirizzi MAC vengono ignorati
> - **tipo** (2 byte): per multiplexing/demultiplexing, indica il protocollo di livello rete del pacchetto incapsulato nel frame (IP, ARP, OSPF, etc.)
> - **dati** (da 46 a 1500 byte): contiene il datagramma di rete. se il datagramma ha dimensione minore della dimensione minima (46 byte), viene `zfill`- ato
> - **CRC** (4 byte): consente alla scheda di rete ricevente di rilevare la presenza di un errore nei bit sui campi di indirizzo, tipo e dati (idk how)
>
>contando i 18 byte di intestazione e trailer, la lunghezza minima del frame è di 64 byte  (necessaria per il corretto funzionamento del CSMA/CD), mentre la lunghezza massima del frame è di 1518 byte (necessaria per evitare che una stazione possa monopolizzare il mezzo, e per ragioni storiche (permetteva di ridurre la memoria necessaria nei buffer dei dispositivi, quando la memoria era molto costosa))

>[!tip] ovviamente
>tutte le stazioni che fanno parte di una ethernet sono dotate di NIC/scheda di rete, in quanto esse forniscono un indirizzo di livello di rete e livello di collegamento
> - gli indirizzi vengono trasmessi da sinistra verso destra, byte per byte, ma per ciascun byte il LSB viene inviato per primo e il MSB per ultimo

### fasi operative del protocollo CSMA/CD
1. **framing**: la NIC riceve un datagramma di rete dal nodo collegato e prepara un frame ethernet
2. **carrier sense e trasmissione**: se il canale è inattivo (viene misurato il livello di energia sul mezzo trasmissivo per un breve periodo di tempo, tipo 100 nanoscondi), inizia la trasmissione. se il canale risulta occupato, resta in attesa fino a quando non rileva più il segnale (e a quel punto trasmette)
3. **collision detection**: verifica, durante la trasmissione, la presenza di eventuali segnali provenienti da altre NIC. se non ne rileva, considera il pacchetto spedito
4. **jamming**: se rileva segnali da altre NIC, interrompe immediatamente la trasmissione del paccheto e invia un segnale di disturbo (fuck it, jam di 48bit per avvisare le altre NIC in fase di trasmissione della collisione)
5. **backoff esponenziale**: la NIC rimane in attesa. quando riscontra l’$n$-esima collisione consecutiva, stabilisce un valore $k$ tra $\{0, 1, 2, \dots,2^m-1\}$, dove $m = min(n, 10)$. la NIC aspetta un tempo pari a $k$ volte 512 bit, e ritorna al passo 2.
	- un tentativo per stimare quanti sono le NIC coinvolte (se sono numerosi, il tempo di attesa potrebbe essere lungo)

## fast ethernet
l’ethernet standard si è evoluta a **fast ethernet** (100mbps), mantenendo compatibilità con la versione precedente
in questa versione, il sottolivello MAC rimase invariato, compreso il formato del frame e le sue dimensioni, ma ci furono problemi con il funzionamento di CSMA/CD, in quanto il funzionamento dipende dalla velocità di trasmissione, dalla dimensione minima del frame, e dalla lunghezza massima della rete
- se la trasmissione è 10 volte più veloce, e il frame è ancora di 512 bit, allora le collisioni devono essere rilevate 10 volte più velocemente, quindi la rete deve essere 10 volte più corta ! (in quanto per  rilevarle più velocemente, devo avere un tempo di trasmissione minore, e per avere un tempo di trasmissione minore, devo avere un tempo di propagazione minore (che si ottiene rendendo il canale più corto (anche se in teoria dovrebbe già essere minore perchè nella formula aumenta la velocità ???? i am confused ngl) ) )
### soluzioni per CSMA/CD
>[!info] prima soluzione
![[Pasted image 20250510202623.png]]
abbandonare la topologia a stella, e utilizzare un hub passivo con topologia a stella ma fissare la dimensione massima della rete a 250 metri, invece che 2500 metri della versione standard
>l’hub (ripetitore multi-porta) è un dispositivo che opera sui singoli bit:
>-  opera a livello fisico e all’arrivo di un bit, lo riproduce incrementandone l’energia e lo trasmette attraverso tutte le sue interfacce
>- ripete il bit entrante su tutte le interfacce uscenti, anche se su qualcuna di queste c’è un segnale (huh ? pericoloso)
>- trasmette in broadcast, e quindi ciascuna NIC può sondare il canale per verificare se è libero e rilevare una connessione mentre trasmette
>	- quindi quando una stazione trasmette, il suo messaggio viene trasmesso in broadcast a tutte le altre stazioni per far capire che la linea è occupata

>[!info] seconda soluzione
si usa uno **switch** di collegamento dotato di buffer per memorizzare i frame e connessione full-duplex per ciascun host (una coppia di host può comunicare simultaneamente in entrambe le direzioni)
> - il singolo mezzo condiviso viene quindi modificato in molti mezzi punto-punto !
> - in questo modo, il mezzo trasmissivo è privato per ciascun host, e non c’è bisogno di usare CSMA/CD dal momento che gli host non sono più in competizione
lo switch riceve un frame da un’host, lo memorizza nel buffer, verifica l’indirizzo di destinazione e invia il frame attraverso l’interfaccia corrispondente
## gigabit ethernet
versione successiva al fast ethernet, permette velocità di 1000mpbs (e successivamente, con la fibra ottica, si arriva alla 10 gigabit ethernet !)
- viene gestita con una topologia a stella con switch
- garantisce no collisioni
# switch
gli switch sono dispositivi che operano a livello di collegamento, e si occupano di filtrare e inoltrare pacchetti ethernet. in particolare, esaminano l’indirizzo di destinazione dei pacchetti e li inviano all’interfaccia corrispondente alla sua destinazione
- gli host non sono consapevoli della presenza dello switch, nonostante abbiano collegamenti dedicati e diretti con lo switch (huh ? )
- hanno quindi un ruolo **attivo**, e sono più intelligenti di un hub (che amplifica e basta)
gli switch bufferizzano i pacchetti, e permettono una connessione full-duplex senza collisioni (non possibile con gli hub)
- viene usato il protocollo su ciascun collegamento in entrata
## autoapprendimento
>[!info] rappresentazione
![[Pasted image 20250510220716.png]]
la **switch table** (**tabella di comunicazione**) viene creata automaticamente dagli switch (attraverso l’**autoapprendimento**), e contiene le associazioni tra gli indirizzi MAC e le interfacce dello switch
>- inizialmente, gli switch venivano configurati staticamente

lo switch **apprende** quali nodi possono essere raggiunti attraverso determinate interfacce
- quando riceve un pacchetto, lo switch “impara” l’indirizzo MAC del mittente, e registra la coppia mittente/interfaccia nella sua **switch table**

durante l’inoltro di pacchetti:
- se la destinazione del frame è ignota, si usa il **flood** (il messaggio viene mandato attraverso tutte le interfacce dello switch)
- se la destinazione è nota, si usa invece il **selective send**, grazie alla riga nella switching table
>[!example] esempio
![[Pasted image 20250510221928.png]]
dato questo esempio, supponendo che la switching table sia inizialmente vuota, si avrà la riga
>$$
<A, 1, 60>
>$$
del tipo $<\text{indirizzo MAC, interfaccia, TTL}>$

>[!info] proprietà
>- gli switch sono dispositivi plug-and-play: non richiedono intervento dell’amministratore di rete o dell’utente
>- eliminano le collisioni, bufferizzando i frame e non trasmettendo più di un frame alla volta su ogni **segmento** di rete (ciò mi fa intuire che ci sia un buffer per ogni interfaccia ?)
>- interconnettono link eterogenei: collegamenti che operano a diverse velocità possono esseere collegati a uno switch
> - aumentano la sicurezza della rete, e migliorano il network management
> 	- limita i packet sniffer, che risiedono su computer di una rete, per “sniffare” il traffico delle altre stazioni (gli swtich, se conoscono il MAC di destinazione, mandano i pacchetti in unicast)
> 		- negli hub ha senso che ci possano essere packet sniffer ngl
>	- forniscono informazioni su uso di banda, collisioni, tipo di traffico, etc.

>[!warning] differenza tra hub e switch
>lo switch garantisce lo stesso rate di input come output per ogni device collegato allo switch
>l’hub usa FDMA per evitare le collisioni, frazionando quindi la capacità della rete ( e la velocità)
# VLAN
supponiamo di avere uno switch che collega 3 LAN, e 3 gruppi di lavoro
- se una persona del primo gruppo viene spostata in un altro gruppo, non sarà possibile fargli arrivare i pacchetti destinati al suo nuovo gruppo, in quanto, fisicamente, appartiene al primo gruppo
- se invece di 3 gruppi sono necessari 10 gruppi, bisognerebbe gestire in modo ostico la situazione: o usando 10 switch, o usandone solo uno, che non rispecchia la separazione tra gruppi, e soprattuto non isola il traffico

le **VLAN** (**virtual** LAN) permettono di creare una rete locale configurata **per mezzo del software** anzichè del cablaggio fisico
- la LAN viene suddivisa in segmenti logici anzichè fisici (e può quindi essere suddivisa in più VLAN), e il gruppo di appartenenza delle stazioni è definito dal software, non dall’hardware
>[!info] rappresentazione
![[Pasted image 20250510223353.png]]
la gestione del software permette all’amministratore di rete di dichiarare quali porte appartengono ad una data LAN, e lo switch mantiene una tabella di associazioni porta-VLAN

>[!example] esempio
![[Pasted image 20250510223451.png]]

## VLAN trunking
supponiamo di avere partecipanti a due gruppi in edifici diversi: esiste una porta speciale, configurata su ogni switch (che supporta VLAN), la **porta trunk**, usata per interconnettere due switch.
- la porta trunk appartiene ad entrambe le VLAN, e riceve i frame indirizzati a entrambe le VLAN
>[!info] porta trunk
![[Pasted image 20250510223814.png]]