---
related to:
created: 2025-03-02T17:41
updated: 2025-12-26T07:19
completed: false
---
*--- DFA*
abbiamo iniziato studiando i *DFA* (*deterministic finite-state automata*), in quanto la loro quantità di memoria limitata e il processing di input bit-a-bit implica degli automi più semplici.
li abbiamo definiti tramite le loro componenti (tra cui funzione di transizione estesa e relazione estesa)
abbiamo studiato l’insieme di *linguaggi accettati/riconosciuti* da un dato DFA, e poi l’insieme di linguaggi riconosciuti da un qualunque $M \in DFA$: i *linguaggi regolari*. 
- sui linguaggi regolari abbiamo definito un insieme di operazioni: unione, interesezione, complemento, concatenazione e potenza.
- abbiamo dimostrato che i linguaggi regolari sono chiusi per tali operazioni
per riuscire a dimostrare la chiusura per la concatenazione, abbiamo introdotto gli *NFA* (non-deterministic finite-state automata).

dopo aver definito gli *NFA*, abbiamo dimostrato che $\text{L(DFA)  = L(NFA) = REG}$, quindi che possono rappresentare gli stessi linguaggi, e abbiamo imparato come passare da *NFA* a *DFA*.
- con gli *NFA* abbiamo poi completato i teoremi di chiusura per i linguaggi regolari.

abbiamo introdotto le *espressioni regolari* (regex), e abbiamo dimostrato che $\text{REG} = \text{L(RE)}$ ( cioe $\text{un linguaggio è regolare } \iff \exists \text{ un'espressione regolare che lo descrive}$)
per completare la dimostrazione, abbiamo usato i *GNFA* (NFA generalizzati, che sugli archi hanno espressioni regolari).
- in particolare, abbiamo usato la loro forma canonica, creato una funzione `convert()` ricorsiva che elimina i nodi intermedi, uno alla volta, fino a rimanere con 2 stati e 1 arco: l’espressione regolare del linguaggio
	- abbiamo anche dimostrato che `convert()` crea un automa equivalente a quello di partenza

abbiamo studiato il *pumping lemma*, che permette di dimostare se un linguaggio è regolare o meno.

dopo aver introdotto due modi diversi per descrivere linguaggi regolari (automi finiti e espressioni regolari). definiamo ora metodi più potenti per definire linguaggi anche non regolari.
la classe di linguaggi che include quelli regolari e ulteriori linguaggi, non regolari, si chiama *CFL*

abbiamo introdotto le *CFG* (grammatiche context-free), un modello di computazione più potente, che permette di rappresentare linguaggi non regolari: i *CFL* (linguaggi context-free)
- notiamo che le grammatiche sono l’insieme di regole che definiscono il linguaggio (struttura matematica) , mentre il linguaggio è l’insieme di stringhe prodotte dalla grammatica
	- CFG diverse possono generare lo stesso CFL !
di conseguenza le grammatiche coincidono con un diverso tipo di automi: i *PDA* (pushdown automata)
- abbiamo studiato dei modi per progettare CFG: unione, da un DFA, e usando la ricorsione
- abbiamo studiato la *forma normale di Chomsky* per i CFG (come la forma canonica per i GNFA)
(di conseguenza, i CFL sono tutti i linguaggi accettati dai PDA)
- ricordiamo che $REG \in CFL$, e $DFA \in NFA \in PDA$
abbiamo studiato i *PDA* (pushdown automata), un’estensione dei DFA che consentono di riconoscere linguaggi non regolari usando una pila, che viene aggiornata ad ogni transizione tra stati. 
abbiamo dimostrato l’equivalenza tra PDA e CFG 


