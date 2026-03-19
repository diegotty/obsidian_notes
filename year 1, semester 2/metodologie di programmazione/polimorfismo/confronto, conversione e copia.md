# instanceof
l'operatore, applicato a un oggetto e a un nome di classe, restituisce true se l’oggetto è un tipo o sottotipo di quella classe !
```java
Impiegato i1 = new ImpiegatoStipendiato("diego", "0001", 1);
System.out.println(i1 instanceof Impiegato);
//output è true !
```

# casting 
posso sempre convertire, senza un cast esplicito, un sottotipo a un supertipo (**upcasting**)
- per farlo devo dichiarare una nuova variabile
```java
ImpiegatoStipendiato is1 = new ImpiegatoStipendiato("mario", "imp1", 1500);
```
può essere invece necessario convertire un supertipo a un sottotipo (**downcasting**), ciò richieste un cast esplicito !
```java
ImpiegatoStipendiato is2 = (ImpiegatoStipendiato)i;
```
>[!tuff] NON STO CREANDO UN NUOVO OGGETTO !
>sto giocando con i riferimenti e i vari livelli dell’oggetto


## campo riferimento di tipo astratto
anche se non è possibile istanziare un oggetto di una classe astratta, è possibile creare istanze di sottoclassi di tale classe astratta, e assegnare il riferimento alla variabile di tipo forma
```java
Animale a = new Gatto();
a.getClass(); //returns gatto
```
ciò è possibile proprio grazie al polimorfismo !!!!!!!!!!!!!


# il metodo clone
- l’operazione di assegnazione `=` non effettua una copia dell’oggetto, ma solo del riferimento all’oggetto !!
- per creare una copia di un oggetto è necessario chiamare il metodo clone()
- x.clone() != x sarà sempre vero 
- clone non richiama il costruttore della classe (quindi si possono copiare singletons ??)
- tuttavia, l’implementazione nativa di default di Object.clone copia l’oggetto campo per campo (shallow copy)
per implementare la copia in una classe bisogna implementare l’intefaccia Cloneable e sovrascrivere il metodo clone()
## shallow copy vs deep copy
copia campo a campo(shallow copy):
- copia una istanza di una classe in modo che punti però allo stesso riferimento 
- basta chiamare .clone()
clonazione profonda(deep copy):
- viene evitata la copia dei riferimenti
- si può usare Object.clone() per la clonazione dei primitivi(non viene copiato il riferimento con i primivi), e richiamare .clone() su tutti i campi che sono riferimenti ad altri oggetti, impostando i nuovi riferimenti nell’oggetto clonato
```java
//shallow copy
public class IntVector implements Cloneable{
	ArrayList<Integer> list = new ArrayList<>();
}


public void getCopy(){
	try{
		return (IntVector)clone();
	}
	catch(CloneNotSupportedException e) {return null;}
}

//deep copy
public IntVector getCopy(){
	try{
		IntVector v = (IntVector)clone();
		v.list = (ArrayList<Integer>)list.clone();
		return v;
	}
	catch(CloneNotSupportedException e) {return null;}
}
```

```armasm
thought:
how is the code above working, if list.clone() makes a shallow copy ? it seems that even though it creates a new object, the references inside the new list are the same as the original list, so when we change an item in one of the two, it refelects in the other one. this is not a deep copy to me! as both objects are not stand alone instances, but the two are intertwined with references
```