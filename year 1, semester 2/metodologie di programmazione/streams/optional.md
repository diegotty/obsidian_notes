## java.util.Optional
è un contenitore di un riferimento, che potrebbe essere o non essere **null**
un metodo può restituire un Optional invece di restituire un riferimento potenzialmente null ! infatti serve ad evitare i NullPointerException

### creazione di un Optional
```java
//creazione di un Optional vuoto
Optional.empty()
//creazione di un Optional non nullo
Optional.of("ayooooo");
//creazione di un riferimento che può essere nullo
Optional<String> optional = Optional.ofNullable(s); //in questo caso ha senso usare Optional perchè, se vado ad usare s ed è veramente null, raise-erei una exception, mentre usando Optional me lo posso gestire senza eccezioni
//controllo della presenza di un valore non null:
Optional.empty().isPresent() // == false;
OPtional.of("bum bum ghigno"); // == true
```
### ottenere il valore di un Optional
```java
Optional<String> op = Optional.of("eccomi");
String res = op.orElse("fallback"); //res = "eccomi";
String rez = Optional.empty().orElse("fallback"); //rez = fallback

//altrimenti:
op.ifPresent(System.out::println); // "eccomi"
//ifPresent prende in input un consumer !! System.out::println fitta la def di consumer effettivamente
optional.get(); //valore o sollevea eccezione se null
```
### difference between orElse() and orElseGet()
```java
public T orElse(T other); 
public T orElseGet(Supplier<? extends T> other);
```
se viene passato un metodo come parametro ad entrambi, il orElse invocherà il metodo anche se l’Optional non è null(anche se ritornerà comunque il valore dell’Optional), 
mentre invece orElseGet() invocherà il metodo Supplier passato come parametro solo se l’Optional è null.