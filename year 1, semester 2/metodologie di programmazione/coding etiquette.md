
le costanti si scrivono in maiuscolo
```java
public final int MAX = 10000000;
```

non usare graffe non necessarie
```java
if (<condizione>){
	return true;
}
else{
	return false
}

if (<condizione>)
	return true;
else;
	return false;
```

se una funzione viene progettata per restituire un valore, 
>[!tuff] restituiscilo ! non stamparlo !!

il 99% dei campi devono essere pubblico(ancora non è ben conosciuto l’1%)

>[!tuff] NON SCRIVERE METODI STATICI CHE INTERAGISCONO CON CAMPI DI ISTANZA

non ti allargare con le righe di codice, java è già abbastanza prolisso. non scrivere libri se non necessario

non scrivere classi insensate
```java
public class Segmento{
	private Punto startPoint; //
	private Punto endPoint;

	public Segmento(){   //non esiste un segmento senza punti di inzio/fine, ne punti senza coordinate
		startPoint = new Punto();
		endPoint = new Punto();
	}
	public Segmento(Punto startP, Punto endP){
		startPoint = startP;
		endPoint = endP;
	}
}
```

# si può fare in una riga !
```java
public int maxTripla(){
	if array[0] > array[array.length / 2] && array[0] > array[array.length - 1])
		return array[0];
	else if(array[0] < [array.length / 2] && array[array.length / 2 ] > array[length - 1])
		return array[array.length - 1]

}
//mannaggia alla miseria se mi capita qualcuno che scrive codice così
```

```java
public int maxTripla(){
	if (array.length < 3)
		return 0;
	else 
		return Math.max(Math.max(array[0], array[array.length / 2]), array[array.length - 1])
}
//very pythonic very nice
```

non inizializzare i campi nella loro dichiarazione !
```java
private Punto p1 = new Punto(); //dumb and stupid i hate you for doing this
```

meglio usare una COSTANTE per la definizione di un array !

i campi dovrebbero essere inizializzati, per più eleganza, nel costruttore !!
```java
	ArrayList<Integer> list = new ArrayList<>; //coding horror !
```


si devono usare campi final per le costanti spento e acceso, e si deve usare un operatore elvis per l’if
```java
Public class ErroriComuni{
	private boolean bAcceso;
	
	@Override
	public String toString()}{
		if (bAcceso) return "ACCESO";
		else return "SPENTO";
	}
}
```

```java
public boolean cercaNO(intk, int... elenco){
	boolean trovato = false;
	for (int k : elenco)
		if (x == k) trovato = true;
	return trovato
}

public boolean cercaOK(int k, int... elenco){
	for(int x : elenco)
		if (x == k) return true;
	return false;
}
```

non posso instanziare interfacce !!
```java
List<Integer> l = new List<>(); // i hate you
List<Integer> l = new ArrayList<>();
```

non posso usare tipi primitivi tra parentesi angolari

non posso assegnare un array a una lista 
```java
List<Integer> l = new Integer[] {1, 2, 3}; //no
List<Integer> l = Arrays.asList(new Integer[] {1, 2, 3});
```

>[!tuff] NON POSSO ACCEDERE E MODIFICARE GLI ELEMENTI DELLA LISTA ITERANDO CON UN FOR EACH !!!!!!!