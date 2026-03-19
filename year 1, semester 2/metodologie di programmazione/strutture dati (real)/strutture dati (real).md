caratteristiche che distinguono le strutture dati:
- è necessario mantenere un ordine ? 
- gli oggetti nella struttura possono ripetersi ?
- è necessario possedere una “chiave” per accedere a uno specifico oggetto ?
# Collection
- le collezioni in java sono rese disponibili mediante il Java Collection Framework
- sono strutture dati già pronte all’uso, con interfacce e algoritmi per manipolarle
- contengono e strutturano riferimenti ad altri oggetti (tipicamente tutti dello stesso tipo)

>[!tuff] Collection e Collections non sono la stessa cosa !!!
>Collections è una classe che consiste solo di metodi statici che operano o ritornano collections.


alcune interfacce del framework:

| Interfaccia | Descrizione                                             |
| ----------- | ------------------------------------------------------- |
| Collection  | L’interfaccia alla radice della gerarchia di collezioni |
| Set         | una collezione senza duplicati                          |
| List        | una collezione ordinata che può contenere duplicati     |
| Map         | associa coppie (chiave, valore) senza chiavi duplicate  |
| Queue       | Una collezione FIFO, che modella una coda               |
## la gerarchia
![[Pasted image 20240429205017.png|600]]
## interazione su collezioni
non è possibile utilizzare meteodi di modifica durante un’iterazione !! ma è possibile utilizzare `Iterator.remove`

### iterazione esterna:
- mediante gli Iterator (vecchio stile)
```java
Iterator<Integer> i = collezione.iterator();
while(i.hasNext()) {      // finché ha un successivo
	int k = i.next();     // ottieni prossimo elemento
	System.out.println(k);
}
```
- mediante il costrutto for each (per ogni elemento della collezione )
```java
for (Integer k : collezione)
	System.out.println(k);
```
- mediante gli **indici**(accesso elemento per elemento, + controllo)
```java
for (int j=0; j<collezione.size(); j++) {
	int k = collezione.get(j);
	System.out.println(k);
}
```
### iterazione interna:
- mediante il metodo `Iterable.forEach` che permette l’iterazione su qualsiasi collezione senza specificare come effettuare l’iterazione(utilizza il polimorfismo, chiamerà il forEach della classe specificata)
	- il metodo forEach prende in input un Consumer, che è un’interfaccia funzionale con un solo metodo
```java
public interface Consumer{
	void accept(T t);
}
//esempio iterazione interna
List<Integer> I = List.of(4,8,15,16,23,42);
I.forEach(x -> System.out.println(x));
//il metodo forEach prende un Consumer
```
il metodo forEach:
```java
public interface Iterable<T> {
	default void forEach(Consumer<? super T> action) { 
		Objects.requireNonNull(action); 
		for (T t : this) {
			action.accept(t); 
		} 
	}
```
# collezioni fondamentali:
## liste
sono basate su `List`, e sono una sottointerfaccia di Collection e di Iterable
le classi liste sono: 
- ArrayList: implementa la lista mediante un array(eventualmente ridimensionato, la cui capacità iniziale è 10)
- LinkedList: implementa la lista mediante elementi linkati
### listIterator()
restituisce un iteratore bidirezionale(un oggetto di una classe che implementa ListIterator, che estende Iterator)
possiamo usare i metodi:
- hasNext()
- hasPrevious()
## insiemi
sono basati su `Set`, una sottointerfaccia di Collection e di Iterable
sono Collection che contengono elementi **tutti distinti**
le classi insiemi sono:
- HashSet: memorizza gli elementi in una tabella di hash
	 ![[Pasted image 20240504145913.png|400]]
	 se due elementi sono uguali, allora hanno lo stesso hashcode
	 se due elementi hanno lo stesso hashcode, non è detto che siano uguali
- TreeSet: memorizza gli elementi in un albero mantenendo un ordine sugli elementi
- LinkedHashSet: memorizza gli elementi in un ordine di inserimento
## mappe
una mappa mette in corrispondenza chiavi e valori(come i dizionari in python)
non ci sono chiavi duplicate
le classi che implementano java.util.Map sono:
- HashMap: memorizza le coppie in una tabella Hash
- TreeMap: memorizza le coppie in un albero mantenendo un ordine sulle chiavi
- LinkedHashMap: estende HashMap e mantiene l’ordinamento di iterazione secondo gli inserimenti effettuati
### operazioni aggiuntive delle mappe
le mappe non supportano gli stream, ma forniscono numerose operazioni aggiuntive in Java 8
- map.putIfAbsent(): se manca la chiave(primo parametro), crea un nuovo record con valore(secondo parametro) 
- computeIfPresent(): se l’elemento(primo parametro) è presente, modifica il valore utilizzando la BiFunction(secondo parametro)
## algoritmi sulle collezioni:
metodi statici per la manipolazione delle collezioni:

| Metodo         | Descrizione                                                         |
| -------------- | ------------------------------------------------------------------- |
| `sort`         | Ordina gli elementi di una List                                     |
| `binarySearch` | Cerca un elemento di una List mediante ricerca binaria              |
| `fill`         | Rimpiazza tutti gli elementi di una List con l’elemento specificato |
| `copy`         | Copia gli elementi da una lista all’altra                           |
| `reversed`     | Inverte l’ordine degli elementi di una List                         |
| `shuffle`      | Mette in ordine casuale gli elementi di una List                    |
| `min/max`      | Restituisce l’elemento più piccolo/grande della Collection          |
