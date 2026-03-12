# comparable
per garantire un ordinamento sui tipi utilizzati nelle [[strutture dati (real)]] che si fondando su un ordinamento, è necessario che i tipi implementino un’interfaccia speciale, chiamata `Comparable<T>`

| Metodo               | Descrizione                                                                             |
| :------------------- | :-------------------------------------------------------------------------------------- |
| `int compareTo(T o)` | Confronta se stesso con l’oggetto o (restituendo 0 se uguali, -1 se ≤ o, +1 altrimenti) |
# comparator

in alternativa, per ordinare in modo diverso gli elementi di un certo oggetto, si può implementare l’interfaccia `Comparator<T>` e passarne un’istanza in input al costruttore delle strutture dati 

| Tipo      | Metodo                                                                                        |
| --------- | --------------------------------------------------------------------------------------------- |
| `int`     | **`compare(T o1, T o2)`**<br>Compares its two arguments for order                             |
| `boolean` | **`equals(Object obj)`**<br>Indicates whether some other object is “equal to” this comparator |
>[!tuff] COME FA COMPARATOR A ESSERE UNA @FunctionalInterface ?
>from documentation:
>If an interface declares an abstract method overriding one of the public methods of `java.lang.Object`, that also does not count toward the interface's abstract method count since any implementation of the interface will have an implementation from `java.lang.Object` or elsewhere.

alcuni metodi di default di comparator:

```java
// ... person è una classe con campi firstName e lastName, costruttore, etc ..
Comparator<Person> comparator = (p1, p2) -> p1.firstName.compareTo(p2.firstName);
Person p1 = new Person("flavio", "sperandeo");
Person p2 = new Person("francesco", "totti");
comparator.compare(p1, p2);

//confronto inverso, reversed()
comparator.reversed().compare(p1,p2);

//confronto per data chiave specificata, comparing()
//comparing() prende come parametro una funzione che estrae un Comparable (che userà come sort key) dal tipo T (in questo caso Person), e ritorna un Comparator<T> che compara by the sort key
comparator = Comparator.comparing(p -> p.getFirstName());

//confronto per criteri multipli a cascata (??):
comparator = Comparator.comparing(p -> p.getFirstname()).thenComparing(p -> p.getLastName)); //man what the fuck
//posso scrivere l'ultima riga di codice anche come:
comparator = Comparator.comparing(Person::getFirstName).thenComparing(Person::getLastName));
```