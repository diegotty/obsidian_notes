queste 2 interfacce disaccoppiano l’oggetto su cui iterare dall’oggetto che tiene la posizione dell’iteratore
esempio: voglio creare un programma che crea tutte le permutazioni di un array
```java
MyIntegerArray arr = new MyIntegerArray({4,5,6,6,7,8,4,21,34,5});
int i = 0;
int j = 0;
while(arr.hasNext()){
	System.out.println(arr.curr())
	while(arr.hasNext()){
		print(arr.curr());
		arr.next();
	}
	arr.next();
	}
// usando l'interfaccia Iterabile, non potrò avere la permutazione, (5,4)
```

`java.lang.Iterable`

| Modifier and Type | Method and Description                                                                |
| ----------------- | ------------------------------------------------------------------------------------- |
| `Iterator<T>`     | `iterator()`<br>Restituisce ogni volta che lo chiamo una nuova istanza dell’iteratore |

`java.lang.Iterator`
chi implementa Iterable restituisce un Iterator sull’oggetto-collezione
contiene uno stato(ha un indice) !!! ci può dire se l’iterabile ha un prossimo elemento ed avanzare.

| Modifier and Type | Method and Description                                           |
| ----------------- | ---------------------------------------------------------------- |
| `boolean`         | `hasNext()`<br>Ritorna true se l’iteraziocolne ha altri elementi |
| `E`               | `next()`<br>Ritorna il prossimo elemento dell’iterazione         |
| `void`            | `remove()`<br>                                                   |
|                   |                                                                  |

quando voglio rendere una classe iterabile, essa deve implementare Iterable. in questo modo la classe sarà obbligata ad implementare il metodo iterator(), in cui bisognerà creare e ritornare un oggetto di tipo Iterator. 
nel video su internet viene creata una classe interna, che implementa Iterator e implementa i suoi metodi. la classe interna viene poi creata e ritornata nel metodo iterator() della classe creata all’inizio

se la classe implementa Iterable posso usare i forEach !!

## esempio:
classe StringaIterabile.

```java
package esercizi7;

  

import java.util.Iterator;

  

public class StringaIterabile implements Iterable<Character>{

String str;

public StringaIterabile(String str) {

this.str = new String(str);

}

  

@Override

public Iterator<Character> iterator() {

IteratoreStringa it = new IteratoreStringa(str);

return it;

}

private class IteratoreStringa implements Iterator<Character>{

  

String internalStr;

int i = 0;

public IteratoreStringa(String str) {

internalStr = new String(str);

}

@Override

public boolean hasNext() {

//if(i < internalStr.length()-1) {

return (i<internalStr.length());

}

  

@Override

public Character next() {

Character val = internalStr.charAt(i);

i++;

return val;

}

}

  

}
```