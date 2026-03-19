---
related to: 
created: 2025-03-02T17:41
updated: 2025-06-19T19:04
completed: false
---
>[!info] momento ricapitolazione
>- variabili: oggetti del dominio
>- simboli di predicato: restituiscono `true/false`
>- simboli di funzione: restituiscono un termine 
>- costanti: simboli di funzione di arità 0
>- termini: variabili/ funzioni costanti/ funzionicon termini come argomenti
>- formule: simboli di predicato che hanno come argomenti termini/ formule separate da operatori logici/ formule con quantificatori
>- **valutazione dei termini**: 
>	- **pre-interpretazione**: dominio di interpretazione + corrispondenza dai simboli di funzione a una funzione totale (definita esplicitamente per ogni elemento del dominio) del tipo $D^n \to D$ : la funzione$preI(f)$)
>	- **assegnamento delle variabili**: una funzione $V \to D$ che associa ogni variabile ad un elemento del dominio (**separato dalla pre-interpretazione**)
>	- **valutazione dei termini (complessi)**: funzione di valutazione (basata su un assegnamento e una funzione di pre-interpretazione), definita induttivamente (è di default, pusho dentro le cose)
>- **valutazione delle formule**:
>	- **interpretazione**: costituita da una pre-interpretazione + una funzione che associa ad ogni simbolo di predicato $p/n$ (di arità $n$) un relazione $I(p) \subseteq D \times\dots \times D(n \text{ volte})$
>	- **valutazione delle formule (complesse)**: costituita da una interpretazione + un assegnamento delle variabili + una funzione $eval^{\text{interpretazione, assegnamento}}: \phi \to \{true, false\}$ definita in modo simile alla logica proposizionale (le formule complesse sono quelle con operatori logici o quantificatori)

>[!info] diagramma UML come formula matematica
la formula che definisce la semantica del diagramma dovrà contenere, in `and`, le seguenti formule:
>- sottoformule per classi, associazioni e domini (disgiunzione, generalizzaione)
>- tipizzazione di associazioni tra due classi (coppie in assoc sono di tipo corretto)
>- tipizzazione di attributi (attributi di classe sono di tipo corretto, attributi di association class sono di tipo corretto)
>- cardinalità di associazioni e attributi (oggetti hanno valori di attributi secondo cardinalità, associazioni rispettano le cardinalità)
>- tipizzazione di operazioni (invocata sul tipo corretto, con argomenti di tipo corretto, e restituisce elemento di dominio corretto (sia operazioni in classi che in association class))
> - vincoli di identificazione di classe
