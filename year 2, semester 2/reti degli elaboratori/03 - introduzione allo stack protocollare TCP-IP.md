---
created: 2025-03-19T13:44
updated: 2025-05-09T10:56
---
>[!index]
>- [introduzione allo stack protocollare TCP/IP](#introduzione%20allo%20stack%20protocollare%20TCP/IP)
>	- [protocollo](#protocollo)
>	- [strutturazione a livelli](#strutturazione%20a%20livelli)
>- [stack protocollare TCP/IP](#stack%20protocollare%20TCP/IP)
>	- [livello 5: applicazione](#livello%205:%20applicazione)
>		- [protocolli standard](#protocolli%20standard)
>		- [protocolli non standard](#protocolli%20non%20standard)
>		- [creare un’applicazione di rete](#creare%20un%E2%80%99applicazione%20di%20rete)
>			- [architettura dell’applicazione](#architettura%20dell%E2%80%99applicazione)
>				- [paradigma client-server](#paradigma%20client-server)
>	- [livello 4: trasporto](#livello%204:%20trasporto)
>	- [livello 3: rete](#livello%203:%20rete)
>	- [livello 2: link](#livello%202:%20link)
>	- [livello 1: fisico](#livello%201:%20fisico)
>	- [incapsulamento e decapsulamento](#incapsulamento%20e%20decapsulamento)
>		- [multiplexing e demultiplexing](#multiplexing%20e%20demultiplexing)
>	- [indirizzamento nel modello TCP/IP](#indirizzamento%20nel%20modello%20TCP/IP)
>- [modello OSI](#modello%20OSI)
>- [Internet standard](#Internet%20standard)

# introduzione allo stack protocollare TCP/IP

abbiamo una panoriamica della struttura e delle varie prestazioni di Internet: sappiamo che è costituita da numerose reti di varie dimensioni, interconnesse tramite opportuni dispositivi di comunicazione. tuttavia, per poter comunicare non è sufficiente assicurare questi collegamenti, ma è necessario utilizzare sia l’hardware che del software !
>[!example]- esempio di comunicazione
![[Pasted image 20250312191705.png]]
>due interlocutori rispettano un protocollo di conversazione:
>- si inizia con un saluto
>- si adotta un linguaggio appropriato al livello di conoscenza
>- si tace mentre l’altro parla
>- la conversazione si sviluppa come un dialogo piuttosto che un monologo
>- si termina con un saluto
## protocollo
un **protocollo** definisce le regole che il mittente, destinatario e tutti i sistemi intermeti coinvolti, devono rispettare per poter comunicare
- potrebbe bastare un solo protocollo, o potrebbe essere necessario dividere i compiti in livelli, dove in ogni livello è richiesto un protocollo: si parla di **layering di protocolli**
## strutturazione a livelli
oltre a consentire la suddivisione di un compito complesso in più compiti semplici, la strutturazione a livelli permette di avere livelli indipendenti tra loro (**modularizzazione**).
**vantaggi**:
- in particolare, possiamo considerare un **modulo** come una black box (con oppurtuni ingressi e uscite), senza preoccuparci delle modalità con cui i dati vengono elaborati per avere un output. in questo modo **un livello usa servizi dal livello inferiore e offe servizi al livello superiore**, indipendentemente da come sia implementato
	- in questo modo, è inoltre possibile modificare un modulo in modo trasparente, se le interfacce con gli altri livelli rimangono le stesse
- possiamo gestire tecnologie diverse (wireless, con fili) senza dover reimplementare tutto
- inoltre, se due macchine forniscono lo stesso output dato il medesimo input, possono essere considerate equivalenti e possono quindi essere acquistate da fornitori diversi (se equivalenti)
	- e ciascun costruttore può adottare la proprima implementazione di un livello, purchè soddisfi i requisiti sulle interfacce
**svantaggi**:
- a volte può essere necessario lo scambio di informazioni tra livelli non adiacenti, non rispettando quindi il principio della stratificazione
# stack protocollare TCP/IP
**TCP/IP** è una famiglia di protocolli attualmente utilizzata in Internet, costruita come una **gerarchia di protocolli** (ogni livello si basa sui servizi forniti dai livelli inferiori) costituita da moduli interagenti, ciascuno dei quali fornisce funzionalità specifiche
- si chiama così perchè TCP e IP sono i 2 protocolli principali dello stack
>[!info] stack TCP/IP
![[Pasted image 20250312193517.png]]
tatoo it on your forhead

## livello 5: applicazione
è il livello in cui si interagisce con le applicazioni di rete, attraverso vari protocolli che regolano la comunicazione (tra 2 host che comunicano attraverso l’applicazione di rete): 
- HTTP, SMTP, FTP, DNS, ….
>[!info] la comunicazione è fornita mediante una **connessione logica**
![[Pasted image 20250312233350.png]]
si può immaginare che esista un canale logico bidirezionale tra i due host, attraverso il quale si possono inviare messaggi

dato che il livello applicazione è l’unico che fornisce servizi agli utenti di Internet, la sua flessibilità ci consente di aggiungere nuovi protocolli con estrema facilità
### protocolli standard
esistono diversi protocolli, di livello applicazione, che sono standardizzati e documentati dagli enti responsabili della gestione di Internet. ogni protocollo è costituito da **una coppia di programmi** che interagiscono con l’utente e con il livello inferiore (livello 4: trasporto) per fornire un servizio specifico. (es: HTTP)
### protocolli non standard
dato che non è necessario chiedere autorizzazioni,  è possibile creare un’applicazione non standard scrivendo due programmi che forniscono servizi agli utenti. 

>[!example] alcune applicazioni di rete
>- posta elettronica
>- web
>- messaggistica istantanea
>- SSH
>- condivisione file P2P
>- giochi multiutente via rete
>- streaming
>- telefono via internet
>- videochiamate
### creare un’applicazione di rete
per creare un’applicazione di rete, è necessario scrivere programmi che:
- girano su sistemi terminali diversi
- comunicano attraverso la rete (es: il software di un server Web comunica con il software di un browser)
- sono in grado di funzionare su più macchine
- sono indipendenti dalla tecnologia che c’è sotto

è necessario quindi avere un piano architetturale:
- che tipo di **architettura** si vuole creare ? (client server, peer-to-peer)
- come **comunicano** i processi dell’applicazione ?
- che tipo di **servizi**(di rete) richiede l’applicazione ? (affidabilità, banda)
#### architettura dell’applicazione
- i due programmi devono essere entrambi in grado di richiedere e offrire servizi (peer-to-peer)
- ciascuno dei due programmi deve occuparsi di **uno** dei due compiti (client-server)
- ibrido (client-server e peer-to-peer)
##### paradigma client-server
in questo paradigma, il ruolo delle due entità è totalmente differente: non è possibile eseguire un client come programma server e viceversa. infatti:
- **client**: richiedente del servizio, è in esecuzione solo quando è necessario il servizio. (di solito ci sono numerosi client che richiedono il servizio)
- **server**: fornitore del servizio, è sempre in esecuzione, in attesa di richieste dal client. esiste un numero limitato di processi server pronti a offrire uno specifico servizio !
**svantaggi**:
- il carico della comunicazione risulta concentrato sul  server, che deve essere molto potente, ed è necessaria una server farm per creare un potente server virtuale
- costi di gestione per offrire il servizio
>[!example] esempi di applicazioni client-server
>- WWW
>- posta elettronica
>- FTP
>- SSH

## livello 4: trasporto
è il livello in cui vengono trasferiti i messaggi a livello di appplicazone, da un client ad un server. si può scegliere tra i protocolli:
- TCP, UDP
## livello 3: rete
è il livello che si occupa dell’instradamento dei segmenti dall’origine alla destinazione (rotte end-to-end). fa si che i pacchetti seguano il percorso corretto per arrivare a destinazione !
## livello 2: link
è il livello che si occupa della trasmissione dei pacchetti nella singola tratta (hop to hop): da un nodo a quello successivo sul percorso. 
## livello 1: fisico
è il livello che gestisce il trasferimento dei singoli bit su lungo un canale di comunicazione
>[!info] comunicazione in una internet
![[Pasted image 20250312195732.png]]
>- grazie al layering, i sistemi implementano solo i livelli necessari, riducendo la complessità !
>- nel router, ci possono essere fino a $n$ livelli fisico e livello collegamento, dove $n$ è il numero di link a cui è collgato (questo perchè possono avere protocolli di collegamento diversi)
>- invece essendo le porte dello swtich omogenee, c’è solo un protocollo (una tecnologia )

>[!warning] servizi e protocolli sono concetti ben distinti !
> - un servizio è un insieme di primitive che uno strato offre a quello superiore (non dice nulla su come sono implementate le operazioni che offre il livello)
>- un protocollo è un insieme di regole che controllano il formato e il significato dei pacchetti, o messaggi scambiati tra le entità pari all’interno di uno strato
![[Pasted image 20250312224953.png]]

>[!info] esempio più dettagliato
![[Pasted image 20250312225518.png]]
>- **interfacce**: definiscono le operazioni elementari e i servizi che lo strato inferiore rende disponibili a quello soprastante
>- i processi di ogni stato (o almeno quelli più alti), modellano la loro comunicazione come se fosse “orizzontale”: avranno funzioni del tipo `sendToOtherSide`, `getFromOtherSide` (quindi non si preoccupano del resto dello stack sottostante, ma usano i serivizi dei livelli inferiori). queste procedure di alto livello comunicano, in verità, mediante strati inferiori
>- la comunicazione virtuale, cioè la comunicazione modellata da ogni strato, è disegnata in rosso
>- la comunicazione reale, che attraversa quindi ogni livello dello stack protocollare, è disegnata in blu

## incapsulamento e decapsulamento
durante la comunicazione, l’host mittente effettua **l’incapsulamento**: prende il pacchetto dal livello superiore, lo considera come payload e aggiunge un header.
l’host destinatario invece effettua il decapsulamento
>[!tip] il router effettua sia incapsulamento che decapsulamento
>perchè è collegato a due link (??) quindi decapsula quando riceve il pacchetto, per poi incapsularlo (con informazioni diverse) e mandarlo al prossimo link

in particolare, i pacchetti cambiano nome ad ogni livello in cui si trovano (in quanto vengono aggiunge informazioni ad ogni livello). abbiamo:
- livello 5: messaggio (nessun header)
- livello 4: segmento/datagramma utente (aggiunta di header a livello di trasporto)
- livello 3: datagramma (aggiunta di header a livello di rete)
- livello 2: frame (aggiunta di header a livello di collegamento)
- livello 1: bit (roba seria)
>[!example]- esempio
![[Pasted image 20250312230642.png]]

### multiplexing e demultiplexing
dato che lo stack TCP/IP prevede più protocolli nello stesso livello, è necessario:
- eseguire **multiplexing** alla sorgente: un protocollo può dover incapsulare, uno alla volta, pacchetti ottenuti da più protocolli del livello superiore
- eseguire **demultiplexing** alla destinazione: un protocollo può dover decapsulare e consegnare pacchetti ottenuti da protocolli diversi dal livello inferiore, da consegnare al livello superiore
>[!info] è quindi necessario un campo nel proprio header per identificare a quale protocollo appartengano i pacchetti incapsulati
![[Pasted image 20250312231210.png]]

>[!figure] img
![[Pasted image 20250312231119.png]]

## indirizzamento nel modello TCP/IP
dato che il modello TCP/IP prevede una comunicazione logica tra coppie di livelli, è necessario avere un indirizzo sorgente ed un indirizzo destinazione ad ogni livello (ad ogni livello, devo dire a chi devo mandarlo: devo usare un indirizzo del livello pari ! in quanto, per modularità, i livelli sono indipendenti e la comunicazione è logica)
>[!info] immagine riassuntiva
![[Pasted image 20250312231514.png]]

# modello OSI
l’ISO ha definito il **modello OSI** come modello alternativo al TCP/IP, ma non si è diffuso, in quanto alla sua pubblicazione, il TCP/IP era già ampiamente diffuso, e non riuscirono a dimostare delle prestazioni tali da convincere le autorità di Internet a sostituire il TCP/IP
>[!info] confronto tra OSI e TCP/IP
![[Pasted image 20250312232356.png]]

>[!info]- lore
>- prima del 1960 esistevano già alcune reti di telecomunicazione, come le reti telegrafiche e le reti telefoniche. erano reti adatte a un tipo di comunicazione a velocità costante, in quanto era necessario stabilire una connessione (fisica) fra i due utenti prima di poter trasmettere il messaggio codificato/voce
>- a metà degli anni 60, l’**ARPA** (advanced research projects agency) andò alla ricerca di un metodo per connetere i calcolatori dei loro centri di ricerca, in modo che i ricercatori finanziati con i suoi fondi potessero facilmente condividere il risultato del loro lavoro. naque l’**ARPANET**, una piccola rete di calcolatori connessi tra di loro: ogni calcolatore era collegato ad una macchina dedicata, l’**IMP**(interface message processor), e gli IMP erano a loro volta collegati tra di loro, in modo tale che ogni IMP potesse essere capace di comunicare con gli altri IMP e con il calcolatore host connesso
>- nel 1972, iniziò l’Internetting project, con scopo il collegare diverse reti in modo che un host di una delle reti potesse comunicare con un altro host di un’altra rete
# Internet standard
nello studio di Internet e dei suoi protocolli, si incontrano spesso riferimenti a **standard o entità amministrative**: 
- uno **standard Internet** è una specifica che è stata rigorosamente esaminata e controllata, ritenuta utile ed accettata da chi utilizza la rete Internet. è quindi un insieme di regole formalizzate, che devono essere necessariamente seguite
>[!info]- procedura di creazione di uno Internet standard
![[Pasted image 20250312233137.png]]
- le entità amministrative invece, sono i gruppi che coordinano aspetti diversi della rete Internet e ne hanno guidato la sua crescita e il suo sviluppo
	- es: **ISOC**(internet society), **IAB**(internet architecture board), bla bla bla ngl 

la velocità che ci permette un protocollo non affidabile può esere un buon compromesso per usarlo (purchè non perdiamo troppi dati)