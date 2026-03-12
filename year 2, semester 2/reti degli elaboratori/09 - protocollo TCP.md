---
related to: "[[07 - livello trasporto]]"
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- [segmenti TCP](#segmenti%20TCP)
>	- [struttura dei segmenti](#struttura%20dei%20segmenti)
>		- [flag di controllo](#flag%20di%20controllo)
>- [connessione TCP](#connessione%20TCP)
>	- [apertura della connessione](#apertura%20della%20connessione)
>	- [trasferimento dati](#trasferimento%20dati)
>	- [chiusura della connessione](#chiusura%20della%20connessione)
>- [controllo degli errori](#controllo%20degli%20errori)
>	- [numeri di sequenza e ACK](#numeri%20di%20sequenza%20e%20ACK)
>	- [controllo degli errori](#controllo%20degli%20errori)
>	- [generazione di ack](#generazione%20di%20ack)
>	- [ritrasmissione dei segmenti](#ritrasmissione%20dei%20segmenti)
>- [controllo di flusso](#controllo%20di%20flusso)
>- [controllo della congestione](#controllo%20della%20congestione)
>	- [rilevare la congestione](#rilevare%20la%20congestione)
>	- [limitare: finestra di congestione](#limitare:%20finestra%20di%20congestione)
>- [gestione della congestione](#gestione%20della%20congestione)
>	- [slow start](#slow%20start)
>	- [congestion avoidance](#congestion%20avoidance)
>- [versioni TCP](#versioni%20TCP)
>- [TCP Taho](#TCP%20Taho)
>- [TCP Reno](#TCP%20Reno)
>- [RTT e timeout](#RTT%20e%20timeout)

approfondiamo il protocollo TCP, che è stato introdotto [[07 - livello trasporto#TCP|precedentemente]]. le caratteristche del protocollo TCP sono:
- **protocollo con pipeline**: come [[08 - meccanismi di trasferimento affidabile#protocolli con pipeline|abbiamo visto]], ammette più pacchetti in transito contemporaneamente
- **bidirezionale**(con piggybacking): un host è sia mittente che destinatario
- **orientato al flusso di dati**: può trasmettere dati sottoforma di flusso: invia uno **stream di byte continuo**
- **orientato alla connessione**: viene effettuato un handshake prima di iniziare il flusso di dati
- **affidabile**(controllo degli errori)
- **controllo del flusso**
- **controllo della congestione**

>[!info] orientato al flusso di dati
possiamo immaginare la trasmissione con protocollo TCP come uno stream di byte continuo: immettiamo dati continuamente, e il protcollo li trasporta dall’altra parte (il TCP segmenta i dati, ma non è visibile a livello applicativo, i segmenti vengono gestiti a livello trasporto))
## segmenti TCP
>[!info] illustrazione
![[Pasted image 20250328194753.png]]
>- TCP riceve uno stream di byte dal processo mittente (livello applicazione)
>- TCP utilizza il servizio di comunicazone tra host del livello di rete che invia i pacchetti: TCP deve raggruppare un certo numero di byte in **segmenti**, aggiungere un’intestazione e consegnare al livello di rete per la trasmissione
### struttura dei segmenti
>[!info] struttura dei segmenti !
![[Pasted image 20250328195117.png]]
>le informazioni mandatorie di un header occupano quindi 20 byte.
in particolare:
>- il **numero di sequenza** indica il numero del primo byte di dati contenuto nel segmento
>- l’`ACK` (**numero di riscontro**) indica il numero di sequenza del prossimo byte che il destinatario si aspetta di ricevere

i numeri di sequenza si riferiscono quindi all’$i-esimo$ byte inviato.
#### flag di controllo

| sigla | descrizione                                                          |
| ----- | -------------------------------------------------------------------- |
| `URG` | contiente messaggio urgente (puntatore urgente valido)               |
| `ACK` | riscontro valido                                                     |
| `PSH` | richiesta di push verso il livello applicazione                      |
| `RST` | azzeramento della connessione                                        |
| `SYN` | richiesta di connessione (e sincronizzazione dei numeri di sequenza) |
| `FIN` | chiusura della connessione                                           |
## connessione TCP
la connessione TCP è composta da 3 fasi:
- apertura della connessione
- trasferimento dei dati
- chiusura della connessione
### apertura della connessione
viene effettuato un **3 way handshake**:
>[!info] 3 way handshake
![[Pasted image 20250328195908.png]]
>- il client manda un pacchetto composto da: `SYN=1`, `seq`: un numero generato**randomicamente** che diventerà il numero di sequenza durante il trasferimento
>- il server risponde con un pacchetto composto da: `ACK` del pacchetto ricevuto, `SYN=1`(in quanto anche il server vuole aprire una connessione con il client), `rwnd` con la dimensione della finestra di ricezione (spiegato più avanti)
>- il client risponde con un `ACK` del pacchetto ricevuto, risponde con la sua `rwnd`. la connessione è aperta da entrambi i lati, e può iniziare il trasferimento di dati
>>[!warning] il numero di sequenza iniziale è scelto a caso
>>ciò per evitare che un segmento di una precedente connessione ancora presente in rete possa essere interpretato come valido per una nuova connessione

### trasferimento dati
>[!info] trasferimento dati: push
![[Pasted image 20250328201717.png]]
>- uhhh actually not really sure of whats happening with the `P` flag

>[!info] trasferimento dati : urgent
>può capitare che ci sia la necessità di mandare dati **urgenti**, cioè da far arrivare al livello applicazione il prima possibile, senza aspettare il `push`. in questo caso, il flag `URG` sarà valido (il suo valore sarà 1). ciò indica che bisogna controllare il **puntatore urgente**:
>- i dati urgenti vengono inseriti all’inizio di un nuovo segmento, che può contenere dati non urgenti a seguire. il puntatore urgente indica dove i dati urgenti finiscono

### chiusura della connessione
ciascuna delle due parti coinvolta nello scambio di dati può richiedere la chiusura della connessione, sebbene sia solitamente richiesta dal client, oppure il server mantiene un timer alla cui scadenza chiede la chiusura (se non si servono richeste entro un determinato tempo !)
- esiste anche un half close
>[!info] chiusura della connessione
![[Pasted image 20250328202033.png]]
>- viene usato il flag `FIN` per indicare una richiesta di chiusura della connessione (in questo caso, inizialmente da pare del client), a cui il server risponde con un `FIN+ACK`

>[!info] half-close
>l’half-close permette la chiusura in una direzione della connessione
![[Pasted image 20250328202254.png]]
>- in questo caso, il client richiede la chiusura della connessione (in uscita), e il client risponde solo con un `ACK`. da quel momento in poi, il server potrà comunque mandare dati al client, finchè il server stesso non chiuderà la connessione 
## controllo degli errori
### numeri di sequenza e ACK
- **numeri di sequenza**: come abbiamo visto, corrispondono al “numero” del primo byte del segmento nel flusso di byte (il primo byte in assoluto è il $\text{random ISN- esimo}$ !)
- `ACK`: TCP usa un `ACK` **cumulativo**, quindi l’`ACK` indica il numero di sequenza del prossimo byte atteso dall’altro lato
>[!example] esempio di comunicazione con TCP
![[Pasted image 20250328202754.png]]

### controllo degli errori
- **checksum**: se un segmento arriva corrotto, viene scartato dal destinatario
- **riscontri + timer di ritrasmissione**(RTO): vengono usati `ACK` cumulativi e timer associato al più vecchio pacchetto non riscontrato (vedremo perchè più avanti ! )
- **ritrasmissione**: del segmento all’inizio della coda di spedizione
### generazione di ack 
esistono delle **regole** che caratterizzano i possibili eventi nello scambio di pacchetti:

| evento                                                                                                                                         | azione                                                                                                                                                              |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2. arrivo **ordinato** di un segmento con numero di sequenza atteso. tutti i dati fino al numero di sequenza atteso sono già stati riscontrati | `ACK` viene ritardato (delayed). il destinatario attende fino a 500ms l’arrivo del prossimo segmento. se il segmento non arriva, invia un `ACK` (`ACK` posticipato) |
| 3. arrivo ordinato di un segmento con numero di sequenza atteso. un altro segmento è in attesa di trasmissione dell’`ACK`                      | invia immediatamente un singolo `ACK` cumulativo, riscontrando entrambi i segmenti ordinati                                                                         |
| 4. arrivo non ordinato di un segmento con numero di sequenza superiore a quello atteso. **viene rilevato un buco**                             | invia immediatamente un `ACK` duplicato, indicando il numero di sequenza del prossimo byte atteso (per indurre a **ritrasmissione rapida**)                         |
| 5. arrivo di un segmento mancante (uno o più dei successivi è stato ricevuto)                                                                  | invia immediatamente un `ACK` (cumulativo)                                                                                                                          |
| 6. arrivo di un segmento duplicato                                                                                                             | invia immediatamente un riscontro con numero di sequenza atteso                                                                                                     |
nella regola 2, si aspettano 500ms perchè dato che il primo segmento è nell’ordine giusto, se la rete non è congestionata, mi arriverà il segmento successivo e potrò inviare un `ACK` cumulativo (proprio ciò che accade nella regola 3 !)
### ritrasmissione dei segmenti
quando un segmento viene inviato, una copia viene memorizzata in una coda **in attesa di essere riscontrato** (la finestra di invio). se il segmento non viene riscontrato, può accadere che:
- scade il timer: ciò implica che il segmento non riscontrato è all’inizio della coda. il segmento viene ritrasmesso e viene riavviato il timer
- **vengono ricevuti 3 `ACK` duplicati**: avviene la **ritrasmissione veloce** del segmento (veloce perchè non viene atteso il timeout)
>[!info] timer
esiste quindi un **unico** timer di ritrasmissione, associato al più vecchio segmento non riscontrato. quando arriva un `ACK`, si riavvia il timer sul più vecchio segmento non riscontrato

>[!example]- esempi di varie situazioni  
normale operatività:
![[Pasted image 20250328204843.png]]
>
>segmento smarrito:
![[Pasted image 20250328204937.png]]
>
>ritrasmissione rapida:
>![[Pasted image 20250328205044.png]]
>
>ritrasmissione rapida: 3 `ACK` duplicati:
![[Pasted image 20250328205211.png]]
>
>riscontro smarrito senza ritrasmissione:
![[Pasted image 20250328205247.png]]
>
>riscontro smarrito con ritrasmissione
![[Pasted image 20250328205319.png]]

## controllo di flusso
l’obiettivo del **controllo di flusso** è quello di non sovraccaricare il buffer del destinatario trasmettendo troppi dati, troppo velocemente
- bisogna quindi bilanciare la velocità d’invio con velocità di ricezione
per gestire ciò, il destinatario invia del feedback esplicito: comunica al mittente lo spazio disponbile attraverso il valore di `RWND`(acronimo di receive window), che si trova nell’header TCP di ogni segmento
l’apertura, chiusura e riduzione della **finestra d’invio** sono quindi controllate dal destinatario (in quanto le due finestre devono avere la stessa dimensione (credo))
>[!info] finestre di invio e ricezione
![[Pasted image 20250328210149.png]]
> si potrebbe ridurre la dimensione della finestra d’invio perchè la finestra di ricezione si è ridotta !

>[!example] esempio
![[Pasted image 20250328210415.png]]
>- l’ultimo `ACK` è stato mandato perchè è stata allargata la window (ma non è utile/di solito non viene mandato)
>- perchè la finestra non si sposta, ma si chiude ? 

>[!warning] in questi esempi di ipotizza una comunicazione unidirezionale, ma in verità ogni host ha 2 buffer: uno di ricezione ed uno di invio!
>informazione non confermata yet

## controllo della congestione
mentre il controllo di flusso si occupa della comunicazione tra un mittente ed il destinatario, la congestione gestisce il caso in cui tante sorgenti trasmettono troppi dati, ad una velocità talmente elevata che la rete non è in grado di gestirli
i sintomi della congestione sono:
- **pacchetti smarriti** (overflow nei buffer dei router)
- **lunghi ritardi** (accodamento nei buffer dei router)
la congestione è uno dei dieci problemi più importanti nel networking !
- la perdita di segmenti comporta la loro rispedizione, aumentando la congestione
- la congestione è un problema che riguarda IP, ma viene gestito da TCP
>[!warning] controllo di flusso in relazione alla congestione
>con il controllo di flusso, la dimensione della finestra di invio è controllata dal destinatario tramite il valore `RWND`, che viene indicato in ogni segmento trasmesso nella direzione opposta
>
>la finestra del ricevente non viene mai sovraccaricata con i dati ricevuti, ma i **buffer intermedi, nei router**, possono comunque congestionarsi, in quanto un router riceve dati da più mittenti !
>quindi anche se non vi è congestione agli estremi, vi può essere congestione nei nodi intermedi

esistono due approcci principali al controllo della congestione: 
- **controllo di congestione end-to-end**: la congestione è dedotta osservando le perdite e i ritardi nei sistemi terminali (o anche `ACK` duplicati, che implicano perdita di pacchetti). è il metodo adottato da TCP
- **controllo di congestione assistito dalla rete**: i router forniscono un feedback ai sistemi terminali: un singolo bit per indicare la congestione, l’**ECN** (**explicit congestion notification**), una feature opzionale in TCP/IP che permette di comunicare in modo esplicito al mittente la frequenza trasmissiva

per mitigare la congestione, i mittenti devono rilevarla, e limitare la frequenza di invio sulla propria connessione in base ad un algoritmo
### rilevare la congestione
la congestione può essere rilevata in base **eventi di perdita**, cioè`ACK` duplicati e timeout, che possono essere intesi come eventi di perdita (danno indicazione dello stato di rete)
avviene poi una **reazione in base allo stato della rete**:
- se gli `ACK` arrivano in sequenza e con buona frequenza, si può inviare e incrementare la quantità di segmenti inviati
- se gli `ACK` sono duplicati, o ci sono timeout, è necessario ridurre la finestra dei pacchetti che si spediscono senza aver ricevuto riscontri
TCP è **auto-temporizzante**: reagisce in base ai riscontri che ottiene 
### limitare: finestra di congestione
per limitare la frequenza di invio del traffico sulla propria connessione, il  mittente usa una **congestion window**(**CWND**, finestra di congestione), in cui
$$
\text{dimensione della finestra = min(rwnd, cwnd)}
$$
## gestione della congestione
l’idea di base è quindi: incrementare il rate di trasmissione se non c’è congestione, e diminurilo se c’è congestione
l’algoritmo di controllo della congestione si basa su 3 componenti (possiamo pensarle come tre modalità, che si alternano a seconda dei feedback ricevuti. vedremo più avanti !)
1. **slow start**
2. **congestion avoidance**
3. **fast recovery**
### slow start
`CWND` è inzializzata a 1MSS, e poichè la banda disponibile può essere molto maggiore, la `CWND` viene incrementata di 1MSS per ogni segmento riscontrato, fino al raggiungimento di una soglia: `ssthresh`, decisa all’inizio. dopo il raggiungimento di tale soglia, si entra in **congestion avoidance**
>[!info] incremento esponenziale
![[Pasted image 20250406131252.png]]
>la dimensione della finestra viene aumentata esponenzialmente fino al raggiungimento della soglia, `ssthresh`

>[!example] rappresentazione di slow start
![[Pasted image 20250406131139.png]]
### congestion avoidance
in questa modalità, la `CWND` cresce finchè non viene perso un pacchetto (in tale caso si pone `ssthresh=CWND/2`) o finchè non raggiunge la `ssthresh` 
- l’incremento è lineare (ogni volta che viene riscontrata l’intera finestra di segmenti, si incrementa di 1 la `CWND`) finchè non si rileva congestione
- al timeout, `ssthresh = CWND/2` e `CWND = 1`
>[!info] incremento lineare
![[Pasted image 20250406171050.png]]

>[!example] rappresentazione di congestion avoidance
![[Pasted image 20250406171002.png]]
# versioni TCP

## TCP Taho
il **TCP Taho** considera timeout o 3 `ACK` duplicati come congestione, e riparte da 1 con `ssthresh=CWND/2`
>[!info] FSM
![[Pasted image 20250406171146.png]]

>[!example] esempio di TCP Taho
![[Pasted image 20250406171440.png]]

>[!warning] il tempo di timeout cambia !! dipende fortemente dall’RTT (e l’RTT varia con la congestione della rete)
>kinda confused about this ngl applico quindi tecniche di rallentamento divers
## TCP Reno
si può affinare la logica del TCP Taho, usando la seguente filosofia:
- 3 `ACK` duplicati indicano (in positivo) la capacità della rete di consegnare qualche segmento (3 pacchetti oltre quello perso sono arrivati)
- un timeout prima di 3 `ACK` duplicati invece è più allarmante, in quanto non sono arrivati nemmento i pacchetti seguenti !
si gestisce quindi in maniera meno drastica il caso di 3 `ACK` duplicati, usando la **fast recovery**:
- **timeout**: indica congestione importante, e si riparte da 1
- **3 `ACK` duplicati**: indica congestione lieve, si applica **fast recovery** a partire da `ssthresh + 3`(dopo aver impostato `ssthresh = CWND/2`)
- quando viene ricevuto un nuovo `ACK` (cioè `ACK` su un segmento successivo), si esce da **fast recovery**, si imposta `CWND = sshthresh` e si continua in **congestion avoidance**
>[!info] FSM TCP Reno
![[Pasted image 20250406172555.png]]

>[!example] esempio di TCP Reno
![[Pasted image 20250406172723.png]]
## RTT e timeout
**come impostare il valore del timeout di TCP ?**
il timeout deve essere più grande dell’RTT  (altrimenti finirà sempre prima di dare il tempo ai pacchetti di arrivare. timeout prematuro e ritrasmissioni non necessarie !), ma non troppo grande da causare una reazione lenta alla perdita di segmenti.
- inoltre, l’RTT viene misurato su un singolo pacchetto, quindi può oscillare molto !
**come stimare l’RTT** ? 
viene usato il **SampleRTT**, il tempo misurato dalla trasmissione del segmento fino alla ricezione dell’`ACK`
- ignora le trasmissioni ed è un valore solo per più segmenti trasmessi insieme
ciononostante, SampleRTT varia a causa di congestione nei router e carico nei sistemi terminali, quindi occorre una stima più “livellata” di RTT: viene calcolata la media delle misure più recenti !!
$$
\text{EstimatedRTT$_{t+1}$ = (1-$\alpha$)$\cdot$EstmatedRTT$_t + \alpha \cdot$SampleRTT$_{t+1}$}
$$
**EstimatedRTT** rappresenta la media mobile esponenziale ponderata (mouthful), cioè una media in cui l’influenza delle misure passate descresce esponenzialmente ([[politiche di scheduling#stima del tempo di esecuzione|exponential averaging !!]])
- tipicamente, $\alpha=0,125$
>[!example] esempio di stima di RTT
![[Pasted image 20250406173939.png]]

il timeout è quindi la somma di **EstimatedRTT** ed un “margine di sicurezza”, in particolare:
- si imposta un valore iniziale pari a 1 secondo
- se avviene un timeout si raddoppia
- avviene viene ricevuto un segmento e aggiornato **EstimatedRTT**, si usa la formula
$$
\text{TimeoutInterval = EstimatedRTT$_{t+1}$ + 4 $\cdot$ DevRTT$_{t+1}$}
$$
in cui **DevRTT** rappresenta di quanto **SampleRTT** si discosta da **EstimatedRTT**

$$
\text{DevRTT$_{t+1}$ = (1 - $\beta) \cdot$ DevRTT$_{t}$ + $\beta \cdot$ |SampleRTT$_{t+1}$ - EstimatedRTT$_t$|}
$$
- tipicamente, $\beta = 0,25$