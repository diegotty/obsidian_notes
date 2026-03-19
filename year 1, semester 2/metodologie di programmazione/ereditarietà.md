# ereditarietà
concetto cardine della programmazione orientata agli oggetti !
è una forma di riuso del software in cui una classe è creata:
- assorbendo i membri di una classe esistente
- aggiungendo nuove caratteristiche e migliorando quelle esistenti
![[Pasted image 20240324215637.png]]
cerchio, triangolo e rettangolo cosa hanno in comune ?
dalla risposta hanno deciso di creare la classe forma 
date poi le distinzioni di ognuno, vengono create le sottoclassi cerchio, triangolo, rettangolo
```java
public class Forma{
public void disegna(){}
}
public class Triangolo extends Forma{
	//la classe Triangolo eredita i membri di Forma !
	//in questo caso il metodo disegna() è vuoto
}
```
## che cosa si eredita ?
- ogni sottoclasse estende solo una superclasse
- la sottoclasse eredita campi e metodi d’istanza secondo il livello d’accesso specificato
- la sottoclasse può aggiungere nuovi metodi e campi
- ridefinire i metodi che eredita dalla superclasse(tipicamente non i campi)
- le classi ereditano in maniera transitiva (se a eredita da b, e c eredita da a, c eredita da b)

## classi astratte
una classe astratta non può essere istanziata(non possono esistere oggetti per quella classe)
```java
public abstract class PersonaggioDisney{
	abstract void faPasticci();
}
```
tipicamente verrà estesa da altre classi, che invece verranno istanziate
anche i metodi possono essere definiti astratti(esclusivamente all’interno di una classe astratta)
```java
	abstract void faPasticci();
```
le classi non astratte che estendono classi con metodi astratte devono implementare il metodo (obbligatoriamente ! )


## overloading vs overriding
overriding:
re-implementazione nella sottoclasse di un metodo creato nella superclasse
- gli argomenti devono essere gli stessi(per numero e tipo)
- i tipi di ritorno devono essere compatibili(lo stesso tipo o una sottoclasse)
- non si può ridurre la visibilità
overloading:
re-impementazione di un metodo con lo stesso nome, ma con numero e/o parametri differenti
- i tipi di ritorno possono essere diversi MA non si può cambiare solo il tipo di ritorno(altrimenti ho 2 metodi uguali con 2 tipi di ritorno diversi, non si saprebbe quale scegliere )
- si può variare la visibilità in qualsiasi direzione !

# tipi di relazioni
è molto importante distinguere tra relazioni di tipo is-a e relazioni di tipo has-a
## is-a
rappresenta l’ereditarietà
un oggetto della sottoclasse può essere trattato come un oggetto della superclasse
(la sottoclasse è un superclasse ? si/no) Paperino è un PersonaggioDisney? si
![[Pasted image 20240324221140.png]]
## has-a
rappresenta la composizione
un oggetto contiene come membri (o sottoclassi ?) riferimenti ad altri oggetti
(un oggetto contiene altri oggetti ? si/no) Bagno contiene Vasca ? si
PersonaggioDisney contiene Paperino ? no
//in questo caso però non avrebbe senso che Vasca sia una sottoclasse di Bagno, bensì avrebbe senso che Bagno avesse un campo di tipo Vasca