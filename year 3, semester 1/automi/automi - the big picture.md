---
related to:
created: 2025-11-03, 15:29
updated: 2026-01-12T06:06
completed: false
---
*- automi*
abbiamo iniziato studiando i *DFA* (*deterministic finite-state automata*), in quanto la loro quantità di memoria limitata e il processing di input bit-a-bit implica degli automi più semplici.
li abbiamo definiti tramite le loro componenti (tra cui funzione di transizione estesa e relazione estesa)
abbiamo studiato l’insieme di *linguaggi accettati/riconosciuti* da un dato DFA, e poi l’insieme di linguaggi riconosciuti da un qualunque $M \in DFA$: i *linguaggi regolari*. 
- sui linguaggi regolari abbiamo definito un insieme di operazioni: unione, interesezione, complemento, concatenazione e potenza, e abbiamo dimostrato la chiusura di $REG$ per tali operazioni
per riuscire a dimostrare la chiusura per la concatenazione, abbiamo introdotto gli *NFA* (non-deterministic finite-state automata), necessari per mettere DFA *in serie* senza sprecare dell’input, bensì usando gli $\varepsilon$-archi

dopo aver definito gli *NFA*, abbiamo dimostrato che $\text{L(DFA)  = L(NFA) = REG}$, quindi che possono rappresentare gli stessi linguaggi, e abbiamo imparato come passare da *NFA* a *DFA*.
- con gli *NFA* abbiamo poi completato i teoremi di chiusura per i linguaggi regolari.

abbiamo introdotto le *espressioni regolari* (regex), e abbiamo dimostrato che $\text{REG} = \text{L(RE)}$ ( cioe $\text{un linguaggio è regolare } \iff \exists \text{ un'espressione regolare che lo descrive}$)
per completare la dimostrazione, abbiamo usato i *GNFA*: NFA generalizzati, che sugli archi hanno espressioni regolari.
- in particolare, abbiamo usato - wlog, in quanto è sempre possibile arrivarci - la loro *forma canonica* (una forma particolare di *GNFA*)
- , creato una funzione `convert()` ricorsiva che elimina i nodi intermedi, uno alla volta, fino a rimanere con 2 stati e 1 arco: l’espressione regolare del linguaggio
	- abbiamo anche dimostrato che `convert()` crea un automa equivalente a quello di partenza

abbiamo studiato il *pumping lemma*, che permette di dimostare se un linguaggio è regolare o meno (nella maggior parte dei casi viene usato per dimostrare che un linguaggio NON è regolare)

dopo aver introdotto due modi diversi per definire linguaggi regolari (automi finiti e espressioni regolari). definiamo ora metodi più potenti per definire anche *linguaggi non regolari*.
la classe di linguaggi che include quelli regolari e ulteriori linguaggi, non regolari, si chiama *CFL* (*context-free languages*)

abbiamo introdotto le *CFG* (*context-free grammars*), un modello di computazione più potente di DFA e NFA, che permette di generare linguaggi non regolari: i *CFL*.
- *importante*: notiamo che le grammatiche sono l’insieme di regole che definiscono il linguaggio (struttura matematica) , mentre il linguaggio è l’insieme di stringhe prodotte dalla grammatica
	- CFG diverse possono generare lo stesso CFL !

di conseguenza le grammatiche coincidono con un diverso tipo di automi: i *PDA* (pushdown automata)
- abbiamo studiato dei modi per progettare CFG: unione, da un DFA, e usando la ricorsione
- abbiamo studiato la *forma normale di Chomsky* per i CFG (come la forma canonica per i GNFA)
(di conseguenza, i CFL sono tutti i linguaggi accettati dai PDA)
- ricordiamo che $REG \in CFL$, e $DFA \in NFA \in PDA$
abbiamo studiato i *PDA* (pushdown automata), un’estensione dei DFA che consentono di riconoscere linguaggi non regolari usando una pila, che viene aggiornata ad ogni transizione tra stati. 
abbiamo dimostrato che $L$ è riconosciuto da un PDA $\iff L\text{ è }CFL$, e abbiamo studiato il *pumping lemma* per i $CFG$.

*- calcolabilità*
abbiamo introdotto le *turing machine* (*TM*), un modello astratto dei computer attuali, con una potenza di calcolo più alta degli automi studiati fino ad ora.
abbiamo introdotto i concetti di *riconoscibilità* e *decidibilità*.
per convincerci della potenza di calcolo della TM, abbiamo definito alcune varianti (*TM multinastro*, *NTM*) e dimostrato la robustezza della TM a singolo nastro. 
dopo alcuni esempi di linguaggi decidibili ($A_{DFA}$,$A_{NFA}$, $A_{REX}$, $E_{DFA}$, $EQ_{DFA}$ ), abbiamo dimostrato l’esistenza di linguaggi *indecidibili* con $A_{TM}$, attraverso l’introduzione delle *TM universali* e usando la diagonalizzazione
abbiamo studiato la *riducibilità*, grazie a cui abbiamo dimostrato l’indecidibilità di altri linguaggi ($HALT_{TM}$, $E_{TM}$, $REGULAR_{TM}$)
attraverso la *co-turing-riconoscibilità*, abbiamo dimostrato che $EQ_{TM}$ *non è riconoscibile*
abbiamo studiato i due *teoremi d’incompletezza di gödel*, che ci hanno illustrato i limiti intrinsechi della matematica
- primo teorema: esisteranno sempre verità matematiche che la logica formale non può raggiungere: la verità è un concetto più ampio della dimostrabilità
	- in calcolabilità, ciò è stato tradotto nell’*indecidibilità* dei programmi, primo tra tutti l’*halting problem* (dichiarato indecidibile da *turing* dopo il primo teorema d’incompletezza, in “on computable numbers“)
- secondo teorema: non possiamo usare la matematica per garantire con certezza assoluta che la matematica stessa non contenga contraddizioni, in quanto se ciò fosse possibile, essa stessa sarebbe una contraddizione
	- in calcolabiltà: 

*- complessità*