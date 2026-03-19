---
related to: "[[07 - livello trasporto]]"
created: 2025-03-02T17:41
updated: 2025-05-09T10:56
completed: true
---
>[!index]
>- 
>	- [API](#API)
>- [socket](#socket)
>	- [indirizzamento dei processi](#indirizzamento%20dei%20processi)
>	- [utilizzo dei servizi di livello di trasporto](#utilizzo%20dei%20servizi%20di%20livello%20di%20trasporto)
>	- [programmazione con socket](#programmazione%20con%20socket)
>		- [programmazione socket con TCP](#programmazione%20socket%20con%20TCP)
>		- [programmazione socket UDP](#programmazione%20socket%20UDP)

# sockets
nel paradigma client/server, la comunicazione a livello applicazione avviene tra due programmi applicativi in esecuzione chiamati **processi**; un client e un server:
- un **client** è un programma in esecuzione che inizia la comunicazione inviando una richiesta
- un **server** è un altro programma applicativo che attende le richieste dai client
## API
anche se un linguaggio di programmazione prevede vari insiemi di istruzioni (es: istruzioni matematiche, manipolazione di stringhe, per la gestione dell’input/output), se si vuole sviluppare un programma capace di comunicare con un altro programma, è necessario un nuovo insieme di istruzioni, per chiedere ai primi 4 livelli dello stack TCP/IP di aprire la connessione, inviare/ricevere dati e chiudere la connessione
un insieme di istruzioni di questo tipo viene chiamato **API** (application programming interface)
>[!info] interfaccia socket nello stack TCP/IP
![[Pasted image 20250406180128.png]]
# socket
il socket appare come un terminale o un file, ma non è un’entità fisica, bensi un’astrazione: una struttura dati creata e utilizzata dal programma applicativo
>[!info] 
![[Pasted image 20250406180327.png]]
>comunicare tra un processo client e un processo server signfica comunicare tra due socket create nei due lati di comunicazione

>[!info] socket address
![[Pasted image 20250406181407.png]]
## indirizzamento dei processi
affinchè un processo su un host invii un messaggio a un processo su un altro host, il mittente deve identificare il processo destinatario. un host ha un indirizzo IP univoco a 32 bit, **ma non è sufficiente** per identificare il processo di un host, in quanto in un host possono essere in esecuzione molti processi.
>[!warning] l’identificare comprende quindi sia l’indirizzo ip, che i **numeri di porta** associati al processo in esecuzione su un host
inoltre il [[07 - livello trasporto#numeri di porta|numero di porta]] è una delle informazioni contenute negli header di livello di trasporto per capire a quale applicazione bisogna riportare il messaggio

>[!example] esempio
per inviare un messaggio HTTP al server `gaia.cs.umass.edu`, sono necessari:
>- indirizzo IP: `128.119.245.12`
>- numero di porta: `80` (well-known) 

dato che l’interazione tra client e server è bidirezionale, è necessaria una coppia di indirizzi socket: **locale**(mittente) e **remoto**(destinatario)
- l’indirizzo locale in una direzione è l’indirizzo remoto nell’altra direzione
[[07 - livello trasporto#individuare i socket|i socket vengono individuati in questo modo]]

## utilizzo dei servizi di livello di trasporto
sappiamo già che per comunicare, i due processi devono utilizzare i servizi offerti dal livello trasporto: in particolare è importante la scelta tra TCP e UDP, in base al servizio richiesto dall’applicazione:
- **perdita di dati**: alcune applicazioni possono tollerare qualche perdita di dati, mentre altre richiedono un trasferimento dati affidabile al 100%
- **temporizzazione**: alcune applicazioni, per essere “realistiche”, richiedono piccoli ritardi, mentre altre non hanno particolari requisiti di temporizzazione
- **throughput**: alcune applicazioni, per essere efficaci, richiedono un’ampiezza di banda minima, altre utilizzano l’ampiezza di banda che si rende disponbile
- **sicurezza**: necessità di cifratura, integrità dei dati, etc.
## programmazione con socket
impareremo a costruire un’applicazione client/server che comunica utilizzando le socket. useremo la **Socket API**, introdotta nel 1981
>[!info] socket
una socket è un’interfaccia di un host locale, creata dalle applicazioni, controllata dal SO, in cui il processo di un’applicazione può inviare e ricevere messaggi da/al processo di un’altra applicazione
### programmazione socket con TCP
>[!info] rappresentazione
![[Pasted image 20250407174137.png]]

1. il client deve contattare il server (il processo server deve essere sempre in corso di esecuzione, e deve aver creato un socket che dà il benvenuto al contatto con il client) creando un socket TCP, specificando indirizzo IP e numero di porta del processo server. 
2. quando il client crea il socket, il client TCP stabilisce una connessione con il server TCP
3. quando viene contattato dal client, il server TCP crea un nuovo socket per il processo server **per comunicare con il client** (ciò consente al server di comunicare con più client)
	- vengono usati i numeri di porta origine per distinguere i client

>[!info] interazione client/server TCP
![[Pasted image 20250407174604.png]]

>[!info] terminologia
**stream** (flusso): sequenza di caratteri che fluisce da/verso un processo
**input stream** (flusso d’ingresso): è collegato a un’origine di input per il processo, ad esempio la tastiera o la socket
**output stream** (flusso di uscita): è collegato a un’uscita per il processo, ad esempio il monitor o la socket
![[Pasted image 20250408121807.png]]

il package `java.net` fornisce interfacce e classi per l’implementazione di applicazioni di rete:
- le classi `Socket` e `ServerSocket` per le connessioni TCP
- la classe `DatagramSocket` per le connessioni UDP
- la classe `URL` per le connessioni HTTP
- la classe `InetAddress` per rappresentare gli indirizzi Internet
- la classe `URLConnection` per rappresentare le connessioni a un URL

```java
//client TCP 
import java.io.*;
import java.net.*;

class TCPClient {
	public static void main(String argv[]) throws Exception {
		String sentence;
		String modifiedSencence;
		
		// crea un flusso d'ingresso
		BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));
		// crea un socket client, connesso al server
		Socket clientSocket = new Socket("hostname", 6789);
		// crea un flusso di uscita collegato al socket
		DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
		// crea un flusso di d'ingresso collegato alla socket
		BufferedReader inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
		
		System.out.print("Inserisci una frase: ");
		sentence = inFromUser.readLine();
		
		// invia la frase inserita dall'utente al server
		outToServer.writeBytes(sentence + '\n');
		// legge la risposta dal server
		modifiedSentence = inFromServer.readLine();
		
		System.out.println("FROM SERVER: " + modifiedSentence);
		
		// chiude socket e connessione con server
		clientSocket.close();
	}
}
```

```java
//server TCP
import java.io.*;
import java.net.*;

class TCPServer {
	public static void main(String argv[]) throws Exception {
		String clientSentence;
		String capitalizedSentence;
		
		// crea un socket di benvenuto sulla porta 6789
		ServerSocket welcomeSocket = new ServerSocket(6789);
		while(true) {
			// attende, sul socket di benvenuto, un contatto dal client
			Socket connectionSocket = welcomeSocket.accept();
			// crea un flusso d'ingresso collegato al socket
			BufferedReader inFromClient = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
			// crea un flusso di uscita collegato al socket
			DataOutputStream outToClient = new DataOutputStream(connectionSocket.getOutputStream());
			
			// legge la riga dal socket
			clientSentence = inFromClient.readLine();
			capitalizedSentence = clientSentence.toUpperCase() + '\n';
			
			// scrive la riga sul socket
			outToClient.writeBytes(capitalizedSentence);
		}
	}
}
```

### programmazione socket UDP
nel protocollo UP, non c’è “connessione” tra client: non c’è handshaking, il mittente allega esplicitamente il suo socket address a ogni pacchetto, e il server deve estrarre IP e porta del mittente dal pacchetto ricevuto
>[!example] esempio di interazione client/server con UDP
![[Pasted image 20250408122851.png]]

>[!info] POV client 
![[Pasted image 20250408123021.png]]

```java
//client UDP
import java.io.*;
import java.net.*;

class UDPClient {
	public static void main(String args[]) throws Exception {
		// crea un flusso di ingresso
		BufferedReader inFromUser = new BufferedReader(new InputStreamReader(System.in));
		// crea un socket client
		DatagramSocket clientSocket = new DatagramSocket();
		// traduce il nome dell'host nell'indirizzo IP usando DNS
		InetAddress IPAddress = InetAddress.getByName("hostname");
		
		byte[] sendData = new byte[1024];
		byte[] receiveData = new byte[1024];
		String sentence = inFromUser.readLine();
		
		sendData = sentence.getBytes();
		
		// crea il datagramma con i dati da trasmettere, lunghezza
		// indirizzo IP e porta
		DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, 9876);
		// invia il datagramma al server
		clientSocket.send(sendPacket);
		// crea il datagramma con i dati da ricevere, lunghezza
		// indirizzo IP e porta
		DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
		// legge il datagramma dal server
		// il client rimane inattivo fino a quando riceve un pacchetto
		clientSocket.receive(receivePacket);
		
		String modifiedSentence = new String(receivePacket.getData());
		System.out.println("FROM SERVER:" + modifiedSentence);
		clientSocket.close();
```

```java
//server UDP
import java.io.*;
import java.net.*;

class UDPServer {
	public static void main(String args[]) throws Exception {
		// crea un socket per datagrammi sulla porta 9876
		DatagramSocket serverSocket = new DatagramSocket(9876);
		
		byte[] receiveData = new byte[1024];
		byte[] sendData = new byte[1024];
		
		while(true) {
			// crea lo spazio per i datagrammi
			DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
			// riceve i datagrammi
			serverSocket.receive(receivePacket);
			
			String sentence = new String(receivePacket.getData());
			
			// ottiene indirizzo IP e numero di porta del mittente
			InetAddress IPAddress = receivePacket.getAddress();
			int port = receivePacket.getPort();
			
			String capitalizedSentence = sentence.toUpperCase();
			sendData = capitalizedSentence.getBytes();
			
			// crea il datagramma da inviare al client
			DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);
			// scrive il datagramma sulla socket
			serverSocket.send(sendPacket);
		}
	}
}
```