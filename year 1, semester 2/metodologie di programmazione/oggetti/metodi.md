# metodi particolari
## metodi statici
sono metodi di classe
non hanno accesso ai campi di istanza, ma hanno accesso ai campi di classe non fare metodi statici che provano a modificare campi d'istanza !!
>[!tuff] I METODI STATICI INTERAGISCONO SOLO CON CAMPI DI CLASSE

fun fact: il metodo main() viene dichiarato static perchè 
- la JVM lo invoca ancora prima di aver creato qualsiasi oggetto
- la classe potrebbe non avere un costruttore senza parametri con cui creare l’oggetto
## metodi con numero di parametri variabile
```java
public static double sum(double... valori){ //double...
	//code
}
```
- valori diventa un riferimento ad array ! 
- ci può essere solo una sequenza variabile di parametri
- i parametri normali vanno definiti prima dell’array variabile


# [[progettazione]] di metodi
- i metodi permettono di modularizzare un programma separandone i compiti in unità autocontenute
- i metodi possono essere riutilizzati 
	i metodi possono essere richiamati(senza aver istanziato un oggetto) da altri metodi nella stessa classe
## get() e set()
l’accesso ad alcuni campi, se necessario, è garantito dai metodi getX() e setX() (dove X è il nome del campo)
essi fanno da filtro tra i dettagli implementativi e ciò che vede l’utente esterno