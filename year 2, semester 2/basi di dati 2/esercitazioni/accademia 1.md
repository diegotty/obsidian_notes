---
related to: 
created: 2025-03-02T17:41
updated: 2025-03-28T19:16
completed: false
---
```
1. docenti
	1. nome
	2. cognome
	3. data di nascita
	4. matricola
	5. posizione universitaria (enum)
	6. progetti a cui partecipa (vedi req. 2)
2. progetti di ricerca
	1. nome
	2. acronimo
	3. data di inizio
	4. data di fine
	5. docenti che vi partecipano (vedi req. 1)
3. attività dei docenti
	1. data 
	2. durata in ore
	3. tipologia di impegno
	4. motivazione
4. work package (WP)
	1. nome
	2. data di inizio
	3. data di fine
	4. progetto a cui fa riferimento (vedi req. 2)
```

la specializzazione dei dati è statica: `intero > 0` è ok ma `intero > altro tipo` non è ok