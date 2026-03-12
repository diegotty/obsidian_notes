---
created: 2025-03-27T08:01
updated: 2025-05-09T10:56
---
>[!index]
>- [indirizzo IP](#indirizzo%20IP)
>- [DNS](#DNS)
>	- [aliasing](#aliasing)
>	- [distribuzione del carico](#distribuzione%20del%20carico)
>	- [gerarchia server DNS](#gerarchia%20server%20DNS)
>		- [server DNS root](#server%20DNS%20root)
>		- [TLD](#TLD)
>			- [etichette dei domini generici](#etichette%20dei%20domini%20generici)
>		- [authoritative server](#authoritative%20server)
>		- [server DNS locale](#server%20DNS%20locale)
>	- [query DNS](#query%20DNS)
>	- [DNS caching](#DNS%20caching)
>	- [DNS record](#DNS%20record)
>		- [tipi di record](#tipi%20di%20record)
>	- [messaggi DNS](#messaggi%20DNS)
>	- [inserire record nel database DNS](#inserire%20record%20nel%20database%20DNS)
# indirizzo IP
gli host Internt hanno i propri **hostname** (`www.google.com`, `w3.uniroma1.it`, ….), ma i nomi, anche se facili da ricordare, forniscono poca informazione sulla collocazione degli host all’interno dell’Internet(`.it` ci dice che l’host si trova probabilmente in Italia, ma non dove)
un **indirizzo IP** ci permette di identificare un host in una rete, e anche di sapere dove si trova tale host !
- consiste di 4 byte, ed è costituito da una stringa in cui ogni punto separa dei byte espressi con un numero decimale da 0 a 255
- presenta una struttura gerarchica
# DNS
ora che abbiamo un hostname ed un indirizzo IP, dobbiamo trovare un sistema per matcharli, memorizzarli, e renderli accessibili
il **DNS**(domain name system) è un protocollo del livello applicazione che rende ciò possibile:
- **memorizazione** → database distribuito, implementato in una gerarchia di server DNS
- **accessibilità** → protocollo a livello di applicazione che consente agli host di interrogare il database distribuito per **risolvere**(tradurre) i nomi(in indirizzi)
>[!info] il DNS viene quindi usato dagli altri protocolli di livello applicazione per tradurre hostname in indirizzi IP
>utilizza il trasporto UDP e indirizza la porta 53 ! wooooo (…)

>[!info] perchè UDP ?
>- less overhead:
>	- messaggi corti
>	- tempo per setup conessione breve, al contrario di TCP
>	- un unico messaggio deve essere scambiato tra una coppia di server, e vanno contattati diversi server per una risposta (mettere su una connessione, come richiesto da TCP, sarebbe un enorme spreco di tempo)
>- se un messaggio non ha risposta entro un timeout, viene semplicemente ri-inviato dal resolver !

>[!example] esempio di interazione con HTTP
un browser(ossia client HTTP) di un host utente richiede l’URL `www.someschool.edu`
>1. l’host esegue il lato client dell’applicazione DNS
>2. il browser estrae il nome dell’host, `www.someschool.edu` dall’URL e lo passa al lato client dell’applicazione DNS
>3. il cient DNS invia una query contenente l’hostname a un server DNS
>4. il client DNS riceve una risposta che include l’indirizzo IP corrispondente all’hostname
>5. ottenuto l’indirizzo IP dal DNS, il browser può dare inizio alla connessione TCP verso il server HTTP localizzato a quell’indirizzo IP

## aliasing
il DNS offre il servizio di **aliasing**: un host può avere uno o più **alias**(sinonimi)
>[!example] alias
>`relay1.west-coast.enterprise.com` potrebbe avere due sinonimi, quali `enterprise.com` e `www.enterprise.com`
>- `relay1.west-coast.enterprise.com` è un **hostname canonico**
>- `enterprise.com` e `www.enterprise.com` sono **alias**

gli alias sono più facili da ricordare obv
## distribuzione del carico
DNS viene utilizzato per distribuire il carico tra **server replicati**: i siti con molto traffico vengono replicati su più server, e ciascuno di questi gira su un sistema terminale diverso, con indirizzo IP differente
con il DNS è possibile associare un hostname canonico ad un insieme di indirizzi IP (contenuto dal DNS). in questo modo, quando viene fatta una richiesta al DNS per tale hostname, il server risponde con l’insieme di indirizzi, ma variando l’ordinamento ogni volta, effettivamente distribuendo il traffico sui server replicati
## gerarchia server DNS
>[!info] lore 
>ai tempi di ARPANET, il DNS era un file `host.txt`, mentre ora è un’applicazione che gira su ogni host, con un grande numero di server DNS distribuiti per il mondo, ed un relativo protocollo a livello applicazione che specifica la comunicazione tra server DNS e host richiedenti

>[!info]- DNS centralizzato
>inoltre, DNS non può essere centralizzato, in quanto se si memorizzasse tutto il database su un singolo server:
>- ci sarebbe un singolo punto di fallimento
>- il volume di traffico sarebbe troppo elevato 
>- ci sarebbe sempre, per qualcuno, troppa distanza dal database centralizzato
>- la manutenzione sarebbe ingestibile: il server dovrebbe essere aggiornato di continuo per includere nuovi nomi di host
>quindi un database centralizzato su un singolo server DNS non è scalabile :(

la **gerarchia DNS** è organizzata in questo modo: le informazioni si organizzano in base al dominio, e ci sono 3 classi di server DNS organizzati in una gerarchia:
- **root**
- **TLD**(top-level domain)
- authoritative
- ci sono poi i server DNS **locali** con cui interagiscono direttamente le applicazioni
>[!figure] gerarchia server DNS
![[Pasted image 20250318213556.png]]
### server DNS root
in Internet ci sono 13 server DNS root, e ognuno di questi server è replicato per motivi di **sicurezza** e **affidabilità**: in totale diventano 247 root server (19 copie per ogni server)
>[!figure] disposizione DNS root server
![[Pasted image 20250318213903.png]]
### TLD
i server TLD si occupano dei domini `com`, `org`, `net`, `edu`, etc …, e di tutti i domini locali di alto livello, quali `it`, `uk`, `fr`, `ca`,  e`jp`.
- in particolare la compagnia Verisign Global Registry Services gestisce i server TLD per il dominio `com`
- in particolare il registro.it che ha sede a Pisa al CNR gestice il dominio `it`
#### etichette dei domini generici
| etichetta | descrizione                            |
| --------- | -------------------------------------- |
| aero      | companie aree e aziende aerospaziali   |
| biz       | aziende (simile a com)                 |
| com       | organizzazioni commerciali             |
| coop      | associazioni di cooperazione           |
| edu       | istituzioni educative                  |
| gov       | istituzioni governative                |
| info      | fornitori di servizi informatici       |
| int       | organizzazioni internazionali          |
| mil       | organizzazioni militari                |
| museum    | musei                                  |
| name      | nomi di persone                        |
| net       | organizzazioni che si occupano di reti |
| org       | organizzazioni senza scopo di lucro    |
| pro       | organizzazioni professionali           |
### authoritative server
gli authoritative server (o server di comptetenza) possono essere mantenuti:
- dall’organizzazione che, essendo dotata di hosts Internet pubblicamente accessibili, deve fornire i record DNS di pubblico dominio che mappano i nomi di tali host in indirizzi IP
- da un ISP per l’organizzazione
in genere sono due server, primario e secondario !
>[!example] esempio di gerarchia server DNS
![[Pasted image 20250318214607.png]]
### server DNS locale
quando un host effettua una richiesta DNS, la query viene inviata al suo server DNS locale, che opera da proxy e inoltra la query in una gerarchia di server DNS !
- il server DNS locale non appartiene strettamente alla gerarchia dei server, e ciascun ISP ha un server DNS locale, detto anche “default name server”
## query DNS
>[!info] query iterativa
![[Pasted image 20250318215327.png]]
ogni volta che il DNS locale fa una query, esso stesso riceve la risposta da uno dei livelli della gerarchia DNS e si occupa di inviare un’altra richiesta al livello della gerarchia DNS inferiore !

>[!info] query ricorsiva
![[Pasted image 20250318215502.png]]
in questo tipo di query, l’host richiedente (e il server DNS locale per lui) affida il compito di tradurre il nome al server DNS contattato
## DNS caching
DNS sfrutta il caching per migliorare le prestazioni di ritardo e per ridurre il numero di messaggi DNS che “rimbalzano” in Internet: una volta che un server DNS impara la mappatura, la mette nella **cache** (duh), secondo i criteri:
- le informazioni nella cache vengono invalidate, e quindi spariscono, dopo un certo periodo di tempo
- tipicamente un server DNS locale memorizza nella cache gli indirizzi IP dei server TLD, ma anche quellli di competenza
	- quindi i server DNS radice non vengono vistati spesso !
## DNS record
il **mapping** è contenuto nei database sotto forma di **resource record**(**RR**): ogni RR mantiene un mapping(es: tra hostname e indirizzo IP, oppure tra alias e nome canonico, etc)
i record vengono quindi spediti tra server e all’host richiedente all’interno di messaggi DNS
- un messaggio può contenere più RR !
>[!figure] formato RR
![[Pasted image 20250319003522.png]]

### tipi di record

| tipo  | interpretazione del campo valore                                                        |
| ----- | --------------------------------------------------------------------------------------- |
| A     | indirizzo IPv4 a 32 bit                                                                 |
| NS    | identifica i server autoritativi di una zona                                            |
| CNAME | indica che un nome di dominio è un alias per il nome di un dominio ufficiale (canonico) |
| SOA   | specifica una serie di informazioni autoritative riguardo una zona                      |
| MX    | indica il server di posta del dominio                                                   |
| AAAA  | indirizzo IPv6                                                                          |

>[!info] type A
>$$
>\text{hostname} \Rightarrow \text{IP \textcolor{red}{a}ddress}
>$$
>- `name` è il nome dell’host
>- `value` è l’indirizzo IP
es: `(relay1.bar.foo.com, 45.37.93.126, A)`

>[!info] type CNAME
>$$
>\text{alias} \Rightarrow \text{\textcolor{red}{c}anonical \textcolor{red}{name}}
>$$
>- `name` è il nome alias di qualche nome canonico
>- `value` è il nome canonico
es: `(foo.com, relay1.bar.foo.com, CNAME)`

>[!info] type NS
>$$
>\text{domain name} \Rightarrow \text{\textcolor{red}{n}ame \textcolor{red}{s}erver}
>$$
>- `name` è il dominio (es: `foo.com`)
>- `value` è il nome dell’host del server di competenza di questo dominio
es: `(foo.com, dns.foo.com, NS)`

>[!info] type MX
>$$
>\text{alias} \Rightarrow \text{\textcolor{red}{m}ail server canonical name}
>$$
>- `value` è il nome canonico del server di posta associato a `name`
es: `(foo.com, mail.bar.foo.com, MX)`

>[!example] esempio
>un server di competenza conterrà un record di tipo A per l’hostname, mentre un server non di competenza conterrà un record di tipo NS per il dominio che include l’hostname, e un record di tipo A che fornisce l’indirizzo ip per il server DNS nel campo `value` del record NS
## messaggi DNS
nel protocollo DNS, le query e i messaggi di risposta hanno lo stesso formato:
>[!info] messaggio DNS
![[Pasted image 20250319005312.png]]
>- identificazione: numero di 16 bit per domanda: la risposta alla domanda usa lo stesso numero
>- flag: 
>	- domanda o risposta
>	- richiesta di ricorsione
>	- richiesta disponibile
>	- risposta di competenza (il server è competente per il nome richiesto)
>- numero di domande/RR di riposta/….: numero di occorrenze delle quattro sezioni di tipo dati che seguono
>- nel corpo del messaggio (celeste) si hanno, in ordine:
>	- campi per il nome richiesto e il tipo di domanda (A, MX (?) )
>	- RR nella risposta alla domanda (insieme di RR nel caso di server replicati)
>	-  record per i server di competenza
>	- informazioni extra che possono essere usate (nel caso di una risposta MX, il campo di risposta contiene il RR MX, mentre la sezione aggiuntiva contiene un record di tipo A con l’indirizzo IP relativo all’hostname canonico del server di posta)
## inserire record nel database DNS
per aggiungere nuovi domini al DNS, si può contattare un **registar**(aziende commerciali accreditate dall’ICANN), che in cambio di un compenso verifica l’unicità del dominio richiesto e lo inserisce nel database (TLD)
- nel nostro server di competenza, dovremo poi aggiungere i relativi RR necessari (almeno un RR di tipo A)

>[!example] esempio di richiesta DNS 
![[Pasted image 20250319010339.png]]