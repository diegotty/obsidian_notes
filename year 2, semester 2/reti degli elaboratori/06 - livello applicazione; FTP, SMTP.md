---
created: 2025-03-19T18:58
updated: 2025-05-09T10:56
---
>[!index]
>- [FTP](#FTP)
>	- [connessioni FTP](#connessioni%20FTP)
>		- [connessione di controllo](#connessione%20di%20controllo)
>		- [connessione dati](#connessione%20dati)
>	- [comandi e risposte FTP](#comandi%20e%20risposte%20FTP)
>		- [principali comandi FTP](#principali%20comandi%20FTP)
>		- [esempi di risposte FTP](#esempi%20di%20risposte%20FTP)
>- [posta elettronica](#posta%20elettronica)
>	- [SMTP](#SMTP)
>	- [formato dei messaggi di posta elettronica](#formato%20dei%20messaggi%20di%20posta%20elettronica)
>		- [esempi di header](#esempi%20di%20header)
>	- [MIME](#MIME)
>		- [messaggi con MIME](#messaggi%20con%20MIME)
>	- [protocolli di accesso alla posta](#protocolli%20di%20accesso%20alla%20posta)
>		- [POP3](#POP3)
>		- [IMAP](#IMAP)
>		- [HTTP](#HTTP)
>
# FTP
**FTP** (file transfer protocol) è un programma di trasferimento file da/a un host remoto. segue il modello client/server:
- **client**: il lato che inizia il trasferimento 
- **server**: host remoto
>[!example] comunicazione FTP
![[Pasted image 20250319110917.png]]
>- quando un utente fornisce il nome dell’host remoto, con il comando `ftp nomeHost`, il processo client FTP stabilisce una connessione TCP sulla porta 21 con il processo server FTP
>- stabilita la connessione, il client fornisce nome utente e password che vengono inviate sulla connessione TCP come parte dei comandi
>- ottenuta l’autorizzazione del server, il client può inviare uno o più file memorizzati nel file system locale verso quello remoto, o viceversa
						mommy maselli
## connessioni FTP
durante la comunicazione con FTP, avvengono 2 connessioni:
### connessione di controllo
si occupa delle informazioni di controllo del trasferimento: identificativo utente, password, comandi per cambiare dir, comandi per richiedere invio/ricezione di file, …
usa regole molto semplici, così che lo scambio di informazioni si riduce allo scambio di una riga di comando per ogni interazione !
- avviene sulla **porta 21**, e viene aperta con il comando `ftp nomeHost`
- tutti i comandi eseguiti dall’utente vengono trasferiti sulla connessione di controllo
- è detta una connessione **out of band**(fuori banda): utilizza un canale separato rispetto alla connesione dati per gestire i comandi e le risposte tra client e server (HTTP per esempio usa un solo canale x tutto !)
- il server FTP mantiene lo “stato”: dir corrente, autenticazione precedente
- è **persistente**
### connessione dati
si occupa del trasferimento del file: quando il server riceve un comando per trasferire un file (che sia `get` o `put`), apre una connessione dati TCP sulla **porta 20** con il client, e dopo il trasferimento di un file, il server chiude la connessione
- la connessione viene quindi usata solo per il vero e proprio invio del file, e si crea una nuova connessione per ogni file trasferito all’interno della sessione
- è quindi **non persistente**
>[!figure] connessioni FTP
![[Pasted image 20250319113753.png]]

## comandi e risposte FTP
### principali comandi FTP

| comando | argomenti              | descrizione                                     |
| ------- | ---------------------- | ----------------------------------------------- |
| `ABOR`  |                        | interruzione del comando precedente             |
| `CDUP`  |                        | sale di un livello nell’albero delle dir        |
| `CWD`   | nome della dir         | cambia la dir corrente                          |
| `DELE`  | nome del file          | cancella il file                                |
| `LIST`  | nome della dir         | elenca il contenuto della dir                   |
| `MKD`   | nome della dir         | crea una nuova dir                              |
| `PASS`  | password utente        | password                                        |
| `PASV`  |                        | il server sceglie la porta                      |
| `PORT`  | numero di porta        | il client sceglie la porta                      |
| `PWD`   |                        | mostra il nome della directory corrente         |
| `QUIT`  |                        | uscita dal sistema                              |
| `RETR`  | nome di uno o più file | trasferisce uno o più file dal server al client |
| `RMD`   | nome della dir         | cancella la dir                                 |
| `RNTO`  | nome (del nuovo) file  | cambia il nome del file                         |
| `STOR`  | nome di uno o più file | trasferisce uno o più file dal client al server |
| `USER`  | identificativo         | identificazione dell’utente                     |
### esempi di risposte FTP
le risposte sono composta da due parti:
- un numero di 3 cifre: il codice della risposta
- un testo: i parametri necessari o informazioni supplementari
la tabella seguente riporta solo i codici

| codice | descrizione                                        |
| ------ | -------------------------------------------------- |
| 125    | connessione dati aperta                            |
| 150    | stato del file OK                                  |
| 200    | comando OK                                         |
| 220    | servizio pronto                                    |
| 221    | servizio in chiusura                               |
| 225    | connessione dati aperta (?)                        |
| 226    | connesione dati in chiusura                        |
| 230    | login dell’utente OK                               |
| 250    | azione sul file OK                                 |
| 331    | nome dell’utente OK: in attesa della password      |
| 425    | non è possibile aprire la connesione dati          |
| 450    | azione sul file non eseguita; file non disponibile |
| 452    | azione interrotta; spazio insufficiente            |
| 500    | errore di sintassi; comando non riconosciuto       |
| 501    | errore di sintassi nei parametri o negli argomenti |
| 530    | login dell’utente fallito                          |

>[!example] esempio richiesta e risposta FTP
![[Pasted image 20250319190752.png]]
# posta elettronica
esistono 3 componenti principali nel funzionamento della posta elettronica:
- **user agent**(UA): detto anche “mail reader”, è usato per scrivere e inviare un messaggio o leggerlo. viene attivato dall’utente o da un timer: se c’è una nuova email informa l’utente, ma si occupa anche di composizione, editing e lettura dei messaggi di posta elettronica. inoltre passa al MTA il messaggio da inviare
	- esempi: eudora, outlook, thunderbird
- **message transfer agent**(MTA): usato per trasferire il messaggio attraverso Internet
>[!info] come comunicano gli MTA ?
![[Pasted image 20250319191644.png]]
>gli MTA comunicano attraverso il protocollo **SMTP**(simple mail transfer protocol), e sono costituiti da:
>- casella di posta: contiene i messaggi in arrivo per l’utente
>- coda di messaggi: i messaggi da trasmettere (tentativi ogni $x$ minuti per alcuni giorni)
- **message access agent**(MAA): usato per leggere la mail in arrivo
vediamo il loro funzionamento nell’esempio:
>[!example] l’esempio
![[Pasted image 20250319191229.png]]

## SMTP
il protocollo **SMTP** usa [[06 - livello applicazione; FTP, SMTP#FTP|FTP]] per trasferire in modo affidabile i messaggi di posta elettronica dal client al server, utilizzando la porta 25
- il trasferimento è diretto: dal server trasmittente al server ricevente, e si divide in 3 fasi:
	- handshaking
	- trasferimento di messaggi
	- chiusura
i messaggi devono essere in formato ASCII a 7 bit, così come i comandi inviati durante la comunicazione. le risposte invece sono composte da codice di stato ed espressione
- SMTP usa conessioni persistenti, e più oggetti vengono trasmessi in un unico messaggio
>[!warning] HTTP ed STMP
una delle differenze sostanziali tra HTTP ed STMP, che sono entrambi protocolli utilizzati per trasferire file da un host all’altro è:
>- HTTP è un protocollo di **pull**: gli utenti iniziano le connessioni TCP e scaricano i file da loro richiesti
>- SMTP è un protocollo di **push**: il server di posta inizia la connessione TCP e spedisce il file

>[!example] esempio …
>1. alice usa il suo agente utente per comporre il messaggio da inviare a `rob@someschool.edu`
>2. l’agente utente di alice invia un messaggio al server di posta di alice: il messagio è posto nella coda di messaggi
>3. il lato client di SMTP apre una connessione TCP con il server di posta di rob
>4. il client SMTP invia il messaggio di alice sulla connessione TCP
>5. il server di posta di rob riceve il messaggio e lo pone nella casella di posta di rob
>6. rob invoca il suo agente utente per leggere il messagio
![[Pasted image 20250319192341.png]]

>[!esempio] a livello di protocollo:
![[Pasted image 20250319192356.png]]
>1. il client SMTP, che gira sull’host server di posta in invio, fa stabilire una connessione sulla porta 25 verso il server SMTP: se il server è inattivo, il client riprova più tardi, altrimenti viene stabilita la connessione
>2. il server e il client effettuano una forma di handshaking (il client indica indirizzo email del mittente e del destinatario)
>3. il client invia il messaggio
>4. il messaggio arriva al server destinatario grazie all’affidabilità di TCP
>
>se ci sono altri messaggi, si usa la stessa connessione (in quanto è una connessione persistente), altrimenti il client invia richiesta di chiusura di connessione


## formato dei messaggi di posta elettronica
>[!info] formato dei messaggi
![[Pasted image 20250320092444.png]]
### esempi di header

| header  | descrizione                                                                                                                                         |
| ------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| to      | indirizzo di uno o più destinatari                                                                                                                  |
| from    | indirizzo del mittente                                                                                                                              |
| cc      | indirizzo di uno o più destinatari a cui si invia per conoscenza, (gli altri destinatari sanno a chi altro è stata inviata la mail) (crack cocaina) |
| bcc     | blind cc: gli altri destinatari non sanno che anche lui riceve il messaggio                                                                         |
| subject | argomento del messaggio                                                                                                                             |
| sender  | chi materialmente effettua l’invio (es: nome della segretaria)                                                                                      |
`cc` and `bcc` are mostly about email visibility and etiquette, not routing

>[!example] ulteriore esempio
![[Pasted image 20250320092814.png]]
## MIME
il protocollo **MIME** viene usato per inviare messaggi in formati che non sono ASCII
>[!info] utilizzo di MIME
![[Pasted image 20250319195741.png]]
>MIME si occupa di tradurre da entrambe le parti il codice non-ASCII in ASCII e poi di nuovo in non-ASCII (in quanto SMTP richiede che i messaggi siano in ASCII a 7 bit)
### messaggi con MIME
- vengono usate intestazioni aggiuntive per dichiarare il tipo di contenuto MIME
>[!example] messaggio con oggetto MIME
invio:
![[Pasted image 20250319200022.png]]
>-`Content-Transfer-Encoding` indica il metodo usato per codificare i dati in ASCII
ricezione:
![[Pasted image 20250319200146.png]]

## protocolli di accesso alla posta
come abbiamo visto, SMTP è un protocollo di **push**: si occupa della consegna del messaggio sul sever del destinatario. di conseguenza, non può essere usato dall’agente utente del destinatario perchè l’utente, per leggere la mail, deve eseguire un’operazione di **pull**
per eseguire un’operazione di **pull**, ci si può affidare a:
- **POP3**
- **IMAP**
- **HTTP**
### POP3
il protocollo **POP3** permette al client ricevente la posta di aprire una connessione TCP verso il server di posta, sulla porta 110. una volta che la connessione è stabilita, si procede in 3 fasi:
- **autorizzazione**: l’agente utente invia nome utente e password per essere identificato
- **transazione**: l’agente utente recupera i messaggi
- **aggiornamento**: dopo che il client ha inviato `QUIT`, e quindi conclusa la connessione, vengono cancellati i messaggi marcati per la rimozione
>[!info] comandi POP3
![[Pasted image 20250320090746.png]]
>- in questo esempio, viene usata la modalità “scarica e cancella”: rob non potrà rileggere le e-mail se cambia il client(in quanto saranno eliminate sul server, e salvate solo sul client da cui le ha lette e scaricate)
>- si può anche usare la modalità “scarica e mantieni”, in cui i messaggi vengono mantenuti sul server dopo essere stati scaricati dal client

POP3 è un protocollo senza strato tra le varie sessioni (?), e non fornisce all’utente alcuna procedura per creare cartelle remote ed assetnare loro messaggi, ma l’utente può crearle solo localmente sul suo computer !
### IMAP
a differenza di **POP3**, il protocollo **IMAP**:
- mantiene tutti i messaggi in un unico posto: il server
	- in particolare, un **server IMAP** asssocia a una **inbox**(una cartella) ogni messaggio arrivato al server (quindi ogni messaggio si trova in una inbox)
- consente all’utente di organizzare i messaggi in cartelle, fornendo comandi agli utenti per creare cartelle, spostare messaggi tra cartelle, ed effettuare ricerche nelle cartelle remote
- conserva lo stato dell’utente tra le varie sessioni: i nomi delle cartelle e le associazioni messaggi-cartelle(conservano praticamente la struttura del ““““filesystem ad un livello””””””’ ?)
- fornisce comandi che permettono agli utenti di ottenere componenti di un messaggio (es: intestazione, parte di un messaggio)
### HTTP
si torna sempre dove si è stati bene ! infatti alcuni mail server forniscono accesso alla mail via web (ovvero mediante il protocollo HTTP). l’agente utente è quindi il browser (che fa richiesta al MTA usando client-side HTTP (?))
- SMTP rimane il protocollo di comunicazione tra mail server, ovviamente
>[!example] esempio
![[Pasted image 20250320092142.png]]
