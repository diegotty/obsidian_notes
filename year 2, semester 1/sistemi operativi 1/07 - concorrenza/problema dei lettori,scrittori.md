---
created: 2024-12-09
related to: "[[mutua esclusione, soluzioni software]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [soluzione con precedenza ai lettori](#soluzione%20con%20precedenza%20ai%20lettori)
>- [soluzione con precedenza agli scrittori](#soluzione%20con%20precedenza%20agli%20scrittori)
>- [soluzione con i messaggi](#soluzione%20con%20i%20messaggi)
>	- [breakdown](#breakdown)

a differenza del problema [[intro alla concorrenza#problema del produttore/consumatore|problema del producer/consumer]], le condizioni da soddisfare sono le seguenti:
- più lettori possono leggere il buffer contemporaneamente
- un solo scrittore può leggere il buffer
- se uno scrittore è all’opera sul buffer, nessun lettore può effettuare letture
inoltre, a differenza del problema producer/consumer, il buffer si accede **per intero**
- il buffer è quindi un’area condivisa **intera**, e non ci sono problemi di buffer pieno/vuoto
## soluzione con precedenza ai lettori
precedenza ai lettori: se un lettore sta operando sull’area, e “arriva” uno scrittore ad aspettare, e poi arrivano altri lettori ad aspettare, hanno la precedenza i lettori (starvation ? capiamo)
```c
**implementazione con precedenza ai lettori
int readcount;
semaphore x = 1, wsem = 1;
void reader(){
	while(true){
		semWait(x);
		readcount++;
		if(readcount == 1) semWait(wsem);
		semSignal(x);
		READUNIT();
		semWait(x);
		readcount--;
		if(readcount == 0) semSignal(wsem);
		semSignal(x);
	}
}
void writer(){
	while(true){
		semWait(wsem);
		WRITEUNIT();
		semSignal(wsem);
	}
}
void main(){
	readcount = 0;
	parbegin(reader, writer);
}
```
- il primo lettore blocca gli scrittori, l’ultimo lettore sblocca gli scrittori:
```c
if(readcount == 1) semWait(wsem);
if(readcount == 0) semSignal(wsem);
```
- semaforo `x` serve per garantire mutua esclusione su `readcount`
- simile a quello che abbiamo visto in [[esempi (trastevere, barbiere)#trastevere (roma)|trastevere]] 
- gli scrittori possono andare in starvation ! (anche se coda dei `BLOCKED` gestita con semafori forti)
>[!example] esempio
>in particolare, notiamo come, quando arrivano più lettori, oltre al fatto che tutti i lettori che arrivano possono leggere l’area di memoria (come previsto), ma effettivamente nessuno scrittore riuscirà a tornare `READY` fino a che l’ultimo lettore non finisce la lettura
## soluzione con precedenza agli scrittori
```c
**soluzione con precedenza agli scrittori
int readcount, writecount;
semaphore x = 1, y = 1, z = 1, wsem = 1, rsem = 1;
void reader(){
	while(true){
		semWait(z);
			semWait(rsem);
				semWait(x);
					readcount++;
					if(readcount == 1) semWait(wsem);
				semSignal(x);
			semSignal(rsem);
		semSignal(z);
		READUNIT();
		semWait(x);
			readcount--;
			if(readcount == 0) semSignal(wsem);
		semSignal(x);
// upon re-reading: WHAT THE FUCK
	}
}

void writer(){
	while(true){
		semWait(y);
			writecount++;
			if(writecount == 1) semWait(rsem);
		semSignal(y);
		semWait(wsem);
		WRITEUNIT();
		semSignal(wsem);
		semWait(y);
			writecount--;
			if(writecount == 0) semSignal(rsem);
		semSignal(y);
	}
}

void main(){
	readcount = writecount = 0;
	parbegin(reader, writer);
}
```
(indentazione puramente per facilitare la comprensione)
- semaforo `y` usato solamente dagli scrittori, per garantire la mutua esclusione su `writecount`
- il primo reader che esegue `reader()`, blocca gli scrittori !
```c
if(readcount == 1) semWait(wsem);
```
## soluzione con i messaggi
- oltre a questo codice occorre un processo di inizializzazione che crea le 3 mailbox e lancia 1 controller e più reader e writer a piacimento
```c
// mailbox = readrequest, writerequest, finished
// empty verifica se ci sono messaggi da ricevere

void reader(int i) {
	while(true) {
		nbsend(readrequest, null);
		receive(controller_pid, null);
		READUNIT();
		nbsend(finished, null);
	}
}

void writer(int j) {
	while(true) {
		nbsend(writerequest, null);
		receive(controller_pid, null);
		WRITEUNIT();
		nbsend(finished, null);
	}
}

void controller() {
	int count = MAX_READERS;
	while(true) {
		if (count > 0) {
			if (!empty(finished)) {
				receive(finished, msg); /* da reader! */
				count++;
			}
			else if (!empty(writerequest)) {
				receive(writerequest, msg);
				writer_id = msg.sender;
				count = count - MAX_READERS;
			}
			else if (!empty(readrequest)) {
				receive(readrequest, msg);
				count--;
				nbsend(msg.sender, "OK");
			}
		}

		if (count == 0) {
			nbsend(writer_id, "OK");
			receive(finished, msg); /* da writer! */
			count = MAX_READERS;
		}

		while (count < 0) {
			receive(finished, msg); /* da reader! */
			count++;
		}
	}
}
```
### breakdown 
- vegono usate `nbsend` e `receive`
- sia reader che writer mandano una richiesta alle rispettive mailbox: `readrequest`, `writerequest`, per “chiedere” se possono accedere all’area ([[mutua esclusione, soluzioni software#indirizzamento indiretto|indirizzamneto indiretto !!]])
- viene poi chiamata `receive(controller_pid, null);` , in cui writer e reader aspettano una risposta dal controller per accedere all’area ([[mutua esclusione, soluzioni software#indirizzamento diretto|indirizzamento diretto !]])
- `count`, se positivo, indica il numero corrente di lettori sull’area
- tutte le condizioni dentro `if(count > 0)` controllano se una delle mailbox ha dei messaggi, e in caso positivo, viene usato `receive` per prendere tali messaggi. quindi, anche se `receive` è bloccante, non succederà mai che il controller si bloccherà su una di queste `receive`, perchè è sicuro che ci sia almeno un messaggio
- se `writerequest` non è vuota, invece (e ciò viene controllato prima di `!empty(readrequest))`, si usa la linea di codice `count = count - MAX_READERS;`(**il barbatrucco**) per forzare `count <= 0`
	- se `count == 0`, non erano presenti lettori, e quindi writer può andare scrivere nell’area
	- se `count < 0`, sono presenti dei lettori, e si attende finchè tutti i lettori non finiscano, con lo snippet di codice appena sotto. in questo modo, quando si esce da quel while, all’iterazione dopo di `while(true)`, avremo `count == 0` e il writer verrà ammesso all’area (very smart)
```c
while(count < 0){
	receive(finished, msg);
	count++;
}
```
- si nota come il controller, per mandare un messaggio al writer che ha mandato la sua richiesta in `readrequest`, usi `msg.sender` come destinatario
- se ci sono più di `MAX_READERS-1` richieste contemporanee da lettori, la soluzione non funziona
