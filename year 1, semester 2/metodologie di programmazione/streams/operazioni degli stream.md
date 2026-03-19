# operazioni 
![[Pasted image 20240515110119.png]]
## op intermedie
restituiscono un altro stream su cui continuare a lavorare
- operazioni terminali: restituiscono il tipo atteso. 
una volta che uno stream è stato consumato (finendo con l’operazione terminale), non può essere riutilizzato !

### filter
```java
Stream<T> filter(Predicate<? super T> predicate)
//accetta un Predicate per filtrare gli elementi dello stream
Predicate<String> startsWithJ = s -> s.startsWith("J");
List<String> l = Arrays.asList("java", "guava", "jam", "gum");

l.stream().filter(startsWithJ).forEach(s -> System.out::print("starts with j: " + s));
```

### sorted
```java
//restituisce uno stream ordinato senza modificare la collezione da cui è stato creato lo stream
List<String> l = Arrays.asList("da", "ab", "ac", "bb");
l.stream().sorted().forEach(System.out::print);
```

### map
```java
//restituisce un nuovo stream in cui ciascun elemento dello stream originale è convertito in un altro oggetto attraverso la Function passata in input
<R> Stream<R> map(Function<? super T, ? extends R> mapFunction);
//non è PECS
l.stream().map(s -> s.toUpperCase()).forEach(System.out::println);

// il vincolo su R ha senso perchè mi sto dando la possibilità di creare uno stream di ritorno di un sottotipo del secondo tipo generico di R
Function<Integer, Double> func = x -> x * 2;
Stream<Float> s = l.stream().map(func);
```

### distinct
```java
//restituisce un nuovo stream senza ripetizione di elementi (gli elementi sono tutti distinti tra loro)
List<Integer> l = List.of(3,4,5,6,4,2,1,6,3);
List<Integer> distinti = l.stream().map(x -> x*x).distinct().collect(Collectors.toList());
```

### limit
```java
//limita lo stream a k elementi(k long passato in input)
List<String> elementi = List.of("uno, "due", "tre");
List<String> reduced = l.stream().limit(2).collect(toList()); //contiene ["uno", "due"]
```

### skip
```java
//salta k elementi (k long passato in input)
List<String> elementi = List.of("uno, "due", "tre");
List<String> reduced = l.stream().skip(2).collect(toList()); // contiene ["tre"]
```

### takeWhile, dropWhile
```java
//takeWhile prende elementi finchè si verifica la condizione del predicato
//dropWhile salta gli elementi finchè si verifica la condizione
List<Integer> l = List.of(3,46,54,63,45,21,1,62,3);
List<Integer> reduced = l.stream().takeWhile(x -> x < 42).collect(toList);
//contiene [3, 21, 1, 3]
```

### flatMap
```java
//permette di unire gli stream in un uno stream:
<R> Stream<R> flatMap(Function<? super T, ? extends Stream<? extends R>> mapper);
//se ho uno stream di collection(Stream<Collection<T>>, con flatMap rendo quelle collection degli stream, e avendo Stream<Stream<T>>, creo un solo grande stream piatto
//flatMap pArrende un supplier che usa per rendere il tipo stream
Map<String, Long> letterToCount = words.map(w -> w.split(""))//returns String[]
.flatMap(Arrays::stream) //uso il supplier su ogni elemento dello stream !!
.collect(groupingBy(identity(), counting()); 
```

### flatMapToInt
```java
//come flatMap, ma ritorna su IntStream
```

## op terminali

### min e max
```java
Optional<T> max/min(Comparator<? super T> comparator) 
//restituisce il massimo/minimo elemento all'interno dello stream
List<Integer> p = Arrays.asList(2,3,4,5,6,7,8);
Optional<Integer> max = p.stream().max(Integer::compare);

System.out.println(max.orElse(-1));
```

### forEach
```java
void forEach(Consumer<? super T> action);
//prende in input un Consumer e lo applca ad ogni elemento dello stream
List<Integer> l = Arrays.asList(4,6,5,3,2,343,53);
l.stream.filter(x-> x > 10).forEach(System.out::println);
```

### count
```java
long count();
//restituisce il numero(long) di elementi nello stream
long startsWithA = l.stream.filter(s-> s.startsWith("a").count());

long numberOfLines = Files.lines(Paths.get("yourfile.txt")).count();
```

### collect
```java
<R,A> R collect(Collector<? super T, A, R> collectorFunction);
// permette di raccogliere gli elementi dello stream in qualche oggetto (collection, una stringa, un intero)
List<Integer> ivaEsclusa = Arrays.asList(10, 20, 30);
List<Double> l = ivaEsclusa.stream().map(p->p*1.22).collect(Collectors.toList());
```

### reduce
```java
//effettua una riduzione sugli elementi dello stream utilizzando la funzione data in input
T reduce(T identity, BinaryOperator <T> accumulator);
list.stream.reduce(0, (a,b) -> a+b);
list.stream.reduce(0, Integer::sum);
// il primo parametro, l'elemento di identità, serve come "inizio"
//riduce ad un solo numero, la somma di tutti gli elementi dello stream !

```
### reduce (con Optional)
```java
//esiste anche una versione di reduce con solo un parametro, che restituisce un Optional<T>
T reduce(BinaryOperator <T> accumulator);
lista.stream().reduce(Integer::sum);
//viene usato Optional perchè se lo stream è vuoto, non avendo l'elemento di identità, non si sa quale valore restituire
```

### anyMatch, allMatch, noneMatch
```java
//gli stream espongono diverse operazioni personali di matching. restituiscono un booleano relativo all'esito del matching
List<String> l = List.of("ciao", "abracadabra", "kenny", "luka");
boolean anyStartsWithA = l.stream().anyMatch(s -> s.startsWith("a")); //true
```

### findFirst, findAny
```java
//findFirst: ottieni il primo elemento dello stream
//findAny: ottieni un qualsiasi elemento dello stream
