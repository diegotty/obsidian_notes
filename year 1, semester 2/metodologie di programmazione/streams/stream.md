 uno stream rappresenta una sequenza di elementi su cui possono essere effettuate una o più operazioni.
supporta operazioni sequenziali e parallele !!

>[!tuff] Stream è un’interfaccia !!
>per natura, gli stream sono parallelizzabili

## creazione di uno Stream
lo stream viene creato a partire da una sorgente di dati, ad esempio una java.util.Collection, ma al contrario delle Collection, uno stream non memorizza ne modifica i dati della sorgente, ma opera su essi
```java
//direttamente dai dati
Stream.of(6,5,3,67,3,123,4);

//da una collection, usando i metodi stream() o parallelStream()
ArrayList<Integer> l1 = new ArrayList<>(42,67,59,23532,3);
l1.stream(); //restituisce un nuovo stream sequenziale
l1.parallelStream(); // restituisce un nuovo stream parallelo se possibile (altrimenti restituisce uno stream sequenziale)

//da un array
int[] arr = new int[] {10,5,6,32,46421};
Arrays.stream(arr);

//da un file
BufferedReader.lines()
Files.lines(path);
```

## ottenere uno Stream infinito
l’interfaccia Stream espone un metodo `iterate` che, partendo dal primo argomento, restituisce uno stream infinito con valori successivi applicando la funzione passata come secondo argomento
```java
Stream<Integer> numbers = Stream.iterate(0, n -> n +10);
//inoltre è possibile limitare uno stream infinito con il metodo limit
numbers.limit(5).forEach(System.out::println);
//esiste anche un secondo metodo iterate che prende come secondo argomento un predicato (la funzione diventa il terzo argomento). lo stream smette di dare valori (esce) quando il predicato del terzo argomento è false
Stream<Integer> numbers = Stream.iterate(0, n -> n < 50, n+10);
```
## fare copie di stream
si può creare un builder di stream mediante una lambda 
```java
Supplier<Stream<String>> streamSupplier = () -> Stream of.("d2", "a2", "b1", "b3", "c")
.filter(s -> s.startsWith("a"));
streamSupplier.get().anyMatch(s -> true);
streamSupplier.get().noneMatch(s -> true);

//ovviamente ha più senso se invece di un supplier, abbiamo una funzione che prende in input una Collection e restituisce uno stream su tale Collection
```

## perchè creare stream paralleli
- le operazioni su stream sequenziali sono effettuate in un singolo thread
- le operazioni su stream paralleli, invece, sono effettuate concorrentemente su thread multipli
```java
long count = values.Stream().sorted(). count();
//899 ms

long count = values.parallelStream().sorted(). count();
//472 ms
```
quando le operazioni sono però bloccanti, uno stream parallelo può essere molto più lento di uno stream sequenziale 
### quando usare uno stream parallelo
- quando è un problema parallelizzabile 
	- quando c’è un minimo di una sequenza di operazioni non bloccanti adiacenti, posso parallelizzarle
- quando posso permettermi di usare più risorse
- la dimensione del problema è tale da giustificare il sovraccarico dovuto alla parallelizzazione


### stream di primitivi
poichè Stream opera su oggetti, esisono versioni ottimizzate per lavorare con 3 tipi primitivi:
- IntStream
- DoubleStream
- LongStream
tutte queste interfacce estendono l’interfaccia di base BaseStream

dispongono di 2 metodi statici(per creare stream su range):
- range(inizio, fine) intervallo esclusivo (aperto a destra)
- rangeClosed(inizio, fine) intervallo inclusivo (chiuso a destra)
```java
IntStream.range(0, 10).filter(n -> n % 2 == 1).forEach(System.out::println);
```

IntStream, DoubleStream e LongStream si ottengono da uno stream, con i metodi mapToInt, mapToLong, e mapToDouble
```java
List<String> s = Arrays.asList("a", "b", "c");
s.stream   //Stream<String>
.mapToInt(String::length)    //IntStream
.asLongStream()    //LongStream
.mapToDouble(x -> x / 42.0)    //DoubleStream
.boxed()   //Stream<Double>
.mapToLong( x -> 1L)    //LongStream
.mapToObj(x -> "");    //Stream<String>
//boxed è un metodo degli stream di primitivi, e permette di ritornare a uno Stream di tipo Integer/Double/Long

//mapToObj è sempre un metodo degli stream di primitivi, prende come parametro una IntFunction (una Function che ha come primo tipo un Integer) e ritorna uno stream con il risultato della function applicata agli elementi
```


# comportamento
gli stream adottano una **lazy behavior**: le operazioni intermedie non vengono eseguite immediatamente, ma solo quando si richiede l’esecuzione di un’operazione terminale !
## op stateful e stateless
stateless: l’ elaborazione dei vari elementi può procedere in modo indipendente
stateful: l’elaborazione di un elemento potrebbe dipendere da quella di altri elementi !

cioò detta l’ordine in cui devono essere eseguite le istruzioni in quanto la JVM decide l’ordine delle operazioni intermedie (o almeno ci prova)
- se lo stream ha solo operazioni stateless, la JVM può eseguire le operazioni in qualsiasi ordine (e quindi può ottimizare di più)
- se invece ci sono operazioni stateful, esse non ci permettono di creare delle pipeline. non permettono di parallelizzare operazioni indipendenti tra di loro

## stile dichiarativo
- lo stream permette di utilizzare uno stile dichiarativo (dichiariamo le operazioni da effetturare, la ma JVM decide l’ordine)
- mentre la collection impone l''utilizzo di uno stile imperativo (dichiarlo le operazioni da effettuare e l’ordine in cui effettuarle, passo per passo)
lo stream si focalizza sulle operazioni di alto livello da eseguire, eventualmente anche in parallelo, **senza specificare come verranno eseguite**
uno stream è quindi: dichiarativo, componibile, e parallelizzabile

## ordine delle operazioni
- ci conviene sempre filtrare il prima possibile !
- ci vuole comunque intuizione a scrivere il codice per ottimizzare l’esecuzione delle operazioni !