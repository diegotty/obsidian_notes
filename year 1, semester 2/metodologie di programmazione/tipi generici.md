
# generici
i tipi generici sono un modello di programmazione che permette di definire, con una sola dichiarazione, un intero insieme di metodi o classi
è un meccanismo molto potente, da usare con consapevolezza !

## esempio di classe generica 
```java
public class Valore<T>{
	public final T val;
	
	public Valore(T val) { this.val = val; }

	public T get() { return val; }

	public String toString() { return ""+val;}

	public String getType() { return val.getClass().getName();}
	
} 
public static void main(String[] args){
	Valore<Integer> i = new Valore<Integer>(42); //getType ritorna Integer
	Valore<Valore<Integer>> v = new Valore<>(i); //getType ritorna Valore
// si può omettere il tipo nella parte destra dell'inizializzazione !

}
```
per convenzione i tipi generici sono chiamati con le lettere T,S , etc (E nel caso in cui siano elementi di una collection
## perchè sono utili ?
utilizzare Object fa perdere ogni informazione sul tipo utilizzato, e costringerebbe a continui downcast
## caratteristiche 
- non è possibile utilizzare i primitivi come argument dei tipi generici
```java
Valore<int> v; //da errore
//versioni future di java potrebbero permetterlo
```

- i tipi generici differiscono sulla base dei loro tipi(Valore\<Integer> non è compatibile/convertibile con Valore\<String>)
- quando si estendono classi generiche, si deve inserire il tipo
## vincolo di comparabilità
```java
public interface MinMax<T extends Comparable<T>>{ 
//sto vincolando T a essere un comparabile di T(se stesso) o un sottotipo
	T min();
	T max();	
}

public class MyClass<T extends Comparable<T>> implements MinMax <T>{
// scrivo che T extends Comparable<T> per essere sicuro di poter implementare MinMax !! altrimenti potrei non esserne capace
}
```

>[!tuff] TUTTE LE T SONO LO STESSO TIPO !!

```java
public class ViolenzaSuUnArrayList{
	public static void main(String[] args){
		ArrayList<Mela> mele = new ArrayList<Mela>();
		prendiFrutta(mele); //errore, non è possibile fare upcasting tra tipi generici, altrimenti potrei aggiungere una pera ad un ArrayList di mele !!!
		
		//qui avrei una lista di mele con una pera !!
		System.out.println(mele.toString());
	}
	public static <T extends Frutto> void prendiFrutta(ArrayList<T> frutti){
		frutti.add(new Pera());
	}
}

//l'upcasting è invece possibile,a tempo di compilazione, con gli array, e fare la stessa cosa non darebbe errori ma  verrebbe lanciata un'eccezione
```

## peculiarità
### metodi generici in classi non generiche
posso definire metodi generici (anche in classi non generiche !)
per farlo è necessario **anteporre** il tipo generico tra parentesi angolari **al tipo di ritorno**:
```java
static public <T> void esamina(ArrayList<T> lista){
	for(T o : lista)
		System.out.println(o.toString());
}
```

differenze : 
```java
static public void esamina(ArrayList<Frutto> frutti){}
//non accetta ArrayList<Arancia> !!! non sottoclassi del tipo expected, e come visto prima i tipi generici differiscono sulla base dei oro tipi

static public <T extends Frutto> void esamina(ArrayList<T> frutti){}
//questo è veramente generico !! T accetta qualunque sottotipo della classe Frutto
```

per le classi generiche non vale l’ereditarietà dei tipi generici !!
- ArrayList\<Integer> non è di tipo ArrayList\<Number> o ArrayList\<Object>  !!!
ma rimane comunque il polimorfismo tra classi:
```java
List<Integer> listaDiNumeri = new ArrayList<Integer>();
```

## jolly
nel caso in cui non sia necessario utilizzare il tipo generico T nel corpo della classe o del metodo, è possibile utilizzare il jolly  `?(punto interrogativo)`
```java
public static void mangia(ArrayList<? extends Mangiabile> frutta){} // equivale a 
public static <T extends Mangiabile> void mangia2(ArrayList<T> frutta){} 
// ma nel secondo metodo posso usare T ! nel primo non ho la nozione del tipo utilizzato
```
si può usare il jolly per dichiarare un oggetto di tipo classe generica con qualsiasi tipo parametrico
```java
Punto<?> p = new Punto<Integer>(10,42);
p = new Punto<Double>(11.0, 43.5); //polimorfismo type beat !!
```

## cancellazione del tipo
dietro le quinte le classi generiche vengono gestite con la cancellazione del tipo.
quando il compilatore traduce il metodo/la classe generica in bytecode Java:
- viene eliminata la sezione del tipo parametrico e si sostituisce il tipo parametrico con quello reale
- per default il tipo generico viene sostituito con il tipo Object (a meno di vincoli sul tipo)
- solo una copia del metodo/classe viene creata !!
## extends e super
si può imporre un vincolo sul tipo generico T mediante le parole chiave:
- **extends**: T deve essere un sottotipo della classe specificata o la classe estesa
- **super**: T deve essere una superclasse della classe specificata o la classe estesa
```java
List<? extends Number> l1 = new ArrayList<Number>();
List<? extends Number> l2 = new ArrayList<Integer>();
//non posso sapere a priori quali sarannno i tipi di l1 o l2, ma per certo saprò che saranno tipo/sottotipo di Number

List<? super Integer> l1 = new ArrayList<Number>();
List<? super Integer> l2 = new ArrayList<Object>();
//non posso sapere a priori quali sarannno i tipi di l1 o l2, ma per certo saprò che saranno tipo/supertipo di Integer(posso assumere che saranno certamente Object)
```

# PECS (producer extends, consumer supers)
extends e super esistono per due necessità primarie:
- leggere da/scrivere in una collezione generica

consideriamo: 
```java
List<?> lista = new ArrayList<Number>();
List<? extends Number> lista = new ArrayList<Number>;
List<? super Number> lista = new ArrayList<Number>;
```
con PECS:
- usando `<?>`, non so nulla sul tipo, quindi posso solo leggere, non scrivere
- usando `extends`, hai bisogno di una lista in input che “produca” valori di T, ma non puoi(vuoi) aggiungere elementi alla lista
- usando `super`, hai bisogno di una lista che consumi elementi di tipo T, per scrivere nella lista, ma non puoi assumere il tipo degli stessi

 PECS si applica sulle collection !! non sugli array, dato che negli array non è previsto poter usare tipi generici come tipo
 
### esempio
nell’esempio fatto a lezione, sto usando PECS per vincolare src e dst, in modo da poter “““usare””” l’ereditarietà senza errori (aggiungo in un ArrayList\<Frutto> gli elementi di un ArrayList\<Mela>)
```java
package testPECS;  
  
import java.util.Arrays;  
import java.util.List;  
  
public class Main {  

    public static void main(String[] args) {  
		List<Mela> lmel = Arrays.asList(mele);  
        List<Pera> lper = Arrays.asList(pere);  
        copyListPECS(lmel, lfrut); //questo funziona, sfruttando l'ereditarietà pur non avendo il polimorfismo tra tipi generici !!   
}  

    public static <T> void copyListPECS(List<? extends T> src, List<? super T> dst) {  
       for ( T o: src)  
          dst.add(o);  
       // il tipo di destinazione può essere una mela, o un frutto, o un object  
       // il tipo di souce può essere una mela, o un sottotipo di mela    }  
}
```

//slide 47, cosa da cui non siamo riusciti a uscire a lezione
non posso implementare 2 volte la stesa interfaccia, quindi non la implemento in pera. in questo modo, però, posso ordinare una collezione di Pera poichè Pera non estends Comparable(Pera), ma Comparable(Frutto)

List\<T extends Comparable\<? super T> >
## overloading dei metodi generici
un metodo generico può essere sovraccaricato, come ogni altro metodo, e inoltre anche da un metodo non generico con lo stesso nome e numero di parametri
- quando il compilatore traduce una chiamata di metodo cerca il metodo più specifico(prima il non generico, e poi, eventualmente, il generico)
## tipi raw
per retrocompatibilità, è possibile istanziare una classe generica senza specificare il tipo parametrico
```java
Pila<Integer> p1 = new Pila<Integer>(10); //tipo generico normale
Pila p2 = new Pila(10); //tipo raw
```
