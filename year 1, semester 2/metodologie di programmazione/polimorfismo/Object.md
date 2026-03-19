Object è la superclasse universale da tutte le classi in Java ereditano direttamente o indirettamente
- in questo modo, tutti i suoi 11 metodi sono ereditati
```java
public class LaMiaClasse{}
//è uguale a :
public class LaMiaClasse extends Object {}
```
## metodi principali

| Metodo                               | Descrizione                                                                                                           |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------- |
| `Object clone()`                     | Restituisce una copia dell’oggetto                                                                                    |
| `boolean eqauls(Object o)`           | Confronta l’oggetto con quello in input                                                                               |
| `Class<? extends Object> getClass()` | Restituisce un oggetto di tipo Class che contiene informazioni sul tipo dell’oggetto                                  |
| `int hashCode()`                     | Restituisce un intero associato all’oggetto (per es. ai fini della memorizzazione in strutture dati, hashtable, ecc.) |
| `String toString()`                  | Restituisce una rappresentazione di tipo String dell’oggetto(per default: tipo@codice_hash)                           |
### il metodo toString
- chiamato implicitamente quando un oggetto deve essere convertito a String 
- ogni classe lo eredita da Object
### il metodo equals
- viene invocato per confrontare il contenuto di 2 oggetti
- se gli oggetti sono della stessa classe, restituisce true, ma non riconosce se sono a livelli diversi di sottoclassi (in questo caso è meglio usare [[confronto, conversione e copia#instanceof]]]instanceof)

