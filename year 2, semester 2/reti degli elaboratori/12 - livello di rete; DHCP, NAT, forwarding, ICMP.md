---
created: 2025-05-06T13:13
updated: 2025-06-19T19:04
---
>- [indirizzamento IPv4](#indirizzamento%20IPv4)
>	- [gerarchia nell’indirizzamento](#gerarchia%20nell%E2%80%99indirizzamento)
>		- [indirizzamento con classi](#indirizzamento%20con%20classi)
>		- [indirizzamento senza classi](#indirizzamento%20senza%20classi)
>			- [notazione CIDR](#notazione%20CIDR)
>	- [indirizzi IP speciali](#indirizzi%20IP%20speciali)
>	- [ottenere un blocco di indirizzi](#ottenere%20un%20blocco%20di%20indirizzi)
>- [DHCP](#DHCP)
>	- [messaggi DHCP](#messaggi%20DHCP)
>	- [sottoreti](#sottoreti)
>- [NAT](#NAT)
>- [forwarding dei datagrammi IP](#forwarding%20dei%20datagrammi%20IP)
>		- [aggregazione degli indirizzi](#aggregazione%20degli%20indirizzi)
>- [ICMP](#ICMP)
>	- [messaggi ICMP](#messaggi%20ICMP)
# indirizzamento IPv4
>[!warning] **ogni interfaccia** di host e router di Internet ha un indirizzo IP globalmente univoco a 32 bit !
>- per **interfaccia** si intende il confine tra host e collegamento fisico (quindi tipo una porta **fisica** ?)
>	- i router devono necessariamente essere connessi ad almeno due collegamenti, mentre un host, in genere, ha un’interfaccia
>
>>[!example]- esempio
>![[Pasted image 20250423084857.png]]

gli indirizzi IPv4 sono in totale $2^{32}$ (ovvero più di 4 miliardi), e possono essere scritti in notazione binaria, decimale puntata, o esadecimale
## gerarchia nell’indirizzamento
>[!info] gerarchia nell’indirizzamento
![[Pasted image 20250423085141.png]]
ogni indirizzo IP si divide in **prefisso**, che individua la rete, e **suffisso**, che individua il collegamento al nodo
>il prefisso può avere lunghezza:
>- **fissa**: indirizzamento con classi
>- **variabile**: indirizzamento senza classi
### indirizzamento con classi
data la necessità di supportare sia reti piccole che grandi, il prefisso viene diviso in **classi**
>[!info] classi di indirizzamento
![[Pasted image 20250423085724.png]]
ci sono **3 lunghezze** di prefisso: 8, 16 e 24bit
inoltre:
>- negli indirizzi di classe A, i primo bit del primo ottetto è sempre 0, e il resto del primo ottetto viene usato per specificare la sottorete
>- negli indirizzi di classe b, i primi 2 bit del primo ottetto sono sempre 10, e i primi 2 ottetti vengono usati come prefisso
>- negli indirizzi di classe C, i primi 3 bit del primo ottetto sono sempre 110, e i primi 3 ottetti vengono usati come prefisso
>
in questo modo gli intervalli a destra hanno senso ! (e in questo modo si riconosce subito a che classe un indirizzo appartiene)

**vantaggi**:
- in questo modo, una volta individuato l’indirizzo, si può facilmente risalire alla classe e la lunghezza del prefisso
**svantaggi**:
- è facile che gli indirizzi vengano esauriti/sprecati:
	- la classe A può essere assegnata solo a 128 orgnizzazioni nel mondo, e ognuna ha 16.777.216 nodi: la maggior parte degli indirizzi verrebbe sprecata, e poche organizzazioni potrebbero usufruire di indirizzi di classe A
	- lo stesso problema occorre per la classe B
	- per la classe C, sono disponibili solo 256 host per ogni rete (pochi)
### indirizzamento senza classi
è necessaria quindi un maggiore flessibilità nell’assegnamento degli indirizzi: **vengono utilizzati blocchi di lunghezza variabile**, che non appartengono a nessuna classe
- un indirizzo non è in grado di definire da solo la rete (o blocco) a cui appartiene, è necessaria la lunghezza del prefisso (che è variabile, e va da 0 a 32 bit), che viene aggiunta all’indirizzo, separata da uno slash (/)
#### notazione CIDR
la notazione **CIDR** (**c**lassless **i**nter**d**omain **r**outing) è la strategia di assegnazione degl indirizzi, secondo la quale la struttura di un indirizzo è: `a.b.c.d/n`, dove `n` indica il numero di bit nella prima parte dell’indirizzo

>[!example] esempio
![[Pasted image 20250423093620.png]]

in questo modo, se `n` è la lunghezza del prefisso:
- il numero di indirizzi nel blocco è dato da $N=2^{32-n}$
- per trovare il primo indirizzo si impostano a 0 tutti i bit del suffisso di $32-n$ bit 
- per trovare l’ultimo indirizzo si impostano a 1 tutti i bit del suffisso di $32-n$ bit
>[!info] rappresentazione
![[Pasted image 20250423093757.png]]

la **maschera dell’indirizzo** è un numero composto da 32 bit, in cui i primi $n$ bit a sinistra sono impostati a 1 e il resto ($32-n$) a 0
- mediante la maschera si ottiene l’indirizzo di rete che è usato nell’instradamento dei datagrami verso la destinazione
>[!info]- da indirizzo IP a entry nella tabella
![[Pasted image 20250423094041.png]]

inoltre, la **subnet mask** può essere usata da un programma per calcolare in modo efficiente le informazioni di un blocco, usando solo tre operatori sui bit:
- il numero degli indirizzi del blocco è $N=NOT\text{(maschera})+1$
- il primo indirizzo del blocco è $\text{(qualsiasi indirizzo del blocco)} \land \text{(maschera)}$
- l’ultimo indirizzo del blocco è $(\text{qualsiasi indirizzo del blocco}) \lor NOT(\text{maschera})$
sensato !!
## indirizzi IP speciali
>[!info] woop
![[Pasted image 20250423165724.png]]
>- l’indirizzo `0.0.0.0` è utilizzato dagli host al momento del boot
>- gli indirizzi IP che hanno lo 0 come **numero di rete** si riferiscono alla rete corrente
>- l’indirizzo composto da tutti 1 permette la trasmissione **broadcast** sulla rete locale (in genere una LAN)
>- gli indirizzi con numero di rete opportuno e tutti 1 nel campo **host** permettono l’invio di pacchetti broadcast a LAN distanti (alla LAN specificata dal numero di rete)
>- gli indirizzi nella forma `127.xx.yy.zz` sono riservati al **loopback**: sono pacchetti non immessi nel cavo, ma elaborati localmente e trattati come pacchetti in arrivo

## ottenere un blocco di indirizzi
>[!info] how ? 
>per ottenere un blocco di indirizzi IP da usare in una sottorete, l’amministratore di rete deve contattare il proprio ISP e ottenere un blocco di indirizzi contigui con un prefisso comune !
>otterrà indirizzi nella forma `a.b.c.d/x`, dove `x` bit indicano la sottorete, e `(32-x)` indicano i singoli dispositivi dell’organizzazione
>
>a sua volta, un ISP, per ottenere un blocco di indirizzi, si rivolge all’ICANN, che ha la responsabilità di allocare i blocchi di indirizzi, gestire i server radice DNS, e assegnare/risolvere dispute su nomi di dominio

per assegnare un indirizzo IP ad un host, si può decidere se farlo in modo temporaneo o in modo permanente, e se farlo attraverso configurazione manuale o usando il DHCP
# DHCP
il protocollo DHCP (**dynamic host configuration protocol**) permette a un host di ottenere un indirizzo IP in modo **dinamico** e automatico
- viene largamente usato dove gli host si aggiungono e si rimuovono dalla rete con estrema frequenza
- può essere configurato in modo che un host riceva un indirizzo IP persistente (ogni volta che entra in rete gli viene assegnato lo stesso indirizzo)
attraverso il DHCP è possibile:
- rinnovare la proprietà dell’indirizzo in uso
- riusare gli indirizzi (quantità di indirizzi inferiore al numero totale di utenti)
- gestire **anche** gli utenti mobili che si vogliono unire alla rete
>[!warning] anche se è un protocollo del livello di rete, viene implementato come programma client/server di livello applicazione !

in particolare:
- il **client** è un host appena connesso, che desidera ottenere informazioni sulla configurazione della rete, **non solo un indirizzo IP** (??????????)
- il **server DHCP** solitamente è presente in ogni sottorete, altrimenti il router fa da agente di appoggio DHCP (conosce un server DHCP per quella rete e inoltra le richieste)

>[!info] panoramica DHCP
>- l’host invia un messaggio broadcast `DHCP discover`
>- il server DHCP risponde con `DHCP offer`
>- l’host richiede l’indirizzo IP `DHCP request`
>- il server DHCP invia l’indirizzo `DHCP ack`

## messaggi DHCP
>[!info] formato messaggi DHCP
![[Pasted image 20250423194206.png]]
nel pacchetto non è previsto un campo per il tipo di messaggio, ma nelle opzioni viene indicato un **magic cookie** pari a `99.130.83.99`, che segna l’inizio della parte del pacchetto che contiene le opzioni specifiche del protocollo DHCP, di questo tipo:
![[Pasted image 20250423195259.png]]

>[!example] esempio di completamento richiesta DHCP
![[Pasted image 20250423194240.png]]
>si nota:
>- vengono usate porte well-known (client: 68, server: 67)
>- durante `DHCPDISCOVER`, il client usa come IP mittente `0.0.0.0`, e come IP destinatario `255.255.255.255` (broadcast on local network)
>- in `DHCPOFFER`, il messaggio viene mandato in broadcast (`255.255.255.255)`, ma l’host richiedente saprà che è riferito a lui in base al **transaction ID**
>- anche `DHCPREQUEST` e `DHCPACK` vengono mandati in broadcast, pur sapendo IP mittente e destinatario !! 
>- nel `DHCPACK`, il server inserisce il pathname di un file contenente le info mancanti, e il client usa FTP per ottenere il file

>[!warning] dhcp usa udp (trasp non affidabile)

## sottoreti
ci addentriamo ora nelle **sottoreti**, reti isolate in cui i punti terminali sono collegati all’interfaccia di un host o di un router
>[!example] esempio di sottorete
![[Pasted image 20250423195624.png]]
>in questo caso la subnet mask è `/24`, quindi ogni host connesso alla sottorete `223.1.1.0/24` deve avere un indirizzo della forma `223.1.1.xxx`

>[!info] dato un indirizzo IP e la sua maschera di rete, posso facilmente trovare a quale blocco appartiene:
>se il prefisso di rete è multiplo di 8bit (`a.b.c.d/24`):
>- allora gli indirizzi degli host vanno da `a.b.c.0` a `a.b.c.255`
se il prefisso di rete non è multiplo di 8bit (`a.b.c.d/26`):
>- bisogna vedere la rappresentazione binaria di `d`: per esempio, se `d=10xxxxxx`, allora gli indirizzi degli host nella sottrete vanno da `10000000`(128) a `10111111`(191)

detto ciò, può capitare che un’entità che ha ricevuto un blocco abbia bisogno di un numero maggiore di indirizzi, ma che il blocco successivo sia assegnato ad un’altra entità. entrano allora in gioco gli **indirizzi privati** e il **NAT** !
# NAT
con la proliferazione di sottoreti **SOHO** (small office, home office), ogni volta che si vuole installare una rete locale per connettere più macchine, l’ISP deve allocare un intervallo di indirizzi per coprire la sottorete, e spesso ciò risulta impossibile per la mancanza di indirizzi aggiuntivi nella sottorete
il **NAT** (**network address translation**) permette di usare indirizzi riservati (spesso identici) nelle singole reti private, per scambiare pacchetti tra i loro dispositivi
>[!info] NAT
![[Pasted image 20250423200853.png]]
>- il **NAT** (**network address translation**) permette di usare indirizzi riservati (spesso identici) nelle singole reti private, per scambiare pacchetti tra i loro dispositivi
>- i router abilitati al NAT non appaiono al mondo esterno come router, ma come **unico** dispositivo con un **unico** indirizzo IP, e tutto il traffico verso Internet da quel router deve riportare lo stesso indirizzo

>[!info] implementazione
![[Pasted image 20250423202248.png]]
quando un router NAT riceve il datagramma, genera per esso un nuovo numero di porta d’origine (es: `5001`), sostituisce l’indirizzo IP origine con il proprio indirizzo IP sul lato WAN (`138.76.29.7`), e sostituisce il numero di porta origine iniziale con il nuovo numero (`5001`)

>[!example] esempio di NAT
![[Pasted image 20250423202649.png]]

il campo `numero di porta` è lungo 16bit: il protocollo NAT può supportare più di 60.000 connessioni simultanee con un solo indirizzo IP sul lato WAN. what a trooper !
>[!info] NAT è contestato perchè:
>- i router dovrebbero elaborare i pacchetti solo fino al livello 3
>- il numero di porta viene usato per identificare host e non processi
>- viola il cosiddetto **argomento punto-punto**: gli host dovrebbero comunicare tra di loro direttamente, senza intromissione di nodi nè modifica di indirizzi IP e numeri di porta. per risolvere la scarsità di indirizzi IP, si dovrebbe usare IPv6
>- fa interferenza con le applicazioni P2P in cui ogni peer dovrebbe essere in grado di avviare una connessione TCP con qualsiasi altro peer, a meno che il NAT non sia specificamente configurato per quella specifica applicazione P2P
# forwarding dei datagrammi IP
inoltrare un datagramma significa collocarlo sul giusto percorso (porta di uscita del router), che lo farà avanzare verso la destinazione: inviare il datagramma al **prossimo hop**
in particolare, quando un host ha un datagramma da inviare, lo invia al router della rete locale, che accede alla tabella di routing per trovare l’hop successivo a cui inviarlo: l’inoltro richiede una riga nella tabella **per ogni blocco di rete**
>[!example] esempio
![[Pasted image 20250423204754.png]]
le entry che non hanno un next hop sono collegate direttamente al router

>[!info] instradamento
un’altra rappresentazione della tabella d’inoltro è:
![[Pasted image 20250423204927.png]]
>- la prima colonna contiene i bit che identificano il blocco di indirizzi (lunghezza inferiore a 32 bit)
>
>un datagramma contiene però l’indirizzo IP dell’host di destinazione (32 bit), e non indica la subnet mask. l’instradamento si esegue in questo modo:
>- quando arriva un datagramma in cui i 26bit a sinistra nell’indirizzo di destinazione combaciano con i bit della prima riga, il pacchetto viene inviato attraverso l’interfaccia `m2`, e viene gestito analogamente per gli altri casi (le subnet mask vengono applicate in ordine, in quanto sono ordinate in ordine decrescente)

>[!example] esempio di instradamento
![[Pasted image 20250423205415.png]]

### aggregazione degli indirizzi
in questo modo, inserire nella tabella una riga per ogni blocco può portare a tabelle molto lunghe, con aumento del tempo necessario per fare la ricerca
si usa quindi **l’aggregazione degli indirizzi**
>[!info] aggregazione degli indirizzi
![[Pasted image 20250423205907.png]]
in questo caso, gli indirizzi delle società 1, 2, e 4 (indirizzi del tipo `140.24.7.xx/26`) vengono aggregati da $R2$ in una sola voce : `140.24.7.0/24` (si ha quindi una corrispondenza con la maschera più lunga !)

>[!info] livello di rete Internet
![[Pasted image 20250423210502.png]]
# ICMP
**ICMP** (**internet control message protocol**) permette di notificare errori, e aiuta il protocollo IP, che non gestisce nessun tipo di errore, per esempio:
- caso in cui un router deve scartare un datagramma perchè non riesce a trovare un percorso per la destinazione finale
- caso in cui un datagramma ha il campo `TTL == 0`
- caso in cui l’host di destinazione non ha ricevuto tutti i frammenti di un datagramma entro un determinato limite di tempo
il protocollo ICMP viene quindi usato da host e router per scambiarsi informazioni a livello di rete
>[!warning] il campo dati dei datagrammi IP può contenere un messaggio ICMP !!
e ICMP è considerato parte di IP, anche se usa IP per inviare i suoi mesaggi

>[!example] ICMP 
![[Pasted image 20250410153256.png]]
un tipico uso di ICMP è per mandare un feedback quando un messaggio IP viene mandato. per esempio, in questa immagine, l’host A prova a mandare un datagramm IP all’host B. ma quando il datagramma arriva al router R3, c’è un problema di qualche tipo che causa al datagramma di essere droppato. R3 manda un messaggio ICMP all’host A per notificare che è successo qualcosa, **possibilmente** con abbastanza informazioni per rendere A capace di correggere il problema, se possibile
>- in questa situazione, R3 può mandare il messaggio ICMP solo all’host A, non a R2 o R1

## messaggi ICMP
i messaggi ICMP hanno un campo **TIPO** e un campo **CODICE**, e contengono l’intestazione e i primi 8 byte del datagramma IP che ha provocato la generazione del messaggio (huh, ok though)

| tipo | codice | descrizione                             |
| ---- | ------ | --------------------------------------- |
| 0    | 0      | risposta eco (a ping)                   |
| 3    | 0      | rete destinatario irraggiungibile       |
| 3    | 1      | host destinatario irraggiungibile       |
| 3    | 2      | protocollo destinatario irraggiungibile |
| 3    | 3      | porta destinatario irraggiungibile      |
| 3    | 6      | rete destinatario sconosciuta           |
| 3    | 7      | host destinatario sconosciuto           |
| 4    | 0      | riduzione (controllo di congestione)    |
| 8    | 0      | richiesta eco                           |
| 9    | 0      | annuncio del router                     |
| 10   | 0      | scoperta del router                     |
| 11   | 0      | TTL scaduto                             |
| 12   | 0      | errata intestazione IP                  |
