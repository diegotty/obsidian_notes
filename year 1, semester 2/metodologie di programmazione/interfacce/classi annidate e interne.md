le classi usate finora vengono dette top-level, cioè esse si trovano più in alto di tutte le altre e non sono contenute in altre classi(e richiedono un file .java con lo stesso nome della classe contenuta nel file)
# classi annidate
sono classi all’interno di altre classi
possono essere 
- static 
- non-static(in questo caso vengono dette **classi interne**)
## perchè sono utili ? 
- raggruppamento logico delle classi 
	- se una classe è utile solo ad un’altra classe, è logico inserirla al suo interno e tenere le due classi **logicamente vicine**
- incrementa incapsulamento
	- una classe B annidata in A può accedere ai membri di A (anche se privati), ma B può essere nascosta al mondo esterno
- codice + leggibile e + facile da mantenere
	- la vicinanza spaziale è un fattore decisivo

## classi interne
- prima di poter creare un’istanza di una classe interna, è necessario istanziare la top-level che la contiene
- **ciascuna classe interna ha un riferimento implicito all’oggetto della classe che la contiene !!!!**
- dalla classe interna è possibile accedere a tutte le variabili e tutti i metodi della classe esterna !
- le classi interne possono essere public, protected o private
### accesso a campi e metodi
per disambiguare i casi di ambiguità (come campi con lo stesso nome in top-level e nested)
- se dalla classe interna viene usato soltanto this, viene inteso che si riferisca ai campi della classe interna
- per riferisi ai campi della classe esterna, si usa la sintassi ClasseEsterna.this.metodo()/.campo
per istanziare la classe interna, è sufficiente usare l’operatore new
per istanziare la classe interna a partire da un’altra classe si usa la sintassi `riferimentoOggetoClasseEsterna.new ClasseInterna()` //un po clunky devo dire

## classi annidate statiche
- non richiede l’esistenza di un oggetto appartenente alla classe esterna, e non ha un riferimento implicito ad essa.
- non può accedere ai campi di istanza della classe esterna(slide dice: no può accedere allo stato dei singoli oggetti della classe esterna)
- da un punto di vista di comportamento, una classe annidata statica è equivalente ad una top-level inserita all’interno di un’altra top-level
- sono accessibili secondo la forma : `new ClasseEsterna.ClasseAnnidataStatica()`
