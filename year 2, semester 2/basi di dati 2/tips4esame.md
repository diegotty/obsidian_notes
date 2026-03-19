---
related to: 
created: 2025-03-02T17:41
updated: 2025-06-19T19:04
completed: false
---
>[!info] ngl
>- durata > inizio e fine (evita vincoli su date !!!!!)

- vincoli esterni: è necessario specificare TUTTI i vincoli esterni necessari (in particolare, i vincoli banali: date, )
- le operazioni sono necessarie quando vanno a sostituire un attributo che va calcolato
	- se invece servono a calcolare qualcosa che non sarebbe un dato, sono use-case

## progettazione
### ristrutturazione
- eliminazione di attributi multivalore (classe per attributo (con $\{ id \}$ e associazione con molteplicità)
- scelta dei tipi di dato (scrivere tipi non base in SQL ?)
	- tipi concettuali base
	- tipi base specializzati: domain
	- tipi enumerativi: type as enum
	- tipi composti: create type (se campi `NOT NULL`, bisogna creare domini ausiliari (nei domini è consentito usare `NOT NULL`))
- generalizzazioni (attenzione ai vincoli esterni !!) (la decisione deriva in parte dalla natura delle query !)
	- classi:
		- *fusione* **di sottoclassi in superclassi** (se mi interessa fare query specifiche sulla superclasse, e non sulle sottoclassi)
		- *divisione* **delle superclassi in classi disgiunte** (deve esserci `{disjoint,complete}`, utile se dobbiamo fare query specifiche per entrambe le sottoclassi, e non ci interessano query sulla superclasse)
		- *sostituzione* **di relazioni is-a con associazioni** (se mi interessa rappresentare superclasse e sottoclassi (**strettamente**) in modo separato)
	- associazioni
		- *fusione* **di sotto-associazioni nelle loro super-associazioni**
- identificatori: se ci sono già $\{id\}$, controlliamo se uno di loro basta. altrimenti usiamo un **identificatore artificiale**
- vincoli esterni e use-case (in FOL)

>[!warning] operazioni non sono da ristrutturare
### traduzione diretta
- associazioni:
	- molteplicità:
	- 0..* - 0..* : chiave è composta dalle foreign key
	- 0..* - 0..1 : chiave è composta da foreign key del ruolo 0..1
	- 0..1 - 0..1 : chiave è composta da una delle due foreign key (è uguale)
	- 1..\* - 0..\*: **vincolo di inclusione**: ogni chiave di ruolo 1../* deve apparire in tabella associazione 
	- 1..\* - 1..\*: 2 **vincoli di inclusione**
	- 1..1 - 0..* : **vincolo di inclusione** che può esser implementato con vincolo di foreign key da parte del ruolo 1..1 (quindi doppia foreign key)
		 - in pratica, visto che ogni classe ha una e una sola associazione, nella tabella in mezzo ci mettiamo la chiave (?) e creiamo un vincolo di foregin key nella tabella che ha il ruolo 1..1
		 - inoltre, posso accorpare! metto la chiave della tabella che non ha ruolo 1..1 nella tabella che ha ruolo 1..1 ! fuoco
	 - $\{ id1 \}$ su 1..1 e attributo : **accorpamento** nel verso della tabella che viene riconosciuta con l’associazione. campo `chiave_tabella_opposta`, foreign key
	 - $\{ id \}$ unicamente su associazione (ristrutturazione per sostituzione): attributo `chiave_tabella_opposta` che è anche chiave primaria (e foreign key)
>[!warning] possiamo accorpare ogni volta che abbiamo molteplicità `0..1` o `1..1`

>[!warning] UNIQUE !!!

### vincoli
i vincoli esterni devono diventare:
- vincoli di ennupla (vincoli esterni che sono nella scope di un’unica tabella)
- trigger (vincoli esterni che necessitano il check su altre tabelle oltre alla propria)

>[!info] domande
>mettere vincoli dominio e usare domini è la stessa cosa giusto ….


aggregazione
se voglio aggregare una tabella che ha comp
>[!info] caso cool
![[Pasted image 20250604142708.png]]
in questo caso è conveniente mettere un id a PostiASedere e mettere unique alla tripla che identifica veramente la tabella (sala, fila, colonna)


per vincoli esterni. la classe a cui assegnali e quella che, se modificata, potrebbe portare a vincoli non rispetatati


- posso mettere distinct in count
- group by + funzione aggregata: prima vengono grouppate le tuple, poi viene usata la funzione aggregata
- posso fare group by per più di un valore (grouppera per ogni combinazione diversa dei due valori)
- having (senza usare alias della target list)
- limit
- like (\_, \%) per stringhe
- sum, avg, min, max
- omogeneità delle funzioni aggregate ! se estono nella target list, non ci possono essere attributi nella target list, except per group by attributes
- query correlate: utilizziamo un valore di ogni ennupla della query di fuori. la query correlata viene runnata una volta per ogni row della query esterna.
- le ficchiamo nella where clause
- OVERLAPS 4 intervals (in1, f1) overlaps (in2, fin2)
- EXTRACT (MONTH from CURRENT_DATE)
- BETWEEN for date in period
- COALESCE(att1, att2) restituisce il primo dei due che non è 
- tsrange: intervallo di timestamp senza hour zone