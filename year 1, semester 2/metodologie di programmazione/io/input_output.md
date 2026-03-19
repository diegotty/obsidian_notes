## output su console
- usando la classe System.out (oggetto dello standard input)
- `out` è un campo statico, pubblico, final di System di tipo java.io.PrintStream (che estende java.io.OutputStream)
java.io.PrintStream è una classe con tanti metodi, di cui `print(Object obj)`, che prende un oggetto e chiama il metodo toString della classe (è importante implementare toString nelle classi create !!)

## input da tastiera
- usando la classe java.util.Scanner costruita con System.in
- `System.in` è un campo statico, publico, final di System, di tipo java.io.InputStream
### java.util.Scanner
si può utilizzare lo scanner anche passando un file o altre fonti invece della console, e per alcuni di questi canali di flussi dati sarà molto importante chiuderli con il metodo close() per evitare comportamenti indesiderati
![[Pasted image 20240513213853.png|500]]

## gli stream
uno stream è un’astrazione derivata da dispositivi input o output sequenziale
- uno stream di input riceve uno stream di caratteri, “uno alla volta”
- uno stream di output produce uno stream di caratteri
- gli stream non si applicano solo ai file, ma anche a dispositivi di input/output, internet, etc..
un file può essere trattato come uno stream di input o output (in realtà i file sono bufferizzati per questioni di efficienza)

tutti gli oggetti di classi che implementano java.lang.AutoCloseable (che è estesa dall’interfaccia java.io.Closeable) si chiudono automaticamente. tra cui anche gli stream !!

### lettura e scrittura su files
per leggere o scrivere caratteri(16 bit alla volta):
- java.io.Reader/Writer
per leggere o scrivere byte(da file binari, 8 bit alla volta):
- java.io.InputStream/OutputStream
l’accesso ai file di testo è stato semplificato in Java 5 mediante l’aggiunta di java.util.Scanner, che tuttavia è più lenta proprio perchè più potente

lettura bufferizzata dei caratteri forniti da FileReader:
```java
try(BufferedReader br = new BufferedReader(new FileReader(fileName))){ //br si chiude da solo !! (try with resources)
	while(br.ready()){
		String line = br.readLine();
	}
}catch(IOException e)
```

scrittura con BufferedWriter
```java
try(BufferedWriter bw = new BufferedWriter(new FileWriter(fileName))){
	bw.write("the great gig in the sky");
}catch(IOException)
```

