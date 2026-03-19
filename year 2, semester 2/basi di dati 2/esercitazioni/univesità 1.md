---
related to: 
created: 2025-03-02T17:41
updated: 2025-03-15T16:55
completed: false
---
**usando solo i costrutti di classe, associazione, attributo**
```
1 studenti
	1.1 nome x
	1.2 codice fiscale x
	1.3 numero di matricola x
	1.4 data di nascita x
	1.5 luogo di nascita x
		1.5.1 regione x
		1.5.1 città x
	1.6 corso di laurea a cui è iscritto (vedi req. 4) x
	1.7 anno di iscrizione x
	1.8 insegnamenti di cui ha superato l'esame (vedi req. 3) x
2 professori
	2.1 nome x
	2.2 data di nascita x
	2.3 codice fiscale x
	2.4 luogo di nascita x
	2.5 insegnamenti erogati (vedi req.3) x
3 insegnamenti
	3.1 codice x
	3.2 nome x
	3.3 ore di lezione x
	3.4 corsi di laurea a cui appartiene x
4 corsi di laurea
	4.1 nome x
	4.2 facoltà di appartenenza (vedi req. 5) x
5 facoltà
	5.1 nome x
	
```

domande:
- id o non {id}
- abbiamo deciso di mettere molteplicità di studente verso corso a 1..1
- abbiamo deciso di mettere le molteplicità dell’assegnamento di 