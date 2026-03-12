# definizione
>[!tuff] è una classe “speciale” !!

le enumerazioni sono allo stesso livello delle classi(non sono campi di una classe)
sono un tipo i cui valori possono essere scelti tra un insieme predefinito di identificatori univoci
- ogni valore corrisponde a una costante
- le costanti enumerative sono implicitamente static
- non è possibile creare un oggetto del tipo enumerato
la dichiarazione di una enumerazione può contenere altre componenti tradizionali:
- costruttori
- campi
- metodi
non si istanzia nulla di tipo enum, i suoi campi statici pubblici diventano riferimeti ad un oggetto pubblico e statico
enum vengono allocati solo una volta dal class loader nel metaspace.

# metodi
## values()
il metodo values (generato dal compilatore, presente per ogni numerazione) restuisce un array delle costanti numerative

## valueOf()
restituisce la costante numerative associata alla stringa fornita in input(dando per scontato che l’enumerazione sia un array di stringhe evidentemente). se il valore non esiste viene emessa un’eccezione

# esempi
## esempio taglia

esempio più facile di enum:
```java
public enum Taglia {
	PICCOLA, MEDIA, GRANDE
}
```
classe:
```java
public abstract class Animale {

protected Taglia taglia;
protected int numZampe;
protected String verso;

public Animale(int numZampe, String verso, Taglia taglia) {
	this.verso = verso;
	this.numZampe = numZampe;
	this.taglia = taglia;
}
```

## esempio mese
```java
public class Mese {
	private int mese;

	public Mese(int mese) { this.mese = mese; }

	public int toInt() { return mese; }
	public String toString(){
		switch(mese){
			case 1: return "GEN";
			case 2: return "FEB";
			case 3: return "MAR";
			case 4: return "APR";
		}
	}
}

// implementazione della classe mese ma con enum(sopra e sotto non hanno nessun legame !!!!!! sono 2 implementazioni diverse della stessa cosa)
public enum Mese 
{
	GEN(1), FEB(2), MAR(3), APR(4); //GEN, FEB, MAR, ... sono campi statici pubblici di tipo mese creati con il costruttore e il valore tra parentesi
	private int mese;
/++
+
+ Costruttore delle costanti enumerative
+ @param mese il mese intero
+/
Mese(int mese) {this.mese = mese; }
public int toInt() { return.mese; }
}
```

# enumerazioni e Object
- una enumerazione ha tante istanze quante sono le costanti enumerative al suo interno (non è - possibile costruire altre istanze)
- le classi enumerative estendono la classe Enum, da cui ereditano i metodi toString e clone
- Enum estende Object, per cui il metodo equals restituisce true solo se le costnti enumerative sono identiche
```java
public enum TipoDiMoneta {
	// le costanti enumerative, costruite in modo appropriato
	CENT(0.01), CINQUE_CENT(0.05), DIECI_CENT(0.10), VENTI_CENT(0.20),
	CINQUANTA_CENT(0.50), EURO(1.00), DUE_EURO(2.00);
	
	// valore numerico della costante
	private double valore;
	
	// costruttore con visibilità di default
	TipoDiMoneta(double valore) { this.valore = valore; }
	
	// meotodo di accesso al valore
	public double getValore() { return valore; }
}
```
in questo esempio, si nota come le costanti (CENT, CINQUE_CENT, etc) vengano costruite con dei valori. 
>[!tuff] non possono essere create nuove istanze, ma possono essere costruite le istanze “costanti” !!

