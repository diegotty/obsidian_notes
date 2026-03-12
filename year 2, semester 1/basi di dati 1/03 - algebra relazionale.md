---
created: 2024-09-28T09:11
updated: 2025-02-20T09:38
---
>[!info] index !
>- [proiezione](#proiezione)
>- [selezione](#selezione)
>- [unione](#unione)
>- [differenza](#differenza)
>- [intersezione](#intersezione)
>- [unire dati da piu tabelle](#unire%20dati%20da%20piu%20tabelle)
>- [prodotto cartesiano](#prodotto%20cartesiano)
>	- [accortezze nel usare il prodotto cartesiano](#accortezze%20nel%20usare%20il%20prodotto%20cartesiano)
>- [join naturale](#join%20naturale)
>	- [casi limite nel join naturale](#casi%20limite%20nel%20join%20naturale)
>- [$\theta$ join](#$%5Ctheta$%20join)

linguaggio usato per interrogare una base di dati relazionale, consiste di un insieme di operatori che possono essere applicati ad una o due istanze di relazione, e forniscono come risultato una nuova istanza di relazione
viene definito linguaggio procedurale, in quanto l’interrogazione consiste in un’espressione in cui compaiono operatori dell’algebra e istanze di relazioni, in una sequenza che prescrive in maniera puntuale l’ordine delle operazioni
## proiezione
taglio verticale su una relazione(selezionare solo alcuni attributi)
- si denota con il simbolo $\pi$
, selezionando gli attributi della relazione (in questo caso r)
$$\pi_{\text{A1,A2,...Ak}}(r)$$
>[!warning] si seguono le regole insiemistiche ! nella relazione risultato NON CI SONO DUPLICATI. per avere anche i doppioni bisogna includere una chiave nella proiezione
## selezione
selezione di alcune righe che soddisfano una condizione
- si denota con il simbolo $\sigma$
selezionando la condizione C con cui “filtare” le tuple della relazione
$$\sigma_{\text{C}}(r)$$
la condizione e’ un’espressione booleana composta, con:
- operatori AND, OR, e NOT
- termini semplici: $A\theta B$, $A\theta  'a'$, dove $\theta$ e’ un operatore di confronto (<,>,=,≤, ≥), A e B sono attributi _con lo stesso dominio_ e `a` e’ un elemento di dom(A)
## unione
consente di costruire una relazione contenente tutte le tuple che appartengono almeno ad uno dei 2 operandi.
- si denota con il simbolo $\cup$ 
>[!info] union-compatibilita’
>l’unione, come altre operazioni, puo’ essere applicata solo a operandi union-compatibili, cioe’:
>- che hanno lo stesso numero di attributi(possiamo usare la proiezione per eliminare gli attributi che ci impedirebbero di fare un unione)
>- i cui attributi corrispondenti, in ordine(l’ordine degli attributi influenza l’union-compatibilita’), sono definiti sullo stesso dominio
la union-compatibilita’, quindi, si guarda sugli schemi delle relazioni

non e’ necessario che gli attributi abbiano lo stesso nome, ma ovviamente il risultato ha senso solo se hanno un significato omogeneo !! (e’ quasi un requisito, insieme alla union-compatibilita)
- Eta e CFU possono essere definiti sullo stesso dominio, ma non averebbe senso unire le due relazioni che hanno questi attributi in colonne corrispondenti
il risultato dell’unione non ha duplicati (anche in sql!)
## differenza
consente di costruire una relazione contenente tutte le tuple che appartengono al primo operando e NON apparengono al secondo operando
- si applica a operandi union-compatibili
- si denota con il simbolo $-$  $$r_{1} - r_{2}$$
la differenza non e’ commutativa come l’unione! l’ordine degli operandi cambia il risultato della query.
## intersezione
consente di costruire una relazione contente tutte le tuple che appartengono ad entrambi gli operandi
- si denota con il simbolo $\cap$
- si applica a operandi union-compatibili
$$ r_{1}\cap r_{2}= (r_{1}-(r_{1}-r_{2}))$$
l’intersezione e’ un operazione commutativa

# unire dati da piu tabelle
per garantire determinate “buone” qualita’ di una relazione, occorre rappresentare in relazioni diverse concetti diversi.
capita quindi molto spesso che le informazioni necessarie in una query sono distribuite in piu’ relazioni, in quanto coinvolgono piu’ oggetti in qualche modo associati
bisogna quindi combinare le informazioni delle relazioni che ci interessano in maniera opportuna !
## prodotto cartesiano
consente di costruire una relazione contente tutte le tuple che si ottengono concatenando una tupla del primo operando con una tuple del secondo operando
- si denota con il simbolo $\text{x}$
$$ r_{1}\text{x}r_{2}$$
si usa quando le informazioni necessarie per rispondere a una query si trovano in relazioni diverse
### accortezze nel usare il prodotto cartesiano
- se ho 2 attributi con lo stesso nome in 2 tabelle diverse che vogliamo poter distinguere, possiamo usare l’operazione di ridenominazione ($\rho$)
- spesso, le tuple che ci servono sono solo un sottoinsieme del prodotto cartesiano. e’ quindi opportuno usare, dopo il prodotto cartesiano, la [[#selezione]] per selezionare tali tuple
## join naturale
consente di selezionare le tuple del prodotto cartesiano di due operandi($R_{1}, R_{2}$), a patto che le tuple rispettino la condizione: 
$$ R_{1}.A_{1}=R_{2}.A_{1} \land R_{1}.A_{2}=R_{2}A_{2}\land \dots \land R_{1}.A_{k}=R_{2}.A_{k}$$
	dove $A_{1},A_{1},\dots, A_{k}$ sono gli attributi da avere in comune(e con lo stesso nome, ma non nello stesso ordine !!!)
- fa cio’ eliminando le ripetizioni degli attributi (li rimuove dalla proiezione del risultato)
$$ r_{1}>|< r_{2} = \pi_{XY}(\sigma_{C}(r_{1} \text{x} r_{2}))$$
dove:
- C e’ la condizione da rispettare
- X e’ l’insieme degli attributi di $r_{1}$
- Y e’ l’insieme degli attributi di $r_{2}$ che non sono attributi di $r_{1}$
>[!info] gli attributi vengono rilevati da soli (o almeno cosi e’ sottinteso) quando scrivo $r_{1}>|<r_{2}$. prendere come $A_{1},A_{1},\dots, A_{k}$ gli attributi con lo stesso nome delle due relazioni
### casi limite nel join naturale
- se le relazioni contengono attributi con lo stesso nome, ma non esistono tuple con lo stesso valore per tali attributi, il join naturale e’ vuoto
- se non esistono attributi con lo stesso nome nelle 2 relazioni, verrebbe restituito il prodotto cartesiano tra esse. in questo caso e’ necessario usare la ridenominazione per ottenere attributi con lo stesso nome tra le 2 relazioni
## $\theta$ join
consente di selezionare le tuple del prodotto cartesiano dei due operandi che soddisfano una condizione del tipo: 
$$ A\theta B$$
dove:
- $\theta$ e’ un operatore di confronto $(\theta\in\{<,=,>,\leq,\geq\})$
- A e’ un attributo dello schema del primo operando
- B e’ un attributo dello schema del secondo operando
- dom(A)=dom(b)
$$r_{1}\underset{A\theta B}{\bowtie}r_{2}= \sigma_{A\theta B}(r_{1} \text{x}r_{2})$$