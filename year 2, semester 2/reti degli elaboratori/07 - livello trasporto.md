---
related to: "[[03 - introduzione allo stack protocollare TCP-IP]]"
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]-
>- [livello trasporto](#livello%20trasporto)
>	- [indirizzamento](#indirizzamento)
>		- [incapsulamento/decapsulamento](#incapsulamento/decapsulamento)
>		- [multiplexing/demultiplexing](#multiplexing/demultiplexing)
>			- [demultiplexing](#demultiplexing)
>	- [API di comunicazione](#API%20di%20comunicazione)
>		- [numeri di porta](#numeri%20di%20porta)
>		- [individuare i socket](#individuare%20i%20socket)
>- [servizi di trasporto](#servizi%20di%20trasporto)
>	- [overview](#overview)
>	- [UDP](#UDP)
>		- [datagrammi UDP](#datagrammi%20UDP)
>		- [checksum UDP](#checksum%20UDP)
>	- [TCP](#TCP)
>		- [demultiplexing orientato alla connessione](#demultiplexing%20orientato%20alla%20connessione)
>		- [servizio connection-oriented](#servizio%20connection-oriented)
>		- [controllo di flusso](#controllo%20di%20flusso)
>		- [controllo degli errori](#controllo%20degli%20errori)
>			- [realizzazione](#realizzazione)
>		- [integrazione di controllo di errori e controllo di flusso](#integrazione%20di%20controllo%20di%20errori%20e%20controllo%20di%20flusso)
>		- [controllo della congestione](#controllo%20della%20congestione)

# livello trasporto
i protocolli di trasporto forniscono la **comunicazione logica** tra processi applicativi di host differenti
- gli host eseguono i processi come se fossero direttamente connessi, anche se sono agli antipodi del pianeta (a loro non frega nulla !!!)
i protocolli di trasporto vengono quindi eseguiti nei **sistemi terminali**:
- **lato invio**: **incapsula** i messaggi in **segmenti** e li passa al ivello di rete
- **lato ricezione**: **decapsula** i segmenti in messaggi e li passa al livello applicazione
>[!info] livello di trasporto e livello di rete
il livello di trasporto quindi comunica con il livello di rete, ma offrono servizi diversi:
>- **livello di trasporto**: si occupa della comunicazione tra processi (si basa sui servizi del livello rete e li potenzia)
>- **livello di rete**: si occupa della comunicazione tra host (si basa sui servizi del livello collegamento)
![[Pasted image 20250321110954.png]]
>>[!example] esempio
>>**analogia con la posta ordinaria**:
>>una persona di un condominio invia una lettera ad una persona di un altro condominio consegnandola/ricevendola da/a un portiere
>>- processi = persone
>>- messaggi delle applicazioni = lettere
>>- host = comdomini
>>- protocollo di trasporto = portieri dei condomini ( i portieri svolgono il proprio lavoro localmente, non sono coinvolti nella tappe intermedie delle lettere, così come il protocollo di trasporto)
>>- protocollo del livello di rete = servizio postale
## indirizzamento
la maggior parte dei SO è **multiutente** e **multiprocesso**, quindi ci sono:
- diversi processi clienti attivi (host locale)
- diversi processi server attivi (host remoto)
per stabilire una comunicazione tra i due processi è necessario un metodo per individuare:
- **host locale** → indirizzo IP locale
- **host remoto** → indirizzo IP remoto
- **processo locale** → numero di porta
- **processo remoto** → numero di porta
un **socket address** è l’unione di indirizzo IP e porta
### incapsulamento/decapsulamento
>[!info] illustrazione !
![[Pasted image 20250321112311.png]]
>i pacchetti a livello di trasporto sono chiamati **segmenti** se viene usato il protocollo TCP, o **datagrammi utente** se viene usato il protocollo UDP
### multiplexing/demultiplexing
permette di rendere il servizio di trasporto da **host a host** fornito dal livello di rete un servizio di trasporto da **processo a processo** per le applicazioni eseguite sugli host
- **multiplexing dell’host mittente**: raccogliere i dati da varie socket, incapsularli con l’intestazione e passarli al livello di rete
- **demultiplexing dell’host destinatario**: consegnare i segmenti ricevuti alla socket appropriata. una volta ricevuti i dati del livello di rete, indirizza i dati a uno dei processi dell’'host ricevente grazie alle informazioni all’interno dell’header
#### demultiplexing
l’host riceve i datagrammi IP (pacchetti del livello rete)
- ogni datagramma ha un indirizzo IP di origine e un indirizzo IP di destinazione, e trasporta un segmento a livello di trasporto:
	- il segmento ha un numero di porta di origine e un numero di porta di destinazione
>[!info]- struttura del pacchetto TCP/UDP
![[Pasted image 20250321113540.png]]

l’host usa quindi indirizzi IP e numeri di porta per inviare il segmento al processo appropriato
## API di comunicazione
>[!info] huh
![[Pasted image 20250321113643.png]]

il **socket** è un’astrazione (?): una struttura dati creata e utilizzata dal programma applicativo, che permette di comunicare, attraverso il socket,  tra un processo client e un processo server (???????)
>[!info] illustrazione
![[Pasted image 20250321114427.png]]
### numeri di porta
i numeri di porta sono indirizzi di 16bit, che vanno quindi da 0 a 65535, divisi in:
- **well known ports**: porte riservate per servizi comuni e noti
	- FTP 20
	- TELNET 23
	- SMTP 25
	- HTTP 80
	- POP3 110
	- ….
- **assigned ports**
	- 0: non usata
	- 1-255: **well known ports**
	- 256-1023: riservate per altri processi
	- 1024-65535: dedicate a user apps (utilizzabili da tutti per nuove applicazioni)

dato che l’interazione tra client e server è bidirezionale, è necessaria una coppia di indirizzi socket: **locale**(mittente) e **remoto**(destinatario)
- l’indirizzo locale in una direzione è l’indirizzo remoto nell’altra direzione !
### individuare i socket
come vengono individuati questi indirizzi ?
>[!info] individuare i socket lato client
>- **socket adress locale**: fornito dal SO, in quanto conosce l’indirizzo ip del computer su cui il client è in esecuzione. il numero di porta è assegnato temporaneamente dal SO(un socket dedicato a user apps \\QUESTION ……)
>- **socket address remoto**: il numero di porta è conosciuto in base all’applicazione, mentre l’indirizzo IP è fornito dal DNS 

>[!info] individuare i socket lato server
>- **socket address locale**: fornito dal SO, in quanto conosce l’indirizzo IP del computer su cui il server è in esecuzione. il numero di porta è noto al server perchè assegnato dal progettista ! (numero well known o scelto)
>- **socket address remoto**: è il socket address locale del client che si connette ! lo trova quindi all’interno del pacchetto di richiesta
>>[!warning] il socket address locale di un server non cambia(rimane fisso e invariato), mentre il socket address remoto varia ad ogni interazione con client diversi ( o stesso client su connessioni diverse)
# servizi di trasporto
## overview
**TCP**:
- orientato alla connessione: è richiesto un setup fra processi client e server, che permette la “““creazione di un tubo”””” in cui i bit arrivano in ordine di spedizione
- trasporto affidabile
- controllo di flusso: il mittente non vuole sovraccaricare il destinatario
- controllo della congestione: “strozza” il processo d’invio quando la rete è sovraccaricata (kinky)
- non offre: temporizzazione, garanzie su ampiezza di banda minima, sicurezza
**UDP**
- senza connessione
- trasporto inaffidabile
- non offre: setup della connessione, affidabilità, controllo di flusso, controllo della congestione, temporizzazione, ampiezza di banda minima, sicurezza

>[!warning] sockets
socket per TCP : ip e porta mittente + ip e porta destinatario 
socket per UDP :  numero di porta  + ip del destinatario (ip e porta del mittente sono comunque nel pacchetto affinchè il server possa rispondere ! quindi è solo una distinzione logica, le informazioni ci sono comunque )

>[!info]- perchè usare UDP ? 
![[Pasted image 20250321125022.png]]
è più veloce, ed è usato quando non interessa che arrivi sempre tutto e in ordine perfetto. 
## UDP
il protocollo **UDP** è quindi un protcollo di trasporto inaffidabile e privo di connessione
fornisce i servizi di:
- comunicazione tra processi utilizzando i socket
- multiplexing/demultiplexing dei pacchetti
- incapsulamento e decapsulamento 
	- i datagrammi sono indipendenti e non numerati
- controllo checksum per errori (unico controllo che fornisce)
>[!info] diagramma di comunicazione
il mittente invia pacchetti un dopo l’altro senza pensare al destinatario
>- ne può inviare a raffica in quanto non c’è un controllo di flusso o di congestione
![[Pasted image 20250321123345.png]]

UDP è connectionless: non c’è coordinazione tra livello di trasporto del mittente e del destinatario: il mittente divide i suoi messaggi in porzioni di dimensioni accettabili dal livello di trasporto, a cui lo consegna uno per uno.
- la sequenza di arrivo può essere diversa da quella di spedizione, in quanto i pacchetti sono **indipendenti** l’uno dall’altro
### datagrammi UDP
nel procollo UDP, i messaggi devono avere dimensione inferiore a 65507 byte (65535 - 8 byte di intestazione UDP e 20 byte di intestazione IP)
>[!info] struttura dei datagrammi UDP
![[Pasted image 20250321124006.png]]
>i primi 4 campi occupano ognuno 2 byte (insieme sono quindi gli 8 byte di intestazione UDP !)
### checksum UDP
l’obbiettivo del **checksum** è di rilevare i bit alterati nel datagramma trasmesso
il procedimento è il seguente:
1. il messaggio del mittente viene diviso in parole da 16bit
2. il valore del checksum viene inizialmente posto a 0
3. tutte le parole del messaggio, incluso il checksum, vengono sommate usando l’addizione complemento ad 1 (ca1)
4. viene fatto il complemento ad uno della somma e il risultato è il checksum
5. il checksum viene inviato assieme ai dati
il ricevente esegue gli stessi passi, e se il valore del checksum calcolato dal ricevente è 0, allora il messaggio viene accettato, altrimenti viene scartato

>[!info] DNS usa UDP !
>quando vuole effettuare una query, DNS costruisce un messaggio di query, lo passa a UDP e aspetta una risposta. se non ne riceve, tenta di inviarla a un altro server dei nomi (server dei nomi ? server DNS ?)
## TCP
il protocollo di trasporto **TCP** fornisce i servizi di:
- comunicazione tra processi
- incapsulamento/decapsulamento
- multiplexing/demultiplexing
- trasporto orientato alla connessione
- controllo di flusso
- controllo degli errori
- controllo della congestione
### demultiplexing orientato alla connessione
la socket TCP è identificata da 4 parametri:
- indirizzo IP di origine
- numero di porta di origine
- indirizzo IP di destinazione
- numero di porta di destinazione
l’host ricevente usa i quattro parametri per inviare il segmento alla socket appropriata
- un host server può supportare più socket TCP contemporaneamente !
- i socket web hanno socket differenti per ogni connessione client
- con HTTP non persistente, si avrà una socket differente anche per ogni richiesta dallo stesso client
>[!info] img
![[Pasted image 20250321131641.png]]
### servizio connection-oriented
viene stabilita una **connessione logica** prima di scambiarsi i dati !
>[!info] gestione di messaggi in ordine errato
![[Pasted image 20250321132102.png]]
### controllo di flusso
quando un’entità produce dati che un’altra entità deve consumare, deve esistere un equilibrio fra la velocità di produzione e la velocità di consumo dei dati
- velocità di produzione > velocità di consumo: il consumatore potrebbe essere sovraccaricato e costretto ad eliminare dati
- velocità di produzione < velocità di consumo: il consumatore rimane in attesa riducendo efficienza del sistema (migliore delle due opzioni, non è grave)

>[!warning] il **controllo del flusso** è legato alla prima problematica per evitare di perdere dati !
>si riferisce al flusso di dati tra mittente e destinatario al contrario del [[#controllo della congestione]], che si riferisce alla rete, ed è quindi più generale

>[!info] controlli di flusso a livello trasporto
![[Pasted image 20250321132830.png]]

come viene realizzato il controllo di flusso ?
- esiste un **buffer** contenente pacchetti
vengono comunicate informazioni di controllo d flusso tramite segnali dal consumatore al produttore:
- **il livello di trasporto del destinatario segnala al livello trasporto del mittente** di sospendere l’invio di messaggi quando ha il buffer **mittente** saturo (e segnala di poter riprendere l’invio quando si libera spazio nel buffer)
- **il livello di trasporto del mittente segnala al livello applicazione** di sospendere l’invio di messaggi quando ha il buffer **destinatario** saturo (come sopra)
>[!warning] esistono quindi 2 buffer ! uno del mittente e uno del destinatario
### controllo degli errori
poichè il livello di rete è inaffidabile, è necesario implementare l’affidabilità al livello di trasporto, implementando un **controllo degli errori** sui pacchetti che permette di:
- rilevare e scartare pacchetti corrotti
- tenere traccia dei pacchetti persi e gestirne il rinvio
- riconoscere pacchetti duplicati e scartarli
- bufferizzare i pacchetti fuori sequenza finchè arrivano i pacchetti mancanti
il controllo degli errori coinvolge solo i livelli trasporto di mittente e destinatario, attraverso segnalazioni da parte del destinatario al mittente
#### realizzazione
ogni pacchetto viene etichettato con un **numero di sequenza**, utile al destinatario per capire:
- la sequenza di pacchetti in arrivo
- i pacchetti persi
- i pacchetti duplicati
in questo modo il destinatario può scartare i pacchetti corrotti e duplicati. se un pacchetto viene perso invece, il mittente se ne accorge per la mancanza di **numero di riscontro**(acknowledgement/`ACK`/conferma), che permette al destinatario di notificare al mittente la corretta ricezione di un pacchetto
### integrazione di controllo di errori e controllo di flusso
a combinazione dei due meccanismi avviene mediante un **buffer numerato** presso mittente e destinatario:
>[!info] integrazione per mittente
>- quando prepara un nuovo pacchetto, usa come numero di sequenza il numero ($x$) della prima locazione libera nel buffer
>- quando invia il pacchetto ne memorizza una copia nella locazione $x$
>- quando riceve un `ACK` di un pacchetto, libera la posizione di memoria che era occupata da quel pacchetto

>[!info] integrazione per destinatario
>- quando riceve un pacchetto con numero di sequenza $y$, lo memorizza nella locazione $y$ fin quando il livello applicazione è pronto a riceverlo
>- quando passa il pacchetto $y$ al livello applicazione, invia `ACK` al mittente

poichè i numeri di sequenza sono calcolati in modulo $2^m$(il numero di posti nel buffer è un potenza di 2), possono essere rappresentati in un cerchio
- il buffer viene rappresentato con un insieme di settori, chiamati **sliding windows**, che in ogni istante occupano una parte del cerchio
>[!figure] buffer come cerchio
![[Pasted image 20250321135647.png]]

>[!figure] buffer come sliding window
![[Pasted image 20250321135812.png]]
### controllo della congestione
nella [[01 - introduzione alle reti#reti a commutazione di pacchetto (store and forward)|commutazione a pacchetto]], la congestione avviene se il **carico**(numero di pacchetti inviati alla rete) della rete è superiore alla **capacità**(numero di pacchetti che la rete può gestire) della rete
- il controllo della congestione si concretizza quindi in una serie di meccanismi e tecniche per controllare la congestione, manetenendo il carico della rete al di sotto della sua capacità