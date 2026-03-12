---
created: 2025-03-24T10:05
updated: 2025-05-09T10:56
---
>[!index]
>- [obiettivi](#obiettivi)
>- [specifica dei requisiti](#specifica%20dei%20requisiti)

- [raffinamento dei requisiti](#raffinamento%20dei%20requisiti)
>- [diagramma UML](#diagramma%20UML)
>- [specifica dei tipi](#specifica%20dei%20tipi)
## obiettivi
Si vuole progettare un sistema informativo per la gestione di partite singole di tornei del gioco da tavolo Go.
Durante la fase di raccolta dei requisiti è stata prodotta la seguente specifica dei
requisiti.
Si chiede di iniziare la fase di Analisi Concettuale ed in particolare di:
1. raffinare la specifica dei requisiti eliminando inconsistenze, omissioni o ridondanze e produrre un elenco numerato di requisiti il meno ambiguo possibile
2. produrre un diagramma UML delle classi concettuale che modelli i dati di in-
teresse, utilizzando solo i costrutti di classe, associazione, attributo, vincolo di identificazione di classe, generalizzazione
3. produrre la relativa specifica dei tipi di dato in caso si siano definiti nuovi tipi di
dato concettuali.
## specifica dei requisiti
 I dati di interesse per il sistema sono i giocatori, i tornei e le partite.
Di un giocatore interessa conoscere il nick-name (univoco), il nome, il cognome, l’indirizzo e il rank dichiarato (un intero positivo).
Due giocatori si possono sfidare in una partita. Di una partita interessa sapere la data e il luogo in cui è giocata, le regole di conteggio usate (giapponesi o cinesi), quale giocatore gioca con le pietre bianche e quale con le pietre nere, il fattore di deficit chiamato komi (numero reale non negativo, tra 0 e 10) e l’esito. L’esito può essere rappresentato da una rinuncia di uno dei due giocatori, oppure da una coppia di punteggi di bianco e di nero (interi non negativi).
Le partite si possono anche riferire a un torneo.
Di un torneo interessa sapere il nome, una descrizione testuale, e l’edizione in termini dell’anno in cui si svolge.
## raffinamento dei requisiti
1. giocatori
	1. nick-name (univoco)
	2. nome
	3. cognome
	4. indirizzo
	5. rank (intero positivo)
2. tornei
	1. nome
	2. descrizione testuale
	3. anno di svolgimento
	4. partite che ne fanno parte
3. partite
	1. data
	2. luogo
	3. regole di conteggio (giapponesi o cinesi)
	4. komi (0 ≤ reale ≤ 10)
	5. giocatori partecipanti
		1. giocatore con le pietre bianche e giocatore con le pietre nere
	6. esito (rinuncia o coppia di punti)
## diagramma UML
![[Pasted image 20250329191855.png]]
## specifica dei tipi

- Punteggio : (punteggio_bianco : Intero ≥ 0 , punteggio_nero ≥ 0)