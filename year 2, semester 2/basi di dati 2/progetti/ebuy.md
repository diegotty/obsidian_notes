---
created: 2025-03-24T10:05
updated: 2025-05-09T10:56
---
>[!index]
>- [obiettivi](#obiettivi)
>- [specifica dei requisiti](#specifica%20dei%20requisiti)
>- [raffinamento dei requisiti](#raffinamento%20dei%20requisiti)
>- [diagramma UML](#diagramma%20UML)
>- [specifica dei tipi di dato](#specifica%20dei%20tipi%20di%20dato)
>- [specifica di classe](#specifica%20di%20classe)
>	- [Utente](#Utente)
>		- [operazioni di classe](#operazioni%20di%20classe)
>	- [VenditoreProfessionale](#VenditoreProfessionale)
>		- [operazioni di classe](#operazioni%20di%20classe)
>	- [Bid](#Bid)
>		- [operazioni di classe](#operazioni%20di%20classe)
>		- [vincoli esterni](#vincoli%20esterni)
>	- [AstaConclusa](#AstaConclusa)
>		- [operazioni di classe](#operazioni%20di%20classe)
>	- [Categoria](#Categoria)
>		- [operazioni di classe](#operazioni%20di%20classe)
>		- [vincoli esterni](#vincoli%20esterni)
>- [diagramma UML degli use-case](#diagramma%20UML%20degli%20use-case)
>- [specifica degli use-case](#specifica%20degli%20use-case)
## obiettivi
Si vuole progettare e realizzare eBuy, un sistema informatico per la gestione di aste
on-line e di attività di commercio elettronico.
Il sistema deve permettere, agli utenti registrati, di pubblicare annunci per la vendita
di oggetti e di gestire aste al rialzo per la loro aggiudicazione. Il sistema deve anche consentire di mettere in vendita oggetti senza l’effettuazione di alcun’asta (formula “compralo subito”).
## specifica dei requisiti
Il sistema deve permettere agli utenti registrati (di cui interessa il nome scelto e la data di registrazione) di pubblicare annunci per la vendita di singoli oggetti. Tali annunci sono chiamati post. Degli oggetti in vendita va specificata una descrizione, la categoria alla quale appartiene, il prezzo di vendita, i metodi di pagamento accettati (bonifico o carta di credito), e l’informazione sul fatto che l’oggetto sia nuovo oppure usato.
Gli annunci di vendita (post) sono di due tipologie distinte, potendo prevedere o
meno un’asta al rialzo per la loro aggiudicazione. Per i post che prevedono un’asta, il
venditore deve specificare il prezzo iniziale d’asta, l’ammontare dei singoli rialzi (ad es., 5 euro a rialzo) e l’istante di scadenza dell’asta. Al contrario, per i post che non prevedono un’asta (modalità di vendita “compralo subito”), al venditore è richiesto specificare esclusivamente il prezzo di vendita dell’oggetto. Il sistema deve consentire agli utenti (via Web) di pubblicare post per oggetti in vendita, con o senza asta.
Gli oggetti relativi a post che non prevedono asta vengono venduti al primo utente
che procede con l’acquisto. I post che prevedono un’asta, invece, diventano oggetto di offerte di acquisto da parte di più utenti. Tali offerte vengono comunemente chiamate bid. Di ogni bid interessa l’istante in cui è stato proposto e l’utente offerente (chiamato bidder ). Dato che i post oggetto d’asta specificano sia il prezzo iniziale che l’ammontare dei singoli rialzi, quando un bidder decide di proporre un bid per tale post, di fatto si propone di acquistare l’oggetto in questione per un prezzo che è pari all’ultimo prezzo proposto fino a quel momento, aumentato dell’ammontare del rialzo (valore deciso a priori dal venditore). Ad esempio, se il prezzo del bid più recente è x euro e l’ammontare del rialzo è di r euro, il nuovo bidder si propone di acquistarlo per x + r euro.
Il sistema deve consentire ad un utente (da Web) di proporre un nuovo bid per un oggetto in vendita tramite asta, oppure procedere all’acquisto di un oggetto messo in vendita con la modalità “compralo subito”.
Le aste vengono automaticamente chiuse alla data/ora specificata dal venditore. A
questo istante, l’ultimo utente che ha effettuato un bid si aggiudica l’oggetto in vendita, al prezzo del bid. Di ogni asta conclusa è di interesse conoscere il bid che si è aggiudicato l’oggetto in vendita (se esiste), con il prezzo relativo.
Per motivi legali, i venditori di oggetti nuovi devono prevedere una garanzia di almeno due anni (minimo di legge), mentre per quelli usati non c’è alcun obbligo di garanzia (che però può essere ugualmente prevista). L’informazione circa la durata della garanzia (se presente) deve essere dichiarata dal venditore e mantenuta dal sistema. Per gli oggetti usati, al venditore viene anche richiesto di dichiararne le condizioni, nella gamma di valori ottimo, buono, discreto, da sistemare. (**A1.**)
Per semplificare la ricerca dei post da parte degli utenti, il sistema deve permettere di organizzare le categorie degli oggetti in vendita in modo gerarchico (ad albero, ovvero in categorie principali, di secondo livello, ecc.). Per favorire la navigazione inoltre, da una categoria deve essere possibile ricavare l’insieme delle sue sottocategorie, se esistono. 
Il sistema deve supportare, oltre agli utenti privati, anche i venditori professionali. Per questi ultimi è di interesse anche la URL della loro vetrina on-line, dove devono essere pubblicate ulteriori informazioni legali. Tuttavia, per non stravolgere la natura del servizio offerto, si decide che solo gli utenti privati possono acquistare o proporre bid per oggetti in vendita (i venditori professionali possono quindi solo effettuare vendite). Inoltre, dei venditori professionali diventa di interesse conoscere la loro popolarità, che dipende dal numero di utenti che hanno effettuato negli ultimi 12 mesi bid per gli articoli da loro messi all’asta, o che hanno acquistato (sempre negli ultimi 12 mesi) articoli secondo la modalità “compralo subito”. In particolare, la popolarità di un venditore professionale è bassa se tale numero è inferiore a 50, media se tra 50 e 300, alta se superiore a 300. 
Per favorire l’esclusione dal sistema dei venditori scorretti, il sistema deve inoltre permettere, agli utenti che si aggiudicano un’asta e a quelli che acquistano oggetti secondo la modalità “compralo subito”, di esprimere un giudizio sulla qualità della transazione e sul loro grado generale di soddisfazione. Tali giudizi sono denominati feedback e consistono in un voto numerico da 0 (non soddisfatto) a 5 (molto soddisfatto), al quale può aggiungersi un commento testuale.
Per ogni utente, il sistema deve permettere di calcolarne l’affidabilità, che si calcola a partire dai feedback che ha ricevuto per gli oggetti che ha messo in vendita. In particolare, l’affidabilità di un venditore è data dalla media aritmetica m di tutti i feedback che ha ricevuto, diminuita di un fattore che è tanto più grande quanto maggiore è il numero di feedback negativi (ovvero ≤ 2). Tecnicamente, detta z la frazione dei feedback negativi rispetto ai feedback totali, l’affidabilità di un venditore è data da m(1 − z)/5.
L’affidabilità è quindi sempre un reale tra 0 e 1 (dato che è pari ad m/5 ∈ [0, 1] se non ci sono feedback negativi (z = 0), mentre scende verso 0 all’aumentare della percentuale z di questi ultimi). 
## raffinamento dei requisiti
1. utenti registrati
	1. nickname
	2. data registrazione
	3. post pubblicati (vedi req. 2)
	4. affidabilità (operazione)
2. post (annunci per la vendita di **singoli** oggetti)
	1. descrizione
	2. categoria a cui appartiene l’oggetto (vedi req. 4)
	3. metodi di pagamento accettati (bonifico o carta di credito)
	4. stato dell’oggetto
		1. nuovo
			1. durata della garanzia (obbligatorio)
		2. usato
			1. durata della garanzia (non obbligatorio)
			2. condizioni (ottimo, buono, discreto, da sistemare)
	5. tipologia di post
		1. con asta al rialzo
			1. prezzo iniziale dell’asta
			2. prezzo dei singoli rialzi (in euro)
			3. istante di scadenza dell’asta
			4. se è stata conclusa
				1. il bid che si è aggiudicato l’oggetto in vendita (se esiste)
		2. “compralo subito”
			1. prezzo di vendita dell’oggetto
3. bid (offerte a post con asta al rialzo)
	1. istante in cui è stata proposta
	2. utente offerente (bidder)
	3. meccanismo su aumento sistematico del prezzo
4. categorie
	1. livello della gerarchia ad albero
5. venditori professionali
	1. URL della vetrina online
	2. ulteriori informazioni legali
	3. popolarità (operazione)
			utenti professionali non posson fare bid
6. feeback
	1. voto numerico (0-5)
	2. commento testuale (non obbligatorio)
## diagramma UML
![[Pasted image 20250506102704.png]]
## specifica dei tipi di dato
- MetodiPagamento = {bonifico, carta di credito}
- Condizioni = {ottimo, buono, discreto, da sistemare}
## specifica di classe
### Utente
ogni istanza di questa classe descrive un utente registrato al sito
#### operazioni di classe
- affidabilità(): Reale in 0..1

### VenditoreProfessionale
ogni istanza di questa classe descrive un utente che è anche un venditore professionale
#### operazioni di classe
- popolarità(t : Istante) : Stringa
	precondizioni:
		t ≥ this.data_registrazione
	postcondizioni:
		l’operazione non modifica il livello estensionale
		post_venditore = {p : Post | esiste il link (this, p) : utente_post AND (t - p.istante_pubblicazione) ≤ 12 mesi AND
		se p : Asta, allora p : AstaConclusa
		altrimenti esiste il link (p, priv) : acquista }	
		result = bassa se |post_venditore| < 50
		result = media se  50 < |post_venditore| < 300
		result = alta se  |post_venditore| > 300
### Bid
ogni istanza di questa classe descrive un’offerta a rialzo per l’acquisto di un oggetto
#### operazioni di classe
- prezzo(): Reale ≥ 0
	precondizioni:
		nessuna
	postcondizioni:
		l’operazone non modifica il livello estensionale
		sia a l’unica asta tale che esiste il link (this, a) : bid_asta
		bids = { b : Bid | esiste il link (b, a) : bid_asta}
		sia mr_bid l’elemento apparentente a bids con b.data più recente
		result = mr_bid + a.prezzo_rialzo
#### vincoli esterni
\[V.bid.data_legale]
- per ogni b : Bid e l’unica asta per cui esiste il link (b, a) : bid_asta, b.data < a.data_scadenza AND b.asta < a.istante_pubblicazione
### AstaConclusa
ogni istanza di questa classe descrive un’asta conclusa
#### operazioni di classe
- bid_vincente() : Bid
	precondizioni:
		nessuna
	postcondizioni:
		bids = { b : Bid | esiste il link (b, this) : bid_asta }
		result = l’elemento di bids con la data più recente
	
- prezzo_vendita() : Reale ≥ 0
	precondizioni:
		nessuna
	postcondizioni:
		sia b : Bid l’elemento restituito dall’operazione this.bid_vincente()
		result = b.prezzo()
### Categoria
ogni istanza di questa classe descrive una categoria di oggetto
#### operazioni di classe
- sottocategorie() : Categoria\[0..\*]
	precondizioni:
		nessuna
	postcondizioni:
		result = { c : Categoria | esiste il link (c, this) : gerarchia in cui this ha il ruolo categoria_padre }
- livello() : Intero ≥ 0
	precondizioni:
		nessuna
	postcondizioni:
		se non esiste un link (this, c) : gerarchia in cui this ha il ruolo categoria_figlio, allora result = 0
		altrimenti result = c.livello() + 1
	
#### vincoli esterni
\[V.categoria.link_validi]
	per ogni c : Categoria, può esistere un link (c, c1) : gerarchia in cui c ha il ruolo di gerarchia_padre se e solo se c.livello() < c1.livello()
## diagramma UML degli use-case
## specifica degli use-case