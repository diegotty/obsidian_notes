---
related to: "[[11 - livello di rete]]"
created: 2025-05-09T10:56
updated: 2025-06-19T19:04
completed: true
---
>[!index]
>- [definizioni](#definizioni)
>- [broadcast](#broadcast)
>	- [uncontrolled flooding](#uncontrolled%20flooding)
>	- [controlled flooding](#controlled%20flooding)
>	- [spanning tree based](#spanning%20tree%20based)
>- [multicast](#multicast)
>	- [indirizzi multicast](#indirizzi%20multicast)
>- [IGMP](#IGMP)
>- [messaggi IGMP](#messaggi%20IGMP)
>- [problema del routing multicast](#problema%20del%20routing%20multicast)
>- [instradamento multicast in Internet](#instradamento%20multicast%20in%20Internet)
>- [IPv6](#IPv6)
>- [adozione di IPv6](#adozione%20di%20IPv6)
>- [gestione IPv6](#gestione%20IPv6)
## definizioni
>[!info] unicast
**unicast**: comunicazione tra UNA sorgente e UNA destinazione
> - definita da: indirizzo IP sorgente - indirizzo IP destinazione
![[Pasted image 20250508115626.png]]

## broadcast
>[!info] broadcast 
>**broadcast**: invio di un pacchetto da un nodo sorgente a TUTTI i nodi della rete (quindi 1 a $N$, con $N$ = tutti i nodi della rete)
>- definita da: indirizzo IP sorgente - indirizzo broadcast di destinazione

il broadcast può essere eseguito in diversi modi: 
### uncontrolled flooding
>[!info] uncontrolled flooding
quando un nodo riceve un pacchetto broadcast, lo duplica elo invia a tutti i nodi vicini (eccetto a quello da cui lo ha ricevuto)
>- se il grafo ha cicli, una o più copie del pacchetto cicleranno all’infinito nella rete !!!! bad
![[Pasted image 20250508120111.png]]
### controlled flooding

>[!info] controlled flooding: sequence number
**NON** forwardare pacchetti già ricevuti e inoltrati: ogni nodo tiene una lista di (indirizzo IP, \#seq) dei pacchetti già ricevuti, duplicati, inoltrati
>- quando riceve un pacchetto, controlla nella lista: se già inoltrato lo scarta, altrimenti lo forwarda
>- per evitare i cicli dell’uncontrolled flooding !

>[!info] controlled flooding: reverse path forwarding (RPF)
forwarda il pacchetto solo se è arrivato dal link che e sul suo shortest path (unicast) verso la sorgente (quindi se è la prima volta che lo riceve)
>- in questo modo viene eliminato il problema dell’inondare la rete con troppi pacchetti, ma **NON** viene eliminata completamente la ritrasmissione di pacchetti ridondanti
>>[!example] esempio di RPF con pacchetti ridondanti
>>![[Pasted image 20250508120746.png]]

### spanning tree based
viene creato uno spanning tree (un grafo che include tutti i vertici originali ($V$), è un albero (connesso, no cicli), ed ha il numero miniore di archi per connettere tutti i vertici: $V-1$):
- si prende un nodo come centro: $E$
- ogni nodo invia un messaggio di join in unicast verso il centro, per costruire lo spanning tree (i messaggi vengono inoltrati finchè arrivano ad un nodo che appartiene all’albero oppure arrivano alla radice)
>[!example]- costruzionamento di spanning tree
![[Pasted image 20250508121205.png]]

per l’invio di messaggi in broadcast, i pacchetti vengono inoltrati solo sui link dello spanning tree, in modo tale che ogni nodo riceva solo una copia del pacchetto
## multicast
>[!info] multicast
comunicazione tra una sorgente e **un gruppo** di destinazioni
![[Pasted image 20250508121354.png]]
>>[!tip] multicast come unicast multiplo
>>non è ottimale gestire il multicast come unicast multiplo, in quanto sarebbe inefficiente e aggiungerebbe ritardi (per il numero di pacchetti da inviare )
>>![[Pasted image 20250508121705.png]]

inoltre, molte applicazioni richiedono il trasferimento di pacchetti da uno o più mittenti ad un gruppo di destinatari, ad esempio:
- il trasferimento di un aggiornamento SW su un gruppo di macchine
- streaming audio/video ad un gruppo di utenti o studenti
- applicazioni con dati condivisi  (figjam (kelliot kelliot kelliot))
- aggiornamento di dati
### indirizzi multicast
nella pratica, sorge un problema banale: l’indirizzo di destinazione nell’IP può essere uno solo. per risolvere ciò, è necessario un **unico** indirizzo per tutto il gruppo, ovvero l’**indirizzo multicast**
>[!info] gruppo multicast
![[Pasted image 20250508122124.png]]
>- è importante ricordare che i router devono sapere quali host sono associati a un gruppo multicast !!
>	- deve quindi scoprire quali gruppi sono presenti in ciascuna delle sue interfacce per poi propagare le informazioni agli altri router
> - inoltre l’appartenenza ad un gruppo non è un attributo fisso dell’host (il periodo d’appartenenza può essere limitato)

viene quindi riservato un blocco di indirizzi per il multicast: in IPv4, è il blocco `224.0.0.0/4` ( da `224.0.0.0` a `239.255.255.255`), quindi $2^{28}$ indirizzi disponibili per gruppi multicast
>[!warning] un host che appartiene a un gruppo ha un indirizzo multicast separato e aggiuntivo rispetto al primario
>e l’indirizzo multicast non ha alcuna relazione con il prefisso associato alla rete

# IGMP
il protocollo **IGMP** (**internet group management protocol**) lavora tra un host e il router che gli è direttamente conesso, e offre agli host il mezzo per informare i router ad essi connessi del fatto che un’applicazione in esecuzione vuole aderire ad uno specifico gruppo multicast
- i messaggi vengono incapsulati in datagrammi IP, con IP protocol number 2 (`IGMP`), e `TTL` = 1
>[!info] rappresentazione
![[Pasted image 20250508122846.png]]
## messaggi IGMP
- **membership query**: mandati dal router all’host, per determinare a quali gruppi hanno aderito gli host su ogni interfaccia. vengono inviati periodicamente
- **membership report**: mandati dall’host al router, per informare il router su un’adesione (sia per rispondere ad una membership query che non  (quindi al momento dell’adesione))
- **leave group**: mandati dall’host al router, per informare dalla dipartita da un gruppo.
	- è opzionale, in quanto il router può capire che no ci sono più host associati ad un gruppo quando non riceve report riguardo a tale gruppo in risposta alla membership query 

un **router multicast** (quindi tipo speciale di router) tiene una lista per ciascun gruppo multicast (in cui almeno un elemento fa parte del gruppo), con un timer per ogni membership al gruppo: la membership deve essere aggiornata da report inviati prima della scadenza del timer o tramite messaggi leave group espliciti
## problema del routing multicast
fra la popolazione complessiva di router, solo alcuni dovranno ricevere traffico multicast: quelli collegati a host del gruppo multicast
- è quindi necessario un protocollo che coordini i router multicast in Internet, per instradare i pacchetti multicast dalla sorgente alla destinazione
>[!info] esempio
![[Pasted image 20250508124138.png]]

esistono diversi approci per determinare l’albero di instradamento multicast
>[!info] albero condiviso dal gruppo
viene costruito un singolo albero d’instradamento, condiviso da tutto il gruppo multicast
>- un router agisce da radice, e se il mittente del traffico multicasto non è la radice, allora esso invierà il traffico in unicast alla radice, che provvederà a inviarlo al gruppo
![[Pasted image 20250508124521.png]]

>[!info] albero basato sull’origine
viene creato un albero per ciascuna origine nel gruppo multicast (quindi ci sarà un albero per ogni router collegato ad un host appartentente al gruppo multicast)
>- per la costruzione si usa un algoritmo basato sul RPF (reverse path forwarding, diego) con **pruning** (potatura)
![[Pasted image 20250508124701.png]]
## instradamento multicast in Internet
**multicast intra-dominio**:
- DVMRP: distance-vector multicast routing protocol
- MOSPF: multicast open shortest path first
- PIM: protocol independent multicast
**multicast inter-dominio**:
- MBGP: multicast border gateway protocol
# IPv6
gli indirizzi IPv6 sono nati con lo scopo di:
- aumentare lo spazio di indirizzi rispetto a IPv4
- ridisegnare il formato dei datagrammi
- rivedere protocolli ausiliari come ICMP
gli indirizzi IPv6 sono lunghi 128 bit, e portano le seguenti caratteristiche:
- nuovo formato header IP
- nuove opzioni
- possibilità di estensione
- opzioni di sicureza
- maggiore efficienza (no frammentazione nei nodi intermedi (how ????), etichette di flusso per traffico audio/video)
>[!info] formato datagramma IPv6
![[Pasted image 20250509104452.png]]
> ricordiamo che nel datagramma IPv4, l’intestazione di base aveva dimensione (minima) di 20 byte !

## adozione di IPv6
l’adozione di IPv6 è ancora in corso e molto lenta, a causa di soluzioni più immediate per tamponare la crescente richiesta di indirizzi IP (es: indirizzamento senza classi, DHCP, NAT)
>[!info] chart adozione IPv6
>![[Pasted image 20250509104949.png]]
## gestione IPv6
per determinare quale versione utilizzare per inviare un pacchetto a una destinazione, l’host sorgente interroga il DNS, e si usa il protcollo relativo all’indirizzo ritornato (IPv4 o IPv6)
>[!info] dual stack
deve inoltre essere presente una doppia pila di protcolli per la comunicazione in rete, in modo da gestirli entrambi
![[Pasted image 20250509105139.png]]

>[!info] tunneling
inoltre può capitare che 2 host usanti IPv6 debbano scambiarsi un messaggio attraverso una regione IPv4. in questo caso, bisgona usare la tecnica del **tunneling**: si incapsula il datagramma IPv6 nel payload di un datagramma IPv4, e si inseriscono come IP sorgente e destinazione gli estremi del tunnel
![[Pasted image 20250509105342.png]]

>[!info] traduzione dell’intestazione
può altrimenti capitare che un host IPv6 debba comunicare con un host IPv4. in questo caso viene effettuata la traduzione del datagramma prima che arrivi a destinazione
![[Pasted image 20250509105811.png]]