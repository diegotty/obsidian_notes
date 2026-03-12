---
related to: 
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [le reti](#le%20reti)
>	- [dispositivi terminali](#dispositivi%20terminali)
>		- [host](#host)
>		- [server](#server)
>	- [dispositivi di interconnessione](#dispositivi%20di%20interconnessione)
>	- [collegamenti](#collegamenti)
>		- [mezzi trasmissivi cablati](#mezzi%20trasmissivi%20cablati)
>		- [mezzi trasmissivi wireless](#mezzi%20trasmissivi%20wireless)
>- [classificazione delle reti](#classificazione%20delle%20reti)
>	- [reti LAN](#reti%20LAN)
>	- [reti WAN](#reti%20WAN)
>		- [la rete GARR](#la%20rete%20GARR)
>- [switching](#switching)
>	- [reti a commutazione di circuito](#reti%20a%20commutazione%20di%20circuito)
>		- [suddivisione della banda](#suddivisione%20della%20banda)
>	- [reti a commutazione di pacchetto (store and forward)](#reti%20a%20commutazione%20di%20pacchetto%20(store%20and%20forward))
>- [Internet](#Internet)
>		- [ARPANET](#ARPANET)
>	- [accesso ad internet](#accesso%20ad%20internet)
>		- [via rete telefonica](#via%20rete%20telefonica)
>		- [accesso tramite ethernet](#accesso%20tramite%20ethernet)
>		- [accesso wire less](#accesso%20wire%20less)

>[!info] scopo del corso: capire cosa succede all’interno della rete
>- imparare come funziona internet
>- acquisire i concetti fondamentali relativi alle reti di elaboratori: livelli, servizi, protocolli
>- conoscere le problematiche fondamentali,e le relative soluzioni, incontrate nella definizione dello stack protocollare di una moderna architettura di rete (affidabilità, sicurezza, etc)
>- conoscere caratteristiche e funzionamento dei vari livelli e protocolli dell’architettura di rete **TCP/IP**
# le reti
una **rete** è composta da dispostivi in grado di **scambiarsi informazioni** (end system), e dispositivi di interconessione (che permettono di far viaggiare le informazioni)

**pacchetti**: blocchi di dati che viaggiano in rete

>[!info]- rete 
>![[Pasted image 20250302183128.png]]
![[Pasted image 20250304214229.png]]
## dispositivi terminali
i sistemi terminali possono essere di 2 tipi:
### host
macchine in genere di proprietà degli utenti e dedicate ad eseguire operazioni
- computer desktop, portatili, cellulari, tablet, …
### server
tipicamente, computer con elevate prestazioni destinati a eseguire programmi che forniscono servizi a diverse applicazioni utente come, per esempio, la posta elettronica o il Web
- vengono gestiti da amministratori di sistema
## dispositivi di interconnessione
i dispositivi di interconnessione **rigenerano**/modificano il segnale che ricevono e si distinguono in:
 - **router**: dispositivi che collegano una rete ad altre reti
	- usati nel backbone internet
- **switch**: o commutatori, collegano più sistemi terminali (**instradano**) a livello locale
- **modem**: **trasformano** la codifica dei dati (trasformano i dati digitali del computer in dati analogici, e viceversa)
## collegamenti
i dispositivi di rete vengono collegati utilizzando mezzi trasmissivi cablati o wireless, genericamente chiamati **link** 
### mezzi trasmissivi cablati
i dati viaggiano da un sistema terminale ad un altro, passando per una serie di coppie trasmittente-ricevente, attraverso mezzi fisici
sempi di mezzi fisici: doppino intrecciato, cavo ethernet,
- cavo coassiale: 2 conduttori concentrici in rame, usato per cablatura di reti locali ad alta velocità.
- fibra ottica: conduce impulsi di luce, in cui ciascun impulso rappresenta un bit. ad alta frequenza trasmissiva (da 10 a 100 Gbps), e basso tasso di errore (anche immune all’interferenza elettromagnetica). è il mezzo prevalente delle dorsali di internet

>[!warning] i nodi sono trasmittente E ricevente alllo stesso tempo 
>si parla di nodo trasmittente/ricevente solo per indicare la direzione della commutazione
### mezzi trasmissivi wireless
i segnali si propagano nell’atmosfera e nello spazio esterno
- soffrono dell’ambiente circostante
- propagandosi in tutte le direzioni, si riflettono quando trovano degli ostacoli
- ci sono dei materiali che ostruiscono il passaggio 
- ci possono essere interferenze da altre tecnologie
# classificazione delle reti

| scale    | type                                   | example        |
| -------- | -------------------------------------- | -------------- |
| vicinity | PAN(personal area network)             | bluetooth      |
| building | LAN(local area network)                | wifi, ethernet |
| city     | MAN(metropolitan area network)         | cable, DSL     |
| country  | WAN(wide area network)                 | large ISP      |
| planet   | the Internet (network of all networks) | the Internet ! |
## reti LAN
solitamente, è una rete privata che collega sistemi terminali in un singolo ufficio (azienda, università)
- ogni sistema terminale ha un indirizzo univoco che lo identifica nella rete
>[!info] esempio di LAN con cavo condiviso (rete broadcast)
![[Pasted image 20250304220823.png]]
obsoleto !!!
>- il pacchetto inviato da un dispositivo viene ricevuto da tutti gli altri (broadcast)
>- solo il destinatario elabora il pacchetto, tutti gli altri lo ignorano
>- può trasmettere un nodo alla volta

>[!info] esempio di LAN con switch di interconnessione (topologia a stella)
![[Pasted image 20250304220948.png]]
lo switch gestisce a chi inviare i pacchetti che gli arrivano, ed è in grado di trasmettere su più porte, quindi gli host possono comunicare parallelamente ! (se non vi sono sorgente e destinazione comune)

## reti WAN
rete geografica: interconnette dispositivi quali switch, router, e modem, e può servire una città, una regione, o una nazione
- gestita da un ISP (internet service provider)
>[!warning] generalmente non hanno a che fare con dispositivi terminali !

>[!info] WAN punto-punto
![[Pasted image 20250305110714.png]]
>collega due mezzi di comunicazione tramite un mezzo trasmissivo (cavo o wireless)
> - usata per avere una rete privata

>[!info] WAN a commutazione
![[Pasted image 20250305110800.png]]
è una rete con più di due punti di terminazione usata nelle dorsali di internet !

>[!example]- internetwork composta da due LAN e una WAN punto-punto
![[Pasted image 20250305111149.png]]
azienda con 2 uffici in città differenti: in ciascun ufficio esiste una LAN che consente agli impiegati di comunicare l’uno con l’altro. 
per mettere in comunicazione le due LAN, l’azienda usa una apposita WAN punto-punto da un ISP, realizzando una internetwork (o internet privata)
### la rete GARR
interconnette, ad altissima capacità, luoghi in cui si fa istruzione, scienza, cultura e innovazione su tutto il territorio nazionale
è un’infrastruttura in **fibra ottica**, si sviluppa su circa 15.000km tra collegamenti di dorsale e di accesso, e utilizza le più avanzate tecnologie di comunicazione
>[!info]- more info
![[Pasted image 20250305112144.png]]

# switching
i sistemi terminali comunicano tra di loro per mezzo di dispositivi come **switch** e **router**, che si trovano nella rotta tra i sistemi sorgente e destinazione
(router: switch di livello 3, switch: switch di livello 2)
ci sono 2 tipi di reti basate su switch:
## reti a commutazione di circuito
viene deciso un percorso: il circuito ( aka vengono riservate le risorse necessarie per la comunicazione : la banda full-link, le risorse fisiche presenti sugli switch)
- le informazioni riguardanti il circuito vengono mantenute dalla rete
- ci garantisce, che una volta stabilito un circuito, c’è una certa capacità garantita
le risorse vengono quindi suddivise in “pezzi”, e ciascun pezzo viene allocato ai vari collegamenti.
- le risorse rimangono **inattive** se non utilizzate
>[!figure] rete a commutazione di circuito
![[Pasted image 20250305112910.png]]
> comunicazioni diverse tra gli stessi dispositivi possono usare percorsi diversi (stabiliti a priori)

>[!example] efficienza
>![[Pasted image 20250305113116.png]]
in questo esempio, la linea tra i due switch può gestire contemporaneamente 4 canali voce. ad ogni persona viene allocata 1/4 della capacità
>- se tutte e 4 le persone comunicano con le 4 persone dall’altro lato, allora la capacità della linea verrà completamente utilizzata, altrimenti verrà sottoutilizzata
### suddivisione della banda
>[!info] FDM: frequency divison multiplexing
![[Pasted image 20250305113633.png]]

>[!info] TDM: time division multiplexing
![[Pasted image 20250305113728.png]]
## reti a commutazione di pacchetto (store and forward)
modo in cui funziona la rete internet oggi 
ogni utente spedice i pacchetti (in cui viene suddiviso il messaggio. i pacchetti hanno una lunghezza massima) al router, che li riceve tutti, li mette in una coda (canale seriale), e spedisce i pacchetti al prossimo router
- non viene riservata alcuna risorsa per la comunicazione
- invece di avere una comunicazione continua, i due dispositivi comunicano scambiandosi pacchetti di dati
>[!example] esempio di rete a commutazione di pacchetto
![[Pasted image 20250305214432.png]]
router hanno code in ingresso e code in uscita (nell’esempio i router hanno 5 code in ingresso e 5 code in uscita)

blocchi di dati, anche se dello stesso file o comunicazione, possono prendere percorsi diversi nel viaggio dalla sorgente alla destinazione, e possono arrivare a destinazione in un ordine diverso
- quindi analogamente ad il sistema postale, perchè le cose viaggiano indipendentemente e non si sa se due cose mandate allo stesso tempo, allo stesso destinatario, arriveranno insieme o molto distanti

questa commutazione è molto più flessibile in termini di prestazioni: se solo 2 dispositivi, uno per lato, comunicano tra di loro, viene utilizzata l’intera banda della rete per tale comunicazione. se 2 dispositivi per lato comunicano, la banda verrà dimezzata, etc
- un percorso si può sovraccaricare, e i router si posssono congestionare. a quel punto può essere utile cambiare percorso per inviare il pacchetto ( le code del router congestionato saranno piene, e i pacchetti che arrivano vengono scartati)
# Internet
una internet è costituita da due o più reti interconnesse: l’internet più famosa è chiamata **Internet**, ed è composta da migliaia di reti interconnesse (è una rete a commutazione di pacchetto)
> [!info] rappresentazione concettuale di Internet
![[Pasted image 20250305215209.png]]
### ARPANET
**advanced research projects agency network**
- prima rete packet-switched ad implementare lo stack **TCP/IP**
- progettata per scopi accademici di ricerca, inizialmente collegava 4 università. in 2 anni si è estesa a 15 !
>[!figure]- arpanet
![[Pasted image 20250305215412.png]]
## accesso ad Internet
per accedere all’Internet, l’utente deve essere fisicamente collegato a un ISP, solitamente mediante una WAN punto-punto. il collegamento che connette l’utente al primo router di Internet è detto **rete di accesso**
### via rete telefonica
è possibile collegarsi ad Internet modificando la linea telefonica
- limitazioni: bassa velocità, non si possono inviare contemporaneamente dati e voce
il servizio **DSL** (digital subscriber line) è una tecnologia che supporta la comunicazone digitale ad alta velocità sulla linea telefonica, dividendo il collegamento tra abitazione ed ISP in tre bande di frequenza non sovrapposte
>[!figure] DSL
![[Pasted image 20250305215922.png]]

### accesso tramite ethernet
- ethernet
### accesso wireless
- wifi: access point connesso alla ethernet cablata. raggio di azione di qualche decina di metri
- cellulare: si usa la rete cellulare. access point della compagnia telefonica cellulare, con raggio di azione di decine di kilometri