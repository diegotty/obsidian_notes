---
related to: 
created: 2025-03-02T17:41
updated: 2025-04-29T09:59
completed: false
---
Modellare, mediante formule in logica del primo ordine, le seguenti affermazioni, dopo aver progettato opportuni insiemi di simboli di predicato e/o funzione:
Per ogni formula, determinare una interpretazione che sia un suo modello. (dominio, )
1. Tutte le persone hanno almeno un numero di telefono
- $V=\{\}, F= \{\text{}\}, P=\{\text{persona/1, telefono/2, usa/2}\}$
>[!info] interpretazione
>- $D=\{\text{mario, 3283037544, luca}\}$
>- $\text{persona(mario) = true, persona(3283037544 = false), persona(luca = true)}$
>- $\text{telefono(3283037544) = true, telefono(mario) = false, telefono(luca) = false}$
>- $\text{usa(mario, 3283037542) = true, usa(mario, luca) = false, usa(luca, 3283037544) = false}$

FORALL p (
	persona(p) →
	EXISTS t ( telefono(t) AND usa(p,t) )
)

2. Ogni persona ha esattamente un nome
- $V=\{\}, F= \{\text{usa/1}\}, P=\{\text{persona/1, nome/1}\}$
>[!info] interpretazione
>- $D=\{\text{mario, 3283037544, luca}\}$
>- $\text{usa(mario) = mario, usa(luca) = luca, usa(3283037544) = 3283037544 (huh ??????) }$
>- $\text{persona(mario) = true, persona(3283037544 = false), persona(luca = true)}$
>- $\text{nome(3283037544) = false, nome(mario) = true, nome(luca) = true}$

FORALL p (
	persona(p) →
	EXITS n (nome(n) AND usa(p, n))
)

3. Non ci sono dipendenti che lavorano in più di due dipartimenti
- $V=\{\}, F= \{\text{}\}, P=\{\text{dipendente/1, lavora/2}, \}$
- $D=\{\}$
FORALL d (
	dipendente(d) →
	NOT ( 
		EXISTS dip1, dip2, dip2 (lavora(d, dip1) AND 
		lavora(d, dip2) AND lavora(d, dip3) ) )
)

4. Ogni dipartimento ha esattamente un direttore che è una persona. (quindi può avere direttori che non sono persone)
- $V=\{\}, F= \{\text{direttore/1}\}, P=\{\text{dipartimento/1, direttore(p, dip)}\}$
- $D=\{\}$
FORALL dip (
	dipartimento(dip) →
	EXISTS p (persona(p) AND direttore(p, dip) ) AND 
	FORALL p2 (NOT(p = p2) → NOT(direttore(p2, dip)) )
)

