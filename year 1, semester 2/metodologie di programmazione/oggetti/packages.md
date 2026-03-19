# Package
le classi vengono inserite in collezioni dette package
ogni package racchiude classi con funzionalità correlate
quando si utilizza una classe è necessario specificarne il package o usare un import per il package o classe(in questo modo non si deve specificare il package ogni volta che la classe viene usata !)
```java
import java.util.Scanner; //import di una classe
 ...
 Scanner input = new Scanner(System.in);

import java.util.*; //import dell'intero package 
```
importare l’intero package non è ricorsivo(viene importato solamente il primo layer di classi)
## API
le API di Java sono organizzate in numerosi package !!
![[Pasted image 20240318201939.png|500]]
i package sono fisicamente cartelle
una classe può essere inserita in un package specificandolo all'inizio del file 
```java
package it.thing.otherthing;
```
e posizionando il file nella sottocartella corretta

## javadoc 
commento per campi e metodi di una classe
```java
	/++
	+ Descrizione del metodo/campo
	+ @param per parametro di metodo
	+ @return per return di metodo
	+ @author per autore (a inizio classe)
	+/
```
## lettura di inputs
si effettua con la classe java.util.Scanner
```java
java.util.Scanner input = new java.util.Scanner(System.in);

String nome = input.nextLine();
```