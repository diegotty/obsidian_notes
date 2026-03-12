---
related to: "[[18 - livello di collegamento; indirizzamento, ARP, ethernet, switch, VLAN]]"
created: 2025-03-02T17:41
updated: 2025-06-19T19:04
completed: false
---
>[!index]
>- [reti wireless](#reti%20wireless)
>	- [LAN wireless](#LAN%20wireless)
>		- [elementi](#elementi)
>		- [reti ad hoc](#reti%20ad%20hoc)
>	- [link wireless](#link%20wireless)
>		- [errori](#errori)
>	- [IEEE 802.11](#IEEE%20802.11)
>		- [architettura](#architettura)
>			- [BSS](#BSS)
>			- [ESS](#ESS)
>	- [canali e associazione](#canali%20e%20associazione)
>	- [accesso multiplo](#accesso%20multiplo)
>		- [CSMA/CA](#CSMA/CA)
>			- [IFS](#IFS)
>		- [fasi operative del protocollo CSMA/CA](#fasi%20operative%20del%20protocollo%20CSMA/CA)
>		- [RTS/CTS](#RTS/CTS)
>			- [problema della stazione esposta](#problema%20della%20stazione%20esposta)
>		- [`ACK`timer](#%60ACK%60timer)
>	- [formato del frame](#formato%20del%20frame)
>		- [indirizzamento](#indirizzamento)
>	- [mobilità](#mobilit%C3%A0)
# reti wireless
le reti wireless si dividono in:
- **LAN wireless** (wifi)
- **reti cellulari**
- **bluetooth**
- **reti di sensori, RFID, smart objects**

>[!info] alcuni standard sulle reti wireless
![[Pasted image 20250518125106.png]]

quello più usato è lo standard IEEE 802.11, con le sue diverse versioni:

| Protocol | Release date | Freq.     | Rate (typical) | Rate (max) | Range (indoor) |
| -------- | ------------ | --------- | -------------- | ---------- | -------------- |
| Legacy   | 1997         | 2.4 GHz   | 1 Mbps         | 2 Mbps     | ?              |
| 802.11a  | 1999         | 5 GHz     | 25 Mbps        | 54 Mbps    | ~30 m          |
| 802.11b  | 1999         | 2.4 GHz   | 6.5 Mbps       | 11 Mbps    | ~30 m          |
| 802.11g  | 2003         | 2.4 GHz   | 25 Mbps        | 54 Mbps    | ~30 m          |
| 802.11n  | 2008         | 2.4/5 GHz | 200 Mbps       | 540 Mbps   | ~50 m          |
## LAN wireless
### elementi
>[!info] LAN wireless
![[Pasted image 20250518125705.png|400]]
gli elementi delle LAN wireless sono:
>- **wireless hosts**: utilizzati per eseguire applicazioni, possono essere stazionari o mobili, in quanto wireless non significa sempre mobile (es: laptops, cellulari)
>- **base stations**: sono **relay** (ripetitori) responsabili del mandare pacchetti tra network cablate e host wireless nell’area della base station (sono quindi tipicamente connessi ad un network cablato (es: cell towers, 802.11 access points)
>- **wireless links**: tipicamente usati per connetere dispositivi mobili alle base stations, possono anche essere usati come collegamento per il backbone. hanno vari range di rate e distanza di trasmissione, e il [[17 - livello di collegamento#protocolli di accesso multiplo|protocollo di accesso multiplo]] regola l’accesso al link

il mezzo trasmissione delle LAN wireless è l’aria, e la connessione ad altre reti avviene mediante una stazione base detta **access point** (**AP**) che **unisce l’ambiente wireless all’ambiente cablato**
>[!figure] access point
![[Pasted image 20250518130821.png]]

>[!tip] migrazione dall’ambiente cablato al wireless
il funzionamento di una rete cablata o wireless dipende dai due sottolivelli inferiori dello stack protocollare: collegamento e fisico
>
infatti, per migrare dalla rete cablata a quella wireless, è sufficiente cambiare le schede di rete e sostituire lo switch di collegamento con un **AP**
>- così facendo, cambiano gli indirizzi MAC mentre gli IP rimangono invariati

### reti ad hoc
le **reti ad hoc** non hanno hotspot o punti fissi, sono bensì un insieme di host che si auto-organizzano per formare una rete, e comunicano liberamente tra di loro
- ogni host deve eseguire funzionalità di rete, quali network setup, routing, forwarding, etc..
- viene usata per mettere in comunicazione più dispositivi noti 
## link wireless
vediamo alcune delle caratteristiche più importanti dei link wireless:
- **attenuazione del segnale**: la forza dei segnali elettromagnetici diminuisce rapidamente all’aumentare della distanza dal trasmettitore, in quanto il segnale si disperde in tutte le direzioni 
	- il **raggio di trasmissione** è infatti la distanza in cui un segnale è ancora decodificabile da un host
- **propagazione multi-path**: quando un’onda trova un ostacolo, tutta o parte dell’onda **viene riflessa** sull’ostacolo, rimbalzando con una perdita di potenza
	- un segnale sorgente, infatti , può arrivare tramite riflessi successivi (su muri, terreni, oggetti) a raggiungere una stazione/punto di accesso attraverso percorsi multipli ! (quindi ““ridondanza””, che in verità causa interferenze, in quanto l’host riceve una somma di segnali che creano interferenze)
- **interferenze**: possono essere causate dalla stessa sogente (propagazione multi-path), o da altre sorgenti (altri trasmettitori usano la stessa banda di frequenza per comunicare con altri destinatari)
### errori
le caratteristiche dei link wireless causano errori
il **signal to noise ratio** (**SNR**) misura il rapporto tra il segnale buono e quello “cattivo”
- alto: il segnale è più forte del rumore, quindi può essere convertito in dati reali
- basso: il segnale è stato danneggiato dal rumore, e i dati non possono essere recuperati
inoltre, dato che i link wireless sono un mezzo condiviso, è necessario controllare l’accesso ad essi per evitare collisioni 
>[!info] CSMA/CD
abbiamo visto che con la trasmissione ethernet si usa il protocollo di accesso multiplo CSMA/CD. è possibile usarlo con sulle reti wireless ?
**no!** in quanto per rilevare una connessione, un host deve poter trasmettere il proprio frame e ascoltare, contemporaneamente, il canale. ma, poichè la potenza del segnale ricevuto è molto inferiore a quella del segnale trasmesso, sarebbe troppo costoso (soprattutto a livello di energia, in quanto i dispositivi wireless usano spesso una batteria) usare un adattatore di rete in grado di rilevare le collisioni 
>inoltre, un host potrebbe non accorgersi che un altro host sta trasmettendo, e quindi non sarebbe in grado di rilevare la connessione pur ascoltando il canale
> - chiamato anche hidden terminal problem !
>
![[Pasted image 20250518133359.png]]
>
>quindi non si può contare sulla collision detection nelle reti wireless !
## IEEE 802.11
IEEE ha definito le specifiche per le LAN wireless, chiamate 802.11, che coprono i livelli fisico e collegamento
### architettura
>[!info] architettura generale
![[Pasted image 20250518134144.png]]
#### BSS
**basic service set** (**BSS**) è costituita da uno o più host wireless e da un access point (che è collegato ad un router)
- corrispondono alle **celle** delle reti cellulari
>[!info] BSS
![[Pasted image 20250518133830.png]]
>- il BSS con infrastruttura è l’architettura più diffusa !
>- il BSS ad hoc è invece una rete *standalone*
#### ESS
**extended service set** (**ESS**) è costituito da due o più **BSS** con infrastruttura, collegati tramite un sistema di distribuzione che è una rete cablata (ethernet) o wireless
- quando i BSS sono collegati, le stazioni in visibilità comunicano direttamente mentre le altre comunicano tramite l’AP
- molto comuni nelle reti wi-fi moderne, sopratutto in ambienti dove è necessario coprire aree estese con accesso continuo alla rete wireless
>[!info] ESS
![[Pasted image 20250518134043.png]]
## canali e associazione
lo spettro 2.4GHz-2.48GHz è diviso in 11 canali parzialmente sovrapposti:
- l’amministratore dell’AP sceglie una frequenza su cui far comunicare l’AP
- sono possibili interferenze (es: se viene usato lo stesso canale per AP vicini)
- il numero massimo di frequenze utilizzabili da diversi AP per evitare interferenze è 3
- i canali non interferiscono se separati da 4 o più canali (quindi, uniche frequenze che non si overlappano: 1, 6 ,11)
dato che architettura IEE 802.11 prevede che una stazione wireless si associ a un AP per accedere a internet, è necessario:
- conoscere gli AP disponibili in un BSS
- un protocollo di associazione:
	- AP invia segnali periodici, chiamati **beacon**, che includono l’identificatore dell’AP: il **SSID** (**service set identifier**), e il suo indirizzo MAC
	- l’host wireless che vuole entrare in un BSS scandisce gli 11 canali trasmissivi alla riceva di frame beacon (passive scanning)
	- alla fine della scansione, l’host sceglie l’AP da cui ha ricevuto il beacon con maggiore potenza di segnale, e gli invia un frame con la richiesta di associazione
	- l’AP accetta la richiesta con un frame di risposta associazione, che permetterà all’host entrante di inviare una richiesta DHCP per ottenere l’indirizzo IP
		- può essere prevista un’autenticazione per eseguire l’associazione
## accesso multiplo
più stazioni possono voler comunicare nello stesso momento, e per gestire ciò esisono 2 tecniche di accesso al mezzo:
- **distributed cordination function** (**DCF**): i nodi si contendono l’accesso al canale
- **point coordination function** (**PCF**): non c’è contesa, e l’AP coordina l’accesso dei nodi al canale (boooooringgggg)
vediamo il DCF:
### CSMA/CA
dato che non è possibile contare sulla **collision detection**, obblighiamo la **collision avoidance** (da cui CSMA/**CA**): evitiamo che due o più nodi trasmettano simultaneamente
il protocollo **CSMA/CA** usa:
- `ACK` come riscontro necessario per capire se una trasmissione è andata a buon fine (no collisione)
	- c’è quindi possibilità di collisione anche sugli `ACK`
- doppio carrier sense (ascoltare il canale prima di trasmettere): uno per i dati, e l’altro per l’`ACK`
- **IFS** (spazio interframe):  intervallo di tempo che una stazione deve attendere dopo aver rilevato che il canale è libero, prima di iniziare la trasmissione. in questo modo, si prova ad evitare collisioni con altre stazioni che potrebbero aver già iniziato a trasmettere
#### IFS
esistono due tipi di IFS:
- **SIFS**: short IFS, garantisce **alta priorità** alle trasmissioni (usato anche per `ACK`)
- **DIFS**: distributed IFS, garantisce **bassa priorità** (usato per le trasmissioni normali)
	- (DIFS > SIFS)
### fasi operative del protocollo CSMA/CA
- mittente: ascolta il canale: se lo trova libero, aspetta un DIFS e poi trasmette
	- se durante l’intervallo DIFS, il canale diventa occupato, il nodo interrompe il conteggio del DIFS, aspetta che il canale torni completamente libero, e riavvia da zero il conteggio del DIFS 
- ricevente: se riceve correttamente un frame, invia `ACK` dopo aver aver aspettato un SIFS
dopo aver atteso un tempo IFS, se il canale è ancora libero, l’host attende un ulteriore tempo di tempo di contesa: la **contention window**, il lasso di tempo per cui deve sentire il canale libero prima di trasmettere
- l’host sceglie $R$ random in `[0, CW-1]`
- `while R > 0:`
	ascolta il canale per uno slot (il tempo è suddiviso in slot e ad ogni slot si esegue il sensing del canale)
	se il canale è libero per la durata dello slot: `R = R -1`(conto all’indietro: backoff), altrimenti, se il canale è occupato durante il sensing, interrompe il timer e aspetta che il canale si liberi (e riavvia il timer)
>[!info]
![[Pasted image 20250518153630.png]]

>[!info]- riassunto
![[Pasted image 20250518153758.png]]

>[!info]- rappresentazione
![[Pasted image 20250518150051.png]]

### RTS/CTS
il problema dell’hidden terminal non viene risolto con IFS e finestra di contesa: è necessario un meccanismo di prenotazione del canale: **request-to-send** (**RTS**) e **clear-to-send** (**CTS**)
>[!info] RTS e CTS
![[Pasted image 20250518155121.png]]
>- quando una stazione invia un frame RTS, include la durata di tempo in cui occuperà il canale per trasmettere il frame e ricevere l’`ACK`
>- questo tempo viene incluso anche nel CTS. in questo modo, le stazioni che sono influenzate da tale trasmissione avviano un timer chiamato **NAV** che indica quanto tempo devono attendere prima di eseguire il sensing del canale

se il mittente non riceve CTS, allora assume che c’è stata una collisione durante l’handshaking e riprova dopo un tempo di backoff
#### problema della stazione esposta
può capitare che una stazione si astenga dall’usare il canale anche se potrebbe trasmettere
>[!example] problema della stazione esposta
![[Pasted image 20250518160012.png]]
in questo esempio C è la stazione esposta
### `ACK`timer
il mittente non può aspettare l’`ACK`all’inifinito: imposta quindi un timer: l’`ACK` timeout
- se il timer scade senza aver ricevuto l’`ACK`, il nodo suppone che la trasmissione sia fallita (es: per collisione o errore) e tenta una ritrasmissione
## formato del frame
>[!info] frame
![[Pasted image 20250518160346.png]]
>- **frame control** (**FC**): tipo di frame e alcune informazioni di controllo
>- **D**: durata della trasmissione, usata per impostare il NAV
>- **indirizzi**: indirizzi MAC (descritti in seguito)
>- **SC**: informazioni sui frammenti: # di frammento e # di sequenza. il numero di sequenza serve per distinguere frame ritrasmessi come nel livello di trasporto (`ACK` possono andare perduti)
>- **frame body**: payload
>- **FCS**: codice CRC a 32 bit

>[!info] frame control
![[Pasted image 20250518161201.png]]
una LAN wireless ha 3 categorie di frame:
>- **frame di gestione** (`00`): usati per le comunicazioni iniziali tra stazioni e punti di accesso
>- **frame di controllo** (`01`): si usano per accedere al canale e dare riscontro (impostando il **subtype** a : `1011` (RTS), `1100` (CTS), `1101` (`ACK`))
>- **frame di dati** (`10`): vengono usati per trasportare dati
### indirizzamento
(DS: distribution system)

| Significato                    | To DS | From DS | Address 1    | Address 2   | Address 3    | Address 4 |
| ------------------------------ | ----- | ------- | ------------ | ----------- | ------------ | --------- |
| comunicazione diretta (ad-hoc) | 0     | 0       | destinazione | sorgente    | BSS ID       | N/A       |
| da AP a host                   | 0     | 1       | destinazione | AP mittente | sorgente     | N/A       |
| da host ad AP                  | 1     | 0       | AP ricevente | sorgente    | destinazione | N/A       |
| da AP ad AP                    | 1     | 1       | AP ricevente | AP mittente | destinazione | sorgente  |
in `address 1` viene quindi memorizzato l’indirizzo del dispositivo successivo a cui viene trasmesso in frame, mentre in `address 2` è presente l’indirizzo del dispositivo che il frame ha lasciato
>[!example] esempio
![[Pasted image 20250519004504.png]]
## mobilità
la mobilità all’interno della stessa sottorete IP è semplice. l’indirizzo IP rimane lo stesso
- $H_{1}$ sente che il segnale da $AP_{1}$ si affievolisce, e avvia una scansione per un segnale più forte
- $H_{1}$ rileva $AP_{2}$, si disassocia da $AP_{1}$ e si associa a $AP_{2}$, mantenendo lo stesso IP e sessioni TCP
$AP_{2}$ si occupa di inviare un frame di broadcast allo switch con indirizzo mittente $H_{1}$, e lo switch capisce che $H_{1}$ ora è nel $BSS_{2}$
>[!example] esempio in questione
![[Pasted image 20250519004902.png]]