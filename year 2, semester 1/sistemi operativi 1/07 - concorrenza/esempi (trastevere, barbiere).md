---
created: 2024-12-09
related to: "[[semafori]]"
updated: 2024-12-10T08:14
---
>[!index]
>
>- [breakdown](#breakdown)
>- [il negozio del barbiere](#il%20negozio%20del%20barbiere)
>- [soluzione 1](#soluzione%201)
>	- [breakdown](#breakdown)
>		- [customer](#customer)
>		- [barber](#barber)
>- [soluzione 2](#soluzione%202)
>	- [breakdown](#breakdown)
>		- [customer](#customer)
>		- [barber](#barber)
# trastevere (roma)
>[!info] roma mia quanto sei bella
>![[Pasted image 20241208182157.png]]
>- i blocchetti sono le macchine, il tubo è la strada di trastervere
>- la strada si restringe: senso unico alternato, massimo 4 auto per volta
>- vince chi arriva prima, non ci può essere parità
>- una volta impegnata da un lato, tutte le macchine dell’altro lato devono aspettare che non ci siano più macchine nè sulla strettoia, nè in coda(non effettivamente vero: se la coda di `BLOCKED` è gesita in modo forte, questa caratteristica, con il codice in seguito, non è rispettata)
>- amico mio, vedi ad andare in macchina a trastevere, ma che brutta idea che ti è passata per la mente
>- si ma gli autobus puzzano, io ho l’arbre magique del pupone

```c
semaphore z = 1;
semaphore strettoia = 4;
semaphore sx = 1;
semaphore dx = 1;
//4 semafori (sai com'è, a roma, alla fine ne fuziona 1)
int nsx = 0; // curr numero di macchine in coda a sinistra
int ndx = 0; // curr numero di macchine in coda a destra

macchina_dal_lato_sinistro () {
	wait(sx);
	nsx++;
	if(nsx == 1)
		wait(dx);
	signal(sx); 
	signal(z);
	
	wait(strettoia);
	passa_strettoia();
	signal(strettoia);
	wait(sx);
	nsx--;
	if(nsx == 0)
		signal(dx);
	signal(sx);
}
```

>[!warning] se non c’è mutua esclusione c’è un incidente frontale
## breakdown
`z`: semaforo che ci permette di evitare il deadlock
`strettoia`: semaforo che garantisce il passaggio delle macchine attraverso la strettoia (viene inizializzato a 4 perchè nella strettoia possono trovarsi 4 macchine)
`sx,dx`: semafori usato per garantire la mutua esclusione nell’entrata nella strettoia
`nsx,ndx`: rispettivamente: current numero di macchine in coda a sinistra, current numero di macchine in coda a destra

- il seguente snippet di codice, garantisce che le (al massimo) 4 macchine che sono nella strettoia riescano a passare, mentre la quinta si fermi (`count < 0`)
```c
	wait(strettoia);
	passa_strettoia();
	signal(strettoia);
```

- notiamo come la funzione `macchina_dal_lato_sinistro` incrementi e decrementi solo `nsx` (come è giusto che sia, in quanto una macchina dal lato sinistro non ha informazioni sul numero di macchine in coda dal lato destro)
- il seguente snippet di codice in `macchina_dal_lato_sinistro` serve perchè se viene eseguito dalla prima macchina in coda nel lato sinistro (quindi `nsx == 1`), deve bloccare le macchine dal lato destro dall’entrare nella strettoia. allo stesso modo, se viene eseguito dall’ultima macchina in coda (dopo il decremento `nsx == 0`), essa deve sbloccare le macchine dal lato destro, per farle entrare nella strettoia
	- in particolare, non sarà il`wait(dx)` chiamato a una macchina dal lato sinistro a bloccare la macchina del lato destro, ma il `wait(dx)` chiamato dalla macchina dal lato destro (infatti `dx` è inizializzato ad 1)
```c
if(nsx == 1)
	wait(dx);
/////
if(nsx == 0)
	signal(dx);
```

- il seguente snippet di codice serve per garantire una mutua esclusione sulla variabile globale `nsx` (infatti ricordiamo che il semplice incremento `++nsx;` comporta una piccola race condition (in quanto è composta da 2/3 operazioni assembly), e quindi potrebbe succedere che, se incrementata da 2 processi, risulti incrementata solo da 1)
```c
wait(sx);
signal(sx);
```

- senza la presenza di `wait(z)`, è possibile avere un deadlock: S1 e D1 eseguono entrambe, rispettivamente `wait(sx)` e `wait(dx)`, e quando S1 arriva a `wait(dx)`, va in `BLOCKED` perchè `dx == -1`. lo stesso accade per D1, che arriva a `wait(sx)` e va in `BLOCKED`
	- il semaforo `z` impedisce che lo scheduling sopra avvenga, poichè il bloco tra `wait(z)` e `signal(z)` sarà eseguibile solo da un processo alla volta

la macchina dal lato destro fa esattamente la stessa cosa, ma scambiando `sx` con `dx`, e `nsx` con `ndx`
# il negozio del barbiere
>[!info] barberia
![[Pasted image 20241209093132.png]]
>- dimensione massima del negozio: `max_cust`
>- prima ci si siede sul divano, poi da lì si accede ad una delle sedie per tagliarsi i capelli
>- si compete per entrambe le risorse: un certo numero (`sofa`) di posti sul divano, e un certo numero (minore dei posti sul divano) di posti sulle sedie
>- tra tutti quelli nel negozio si compete per il divano, e tra tutti quelli sul divano si compete per le sedie
>- i barbieri (1 per sedia) fanno anche da cassieri dopo il taglio

## soluzione 1
- si decide che si possono servire, nel corso di una giornata, un massimo numero di clienti (`finish`)
- c’è una sola cassa, per la quale competono i barbieri( ovvero, un barbiere libero a caso può fare le veci del cassiere)
```c
// finish=numero massimo di persone servibili nel periodo
// max_clust=numero massimo di persone contemporaneamente nel negozio
// coord=numero di barbieri
semaphore
	max_clust=20, sofa=4, chair=3, coord=3, ready=0, leave_ch=0,
	paym=0, recpt=0, finish[50]={0};
	mutex1=1, mutex2=1;

int count = 0;

void customer() {
	int cust_nr;
	wait(max_cust);
	enter_shop();
	wait(mutex1);
	cust_nr = count;
	count++;
	signal(mutex1);
	wait(sofa);
	sit_on_sofa();
	wait(chair);
	get_up_from_sofa();
	signal(sofa);
	sit_in_chair();
	wait(mutex2);
	enqueue1(cust_nr);
	signal(mutex2);
	signal(ready);
	wait(finish[cust_nr]);
	leave_chair;
	signal(leave_cr);
	pay();
	wait(recpt);
	exit_shop();
	signal(max_cust);
}

void barber() {
	int b_cust;
	while(true) {
		wait(ready);
		wait(mutex2);
		dequeue1(b_cust);
		signal(mutex2);
		wait(coord);
		cut_hair();
		signal(coord);
		signal(finish[b_cust]);
		wait(leave_ch);
		signal(chair);
	}
}

void cashier() {
	while(true) {
		wait(paym);
		wait(coord);
		accept_pay();
		signal(coord);
		signal(recpt);
	}
}
```
### breakdown
#### customer
- `max_cust, sofa, chair`: semafori con la stessa funzione di `strettoria` nell’esempio precedente, cioè garantire il numero massimo di persone 
- il seguente snippet permette di accedere a `count` in mutua esclusione(dato che`count` è una variabile globale)
```c
	wait(mutex1);
	cust_nr = count;
	count++;
	signal(mutex1);
```
- in seguito, provo a sedermi sul divano, per poi alzarmi quando c’è posto sulla sedia e sedermi quindi sulla sedia
- dopo essermi seduto, “metto il mio numeretto” dentro una coda (`enqueue1(cust_nr)`), da poi il barbiere andrà a prendere i clienti)
- vengono usati 2 semafori (`mutex1`, `mutex2`) perchè se ne avessi usato solo uno, avrebbe funzionato ma sarebbe stato meno efficiente (un cliente non poteva mettere il suo numero nella queue se un altro cliente stava prendendo il suo numero)
- viene chiamato `signal(ready)` (credo!) per tenere traccia del numero dei clienti in coda ?
- `finish[50]` è un vettore di 50 semafori !!!
- viene chiamato `wait(finish[cust_nr)`quando inizia il taglio, e sarà poi il barbiere a chiamare il rispettivo `signal`
- una volta finito il taglio, il cliente si alza dalla sedia e chiama `signal(leave_ch)` (il barbiere chiama `wait(leave_ch)`
- il cliente paga, e chiama `wait(recpt)` per aspettare la ricevuta, e poi se ne va
#### barber
- `wait(ready)` perchè se non ci sono clienti va ananna
- il barbiere prende il numero del prossimo cliente
- `wait(coord)` per gestire il fatto che i barbieri si devono dividere tra barbieri e cassieri (infatti viene fatta la stessa cosa nel codice del cassiere)
- il barbiere taglia i capelli al cliente, e quando ha finito chiama `signal(coord)` poichè si è liberata una sedia, e chiama `signal(finish[b_cust])` perchè il taglio di capelli è finito
- il numero di sedie disponbili viene gestito dal cliente !! il barbiere chiama solo `signal(chair)` alla fine del taglio
## soluzione 2
- niente limite massimo al numero di clienti servibili in un giorno
- niente processo separato per pagare, ma resta il fatto che paga un barbiere qualsiasi, purchè libero
- serve solo un semaforo `mutex`, non serve più il semaforo `coord`(non ci serve gestire la divisione tra barbieri e cassieri)
- ci sono tanti semafori `finish`, quanti sono i barbieri
- il semaforo `chair` è inizializzato a 0, e viene incrementato ogni volta che un barbiere torna libero
- piccola inefficienza: solo un barbiere alla volta può **preparare** la propria sedia
```c
void Customer(i) {
	int my_barber;
	wait(max_cust);
	enter_shop();
	wait(sofa);
	sit_on_sopfa();
	wait(chair);
	get_up_from_sofa();
	signal(sofa);
	my_barber = next_barber;
	sit_in_chair();
	signal(ready);
	wait(finish[my_barber]);
	leave_chair();
	pay();
	signal(paym);
	wait(recpt);
	exit_shop();
	signal(max_cust);
}

int next_barber;
void Barber(i) {
	while(true) {
		wait(mutex);
		next_barber = i;
		signal(chair);
		wait(ready);
		signal(mutex);
		cut_hair();
		signal(finish[i]);
		wait(paym);
		accept_pay();
		signal(recpt);
	}
}
```
### breakdown
#### customer
- prima di sedermi su una sedia, io mi “prendo” un barbiere con `my_barber = next_barber`
#### barber
- la funzione prende un int come parametro ! che rappresenta il numero del barbiere
- `next_barber = i` per dire che il barbiere `i`è libero (per fare ciò entra in una sezione critica), che dura finchè qualcuno non si siede sulla sua sedia !!! quindi non ci sono problemi con altri barbieri che sono pronti (che potrebbero sovrascrivere `next_barber`). in questo modo, i clienti non hanno bisogno di entrare in una sezione critica per accedere in lettura a `next_barber`. very smart ngl