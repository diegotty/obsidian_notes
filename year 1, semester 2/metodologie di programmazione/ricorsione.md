# come funziona la ricorsione in Java ? 
ogni volta che viene effettuata una chiamata a un metodo, viene creato un nuovo ambiente, detto record di attivazione.
un record di attivazione contiene la zona di memoria per le variabili locali del metodo e l’indirizzo di ritorno al metodo chiamante.
- a ogni chiamata, il record corrispondente viene aggiunto allo stack
## mutua ricorsione
a volte, può verificarsi il caso in cui il metodo `a` richiami il metodo `b`, che richiama a sua volta il metodo `a`
questo meccanismo di reciproca chiamata dei metodi è detto di mutua ricorsione
ovviamente, è sempre necessario stabilire uno o più casi base, onde evitare un ciclo infinito di chiamate tra `a` e `b`

esempio : controlla numeri pari e dispari
```java
public class PariDispari{
	public boolean pariDispari(ArrayList<Integer> l){
	return pariDispari(l, 0);
	}

	public boolean pariDispari(ArrayList<Integer>l, int k){
		if (k == l.size()) return true;
	}
```