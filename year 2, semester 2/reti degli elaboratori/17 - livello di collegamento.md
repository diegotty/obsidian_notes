---
related to: "[[03 - introduzione allo stack protocollare TCP-IP]]"
created: 2025-03-02T17:41
updated: 2025-06-19T19:04
completed: true
---
>[!index]
>- [livello di collegamento](#livello%20di%20collegamento)
>		- [tipi di collegamento](#tipi%20di%20collegamento)
>	- [servizi offerti dal livello di collegamento](#servizi%20offerti%20dal%20livello%20di%20collegamento)
>	- [errori](#errori)
>		- [tecniche di rilevazione degli errori](#tecniche%20di%20rilevazione%20degli%20errori)
>			- [controllo di parità](#controllo%20di%20parit%C3%A0)
>	- [implementazione del livello di collegamento](#implementazione%20del%20livello%20di%20collegamento)
>		- [data-link control](#data-link%20control)
>		- [media access control](#media%20access%20control)
>- [protocolli di accesso multiplo](#protocolli%20di%20accesso%20multiplo)
>	- [protocolli a suddivisione del canale](#protocolli%20a%20suddivisione%20del%20canale)
>		- [TDMA](#TDMA)
>		- [FDMA](#FDMA)
>	- [protocolli ad accesso casuale](#protocolli%20ad%20accesso%20casuale)
>		- [ALOHA puro](#ALOHA%20puro)
>	- [studio dell’efficienza](#studio%20dell%E2%80%99efficienza)
>		- [slotted ALOHA](#slotted%20ALOHA)
>		- [CSMA](#CSMA)
>		- [CSMA/CD](#CSMA/CD)
>			- [metodi di persistenza](#metodi%20di%20persistenza)
>	- [protocolli a rotazione](#protocolli%20a%20rotazione)
>		- [polling](#polling)
>		- [token-passing](#token-passing)
# livello di collegamento
la comunicazione a livello di collegamento è **hop-to-hop**
- host e router vengono chiamati **nodi** o **stazioni**
- i canali di comunicazione che collegano nodi adiacenti sono i **link**, e possono essere cablati o wireless
- le unita di dati scambiate dai protocolli a livello di link sono chimate **frame**
>[!info] rappresentazione
![[Pasted image 20250509221200.png]]

i protocolli a livello collegamento si occupano quindi del traporto di datagrammi lungo un canale di comunicazione (fisico o wireless)
### tipi di collegamento
esistono 2 tipi di link, a seconda della funzione che svolgono:
- **collegamento punto-punto**: dedicato a due soli dispositivi (viene utilizzata l’intera capacità del mezzo)
	- viene impiegato per connessioni telefoniche o tra ethernet e host
	- viene utilizzzto il **point-to-point protocol (PPP)**, del [[#data-link control|DLC]]
- **collegamento broadcast**: il collegamento è condivisio tra varie coppie di dispositivi (viene utilizzata solo una parte del mezzo)
	- include l’ethernet tradizionale (cavo/canale condiviso), o le LAN wireless 802.11
	- necessita di un protocolllo (il protocollo MAC) per la gestione del canale condiviso

inoltre un datagramma può essere gestito da diversi protocolli su collegamenti differenti ! e anche i servizi erogati dai protocolli del livello di link possono essere diversi (ad esempio, non tutti i protocolli forniscono un servizio di consegna affidabile)
## servizi offerti dal livello di collegamento
- **framing**: i protocolli incapsulano i datagrammi del livello di rete all’interno di un frame a livello di link, al fine di separare i vari messaggi durante la trasmissione da una sorgente ad una destinazione. in particolare, vengono utilizzati gli **indirizzi MAC** per identificare origine e destinatario
- **consegna affidabile**: la trasmissione è basata su `ACK` come nel livello di trasporto. è considerata non necessaria nei collegamenti che presentano un basso numero di errori sui bit (es: fibra ottica, cavo coassiale e doppino intrecciato) , ma è spesso utilizzata nei collegamenti soggetti ad elevati tassi di errori (es: collegamenti wireless)
- **controllo di flusso**: evita che il nodo trasmittente saturi quello ricevente (come in livello di rete)
- **rilevazione degli errori**: il nodo ricevente individua la presenza di errori, grazie all’inserimento da parte del nodo trasmittente di bit di controllo di errore all’interno del frame
- **correzione degli errori**: il nodo ricevente determina anche il punto in cui si è verificato l’errore, e lo corregge
## errori
gli errori sono dovuti a **interferenze**, che possono cambiare la forma del segnale.
esistono 2 tipi di errori: 
- **errori sul singolo bit**
- **errori burst**
normalmente la durata dell’interferenza è più lunga rispetto a quella di un solo bit, quindi gli errori burst sono più comuni rispetto a quelli sul singolo bit
- il numero di bit coinvolti dipende dalla velocità di trasferimento dati e dalla durata dell’interferenza (es: 1kpbs con rumore di 1/100sec può influire su 10bit !)
>[!info]- errori su singolo bit o a burst
![[Pasted image 20250509223228.png]]
![[Pasted image 20250509223239.png]]
### tecniche di rilevazione degli errori
la rilevazione degli errori non è attendibile al 100%: è possibile che ci siano errori non rilevati, ma per ridurre questa possibilità, le tecniche più sofisticate prevedono un’elevata ridondanza
>[!info] schema
![[Pasted image 20250509223459.png]]
>- **EDC**: error detection and correction
>- **D**: dati che devono essere protetti da errori, ai quali vengono aggiungi dei bit di EDC

#### controllo di parità
viene aggiungo un bit **di parità**, selezionato in modo da rendere pari il numero totale di 1 all’interno della codeword (payload ?)
ciò può essere fatto in 2 modi:
- unico bit di parità: ci permette di rilevare se si è verificato almeno un errore in un bit
- parità bidimensionale: ci permette di individuare e correggere il bit alterato
>[!info] rappresentazione
![[Pasted image 20250509223812.png]]
## implementazione del livello di collegamento
il livello di collegamento è implementato all’interno della **network interface card** (**adattatore di rete**: la scheda ethernet, PCMCI), che implementa sia il livello di collegamento che il livello fisico
- la scheda di rete è una combinazione di hardware, software e firmware
>[!info] scheda di rete
![[Pasted image 20250509222356.png]]

>[!info] esempio
![[Pasted image 20250509222454.png]]
durante la comunicazione:
>- il lato mittente:
>	- incapsula un datagramma in un frame
>	- imposta i bit rilevazione degli errori, trasferimento dati affidabile, controllo di flusso, etc.
>- il lato ricevente:
>	- individua errori, trasferimento dati affidabile, controllo di flusso, etc.
>	- estrae i datagrammi e li passa al nodo ricevente

il livello di collegamento può essere separato in due sottolivelli:
### data-link control
il **DLC** si occupa di tutte le questioni **comuni** sia ai collegamenti punto-punto che ai collegamenti broadcast:
- framing
- controllo del flusso e degli errori
- rilevamento e correzione degli errori
- procedure per la comunicazione tra 2 nodi adiacenti, indipendentemente dal fatto che il collegamento sia dedicato o broadcast
### media access control
il **MAC** si occupa solo degli aspetti specifici dei canali broadcast:
- controllo dell’accesso al mezzo condiviso
>[!warning] il livello di collegamento di un link punto-punto non ha il sotto-livello MAC !

# protocolli di accesso multiplo
quando viene usato un canale broadcast condiviso, è possibile che centinaia/migliaia di nodi possano comunicare direttamente sul canale broadcast. non è quindi raro che si generi una **collisione**, che accade quando i nodi ricevono due o più frame contemporaneamente
lo scopo dei protocolli di accesso multiplo è quello di evitare caos, e realizzare una condivisione. per fare ciò, fissano le modalità con cui i nodi regolano le loro trasmissioni sul canale condiviso
- la comunicazione relativa al canale condiviso deve utilizzare il canale stesso ! (non c’è un canale “out-of-band” per la coordinazione)
>[!info] protocolli di accesso multiplo ideali
idealmente, dato un canale broadcast con velocità $R$ bps:
>- quando un solo nodo deve inviare dati , esso dispone di un tasso trasmissivo pari a $R$ bps
>- quando $M$ nodi devono inviare dati, questi dispongono di un tasso trasmissivo pari a $\frac{R}{M}$ bps
>- ha un protocollo decentralizzato: non ci sono nodi master, o sincronizzazione dei clock

i protocolli di accesso multiplo si possono dividere in 3 categorie:
- **channel partitioning** (protocolli a suddivisione del canale): suddivide il canale in parti più piccole (slot di tempo, frequenza, codice), alloca le parti presso un nodo per utilizzo esclusivo
	- evita le collisioni
- **random access** (protocolli ad accesso casuale): i canali non vengono divisi, e si può verificare una collisione. in caso di collisione (o forse in generale) , i nodi coinvolti ritrasmettono ripetutamente i pacchetti
- **taking-turn**: (protocolli a rotazione): ciascun nodo ha il suo turno di trasmissione, ma i nodi che hanno molto da trasmettere possono avere turni più lunghi !
>[!figure] riassunto
![[Pasted image 20250509225659.png]]
## protocolli a suddivisione del canale
i protocolli a suddivisione del canale condividono (e suddividono) il canale in modo equo, risultando in una gestione efficiente di carichi elevati,  ma inefficiente con carichi non elevati
### TDMA
il protocollo TDMA prevede l’accesso multiplo a **divisione di tempo**:
- vengono assegnati turni per accedere al canale, e ogni nodo ha un turno assegnato
- il canale viene suddiviso in intervalli di tempo
- gli slot non usati rimangono inattivi
il tasso trasmissivo è sempre $\frac{R}{N}$ bps (relativamente all’unità di tempo) (quindi male !!! se ho solo un nodo che vuole trasmettere, perdo tantissimo del canale), quindi non flessibile rispetto a variazioni nel numero di nodi
>[!example]- esempio
![[Pasted image 20250509230018.png]]
### FDMA
il protocollo FDMA prevede l’accesso a **divisione di frequenza**:
- suddivide il canale in bande di frequenza
- le bande di frequenza vengono assegnate ad ogni nodo
carateristiche molto simili al TDMA in termini di prestazioni ! (sempre divisione statica)
>[!example]- esempio
![[Pasted image 20250509230150.png]]
## protocolli ad accesso casuale
i protocolli ad accesso casuale, invece, risultato efficienti anche con carichi non elevati: un singolo nodo, se unico a trasmettere, può utilizzare interamente il canale. con carichi elevati, però, data la natura casuale, si verifica un’eccesso di collisioni
### ALOHA puro
>[!info] lore
>il protocollo **ALOHA** è il primo del suo tipo ad essere stato proposto in letteratura (nei primi anni 70, nelle hawaii), e fu ideato per mettere in comunicazione gli atolli (sponde di un’isola) mediante una LAN radio (wireless !)

>[!warning] essendo un protocollo ad accesso casuale, si possono verificare collisioni !

nel protocollo **ALOHA puro**:
- ogni stazione può inviare un frame tutte le volte che ha dati da inviare
- il ricevente invia un `ACK` per notificare la corretta ricezione del frame
- se il mittente non riceve l’`ACK` entro un **timeout**, deve ritrasmettere il frame
	- il periodo di timeout equivale al **massimo RTT tra le due stazioni più lontane**
- se due stazioni ritrasmettono contemporaneamente creando di nuovo una collisione (quindi, dopo 2 collisioni), si attende un tempo random (**back-off**) prima di effettuare la ritrasmissione del frame
	 - il tempo di back-off è un valore scelto casualmente che dipende dal numero $K$ di trasmissioni fallite: 
	 $$\text{back-off time} = R*T_{fr}$$
	- $\text{con } R \in [0,2^K-1], T_{fr} = \text{tempo x invio frame}$
	 - la casualità del back-off aiuta ad evitare altre collisioni
- dopo un numero massimo di tentativi $k_{max} = 15$, una stazione interrompe i suoi tentativi e prova più tardi
>[!example] esempio calcolo backoff
le stazioni in una rete wireless ALOHA sono a una distanza massima di 600km. supponendo che i segnali si propaghino a $3 \times 10^8$ m/s, troviamo:
>$$ 
T_{fr} = d_{prop} \text{ (in questo caso) } = \frac{600 \times 10^3}{(3 \times 10^8)} = 2ms 
>$$
se $K = 2$, $R = \{0, 1, 2, 3\}$
ciò significa che $T_{b}$ può essere 0, 2, 4, o 6 in base al valore casuale di $R$


>[!info] info
![[Pasted image 20250509230914.png]]
affichè la collisione accada, basta la sovrapposizione di due messaggi per un solo bit !

il protocollo ALOHA puro ha elevate probabilità di collisione, in quanto il **tempo di vulnerabilità**, cioè l’intervallo nel quale il frame è a rischio di collisioni è:
$$
\text{tempo di vulnerabilità} = 2 \times T_{fr}
$$
sempre con $T_{fr} = \text{tempo per inviare un frame}$ 
in quanto il frame trasmesso a tempo $t$ si sovrappone con la trasmissione di qualsiasi frame inviato in $[t-1,t+1]$ (considerando $T_{fr}$ come valore unitario)
>[!info] rappresentazione
![[Pasted image 20250510105320.png]]
## studio dell’efficienza
l’**efficienza** è definita come la frazione di slot vincenti in presenza di un elevato numero $N$ di nodi attivi, che hanno sempre un numero elevato di pacchetti da spedire

>[!info] efficienza dell’algoritmo ALOHA puro
assumiamo che tutti i frame hanno la stessa dimensione e ogni nodo ha sempre un frame da trasmettere:
>- in ogni istante di tempo, $p$ è la probabilità che un nodo trasmetta un frame ( $(1-p)$ la probabilità che non trasmetta)
>- supponendo che un nodo inizi a trasmettere al tempo $t_{0}$, perchè la trasmissione vada a buon fine, nessun altro nodo deve aver iniziato una trasmissione nel tempo $[t_{0}-1, t_{0}]$. tale probabilità è data da $(1-p)^{N-1}$, e **allo stesso modo**, nessun nodo deve iniziare a trasmetter nel tempo $[t_{0}, t_{0}+1]$ e la probabilità di questo evento è ancora $(1-p)^{N-1}$
>- la probabilità che un nodo trasmetta con successo è dunque $p(1-p)^{2(N-1)}$
>
>studiando il valore di $p$ che massimizza la probabiltà di successo per $N$ che tende a $\infty$, si ottiene che l’efficienza massima è $\frac{1}{2e} = 0,18$ (molto bassa …)

### slotted ALOHA
un modo per aumentare l’efficienza di ALOHA consiste nel **dividere il tempo in intervalli discreti**, ciascuno corrispondente a $T_{fr}$ (tempo per iniviare un frame)
- per rendere ciò possibile, è necessario che i nodi debbano essere d’accordo nel confine fra gli intervalli, e ciò può essere fatto facendo emettere, da una attrezzatura speciale, un breve segnale all’inizio di ogni intervallo
in questo protocollo, i nodi iniziano la trasmissione solo all’inizio degli slot (assumiamo che i pacchetti abbiamo tutti la stessa dimensione), e se in uno slot due o più pacchetti collidono, i nodi coinvolti rilevano l’evento prima del termine dello slot
- quindi, quando a un nodo arriva un nuovo pacchetto da spedire, aspetta l’inizio del prossimo slot:
	- **se non si verifica una collisione**, può trasmettere un nuovo pacchetto nello slot successivo
	- **se si verifica una collisione**, il nodo ritrasmette con probabilità $p$ il suo pacchetto durante gli slot successivi
>[!info] rappresentazione
![[Pasted image 20250510111209.png]]

**pro**:
- nel caso ci sia solo un singolo nodo che vuole trasmettere, gli consente di trasmettere continuamente pacchetti alla massima velocità del canale !
- riduce il **tempo di vulnerabilità** a un solo slot di dimensione $T_{fr}$
**contro:**
- una certa frazione degli slot presenterà collisioni e di conseguenza andrà “sprecata” (nel senso, l’intero slot) (eh come fai altrimenti fra)
- un’altra frazione degli slot rimane vuota, quindi inattiva (amen fra)
>[!info] efficienza di slotted ALOHA
supponiamo $N$ nodi con pacchetti da spedire, in cui ognuno ha di nuovo probabilità $p$ di spedire in uno slot
>- la probabilità di successo di un dato nodo è $p(1-p)^{N-1}$, e la probablità che ogni nodo abbia successo è $N \cdot p(1-p)^{N-1}$
>
>l’efficienza che si ottiene per un numero elevato di nodi $N$ che tende all’infinito è $\frac{1}{e} = 0,37$, quindi nel caso migliore solo il 37% degli slot compie il lavoro utile
### CSMA
nel protocollo **CSMA** (**carrier sense multiple access**), un nodo si pone in ascolto prima di trasmettere (listen before talk (as you should !!!!!!!!)):
- se rileva che il canale è libero, trasmette l’intero pacchetto
- se il canale sta già trasmettendo, il nodo aspetta un altro intervallo di tempo
>[!warning] può comunque avvenire una collisione ?
>si ! se due nodi trasmettono allo stesso momento ! il ritardo di propagazione (+ il tempo di trasmissione) fa sì che i due nodi non rilevino la reciproca trasmissione
il **tempo di vulnerabilità** è quindi il tempo di propagazione !!! (secondo me, tempo di trasmissione + tempo di propagazione)
>
>
>forse non tempo di propagazione xke è costante x entrambi quindi non conta ? 

>[!info] rappresentazione
![[Pasted image 20250510112713.png]]
è importante notare che la distanza e il ritardo di propagazione giocano un ruolo importante nel determinare la probabilità di collisione
### CSMA/CD
nel protocollo CSMA/CD (**CD** sta per **collision detection**), i nodi ascoltano il canale anche durante la trasmissione (quindi durante il tempo di trasmissione)
- in questo modo la collisione viene rilevata in poco tempo
- la trasmissione viene annullata non appena si accorge che c’è un’altra trasmissione in corso
	- la rilevazione della collisione è facile nelle LAN cablate, ma difficile nelle LAN wireless (immagino per il maggior tempo di propagazione)
>[!info] rilevazione degli errori
![[Pasted image 20250510113221.png]]
>- $A$ ascolta il canale e inizia la trasmissione al tempo $t_{1}$
>- $C$, al tempo $t_{2}$, ascolta il canale, ma non rileva ancora il primo bit dei $A$, quindi inizia a trasmettere
>- al tempo $t_{3}$, $C$ riceve il primo bit di $A$ e interrompe la trasmissione perchè c’è collisione
>- al tempo $t_{4}$, $A$ riceve il primo bit di $C$ e interrompe la trasmissione perchè c’è collisione
per 

>[!warning] è ancora possibile non detectare una collisione ? 
>si ! potrebbe succedere che un mittente finisca di trasmettere un frame prima di ricevere il primo bit di un’altra stazione che ha già iniziato a trasmettere
>- inoltre, una volta inviato un frame, una stazione non tiene una copia del frame, nè controlla il mezzo trasmissivo per rilevare collisioni

quindi, affinchè il CSMA/CD funzioni, il mittente deve poter rilevare la trasmissione mentre sta trasmettendo, ovvero prima di inviare l’ultimo bit del frame 
- quindi il **tempo di trasmissione** di un frame deve essere almeno due volte il tempo di propagazione $T_{p}$, e la prima stazione deve essere ancora in trasmissione dopo $2T_{p}$ (è necessario che sia in trasmissione dopo $2T_{p}$, per sicurezza, in quanto basterebbe $T_p$ (o poco più) per rilevare una connessione)
**per questo motivo, dato il tempo di propagazione del canale, è necessario impostare una dimensione minima per il frame tale che il tempo di trasmissione sia $2T_{p}$**

>[!warning] link ad altro file
[[18 - livello di collegamento; indirizzamento, ARP, ethernet, switch, VLAN#fasi operative del protocollo CSMA/CD|fasi operative del protocollo CSMA/CD]]
#### metodi di persistenza
a seconda di cosa fa un nodo se trova il canale libero, li possiamo dividere in :
- **non persistente** o **1-persistente**: trasmette subito
- **$p$-persistente**: trasmette con probabilità $p$
e a seconda di cosa fa un nodo se trova il canale occupato, li possiamo dividere in :
- **non persistente**: desiste e riascolta dopo un tempo random
- **1-persistente** o **$p$-persistente**: persiste, cioè rimane in ascolto finchè il canale non si è liberato
>[!info] non persistente
>- se il canale è libero, trasmette immediatamente
>- se il canale è occupato, attende un tempo random e poi riascolta il canale
>- se c’è collisione, aspetta un tempo di back-off per riascoltare il canale
![[Pasted image 20250510115133.png]]

>[!info] 1-persistente
>- se il canale è libero, trasmette immediatamente ($p$=1)
>- se il canale è occupato, continua ad asoltare 
>- se c’è collisione, aspetta un tempo di back-off per riascoltare il canale
![[Pasted image 20250510115220.png]]

>[!info] $p$-persistente
>- se il canale è libero, trasmette con probabilità $p$
>- se il canale è occupato, usa la procedura di back-off (attesa di un tempo random e nuovo ascolto del canale)
>- se c’è collisione, aspetta un tempo di back-off per riascoltare il canale
![[Pasted image 20250510115341.png]]

>[!info] efficienza del CSMA/CD
il throughput del CSMA/CD è maggiore sia dell’ALOHA puro che dello slotted ALOHA
>- quando un solo nodo trasmette, il nodo può trasmettere al massimo rate, e quando più nodi trasmettono, il rate effettivo/throughput è minore
>- per il metodo 1-persistente (che è anche il caso dell’ethernet tradizionale, ovvero 10mbps (????)), il throughput massimo è del 50% !

## protocolli a rotazione
i protocolli a rotazione cercano di realizzare un compromesso tra i protocolli precedenti
### polling
un nodo principale (**master**) sonda a turno gli altri (**slave**), per:
- eliminare le collisioni
- eliminare gli slot vuoti
- decidere chi può trasmettere e in quale momento
	- in particolare, interroga ogni nodo,uno alla volta, per dati da inviare. se i nodi hanno dati da iniviare, li inviano subito, e il master passa al nodo successivo
		- può interrogare i nodi in modo equo (round robin) o rispettando delle prorità
se il nodo principale si guasta, l’intero canale resta inattivo !!
- inoltre il protocollo risulta più lento, in quanto anche le stazioni che non hanno dati vengono interrogate (overhead !)
>[!info]- rappresentazione
![[Pasted image 20250510120558.png]]
### token-passing
viene fatto viaggiare **un messaggio di controllo** (**token**), che circola fra i nodi seguendo un ordine prefissato
- una stazione che riceve il token, ha “l’ok” per inviare dati (se li ha), per poi passare il token alla prossima stazione
- nessun token = nessuna trasmissione
in questo modo:
- si evitano collisioni
- il protocollo è decentralizzato, ma il guasto di un nodo può mettere fuoriuso l’intero canale !
- alta efficienza