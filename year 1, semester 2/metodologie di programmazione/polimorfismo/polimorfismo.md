molte + forme
xke ?
vogliamo utilizzare facilmente e senza differenziazioni formali oggetti diversi, ma con caratteristiche comuni
![[Pasted image 20240331221332.png|450]]
```java
Animale a = new Gatto();
a.emettiVerso();
a = new Chihuahua();
a.emettiVerso()
```
`a` polimorfa da gatto ad chihuahua(2 sottoclassi di animale)
`a` è, di fatto, un riferimento ad un animale
la selezione del metodo da chiamare avviene in base all’effettivo tipo dell’oggetto riferito dalla variabile
posso però solo chiamare metodi dichiarati in animale o ereditati da gatto(anche se astratti), non metodi dichiarati in gatto

# binding
il binding è il processo di associare la variabile al suo tipo
## binding statico
il compilatore, senza eseguire il programma, stabilisce già i tipi delle variabili in maniera statica (non solo il tipo delle variabili statiche lol)
## binding dinamico
fatto in Java dalla JVM, serve a stabilire (quando viene usato il polimorfismo), quale metodo chiamare (guarda emettiVerso() in esempio). 
>[!tuff] viene chiamato il metodo implementato, ereditato, o assorbito nella classe di cui chiamo il costruttore

è buona pratica implementare (e fare l’override) del metodo toString()

per utilizzare un metodo della superclasse basta usare `super`
```java
@Override
public String toString(){
	String striscia = getStriscia();
	return striscia + " " + super.toString() + " " + striscia;
}
```
