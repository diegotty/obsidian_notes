- è possibile definire classi anonime (ovvero senza nome) che implementano un’interfaccia o estendono una classe
- utilizzate esclusivamente per creare un’unica istanza
- utili in determinati contesti (es: per creare un iteratore al volo (???))
```java
TipoDaEstendere unicoRiferimentoAOggetto = new TipoDaEstendere()
{
//codice della classe anonima(implementazione dell'interfaddia o // estensione della classe)
};
```
## perchè è utile ??
è utile se il codice non servirà mai più oltre alla scope in cui viene creata la classe anonima !
```java
public interface formula {
	double calculate(int a);
	default double sqrt(int a) { return Math.sqrt(a);}
}
```

```java
Formula formula = new Formula(){ ///tipo da estendere !!!!!! crazy !!!!!!!!
	@Override
	public double calculate(int a){
		return sqrt(a * 100);
	}
}
```

### peculiarità
la parola chiave this si riferisce all’oggetto anonimo
le classi anonime vengono compilate come classi interne


# lambda function
da Java 8 è possibile specificare funzioni utilizzando una notazione molto compatta: le espressioni lambda.
```java
(tipo nome_param1, ..., tipo nome_paramn) -> { codice della funzione}
```
- il tipo dei parametri in input è opzionale, perché si ricava dal contesto dell’interfaccia a cui facciamo riferimento
- le parentesi tonde sono opzionali se in input abbiamo un solo parametro
- le parentesi graffe intorno al codice sono opzionali se è costituito da una sola riga
- non è necessario return, se il codice è dato dall’espressione di ritorno(viene assunto il return, guada esempio sotto)
```java
(a,b) -> a+b;
```
## perchè sono utili ?????
- è da consigliare l’impiego delle espressioni lambda **principalmente** quando il codice si scrive su una sola riga
- in alternativa, si preferisce un’implementazione mediante classe o classe anonima ( o riferimenti a metodi)

>[!tuff] tali espressioni creano oggetti anonimi, assegnabili a riferimenti a interfacce funzionali compatibili con l’intestazione (input/output) della funzione creata

credo quello sopracitato sia il loro quasi unico scopo ? l’essere assegnate a interfacce funzionali !

esempio di Formula con lambda function
```java
Formula formula = a -> Math.sqrt(a*100);
//ho una classe anonima che implementa un'interfaccia funzionale usando una lambda function per implementare il metodo astratto
```

esempio converter 
```java
public interface Converter<F,T>{
	T convert(F from); // parametro di tipo F chiamato from
}
Converter<String, Integer> converter = from -> Integer.valueOf(from); //ha senso...
Integer converted = converter.convert("123"); //non sto creando una nuova istanza di converter, sto utilizzando l'unica istanza per creare un oggetto di tipo Integer ! fun !!!!!!!!!! fuck
```

## visibilità delle funzioni lambda
si possono accedere:
- campi d’istanza e variabili statiche
- variabili final del metodo che definisce la lambda
- variabili del metodo esterno implicitamente final
```java
final int num = 1;
Converter<Integer, String> stringConverter = from -> String.valueOf(from + num);
stringConverter.convert(2); //3 !!
```
### peculiarità
la parola chiave this si riferisce all’oggetto della classe che le racchiude
le espressioni lambda vengono compilate come metodi privati invocati dinamicamente

## riferimenti a metodi esistenti
è possibile passare riferimenti a metodi esistenti utilizzando la sintassi:
- Classe::metodoStatico
- riferimentoOggetto::MetodoNonStatico (il metodo verrà chiamato sull’oggetto)
- Classe::metodoNonStatico (ci si riferisce al metodo implicitamente esteso con un primo parametro aggiuntivo: un riferimento a un oggetto della classe cui appartiene il metodo)((quindi implicitamente “crea” un altro metodo con un altro parametro in più, l’oggetto))

def di Converter: [[Comparable e Comparator]]
```java
//l'interfaccia converter è creata per rendere facile la conversione tra 2 tipi
Converter<String, Integer> converter = Integer::valueOf;
Integer converted = converter.convert("123");
```
esempi:
```java
public interface StringProcessor{
	String process(String s);
}
StringProcessor f = String::toLowerCase;
System.out.println(f.process("BELLA"));//toLowerCase() di solito non prende parametri !!! terzo caso! Classe::metodoNonStatico
String s = "bella";
StringProcessor g = s::concat; //secondo caso! riferimento::MetodoNonStatico
System.out.println(g.process("zi!")); //stampa "bella zi!"
StringProcessor h = String::valueOf; //valueOf è un metodo statico ! primo caso
System.out.println(h.process("bella")); 

```