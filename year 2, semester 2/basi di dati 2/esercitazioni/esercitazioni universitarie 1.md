---
created: 2025-03-24T10:05
updated: 2025-05-09T10:56
---
>[!index]
>- [obiettivi](#obiettivi)
>- [specifica dei requisiti](#specifica%20dei%20requisiti)
>- [raffinamento dei requisiti](#raffinamento%20dei%20requisiti)
>- [diagramma UML](#diagramma%20UML)
>- [specifica dei tipi](#specifica%20dei%20tipi)
## obiettivi
Si vuole progettare un sistema informativo per tenere traccia delle esercitazioni svolte
durante le lezioni di insegnamenti universitari.
Durante la fase di raccolta dei requisiti è stata prodotta la seguente specifica dei
requisiti.
Si chiede di iniziare la fase di Analisi Concettuale ed in particolare di:
1. raffinare la specifica dei requisiti eliminando inconsistenze, omissioni o ridondanze e produrre un elenco numerato di requisiti il meno ambiguo possibile
2. produrre un diagramma UML delle classi concettuale che modelli i dati di interesse, utilizzando solo i costrutti di classe, associazione, attributo, vincolo di identificazione di classe, generalizzazione
3. produrre la relativa specifica dei tipi di dato in caso si siano definiti nuovi tipi di
dato concettuali.
## specifica dei requisiti
I dati di interesse per il sistema sono insegnamenti universitari e le esercitazioni ivi erogate.
Di ogni insegnamento interessa sapere il nome, il relativo numero di crediti formativi universitari, i docenti (possono essere più d’uno) e l’anno accademico di riferimento. Dei docenti interessa matricola, nome e cognome.
Un insegnamento può prevedere diverse esercitazioni, ognuna erogata in una certa data e composta da molti esercizi, scelti tra quelli disponibili nel sistema.
Di ogni esercizio, il sistema deve rappresentare il testo e la o le relative soluzioni disponibili (anche nessuna). Per ogni esercizio presentato in una esercitazione, il sistema deve mantenere l’informazione circa il fatto che questo sia stato solo presentato (per essere svolto in modo autonomo dagli studenti), oppure anche risolto in aula (e, in questo caso, quale delle soluzioni disponibili è stata mostrata).
## raffinamento dei requisiti
1. insegnamenti universitari
	1. nome
	2. CFU
	3. docenti (anche più di uno) (vedi req. 3)
	4. anno accademico di riferimento
	5. esercitazioni previste (ved req. 2)
		1. data in cui viengono erogate
		2. se l’esrcizio è stato presentato oppure svolto in aula
			1. se volto, quale soluzione (tra le disponibili) è stata mostrata
2. esercitazioni
	1. esercizi da cui è composta (vedi req. 3)
3. esercizi
	1. testo
	2. soluzioni disponibili (molteplici o nessuna)

4. docenti
	1. nome
	2. cognome
	3. matricola

## diagramma UML
![[Pasted image 20250401124344.png]]
## specifica dei tipi
Matricola: Stringa regex che rispetta lo standard dell’università