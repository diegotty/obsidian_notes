supponiamo di avere un’informazione da comunicare ad un altro dispositivo. possiamo serializzare l’oggetto e trasmetterlo. in modo tale, esso può essere letto e utilizzato da altri compilatori
```java
public void salva(String filename){
	try{
		FileOutputStream fos = new FileOutputStream(filename);
		ObjectOutputStream os = new ObjectOutputStream(fos);
		os.writeObject(nome);
		os.writeObject(valore);
		os.close();
	}
}
```

per essere serializzabile, una classe deve implementare l’interfaccia Serializable
- Serializable è un’interfaccia senza metodi, è una sorta di marcatore che indica che la classe ha una determinata caratteristica 
quando si serializza un oggetto, tutti gli oggetti variabili d’istanza dell’oggetto originale vengono (e quindi devono essere serializzabili) serializzati
- tutti gli oggetti che sono variabili d’istanza dell’oggetto variabile d’istanza dell’oggetto originale vengono serializzati
- …etc…
se un solo campo non è serializzabile, l’oggetto non è serializzabile
- tuttavia è possibile rendere un campo `transient`: il campo non verrà serializzato
## serial version UID
è  buona pratica specificare sempre un campo static, final long chiamato serialVersionUID, usato in fase di deserializzazione per verificare se la versione della classe in uso è la stessa della classe usata per serializzare
>[!tuff]
> ad esempio, se dopo un aggiornamento del software viene aggiunto un campo e viene cambiata la UID, le versioni del vecchi codice non funzioneranno e genereranno un errore, dato che le vecchie versioni non sono più compatibili con il nuovo software
