---
created: 2025-03-19T13:44
updated: 2026-01-16T05:49
---
>[!index]
>- [livello applicazione](#livello%20applicazione)
>	- [WWW](#WWW)
>	- [URL](#URL)
>	- [documenti web](#documenti%20web)
>- [HTTP](#HTTP)
>	- [connessioni HTTP](#connessioni%20HTTP)
>		- [RTT](#RTT)
>	- [messaggi HTTP](#messaggi%20HTTP)
>		- [richiesta HTTP](#richiesta%20HTTP)
>			- [metodi di richiesta](#metodi%20di%20richiesta)
>			- [header nella richiesta](#header%20nella%20richiesta)
>		- [risposta HTTP](#risposta%20HTTP)
>			- [codici di risposta](#codici%20di%20risposta)
>			- [intestazioni nella risposta](#intestazioni%20nella%20risposta)
>- [cookie](#cookie)
>	- [sessioni](#sessioni)
>- [web caching](#web%20caching)
>		- [GET condizionale](#GET%20condizionale)

# livello applicazione
come abbiamo visto nel [[03 - introduzione allo stack protocollare TCP-IP#livello 5 applicazione|livello applicazione]], i protocolli in questo livello sono spesso parte di app
>[!info] evoluzione app Internet
![[Pasted image 20250316230932.png]]
## WWW
**WWW**(World Wide Web): applicazione Internet nata dalla necessità di scambio e condivisione di informazioni tra ricercatori universitari di varie nazioni
>[!info] storia
>- 1990: inizialmente una rete di documenti collegati utilizzata sopratutto per scopi universitari
>- prototipo basato su testo (collegamenti ipertestuali)
>- 1993: primo browser grafio (mosaic - netscape)
>- 1994: **W3C**(World Wide Web Consortium):  organizzazione per sviluppare ulteriormente il Web, standardizzare i protocolli, etc.

caratteristiche:
- opera on demand (al contrario di approcci proattivi, in cui c’è sempre qualcosa in funzione)
- facile rendere informazioni disponibili
- **hyperlinks**(collegamenti ipertestuali) e motori di ricerca permettono di navigare su una grande quantità di siti
componenti:
- web client: interfaccia con l’utente (es: browser)
- web server (es: apache)
- HTML: linguaggio standard per pagine web
- HTTP: protocollo per la comunicazione tra clienti e server Web (indipendente dal linguaggio di programmazione usato)

>[!info] terminologia
>- una pagina web è costituita da **oggetti**
>- ogni oggetto puo essere un file HTML, un’immagine, un’applet, un file audio, …
>- una pagina web è formata da un file base HTML, che include diversi oggetti referenziati (una richiesta da parte del client ad un server può scaricare richieste ad altri server
>- ogni oggetto è referenziato da un **URL**
## URL
gli oggetti rifererenziati si possono recuperare attraverso l’**URL**(Uniform Resource Locator), che è composto di 3 parti:
1. il protocollo
2. il nome della macchina in cui è situata la pagina
3. il percorso del file (localmente alla macchina), che indica la pagina, il nome del file e la posizione nel filesystem
```
protocol://host/path #utilizzato quando la porta è standard
protocol://host:porta/path #utilizzato quando è necessario specificare il numero di porta
```
## documenti web
- documento statico: contenuto predeterminato e memorizzato sul server
- documento dinamico: alcune delle informazioni vengono generate dal web server alla ricezione della richiesta (es: date)
- documento attivo: contiene script(es: applet java) o programmi che verranno eseguiti nel browser (ovvero lato client)
# HTTP
come abbiamo visto, il protocollo **HTTP** (hypertext transfer protocol) è uno dei protocolli di comunicazione usati per accedere ai documenti richiesti dall’utente (lato client)
- definisce quindi in che modo i client web richiedono le pagine ai server web, e come questi le trasferiscono ai client
caratteristiche:
- si basa sul modello client/server
	- client: il browser, che richiede, riceve e visualizza gli oggetti del Web
	- server: il server web che invia oggetti in risposta a una richiesta
>[!example]- esempio di connessione HTTP
![[Pasted image 20250316232817.png]]

## connessioni HTTP
esistono due modalità per ricevere più oggetti dallo stesso server:
- connessioni non persistenti: viene stabilita una connessione TCP per ogni file. prima di inviare una richiesta al server è necessario stabilire una connessione
	- le richieste non persistenti si possono parallelizzare(tipicamente da 5 a 10 connessioni), quindi potenzialmente sono più veloci ma con più overhead
	- richiedono 2 RTT per oggetto
- connessioni persistenti (modalità di default): la connessione viene chiusa quando rimane inattiva per un lasso di tempo configurabile
	- le richieste persistenti sono sequenziali 
	- un solo RTT di connessione per tutti gli oggetto referenziati + un RTT per ogni oggetto ricevuto dal server
### RTT
**RTT**(round trip time): tempo impiegato da un **piccolo** pacchetto per andare da client a server e ritornare al client. include i ritardi di elaborazione, accodmento, propagazione e trasmissione 
>[!example]- tempo di risposta
![[Pasted image 20250316233652.png]]
il tempo di risposta per una connessione è:
>- un RTT per iniziare la connessione TCP
>- un RTT per la richiesta HTTP e i primi byte della risposta HTTP
>- tempo di trasmissione del file
## messaggi HTTP
### richiesta HTTP
>[!info] richiesta HTTP
![[Pasted image 20250316233849.png]]
esempio di richiesta HTTP:
>```js
>GET /somedir/page.html HTTP/1.1 //request line
>Host: www.someschool.edu //header line
>Connection: close //header line
>User-agent: Mozilla/4.0 //header line
>Accept-Language:fr //header line
>(carriage return e line feed extra) //blank line
>```
#### metodi di richiesta

| metodo di richiesta | descrizione                                                                                                                                                                                           |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET                 | usato quando il client vuole scaricare, da un server, il documento specificato nell’URL. il server risponde con il documento richiesto nel corpo nel messaggio di risposta                            |
| HEAD                | usato quando il client non vuole scaricare il documento, ma solo alcune informazioni sul documento (es: data dell’ultima modifica). nella risposta, il server inserisce solo degli header informativi |
| POST                | usato per fornire input al server (es: contenuto dei campi di un form). l’input viene inserito nel corpo dell’entità                                                                                  |
| PUT                 | utilizzato per memorizzare un documento nel server. il documento viene fornito nel corpo del messaggo, e la posizione di memorizzazione nell’URL                                                      |
>[!info] è posibile inviare info al server anche attraverso una richiesta GET
utilizzando gli `&` nell’url:
>```js
>GET www.somesite.com/animalsearch?monkeys&banana
>```
#### header nella richiesta

| intestazione      | descrizione                                                           |
| ----------------- | --------------------------------------------------------------------- |
| User-Agent        | indica il programma client utilizzato                                 |
| Accept            | indica il formato dei contenuti che il client è in grado di accettare |
| Accept-charset    | famiglia di caratteri che il client è in grado di gestire             |
| Accept-encoding   | schema di codifica supportato dal client                              |
| Accept-language   | linguaggio preferito dal client                                       |
| Authorization     | indica le credenziali possedute dal client                            |
| Host              | host e numero di porta del client                                     |
| Date              | data e ora del messaggio                                              |
| Upgrade           | specifica il protocollo di comunicazione preferito                    |
| Cookie            | comunica il cookie al server                                          |
| If-Modified-Since | invia il documento solo se è più recente della data specificata       |
### risposta HTTP
>[!info] risposta HTTP
![[Pasted image 20250317185404.png]]
```js
HTTP/1.1 200 OK //riga di stato
Connection close
Date: Thu, 06 Aug 1998 12:00:15 GMT
Server: Apache/1.3.0 (Unix)
Last-Modified: Mon, 22 Jun 1998 ...
Content-Length: 6821 //in byte
Content-Type: text/html
(carriage return e line feed extra)
dati dati dati dati dati //ad esempio, file HTML
```
#### codici di risposta

| code | meaning      | examples                                               |
| ---- | ------------ | ------------------------------------------------------ |
| 1xx  | information  | 100 = server agrees to handle client’s request         |
| 2xx  | success      | 200 = request succeeded; 204 = no content present      |
| 3xx  | redirection  | 301 = page moved; 304 = cached page still valid        |
| 4xx  | client error | 403 = forbidden page; 404 = page not found             |
| 5xx  | server error | 500 = internal server error; 503 = try again later (L) |

#### intestazioni nella risposta

| intestazione     | descrizione                                               |
| ---------------- | --------------------------------------------------------- |
| date             | data corrente                                             |
| Upgrade          | specifica il protocollo preferito                         |
| Server           | indica il programma server utilizzato                     |
| Set-Cookie       | il server richiede al client di memorizzare un cookie     |
| Content-Encoding | specifica lo schema di codifca                            |
| Content-Language | specifica la lingua del documento                         |
| Content-Length   | indica la lunghezza del documento                         |
| Content-Type     | specifica la tipologia di contenuto                       |
| Location         | chiede al client di inviare la richiesta ad un altro sito |
| Last-Modified    | fornisce data e ora di ultima modifca del documento       |
>[!example]- esempio di richiesta GET
![[Pasted image 20250317185937.png]]

>[!example]- esempio di richiesta PUT
![[Pasted image 20250317190049.png]]
note: 
>- il corpo del messaggio di richiesta contiene la pagina web inviata
>- il documento creato, un documento CGI, è incluso nel corpo del messaggio di risposta
# cookie
HTTP è un protocollo “**senza stato**”: una volta che il server ha servito un client, se ne dimentica (non mantiene informazioni sulle richieste fatte)
- i protocolli che mantengono lo “stato” sono complesi, in quanto la storia passata deve essere memorizzata in qualche modo, e se il server/client si bloccano, le loro viste dello “stato” potrebbero essere inconsistenti
può essere però necessario tenere traccia dell’utente: ci sono molti casi !
- in particolare x offrire navigazione più personalizzata (profilare le persone ….), mantenere il carrello nei siti di commercio elettronico, …
- non si può semplicemente tenere traccia degli indirizzi IP in quanto gli utenti possono lavorare su computer condivisi, e molti ISP assegnano lo stesso IP ai pacchetti in uscita provenienti da tutti gli utenti (es: in caso di NAT)
la soluzione a questa esigenza sono i **cookie** ! essi consentono ai siti di tener traccia degli utenti:
- grazie al meccanismo dei cookie, è possibile creare una sessione di richieste e risposte HTTP **“con stato”**(stateful): la sessione rappresenta quindi un contesto più largo della singola richiesta/risposta
## sessioni
ci possono essere diversi tipi di sessione, in base al tipo di informazioni scambiate e la natura del sito. in generale, una sessione:
- ha un inizio e una fine
- ha un tempo di vita relativamente corto
- sia il client che il server possono chiudere la sessione
- la sessione è **implicita** nello scambio di informazioni di stato
>[!warning] per “sessione” non si intende connessione persistente, ma una sessione **logica** creata da richieste e risposte HTTP. una sessione può essere creata su connessioni persistenti e non persistenti

>[!info] interazione utente-server: i cookie
>- l’utente A accede sempre a Internet dallo stesso PC(non necessariamente con lo stesso IP)
>- visita per la prima volta un particolare sito di commercio elettronico
>- quando la richiesta HTTP iniziale giunge al sito, il sito crea un **ID**(identificativo unico), e una entry nel database per ogni ID
>- l’utente A invierà ogni futura richiesta inserendo l’ID nella richiesta
>![[Pasted image 20250317192106.png]]

esiste quindi un file cookie (che contiene entry tipo sito : cookie ?) mantenuto sul sistema terminale dell’utente, che viene consultato ogni vlta che il client manda una richiesta al server: il browser consulta il file cookie, estrae il numero di cookie per il sito che si vuole visitare e lo inserisce nella richiesta http
il server invece mantiene tutte le informazioni riguardanti il client su un file e gli assegna l’identificatore fornito dal client
- per evitare che il cookie sia utilizzato da utenti "maligni", l’ID è composto da una stringa di numeri (e quindi ?)
>[!example]- another cookie example
![[Pasted image 20250317192621.png]]

il server chiude una sessione inviando al client una intestazione `Set-Cookie` nel messaggio, con `Max-Age=0`
- l’attributo`Max-Age` definisce il tempo di vita in secondi di un cookie, dopo i guali il client dovrebbe rimuovere il cookie. 0 vuol dire che il cookie deve essere rimosso subito

i file cookie possono contenere:
- autorizzazione
- carta per acquisti
- preferenze sull’utente
- stato della sessione dell’utente (email)
>[!warning] i cookie permettono quindi ai siti di imparare molte cose sugli utenti (bad)

# web caching
l’obiettivo del **web caching** è quello di migliorare le prestazioni dell’applicazione web
- un modo semplice per fare ciò consiste nel salvare le pagine richieste per riutilizzarle in seguito, senza doverle richiedere al server. questa tecnica è efficiente con pagine che vengono visitate molto spesso !
il caching può essere eseguito sia dal browser, che da un **server proxy**
- il browser può mantenere una cache delle pagine visitate (che è anche personalizzabile dall’utente), ed esistono vari meccanismi per la gestione della cache
- un **server proxy** serve a soddisfare una richiesta del client senza coinvolgere il server d’origine: ha una memoria per mantenere copie delle pagine visitate, e se il proxy possiede una pagina, la richiesta al server d’origine non viene eseguita
>[!example] server proxy in una LAN
![[Pasted image 20250317194144.png]]
>anche gli ISP possono mantenere un proxy per le richieste dei vari utenti (smart)

vantaggi:
- riduce i tempi di risposta alle richieste dei client
- riduce il traffico sul collegamento di accesso a Internet
- Internet arricchita di cache consente ai provider meno efficienti di fornire dati con efficacia
>[!example] esempio in assenza di cache
![[Pasted image 20250317195329.png]]
stimiamo il tempo di risposta:
valutiamo [[02 - capacità e prestazioni delle reti#ritardo di accodamento|l’intensità di traffico]]: 
>$$
>\text{intensità di traffico su LAN= }\frac{L \cdot a}{R} = \frac{15req/s \cdot 1mb/req}{100Mbps}=15\%
>$$
>$$
>\text{ ``` su collegamento d'accesso} = \frac{L\cdot a}{R}= \frac{15req/s \cdot 1Mb}{15Mbps} = 100\%
>$$
>
>$$
>\text{ ritardo totale = ritardo di Internet + ritardo di accesso + ritardo LAN}
>$$
>$$
>\text{ritardo totale = 2sec + minuti + millisecondi}
>$$
>una soluzione possibile potrebbe essere aumentare l’ampiezza di banda del collegamento d’accesso a 100mbps, per esempio. in questo caso, l’utilizzo sul collegamento d’accesso sarebbe del 15% (millisecondi), e il ritardo totale sarebbe più che gestibile. ciò però non è sempre attuabile, e comunque risulta costoso aggiornare il collegamento

>[!example] esempio in presenza di cache
>![[Pasted image 20250317225929.png]]
>supponiamo un **hit rate** di 0,4:
>- il 40% delle richieste sarà soddisfatto quasi immediatamente (circa 10ms) (inoltre, anche se la cache proxy deve comunque inviare richieste al server per verificare che la pagina non sia obsoleta, i messaggi ricevuti saranno più piccoli, e ciò migliora le prestazioni perchè il carico è minore)
>- il 60% delle richieste sarà soddisfatto dal server d’origine
>- l’utilizzo del collegamento d’accesso si è ridotto al 60%, determinando ritardi trascurabili (circa 10ms)
>- ritardo totale medio = ritardo di Internet + ritardo di accesso + ritardo della LAN $\simeq 1,2\sec$

>[!info] validazione dell’oggetto
>la cache, anche se ha l’oggetto, prima di inviarlo al client deve verificare che non sia **scaduto**, cioè modificato sul server di origine
>- la cache esegue quindi una richiesta verso il Web server che mantiene l’oggetto, per verificarne la validità mediante il metodo `GET condizionale`
### GET condizionale
l’obiettivo del `GET condizionale` è di evitare l’invio di un oggetto se la cache ha una copia aggiornata di esso. come ?
- la cache specifica la data della copia dell’oggetto nella richiesta HTTP
- il server **non** invia l’oggetto se la copia nella cache è aggiornata
>[!example] esempio di GET condizionale
![[Pasted image 20250317195153.png]]
