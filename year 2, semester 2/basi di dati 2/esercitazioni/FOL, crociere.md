---
related to: 
created: 2025-03-02T17:41
updated: 2025-04-25T09:47
completed: true
---
Modellare, mediante formule in logica del primo ordine, le seguenti affermazioni, dopo aver progettato opportuni insiemi di simboli di predicato e/o funzione:
1. Ogni crociera viene effettuata utilizzando una nave
2. Ogni crociera segue un itinerario
3. Gli itinerari hanno un nome univoco
4. Ogni crociera tocca un certo insieme non vuoto di destinazioni
5. Le crociere si dividono in crociere di luna di miele e crociere per famiglia.
Per ogni formula, determinare una interpretazione che sia un suo modello.

-  Ogni crociera viene effettuata utilizzando una nave (una e una sola nave)
$V=\{\}, F= \{\}, P=\{crociera/1, nave/1, usa/1\}$
FORALL c (
	crociera(c) →
	 EXISTS n ( nave(n) AND usa(c, n) ) AND NOT( 
		 EXISTS n2 ( NOT( n2 = n) AND usa(c,n) )  
	 )
)

oppure
$V=\{\}, F= \{usa/1\}, P=\{crociera/1, nave/1\}$
FORALL c (
	crociera(c) →
	EXISTS n ( nave(n) AND usa(c)=n )
)
in quanto non $usa$ è una funzione, e non esistono due valori di essa su $c$. fuoco !

-  Ogni crociera segue un itinerario (un solo itinerario)
$V=\{\}, F= \{segue/1\}, P=\{crociera/1, itinerario/1\}$
FORALL c (
	crociera(c) →
	EXISTS i ( itinerario(i) AND segue(c) = i)
)

-  Gli itinerari hanno un nome univoco
$V=\{\}, F= \{nome/1\}, P=\{crociera/1, itinerario/1\}$
credo che sia scontato che esista un n t.c. nome(i) = n, in quanto la funzione di pre-interpretazione è totale
FORALL i (
	itinerario(i) → 
	 FORALL i2 (
		 ( itinerario(i2) AND NOT(i2=i) ) → NOT (nome(i2) = nome(i))
		 )
)

soluzione prof:
FORALL i (
	FORALL i2 (
		 ( itinerario(i) AND itinerario (i2) AND NOT(i=i2) ) → 
		 NOT(nome(i) = nome(i2))
	)
)
-  Ogni crociera tocca un certo insieme non vuoto di destinazioni
$V=\{zero\}, F= \{nome/1, destinazioni/1\}, P=\{crociera/1, itinerario/1\}$
FORALL c (
	crociera(c) →
		NOT ( |destinazioni(c)| = zero )
)
legal ? 
 
 oppure (legal)
$V=\{\}, F= \{nome/1, destinazioni/1\}, P=\{crociera/1, destinazione/1, raggiunge/2\}$
 FORALL c (
	 crociera(c) →
	 EXISTS d ( destinazione(d) AND tocca(c, d))
 )
-  Le crociere si dividono in crociere di luna di miele e crociere per famiglia (partizione)

oppure (come la vorrei fare io):
$V=\{\}, F= \{nome/1, destinazioni/1\}, P=\{crociera/1, crociera\_famiglia/1, crociera\_lunamiele /2\}$
FORALL c (
	crociera(c) → (
		( crociera_famiglia(c) OR crociera_lunamiele(c) ) AND 
		NOT(crociera_familia(c) AND crociera_lunamiele(c) ) 
	)
)

