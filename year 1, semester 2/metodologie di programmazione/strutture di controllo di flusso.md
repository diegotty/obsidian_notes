	# istruzioni di controllo
## operatore ternario (operatore elvis)
```java
int abs = x < 0 ? -x : x;
```

## switch case
```java
switch(<espr intera>)
{
	case <valore1>: <istruzioni>; break;
	case <valore2>: <istruzioni>; break;
}
```
posso rendere più casi comuni (con la stessa operazione in caso di quei case)
```java
case <1>: case <2> : case <3>:
	<istruzioni>; break;
```
## newer switch case
è possibile utilizzare anche una notazione contratta con l’operatore → che non richiede l’utilizzo del `break` per uscire
```java
switch(k%7){
	case <valore1> -> <istruzioni>;
	case <valore2> -> <istruzioni>;
}
```
### yield
parola chiave che permette di restituire il valore di interesse ( come -> nella nuova sintassi o il break)
```java
String s = switch(c) {
	case 'k': yield "kappa";
	case 'h': yield "acca";
	case 'l': yield "elle";
	case 'c': yield "ci";
	default: yield "non so leggerlo";
}
```
## var 
a partire da Java 10 è possibile evitare di dichiarare il tipo di una variabile locale.
```java
var k = 10; //equivale a int k = 10;
```
il tipo della variabile è sempre fissato e non può cambiare
- si può usare solo per le variabili locali 
>[!tuff] non usare var

le costanti in java si scrivono in maiuscolo

# istruzioni di iterazione