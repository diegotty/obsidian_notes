- disponibili da Java 8 grazie all’annotazione `@FunctionalInterface`
- l’annotazione garantisce che l’interfaccia sia dotata esattamente di un solo metodo astratto
```java
@FunctionalInterface
public interface Runnable{
	void run();
}
```
nel caso in cui ci fosse un’interfaccia composta da 2 metodi, di cui uno solo astratto, essa viene comunque considerata una `@FunctionalInterface` ! quando utilizzerò una [[classi anonime e lambda function#lambda function|lambda function]]
questa si riferirà in automatico al metodo astratto !

# SAM (single abstract method)
le interfacce funzionali sono di tipo SAM
>[!tuff] a ogni metodo(tipo forEach che prende un Consumer) che accetta un’interfaccia SAM, si può passare un’espressione lambda compatibile con l’unico metodo dell’interfaccia SAM (analogamente per un riferimento a un’interfaccia SAM)

le interfacce funzionali possono essere “espresse” in Lambda !(in qualche modo, per qualche motivo, guarda [[strutture dati (real)#iterazione interna|esempio iterazione interna]], posso passare come argomento una lambda function a un metodo che prende come argomento un’oggeto di una classe che implementa l’interfaccia funzionale.  the bts does all that !! crazy.)
esempio:
![[Pasted image 20240504173222.png]]
```java
List<String> names = Arrays.asList("peter", "anna", "mike", "xenia");
Collections.sort(names, (a,b) -> b.compareTo(a));
//ho passato una lambda function a un metodo che prende in input una classe che implementa Comparator
```


# interfacce funzionali built-in
## Predicate\<T>
| Modifier and Type         | Method                                                                                                                                             |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `default Predicate<T>`    | **`and(Predicate<? super T> other)`**<br>Returns a composed predicate that represents a short-circuiting logical AND of this predicate and another |
| `static <T> Predicate<T>` | **`isEqual(Object targerRef)`**<br>Returns a predicate that tests if two arguments are equal according to `Object.equals(Object, Object)`          |
| `default Predicate<T>`    | **`negate()`**<br>Returns a predicate that represents the logical negation of this predicate                                                       |
| `default Predicate<T>`    | **`or(Predicate<? super T> other)`**<br>Returns a composed predicate that represents a short-circuiting logical OR of this predicate and another   |
| `boolean`                 | **`test(T t)`**<br>Evaluates this predicate on the given argument                                                                                  |
funzione a valori booleani a un solo argomento generico T
```java
Predicate<String> predicate = s -> s.length() > 0;
predicate.test("foo"); //true
```
si possono creare predicati composti con i metodi di predicate(or(), and(), negate() )

## Function\<T, R>
| Modifier and Type           | Method                                                                                                                                                                                   |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `default <V> Function<T,V>` | **`andThen(Function<? supper R,? extends V> after)`**<br>Returns a composed function that first applies this function to its input, and then applies the `after` function to the result. |
| `R`                         | **`apply(T t)`**<br>Applies this function to the given argument                                                                                                                          |
| `default <V> Function<V,R>` | **`compose(Function<? super V,? extends T> before`**<br>Returns a composed function that first applies the `before` function to its input, and then applies this function to the result. |
| `static <T> Function<T,T>`  | **`identify()`**<br>Returns a function that always returns its input arguments                                                                                                           |
funzione a un argomento di tipo T e un tipo di ritorno R, entrambi [[tipi generici|generici]]
```java
Function<String, Integer> toInteger = Integer::valueOf;
Integer k = toInteger.apply("123");
```
## supplier\<T>

| Modifier and Type | Method                    |
| ----------------- | ------------------------- |
| `T`               | `get()`<br>gets a result. |

funzione senza argomenti in input
```java
Supplier<String> stringSuppliler = () -> "ciao";
Supplier<Person> personSupplier = Person::new;
personSupplier.get(); // new Person(). possiamo ottenere un riferimento al costruttore mediante la parola chiave new !!
```

## consumer\<T>
| Modifier and Type     | Method                                                                                                                                          |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `void`                | `accept(T t)`<br>performs this operation on the given argument.                                                                                 |
| `default Consumer<T>` | `andThen(Consumer<? super T> after)`<br>returns a composed Consumer that performs, in sequence, this operation followed by the after operation. |
funzione con un argomento di tipo generico T e nessun tipo di ritorno
```java
Consumer<Person>
```