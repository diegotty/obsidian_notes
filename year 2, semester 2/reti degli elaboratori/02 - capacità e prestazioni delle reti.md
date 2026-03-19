---
created: 2025-03-19T13:44
updated: 2025-05-09T10:56
---
>[!index]
>- [Internet](#Internet)
>	- [rete di accesso](#rete%20di%20accesso)
>	- [backbone Internet](#backbone%20Internet)
>	- [struttura di Internet](#struttura%20di%20Internet)
>- [capacità e prestazioni delle reti](#capacit%C3%A0%20e%20prestazioni%20delle%20reti)
>	- [ampiezza di banda](#ampiezza%20di%20banda)
>	- [throughput](#throughput)
>	- [delay](#delay)
>		- [ritardo di elaborazione del nodo](#ritardo%20di%20elaborazione%20del%20nodo)
>		- [ritardo di accodamento](#ritardo%20di%20accodamento)
>		- [ritardo di propagazione](#ritardo%20di%20propagazione)
>	- [packet loss](#packet%20loss)
>- [concetto $rate \cdot ritardo$](#concetto%20$rate%20%5Ccdot%20ritardo$)
>- [traceroute](#traceroute)

# Internet
Internet è una rete di reti, composta da reti di accesso e dal **backbone Internet**
## rete di accesso
(o **access network**)
collegamenti fisici, che connettono un sistema al primo **edge router**
- quindi collegano il sistema di origine al primo router sul percorso per il sistema di destinazione
le modalità sono state viste in [[01 - introduzione alle reti#accesso ad internet| accesso ad internet]]
## backbone Internet
è la rete composta esclusivamente da router e collegamenti tra router. può essere a commutazione di circuito, o a commutazione di pacchetto ! [[01 - introduzione alle reti#switching|(switching !)]]
## struttura di Internet
Internet ha una struttura fondamentalmente gerarchica:
- **ISP di livello 1**: al centro, offrono copertura nazionale/internazionale, e comunicano tra di loro come pari
>[!info]- dorsali sottomarine
>sono stati posati cavi sottomarini (?), per connettere diversi continenti a velocità elevate ! 
>esempi: TAT-14, MAREA, SEA-ME-WE 6 (foto sottostante)
![[Pasted image 20250305223100.png]]

- **ISP di livello 2**: ISP nazionali o distrettuali, e si possono connettere solo **ad alcuni** ISP di livello 1, e possibilmente ad altri ISP di livello 2
>[!info]- situazione monetaria
>un ISP di livello 2 paga l’ISP di livello 1 che gli fornisce la connettività per il resto della rete ! un ISP di livello 2 è quindi un cliente di un ISP di livello 1

**ISP di livello 3** e **ISP locali**: anche chiamate **last hop networks**, sono le più vicine ai sistemi terminali
- sono clienti degli ISP di livello superiore

>[!example] in pratica !
possibile routing di un pacchetto !
![[Pasted image 20250305223454.png]]
# capacità e prestazioni delle reti
nel caso di una rete a commutazione di pacchetto, le metriche che ne determinano le prestazioni si misurano in termini di:
- **ampiezza di banda**
- **throughput**
- **latenza (ritardo)**
- **perdita di pacchetti**
## ampiezza di banda
si indicano 2 concetti leggermente diversi, ma strettamente legati:
- **bandwidth** (caratterizzazione di un canale): rappresenta la larghezza dell’intervallo di frequenze utilizzato dal sistema trasmissivo (ovvero l’intervallo di frequenze che un mezzo fisico consente di trasmettere senza danneggiare il segnale in maniera irrecuperabile). 
	- maggiore è l’ampiezza di banda, maggiore è la quantità di informazione che può essere veicolata attraverso un mezzo trasmissivo
	- si misura in Hz
- **bit rate** (caratterizzazione di un collegamento): quantità di bit al secondo (bps) che un link garantisce di trasmettere
>[!warning] il bit rate è proporzionale alla banda, ma dipende anche dalla specifica tecnica di trasmissione, o formato di modulazione digitale

>[!info] per banda di un tipo di rete si intende il bit rate garantito dai suoi link
>il rate di un link Fast Ethernet è 100 mpbs, può inviare al massimo 100 mbps

## throughput
indica quanto velocemente riusciamo **effettivamente** a inviare dati tramite una rete: è quindi il numero di bit al secondo che passano attraverso **un punto** della rete
>[!warning] bit rate e throughput
>il rate è una misura della potenziale velocità di un link, mentre il throughput è una misura dell’effettiva velocità di un link (irl)

in un percorso da una sorgente a una destinazione, un pacchetto può passare attraverso numerosi link, ognuno con throughput diverso. bisogna calcolare il throughput **end-to-end** (totale)
>[!example] throughput su un percorso con 3 link
![[Pasted image 20250305234547.png]]
notiamo come link3 è il **collo di bottiglia** (collegamento su un percorso punto-punto che vincola il throughput end-to-end)
in questo esempio, il throughput dei dati per il percorso è 100 kpbs

in generale, in un percorso con $n$ link in serie, abbiamo:
$$
\text{throughput = min}\{T_{1},T_{2}, \dots,T_{n}\}
$$
>[!info] thoughput nei link condivisi
>il link tra due router è spesso dedicato a più di un flusso di dati, e raccoglie il flusso da varie sorgenti e/o lo distribuisce a varie destinazioni. il rate del link tra due router è quindi condiviso tra flussi di dati
>>[!example] esempio
![[Pasted image 20250305235205.png]]
iin questo caso la velocità del link principale è solo 200 kpbs in quanto il link è condiviso, e il throughput end-to-end ha lo stesso valore
crazy nesting grazie aglaia
## delay
**delay** (ritardo): quanto tempo serve affinchè un pacchetto arrivi completamente a destinazione dal momento in cui il primo bit parte dalla sorgente
- nella commutazione di pacchetto, i pacchetti si accodano nei buffer dei router. se il tasso di arrivo dei pacchetti sul collegamento eccede la capacità del collegamento di evaderli, i pacchetti si accodano, in attesa del proprio turno
vediamo le quattro cause di ritardo per i pacchetti: 
### ritardo di elaborazione del nodo
comprende:
- controllo sugli errori: il pacchetto è integro ? se no, viene tipicamente scartato
- determinazione del canale di uscita
- tempo dalla ricezione dalla porta di input alla consegna alla porta di output
### ritardo di accodamento
comprende:
- attesa di trasmissione (possibile sia nella coda di input che nella coda di output)
- livello di congestione del router
dati
$R=\text{rate di trasmissione (bps)}$
$L= \text{lunghezza del pacchetto (bit)}$
$a = \text{tasso medio di arrivo dei pacchetti (pkt/s)}$
$$
\text{intensità di traffico}= \frac{L \cdot a}{R}
$$
- $\frac{L\cdot a}{r} \simeq 0$: poco ritardo
- $\frac{L\cdot a}{r} \to 1$: il ritardo si fa consistente
- $\frac{L\cdot a}{r} > 1$: più “lavoro” in arrivo di quanto possa essere effettivamente svolto ! (ritardo medio infinito)
### ritardo di trasmissione
comprende:
- il tempo richiesto per trasmettere (immettere) tutti i bit del pacchetto sul collegamento (se il primo bit del pacchetto viene trasmesso al tempo $t_{1}$, e l’ultimo bit del pacchetto viene trasmesso al tempo $t_{2}$, il ritardo di trasmissione del pacchetto è $t_{2}-t_{1}$)

$$

\text{ritardo di trasmissione = } \frac{L}{R} = \frac{\text{lunghezza del pacchetto}}{\text{rate del collegamento}}
$$
### ritardo di propagazione
tempo che **un bit** impiega per propagarsi **sul collegamento**
$$
\text{ritardo di propagazione = } \frac{d}{s} = \frac{\text{lunghezza del collegamento fisico}}{\text{velocità di propagazione del collegamento}}
$$
tipicamente $s$ corrisponde alla velocità della luce !
>[!info] ritardo di nodo
quindi, il ritardo dotale di un nodo è:
>$$
d_{nodal} = d_{proc} + d_{queue} + d_{trans} + d_{prop}
>$$
$d_{proc}$ → ritardo di elaborazione (in genere pochi microsecondi o anche meno)
$d_{queue}$ → ritardo di accodamento (dipende dalla congestione)
$d_{trans}$ → ritardo di trasmissione (significativo sui collegamenti a bassa velocità)
$d_{prop}$ → ritardo di propagazione (da pochi microsecondi a centinaia di millisecondi)
![[Pasted image 20250411130815.png]]
## packet loss
se un buffer (coda) ha capacità finita, quando un pacchetto trova la coda piena viene scartato, e quindi viene perso. in questo caso il pacchetto può essere ritrasmesso dal nodo precedente, dal sistema terminale che lo ha generato, o non essere ritrasmesso affatto
# concetto $rate \cdot ritardo$
il prodotto $rate \cdot ritardo$ rappresenta il massimo numero di bit che possono riempire (allo stesso tempo) un collegamento
>[!info] spiegazione
pensiamo al link come un tubo: la sezione trasversale del tubo rappresenta il rate, e la lunghezza rappresenta il ritardo. possiamo allora dire che il volume del tubo definisce il prodotto $rate \cdot ritardo$
![[Pasted image 20250306104755.png]]

>[!example]- esempio
>supponiamo di avere un link con rate di 1 bps (il link trasmette un bit al secondo) e un ritardo di 5s(un bit ci mette 5s da quando parte dalla sorgente ad arrivare al destinatario)
![[Pasted image 20250306104536.png]]
il massimo numero di bit che possono riempire il collegamento è 5
# traceroute
`tracert` è un programma diagnostico che fornisce una misura del ritardo dalla sorgente a tutti i router lungo il percorso Internet punto-punto verso la destinazione
- invia gruppi di tre pacchetti, ogni gruppo con **tempo di vita incrementale**(da 1 a $n$, con massimo valore = 30) , che raggiungeranno il router $i$ (con $i = 1,n$) che si trova sul percorso della destinazione
- il router $i$ restituirà poi i pacchetti al mittente
- il mittente calcola l’intervallo tra trasmissione e risposta
>[!figure] img
![[Pasted image 20250306103239.png]]

l’output di `tracert` presenta 6 colonne:
1. il numero di router sulla rotta
2. nome del router
3. indirizzo del router
4. RTT del primo pacchetto
5. RTT del secondo pacchetto
6. RTT del terzo pacchetto
**RTT**: round trip time (tempo di andata e ritorno), include i 4 ritardi visti precedentemente !
- può accadere che il RTT del router $n$ sia maggiore del RTT del router $n+1$ a causa dei ritardi di accodamento (dipendono dallo stato attuale della rete)
- se la sorgente non riceve risposta da un router intermedio (o ne riceve meno di 3), allora pone un asterisco al posto del tempo RTT

>[!example] `traceroute` da `gaia.cs.umass.edu` a `www.eurecom.fr`
![[Pasted image 20250306103620.png]]
damn !!!!! crazy !!! collegamento transoceanico too !!
>- \\question come fa a raggruppare le network ?

>[!question] esercizio 1
>1. quanto tempo impiega un pachetto di $1000byte$ per propagarsi su un collegamento di $2500km$, con velocità di propagazione pari a $2,5 \cdot 10^8 \text{m/s}$ e rate di $2mbps$
>2. questo ritardo dipende dalla lunghezza del pacchetto ?
>3. calcolare il ritardo di trasmissione
>
>$L=1000byte$
>$R=2mbps$
>$T_{pr}=2,5 \cdot 10^8 \text{m/s}$
>>[!done]- soluzione
>>1.
ritardo di propagazione: $$T_{pr} = \frac{d}{v} = \frac{2500}{2,5 \cdot 10^8} = \frac{2,5 \cdot 10^3}{2,5 \cdot 10^8} = 10^{-2}s$$ 
>>2.
il ritardo non dipende dall lunghezza del pacchetto
>>3.
$$T_{tr} = \frac{L}{r} = \frac{8000b}{2 \cdot 10^6s}= \frac{4 \cdot 10^3}{10^6}= 4 \cdot 10^{-3} = 4ms$$


>[!question] esercizio 2
>si consideri un host A che trasmette pacchetti, ognuno di lunghezza $L=3000 bit$, su un canale di trasmissione con rate $10Mbps$, verso un host B all’altro estremo del link. Si supponga inoltre il ritardo di propagazione pari a $0,2ms$
>1. quanto tempo impiega l’host A a trasmettere un pacchetto ?
>2. dopo quanto tempo l’host B avrà ricevuto l’intero pacchetto ?
>3. quando l’host A ha terminato di trasmetere un pacchetto, l’host B ha già ricevuto parte di esso ?
>$L = 3000b$
>$R = 10Mbps$
>$T_{pr} = 0,2ms$
>>[!done]- soluzione
>>1.
chiede il ritardo di trasmissione(che è parte del ritardo di accodamento): 
>>$$
>T_{tr}= \frac{L}{R} = \frac{3000b}{10Mbps} = \frac{3000}{10 \cdot 10^6} = \frac{3 \cdot 10^3}{10 \cdot 10^6} = 0,3ms
>>$$
>>2.
>>chiede il ritardo totale di un pacchetto ($d_{a}$)
>>$$
>0,3 + 0,2 = 0,5ms
>>$$
>>3.
si, perchè il tempo di propagazione è minore del tempo di trasmissione (host A impiega $0,3 \text{m/s}$ a immettere **tutto** il pacchetto. il tempo di immisione del primo bit sarà tipo un microsecondo e quindi sarà sicuramente arrivato prima dell’immissione dell’ultimo byte

>[!info] prodotto rate*ritardo
>$$
10Mpbs \cdot 0,5ms = 10 \cdot 10^6 \cdot 5 \cdot 10^{-3}= (10 \cdot 0,2 ) \cdot 10^3 = 
$$


