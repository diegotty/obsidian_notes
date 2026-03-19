---
created: 2025-05-06T13:13
updated: 2025-05-06T13:14
---
>[!index]
>- [raffinamento dei requisiti](#raffinamento%20dei%20requisiti)
>- [diagramma UML](#diagramma%20UML)
>- [specifica dei tipi](#specifica%20dei%20tipi)
>- [specifica di classe](#specifica%20di%20classe)
>- [diagramma UML degli use-case](#diagramma%20UML%20degli%20use-case)
>- [specifica di use-case](#specifica%20di%20use-case)
## raffinamento dei requisiti
1. Requisiti sulle crociere:
	1. codice 
	2. data di inizio
	3. data di fine
	4. nave utilizzata (v. req. 2)
	5. itinerario (v. req. 4)
	6. il tipo, uno tra:
		1. luna di miele, di cui interessa:
			1. sottotipo, uno tra:
				1. tradizionali: 
					quelle che prevedono un numero di destinazioni romantiche (v. req. 3.4) maggiore o uguale al numero di destinazioni divertenti
				2. alternative
					quelle non tradizionali
		2. per famiglie, di cui interessa:
			1. se adatte ai bambini (booleano)

2. Requisiti sulle navi
	1. nome
	2. comfort (3..5)
	3. capienza

3. Requisiti sulle destinazioni:
	1. nome
	2. continente
	3. posti da vedere (v. req. 5)
	4. tipo, almeno uno tra:
		1. romantico
		2. divertente
	5. se è esotica, ovvero se è fuori dall'Europa

4. Requisiti sugli itinerari: di ogni itinerario interessa
	1. sequenza ordinata di elementi, di cui interessa:
		1. destinazione (v. req. 3)
		2. arrivo:
			1. il numero d'ordine del giorno (rispetto alla data di inizio della crociera)
			2. ora
		3. ripartenza	
			1. il numero d'ordine del giorno (rispetto alla data di inizio della crociera)
			2. ora

5. Requisiti sui posti da vedere:
	1. nome
	2. descrizione
	3. orari di apertura, nella forma di una mappa che associa ad ogni giorno della settimana (lunedì, ..., domenica) un insieme di fasce orarie, dove ogni fascia oraria è definita in termini di una coppia di orari

6. Requisiti sui clienti:
	1. nome
	2. cognome 
	3. età 
	4. indirizzo

7. Requisiti sulle prenotazioni di crociere da parte dei clienti:
	1. cliente
	2. crociera
	3. istante di prenotazione
	4. numero di posti prenotati

8. Requisiti sulle funzionalità
	1. Accedute dal personale dell'Ufficio Prenotazioni:
		1. Effettuare la prenotazione, per conto di un cliente, di un certo numero di posti per una crociera (non ancora partita), solo se la nave ha ancora un numero di posti disponibili sufficiente
	2. Accedute dall'Ufficio Marketing:
		1. Dato un periodo 'p', calcolare l'età media dei clienti che hanno prenotato, durante 'p', almeno una crociera che prevede una destinazione esotica (v. req. 3.5)
		2. Dato un periodo 'p', calcolare la percentuale delle destinazioni 'gettonate' in 'p', ovvero raggiunte, durante 'p', da almeno dieci crociere di luna di miele, oppure da almeno quindici crociere per famiglie.
## diagramma UML
![[Pasted image 20250425132355.png]]
## specifica dei tipi
- Ora: (ore: Intero in 0..24, minuti: Intero in 0..60)
- Indirizzo: (via : Stringa, civico : Intero > 0, cap : Intero > 0)
- Orario: (apertura : Ora, chiusura : Ora)
- GiornoSettimana : {lunedì, martedì, mercoledì, giovedì, venerdì, sabato, domenica}
- Istante : (data : Data, ora : Ora, secondi : Intero in 0..60)
- DeltaDataOra : (giorno: Intero > 0, ora: Ora)

>[!warning] disaccordo
>il prof. , per modellare gli orari delle destinazioni, usa:
>- apertura: Apertura[0..7] in PostoDaVedere
>
con
>- Apertura: (giorno: GiornoSettimana, fascia : FasciaOraria)
>- FasciaOraria(ora_inizio: Ora, ora_fine: Ora)
>
>ma in questo modo non è possibile assegnare più fasce orarie in un singolo giorno ad un posto da vedere (credo) ! lame
## specifica di classe
**classe Crociera**
ogni istanza di questa classe rappresenta una crociera
- fine() : Data
	pre:  nessuna
		// esiste il link crociera_itinerario che comprende this (scontato, è 1..1, quindi **errore**)
	post:
		sia i : Itinerario t.c. (this, i) : crociera_itinerario
		result = inizio + i.durata_g()
		
- posti_disponibili (t: DataOra) : Intero ≥ 0
	pre:
		t ≤ adesso
		t ≤ this.inizio
		esiste il link (this, n) : crociera_nave
	post:
		sia pre l’insieme degli oggetti p : Prenotazione t.c. esiste il link (this, p) : crociera_prenotazione
		sia n : Nave l’oggetto t.c. esiste (this, n) : crociera_nave
		posti_prenotati = $\sum_{p \in \text{pre}}p.posti$
		result = n.capienza - posti_prenotati

// operazioni fatte per facilitare gli use-case **statistiche**
- tocca(d : Destinazione, inizio : Data, fine : Data) : Booleano
	pre: 
		inizio ≤ fine
		i periodi (this.inizio, this.fine()) e (inizio, fine) **non** sono disgiunti
	post:
		sia i : Itinerario l’oggetto t.c. esiste (this, i) : crociera_itinerario
		se d non appartiene a i.destinazioni(), result = FALSE
		altrimenti:
			se esiste (i, d) :  partenza_iniziale, result = TRUE se e solo se inizio ≤ this.inizio ≤ fine
			se esiste (i, d) :  arrivo_finale, result = TRUE se e solo se inizio ≤ this.fine() ≤ fine
			se esiste t : Tappa l’oggetto t.c. esiste (i, t) : tappa_itinerario ed esiste (t, d) : tappa_destinazione, result = TRUE se e solo se  i periodi (this.inizio + t.arrivo.giorno, this.inizio + t.partenza.giorno) e (inizio, fine) si sovrappongono
			altrimenti return = FALSE

```
// fu scritta dal bro sull’UML ma non fu mai usata, l’ho fatta e non voglio cancellarla
- destinazioni_toccate() : Destinazione [1..\*]
	pre: nessuna
	post:
		sia i : Itinerario l’oggetto t.c. esiste (this, i) : crociera_itinerario
		result = i.destinazioni()
```

- vincoli esterni
\[V.crociera.Prenotazione.no_overbooking]
per ogni c : Crociera t.c. esiste un link crociera_nave che coinvolge c:
	per ogni t : DataOra tale che t ≤ inizio, deve essere vereo che c.posti_liberi(t) ≥ 0

**classe Itinerario**
ogni istanza di questa classe rappresenta un itinerario
- durata_g() : Intero ≥ 0
	pre: nessuna (basta che ci siano partenza e arrivo, che sono di molteplicità 1 per il ruolo di itinerario)
	post: 
		l’operazione non modifica il livello estensionale
		sia (this, d), il link di assoc. arrivo_finale che coinvolge ‘this’ (duh ?)
		result = (this, d).istante.giorno

//operazioni fatte per facilitare gli use-case **statistiche**
- destinazioni() : Destinazione[0..\*]
	pre: nessuna
	post:
		sia tappe l’insieme di t : TappaIntermedia t.c. esiste (this, t) : itin_tappa
		sia destinazioni l’insieme di d : Destinazione t.c esiste , con t in tappe, (t, d) : tappa_dest
		sia tappa_partenza : Destinazione l’oggetto t.c. esiste (this, d) : partenza_iniziale
		sia tappa_arrivo : Destinazione l’oggetto t.c. esiste (this, d) : arrivo_finale
		result = destinazioni U {tappa_partenza} U {tappa_arrivo}

- esotico() : Booleano
	pre: nessuna
	post:
		sia dest = this.destinazioni()
		result = TRUE se e solo se esiste almeno un d : Destinazione in dest t.c. d.esotica() = TRUE



**classe Cliente**
ogni istanza di questa classe rappresenta un cliente
- eta() : Intero ≥ 0
	pre-condizioni:
		d ≥ this.data_nascita
	post-condizioni:
		l’operazione non modifica il livello estensionale
		result = d- this.data_nascita (espressa in anni approssimata per difetto)

**classe Destinazione**
ogni istanza di questa classe rappresenta una destinazione raggiungibile
- esotica() : Booleano
	pre: nessuna
	post: 
		l’operazione non modifica il livello estensionale
		sia c : Continente t.c. (this, c) : destinazione_continente
		result = c.esotico

**classe LunaDiMiele**
ogni istanza di questa classe rappresenta una crociera di tipologia luna di miele
## diagramma UML degli use-case
![[Pasted image 20250425115707.png]]
## specifica di use-case
**use-case gestione prenotazioni completa**
- prenota(cl : Cliente, cr : Crociera, n_posti : Intero > 0) : Prenotazione
	pre:
	 - adesso < cr.inizio
	 - esiste il link dell’associazione crociera_nave che coinvolge cr  (altrimenti non è possibile sapere la capienza)
	 - cr.posti_disponibili(adesso) ≥ n_posti
	post:
		l’operazione modifica il livello estensionale come segue:
		viene creato l’oggetto pr : Prenotazione con pr.istante = adesso, pr.posti = n_posti
		viene creato il link (cl : pr ) : cliente_prenotazione
		viene creato il link (cr : pr ) : crociera_prenotazione
		result = pr

**use-case statistiche**
8.2.1
- media_esotiche(data_inizio : Data, data_fine : Data)
	pre: 
		data_inizio ≤ data_fine
		esiste almeno un c : Crociera t.c. :
		sia i : Itinerario t.c. (c, i) : crociera_itinerario
		i.esotico() è true
	post:
		sia prenotazioni_inter l’insieme delle prenotazioni in cui data_inizio < prenotazione.istante < data_fine
		sia prenotazioni_ok l’insieme degli oggetti p : Prenotazione appartenenti a prenotazioni_inter in cui, dato l’ogetto c : Crociera coinvolto nell’unico link (c, p) : crociera_prenotazione, e i : Itinerario l’oggetto coinvolto nell’unico link (c, i) : crociera_itinerario, ci sia i.esotico() = TRUE
		sia clienti l’insieme di c : Clienti associati alle singole prenotazioni di prenotazioni_ok nell’assoc. cliente_prenotazione
		result= $\sum_{c \in \text{clienti}} \text{c.età(adesso)}$ / |clienti|
		

		
//soluzione prof. (stessa logica, scritto in modo sensato)
- media_esotiche(data_inizio : Data, data_fine : Data)
	pre: 
		data_inizio ≤ data_fine
		esiste almeno un c : Crociera t.c. :
		sia i : Itinerario t.c. (c, i) : crociera_itinerario
		i.esotico() è true
		sia clienti l’insieme di cl : Cliente t.c. esiste c : Crociera, p : Prenotazione e i: Itinerario t.c. :
			(cl,p ) : cliente_prenotazione AND
			(p, c) : crociera_prenotazione AND
			(c, i) : crociera_itinerario AND
			i.esotico() = TRUE AND
			data_inizio ≤ p.istante < data_fine
		result= $\sum_{c \in \text{clienti}} \text{c.età(adesso)}$ / |clienti|
			

8.2.2
- percentuale_mete_gettonate(inizio : Data, fine : Data)
	pre:
		inizio ≤ fine
		//devo evitare la divisione per 0 !
		esiste d : Destinazione e c : Crociera t.c. c.tocca(d, inizio, fine) = TRUE
	post:
		destinazioni = {
		 d : Destinazione | esiste c : Crociera e c.tocca(d, inizio, fine) = TRUE
		}
		destinazioni_gettonate = {
			(d, v_ln, v_f) | d: Destinazione,
			v_ln = |{(c) | c: LunaDiMiele AND c.tocca(d, inizio, fine) }|, 
			v_f = |{c | c : CrocieraPerFamiglie AND c.tocca(d, inizio, fine)}|, 
			e (v_ln ≥ 10 OR v_f ≥ 15)
		}
		result = |destinazioni_gettonate|/|destinazioni|
