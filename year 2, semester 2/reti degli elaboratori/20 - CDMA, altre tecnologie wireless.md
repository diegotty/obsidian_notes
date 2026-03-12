---
related to: 
created: 2025-03-02T17:41
updated: 2025-06-19T19:04
completed: false
---
abbiamo visto, nelle lezioni precedenti, i vari modi di accesso al mezzo mediante suddivisione del canale: [[17 - livello di collegamento#TDMA|TDMA]] e [[17 - livello di collegamento#FDMA|FDMA]]
studiamo ora un atro protocollo per accesso multiplo
# CDMA
nel **CDMA** (**code division multiple access**):
- l’intera ampiezza di banda viene occupata da un solo canale (non c’è quindi divisone di frequenze)
- tutte le stazioni possono invare contemporaneamente 
- vengono usati **codici**, diversi per ogni stazione, per comunicare in modo “riconoscibile” (come se ogni coppia di stazioni parlasse una lingua diversa)
>[!example] esempio
>assumiamo di avere 4 stazioni connesse sullo stesso canale:
>- i dati spediti sono $d_{1},d_{2},d_{3},d_{4}$, e i codici assegnati alle stazioni sono $c_{1},c_{2},c_{3},c_4$
>
![[Pasted image 20250523103239.png]]
la sequenza sul canale è la somma delle quattro sequenza inviate dalle stazioni (effettuiamo quindi lo **spreading**: il far diventare un bit una sequenza)

nel CDMA, ogni stazione **moltiplica** i propri dati per il proprio codice, e trasmette il risultato
>[!info] proprietà dei codici
>- se moltiplichiamo ogni codice con un altro codice, otteniamo 0
>- se moltiplichiamo ogni codice per se stesso, otteniamo il numero delle stazioni (vedremo che ogni digit del codice è in $\{ 1,-1\}$)
>- **qualsiasi stazione voglia ricevere dati da una delle altre tre stazioni (nell’esempio), moltiplica i dati ricevuti per il codice del mittente e divide per il numero delle stazioni**

>[!example] esempio di calcoli
consideriamo l’esempio di sopra:
>$$
\text{messaggio sul canale = }d_{1}\cdot c_{1}+d_{2}\cdot c_{2}+d_{4}\cdot d_{4}
>$$
>$$
\text{messaggio di stazione1} = \frac{(d_{1}\cdot c_{1}+d_{2}\cdot c_{2}+d_{4}\cdot d_{4})\cdot c_{1}}{4} =
>$$
>$$
\frac{\Big((d_{1}\cdot c_{1})\cdot c_{1}+(d_{2}\cdot c_{2})\cdot c_{1}+(d_{4}\cdot d_{4})\cdot c_{1}\Big)}{4} = \frac{d_{1}\cdot4 + d_{2}\cdot0+ d_{4}\cdot0}{4} = d_{1}
>$$

## sequenze di chip
il CDMA si basa sulla teoria della codifica: ad ogni stazione viene assegnato un codice (sequenza di numeri), chiamati chip
- le sequenze assegnate sono speciali e vengono chiamate **sequenze ortogonali**
>[!info] proprietà delle sequenze ortogonali
> - ogni sequenza è composta da $N$ elementi, con $N= \text{numero di stazioni}$ 
> 	- $N$ deve essere una potenza di 2 (per come calcoliamo le sequenze !)
> - se moltiplichiamo una sequenza per un numero, ogni elemento della sequenza viene moltiplicato per tale numero
> 	- $2\cdot[+1+1-1-1]= [+2+2-2-2]$
> - se moltiplichamo due sequenze uguali e sommiamo i risultati otteniamo $N$
> 	- $[+1+1-1-1]\cdot[+1+1-1-]=1+1+1+1=4$
>- se moltiplichiamo due sequenze diverse e sommiamo i risultati, otteniamo 0
>	- $[+1+1-1-1] \cdot[+1+1+1+1] = 1+1-1-1 = 0$
> - sommare due sequenza significa sommare gli elementi corrispondenti
>	- $[+1+1-1-1]+[+1+1+1+1]=[+2+2\,\,0\,\,0]$

>[!example] esempio caldo
![[Pasted image 20250523105802.png]]
le sequenze vengono poi sommate, e il risultato viene mandato come segnali digitale
![[Pasted image 20250523110106.png]]
viene poi moltiplicato per il codice della stazione mittente, e vengono poi sommate le cifre del risultato e ciò viene diviso per il numero di stazioni
![[Pasted image 20250523110259.png]]
nella trasmissione:
- un bit dati 0 viene interpretato come $-1$
- un bit dati 1 viene interpretato come $+1$
- il silenzio viene interpretato come $0$
>[!info] generazione di sequenze di chip
per generare sequenze di chip usiamo una **tabella di Walsh**: una matrice quadrata in cui ogni riga è una sequenza di chip
> - $W_{1}$ indica una sequenza con un chip solo (quindi una riga e una colonna), e può assumere, a scelta, valore $+1 / -1$
>- conoscendo $W_{n}$, possiamo calcolare $W_{2n}$ nel sequente modo:
![[Pasted image 20250523110615.png]]
>
>>[!example] esempio
>![[Pasted image 20250523110641.png]]

abbiamo visto tanti protocolli MAC:
- in particolare, sappiamo che viene usato CSMA/CD per le LAN wired e CSMA/CA per le LAN wireless
ma abbiamo anche studiato i protocolli [[17 - livello di collegamento#ALOHA puro|ALOHA]], TDMA, etc.
- questo perchè ci sono reti wireless con caratteristiche fisiche che non consentono di usare i protocolli MAC più complessi ed efficienti come CSMA
## bluetooth
il bluetooth è una tecnologia LAN wireless, progettata per connettere dispositivi con diverse funzioni e diverse capacità
- una LAN bluetooth è una rete ad hoc, che si forma spontaneamente senza aiuto di alcun AP
- è una rete piccola, e pochi dispositivi sono ammessi a far parte della rete
- la banda è di 2,5 GHz, divisa in 79 canali da 1MHz ciascuno
### piconet
la **piconet** è una rete composta al massimo da 8 dispositivi: 1 stazione primaria e 7 stazioni che si sintonizzano con la primaria
- possono esserci anche più stazioni secondarie, ma devono essere in stato **parked** (sincronizzate con la primaria, ma non possono prendere parte alla comunicazione) finchè una stazione attiva non lascia il sistema o viene spostata nello stato **parked**
>[!info] rappresentazione piconet
![[Pasted image 20250523112215.png]]
### scatternet
la **scatternet** è una combinazione di piconet: in questa rete uno dei dispositivi secondari della piconet può essere primaria in un’altra piconet, passando messaggi da una rete all’altra
>[!info] rappresentazione scatternet
![[Pasted image 20250523112350.png]]

### protocollo MAC
>[!info] bluetooth layers
bluetooth definisce uno stack protocollare diverso da TCP/IP:
![[Pasted image 20250523112443.png]]

bluetooth usa TDMA, con slot temporali di 625ms
- ogni slot lavora da una frequenza differente
- dispositivi primari e secondari inviano e ricevono dati, ma non contemporaneamente: **primario usa slot pari, secondari usano slot dispari**
- la trasmissione di un pacchetto richiede circa 366ms (quindi quasi la metà dello slot temporale)
- il resto dello slot temporale (circa 259ms), serve per il turnaround (?), il salto di frequenza, la sincronizzazione
>[!info] comunicazione con secondaria singola
![[Pasted image 20250523112928.png]]

>[!info] comunicazione con più secondarie
nella comunicazione con più secondarie, la primaria usa slot pari, e ad ogni slot specifica chi deve trasmettere nello slot successivo
![[Pasted image 20250523113027.png]]

## RFID

se due tag rispondono nello stesso momento, avviene una collisione (praticametne bit a bit) e il reader rimane incluato


reader deve arbitrare il protcoollo MAC


tree slotted aloha 42% di eff.