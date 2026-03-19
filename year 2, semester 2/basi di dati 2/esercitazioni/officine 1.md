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

## obiettivi
Si vuole sviluppare un sistema informativo per la gestione dei dati di una catena di
officine.
Durante la fase di raccolta dei requisiti è stata prodotta la seguente specifica dei
requisiti.
Si chiede di iniziare la fase di Analisi Concettuale ed in particolare di:
1. raffinare la specifica dei requisiti eliminando inconsistenze, omissioni o ridondanze e produrre un elenco numerato di requisiti il meno ambiguo possibile
2. produrre un diagramma UML delle classi concettuale che modelli i dati di interesse, utilizzando solo i costrutti di classe, associazione, attributo, vincoli di identificazione di classe, generalizzazione, operazioni di classe
3. produrre la relativa specifica dei tipi di dato in caso si siano definiti nuovi tipi di
dato concettuali e le specifiche informali di eventuali classi con operazioni.
## specifica dei requisiti
I dati di interesse per il sistema sono quelli relativi alle officine della catena, i relativi dipendenti e direttori, e quelli relativi alle riparazioni dei veicoli.
Di ogni officina della catena interessano il nome, l’indirizzo, il numero di dipendenti, i dipendenti con il relativo numero di anni di servizio ed il direttore.
Dei dipendenti e dei direttori interessano il nome, il codice fiscale, l’indirizzo e il numero di telefono; inoltre dei direttori interessa anche la data di nascita.
Per quanto riguarda le riparazioni dei veicoli, sono dati di interesse il codice, il veicolo (modello, tipo, targa, anno di immatricolazione e proprietario), la data ed ora di accettazione e quella di riconsegna (per le riparazioni terminate).
Infine, dei proprietari dei veicoli interessano nome, codice fiscale, indirizzo e telefono.
## raffinamento dei requisiti
1. officine
	1. nome
	2. indirizzo
	3. numero di dipendenti (operazione)
	4. i dipendenti che vi afferiscono, con(vedi req. 2)
		1. numero anni di servizio (operazione)
	5. direttore
2. dipendenti
	1. nome
	2.  cognome
	3. CF
	4. indirizzo
	5. numero di telefono
3. direttori
	1. nome
	2. cognome
	3. CF
	4. indirizzo
	5. numero di telefono
	6. data di nascita
4. riparazioni
	2. codice
	3. il veicolo (vedi req. 5)
	4. data e ora di accettazione e di riconsegna per le riparazioni terminate(periodo)
5. veicoli
	1. modello
	2. tipo
	3. targa
	4. anno di immatricolazione
	5. proprietario (vedi req. 6)
6. persona
	6. nome
	7. cognome
	8. CF
	9. indirizzo
	10. numero di telefono
## diagramma UML
![[Pasted image 20250407094855.png]]
## specifica dei tipi di dato
- Indirizzo : (via : Stringa, Civico : Intero > 0, CAP : Intero > 0)
- NumeroTelefono: Stringa che rispetta i relativi standard
## specifica di classe
**Specifica della classe Officina**
ogni istanza di questa classe rappresenta una officina
**numero_dipendenti() :  Intero ≥ 0**
pre-condizioni:
- nessuna
post-condizioni:
- l’operazione non modifica il livello estensionale
- il valore del risultato (“result”) è definito come segue:
	- sia $E$ l’insieme dei link di assoc. “afferisce” che coinvolgono “this”
	- sia $N$ la cardinalità di $E$
	- result = $N$

**Specifica della classe Dipendente**
ogni istanza di questa classe rappresenta un dipendente
**numero_anni_servizio() :  Intero ≥ 0**
pre-condizioni:
- nessuna
post-condizioni:
- l’operazione non modifica il livello estensionale
- il valore del risultato (“result”) è definito come segue:
	- sia `(this, officina): afferisce `l’unico link dell’assoc. “afferisce” che coinvolge “this”
	- sia `(this,officina).data_inizio.anno` la data dell’inizio dell’afferenza
	- result = `adesso - (this, officina).data_inizio`