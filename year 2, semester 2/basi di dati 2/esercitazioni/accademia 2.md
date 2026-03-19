---
created: 2025-03-24T09:19
updated: 2025-03-24T10:03
---
>[!index]
>- [obiettivi](#obiettivi)
>- [specifica dei requisiti](#specifica%20dei%20requisiti)
>- [raffinamento dei requisiti](#raffinamento%20dei%20requisiti)
>- [diagramma UML](#diagramma%20UML)
>- [specifica dei tipi di dato](#specifica%20dei%20tipi%20di%20dato)
## obiettivi
Si vuole progettare un sistema informativo per la gestione delle tabelle orarie relative al
ruolo di docente universitario.
Durante la fase di raccolta dei requisiti è stata prodotta la seguente specifica dei
requisiti.
Si chiede di iniziare la fase di Analisi Concettuale ed in particolare di:
1. raffinare la specifica dei requisiti eliminando inconsistenze, omissioni o ridondanze
e produrre un elenco numerato di requisiti il meno ambiguo possibile
2. produrre un diagramma UML delle classi concettuale che modelli i dati di in-
teresse, utilizzando solo i costrutti di classe, associazione, attributo, vincoli di
identificazione di classe, generalizzazione
3. produrre la relativa specifica dei tipi di dato in caso si siano definiti nuovi tipi di
dato concettuali.
## specifica dei requisiti
I dati di interesse per il sistema sono i docenti universitari, i progetti di ricerca e le
attività dei docenti.
Di ogni docente interessa conoscere il nome, il cognome, il luogo e la data di nasci- ta, la matricola e la posizione universitaria (una tra: ricercatore, professore associato, professore ordinario).
Dei progetti interessa il nome, un acronimo, la data di inizio, la data di fine e i
docenti che vi partecipano.
Un progetto è composto da molti Work Package (WP). Oltre al progetto a cui fa
riferimento, del WP interessa sapere il nome, la data di inizio e la data di fine.
Il sistema deve permettere ai docenti di registrare impegni di diverso tipo tra: as-
senza (per chiusura universitaria, malattia, gravidanza, etc.), attività legate a impegni istituzionali (didattica, ricerca, missione, consiglio di dipartimento, consiglio di area didattica, etc.), attività legate a impegni progettuali (Ricerca e Sviluppo, Dimostrazione, Management, etc.).
Degli impegni interessa sapere il giorno in cui avvengono, la durata e la tipologia
di impegno con relativa motivazione. Si noti che alcuni impegni (ad es., impegno per
didattica oppure alcuni tipi di assenza) possono occupare solo parte di una giornata
lavorativa, pertanto la loro durata va misurata in giorni; altri impegni ed altre tipologie di assenza (ad es., assenza per malattia) occupano intere giornate, e la loro durata, dunque, va misurata in giorni.
## raffinamento dei requisiti
1. requisiti sui docenti
	1. nome
	2. cognome
	3. luogo
	4. data di nascita
	5. matricola
	6. posizione universitaria (classe)
2. requisiti sui progetti
	1. nome
	2. acronimo
	3. data di inizio e data di fine
	4. docenti che vi partecipano (vedi req. 1)
	5. work package di cui è composto (vedi req. 6)
3. requisiti sugli impegni 
	1. tipo di impegno 
		1. descrizione del tipo d’impegno
	2. giorno in cui avvengono
	3. durata (unità di misura varia a seconda del tipo di impegno)
4. work package 
	1. nome
	2. data di inizio e di fine
## diagramma UML
![[Pasted image 20250324100239.png]]
## specifica dei tipi di dato
- PosizioneUniversitaria: {ricercatore, professore_associato, professore_ordinario}
- Periodo: (inizio: Data, fine: Data)