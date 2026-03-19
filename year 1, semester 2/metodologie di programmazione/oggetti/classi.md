
>[!info] Index
>- [[#def|def]]
>	- [[#def#Struttura|Struttura]]
>- [[#packages|packages]]
>- [[#campi|campi]]
>	- [[#campi#final|final]]
>	- [[#campi#static ( campo di classe)|static ( campo di classe)]]
>- [[#costruttore|costruttore]]
>	- [[#costruttore#metodi|metodi]]
>	- [[#costruttore#overloading|overloading]]
>- [[#visibilità|visibilità]]
>	- [[#visibilità#occultatori di visibilità|occultatori di visibilità]]
>	- [[#visibilità#incapsulamento|incapsulamento]]




# def
Le classi rappresentano stati/concetti/entità, e sono un prototipo astratto per gli oggetti di un tipo(tipo della classe)
## Struttura
- Campi(stati)
- Metodi(comportamenti)
> [!Warning] Il nome di una classe inizia sempre con la maiuscola e sono case sensitive

***
# packages
Le classi sono organizzate in packages. Alcuni dei package più comuni sono:
- java.lang - package speciale che contiene le classi fondamentali(es. String, System, etc)
- java.util - classi di utilità
- java.awt - 4 graphics and windows
- javax.swing, javafx - 4 gui
***
# [[campi]]
costituiscono la memoria privata di un oggetto ( sono [[private]] la maggior parte delle volte)
dichiarazione di un campo:
```java
private [final] [static] tipo_di_dati nome;
```
## final
un campo final è una costante(dopo il primo valore assegnatogli)
## static ( campo di classe)
un campo static è condiviso da tutti. è allocato una sola volta in memoria per tutti gli oggetti
***

# costruttore
serve ad ottenere un oggetto istanza della classe. Ci possono essere più costruttori !
non hanno valori di uscita, ma non specificano void.
una classe può avere più costruttori(che differiscono nel numero e tipo dei parametri)
java crea per ogni classe un costruttore di default vuoto se non creato manualmente
> [!tuff]
 i campi di una classe vengono inizializzati con dei valori di default !!


***
## [[metodi]]
they do things
## overloading
```java
public void reset() {value = 0}

public void reset(int NewValue) {value = newValue}
```
## metodi statici
sono metodi di classe
non hanno accesso ai campi di istanza, ma hanno accesso ai campi di classe non fare metodi statici che provano a modificare campi d'istanza !!
>[!tuff] I METODI STATICI INTERAGISCONO SOLO CON CAMPI DI CLASSE

## final
i metodi final non possono essere reimplementati

***
# visibilità
## occultatori di visibilità
### private: 
le cose dichiarate come private non possono essere viste da altre classi(information hiding)
### public
### protected
rende il campo/metodo visibile (solo) a tutte le sottoclassi e classi dello stesso package
### default 
visibile all’interno di tutte le classi del package

## incapsulamento
semplifica il lavoro di sviluppo.
funzionamento a "scatola nera":
- non è necessario conoscere i dettagli implementativi delle classi con cui si interagisce
facilita il lavoro di gruppo e l'aggiornamento del codice
una classe interagisce quindi con le altre quasi solo attraverso costruttori e metodi pubblici

i metodi di una classe possono chiamare i metodi pubblici e privati della stessa classe, ma solo i metodi pubblici di altre classi !!!

# classi particolari
## classi wrapper
- permettono di convertire i valori di un tipo primitivo in un oggetto
- forniscono metodi di accesso e visualizzazone dei valori (?)
per ogni tipo primitivo esistono delle classi corrispondenti: classi wrapper dei primitivi
```java
new Integer(5) != new Integer(5); //da false perchè sono stati creati 2 nuovi oggetti di tipo Integer(non primitivi) e quindi l'operatore di confronto va a confrontare i riferimenti(posto in memoria)
```
per l’esempio di sopra dobbiamo usare 
- equals() 
- compareTo()

>[!tuff] I TIPI PRIMITIVI NON SONO ISTANZE DI CLASSE ! 

alcuni membri speciali delle classi wrapper:
- Integer.MIN_VALUE, …
- i metodi Integer.parseInt(), Double.parseDouble(), …
- toString()
- Character.isLetter(), Character.isDigit(), Character.isUpperCase(),…
### autoboxing e auto-unboxing
l’autoboxing converte automaticamente un tipo primitivo al suo tipo wrapper associato, mentre l’auto-unboxing converte automaticamente da un tipo wrapper al suo tipo primitivo associato
```java
Integer k = 3; //autoboxing perchè 3 è un int !
Integer[] array = {5, 3, 7, 8, 9}; //autoboxing xke 5 è un int, 3 è un int, 7 è un int,etc
//dovrei creare l'oggetto Integer 5, l'oggetto Integer 3, etc
// ogni oggetto occuperebbe dello spazio, l'autoboxing ci risparmia questa fatica !

int j = k; //auto-unboxing(k è un oggetto di tipo Integer, non un tipo primtivo int) !!!
int n = array[j]; //auto-unboxing xke array è un array di Integer, non di int
```

## classi astratte
una classe astratta non può essere istanziata(non possono esistere oggetti per quella classe)
```java
public 
abstract class PersonaggioDisney{
	abstract void faPasticci();
}
```
tipicamente verrà estesa da altre classi, che invece verranno istanziate
anche i metodi possono essere definiti astratti(esclusivamente all’interno di una classe astratta)
```java
	abstract void faPasticci();
```
le classi non astratte che estendono classi con metodi astratte devono implementare il metodo (obbligatoriamente ! )

## classi final
le classi final non possono avere sottoclassi !
