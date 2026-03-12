## i file
collezione di dati salvata su un supporto di memorizzazione di massa
un file di dati non è parte del codice sorgente di un programma, e può essere letto o modificato da programmi differenti(le funzioni di base sono fornite dal sistema operativo)
- il programma deve conoscere il formato dei dati nel file!
- è importante distinguere tra:
## file di testo
- contiene linee di testo(ad esempio, in ASCII)
- ogni linea termina con un carattere di nuova linea(“\\n”) o carriage return(“\\r”)
- esempi: .txt, .java, .html, etc
## file binario
I file binari possono contenere qualsiasi tipo di informazione sottoforma di sequenza di byte e solo il programmatore / progettista sa interpretarlo, infatti diversi programmi potrebbero interpretare lo stesso file in modo diverso. qualsiasi file può essere interpretato come file binario.

non usare java.io.File, che è deprecata. usare java.nio.file.Path, che rappresenta un percorso gerarchico
quando si usano dei percorsi: è importante non specificare in modo esplicito i separatori, ma:
- passare in sequenza le cartelle:
```java
Paths.get(cartella1, cartella2, cartella3, ...., cartellaN,file);
```
- costruitre il percorso con File.separator:
```java
Paths.get(cartella1+File.separator+...+File.separator+cartellaN+File.separator + File);
```

le operazioni che prima si svolgevano nella classe File, ora si svolgono con la classe java.nio.file.Files, inclusi i metodi di comodo per la creazione di BufferedReader e BufferedWriter !
```java
try(BufferedReader br = Files.newBufferedReader(Paths.get("myFile.txt"))){
	//reads from myFile.txt
}
```