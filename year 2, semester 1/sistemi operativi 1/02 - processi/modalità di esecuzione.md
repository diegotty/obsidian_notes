---
created: 2024-10-05T22:37
updated: 2025-02-20T09:38
---
>[!index]
>
>- [modalità kernel](#modalit%C3%A0%20kernel)
>- [modalità utente](#modalit%C3%A0%20utente)
>	- [passaggio da kernel mode a user mode](#passaggio%20da%20kernel%20mode%20a%20user%20mode)

ci sono aree di memoria(ad esempio i PCB) o comandi privilegiati ai cui dei processi (quelli di cui il SO non si fida) non devono avere accesso: per permettere ciò, esistono diverse modalità in cui un processo può essere eseguito, ognuna con permessi diversi (di solito)
la maggior parte dei processori supporta almeno 2 modalità di esecuzione:
# modalità kernel
i processi eseguiti in modalità kernel (o modalità sistema) hanno pieno controllo:
- possono eseguire istruzioni macchina che bloccano gli interrupt
- possono accedere a qualsiasi locazione di RAM
ed è quindi pensata per i processi del kernel
in particolare, hanno accesso a:
- gestione dei processi (tramite PCB): creazione e terminazione, pianficazione, process switching, sincronizzazione e comunicazione
- gestione della memoria principale: allocazione di spazio per i processi, gestione della memoria virtuale
- gestione dell’I/O: gestione dei buffer e delle cache per l’I/O, assegnazione risorse I/O ai processi
- gestione interrupt, accounting, monitoraggio
# modalità utente
pensata per i programmi utente, a cui molte operazioni sono vietate
## passaggio da kernel mode a user mode
anche se un processo utente inizia sempre in modalità utente, spesso è necessario che un processo venga eseguito in kernel mode (per esempio, l’utilizzo di I/O). ciò è possibile, e segue una logica:
- la modalità di un processo cambia in seguito ad un interrupt(la prima cosa che fa l’hardware, prima di invocare l’handler, è cambiare modalità da utente a sistema del processo; inoltre l’ultima istruzione dell’interrupt handler è lo switch a modalità utente del processo)
in questo modo, l’interrupt handler può essere eseguito in modalità kernel
- ma dato che l’interrupt handler è dentro il kernel del SO, non ci sono problemi
in questo modo, un processo utente può cambiare la modalità a se stesso, ma **solo per eseguire software di sistema**

l’interrupt handler può essere chiamato:
- per conto dello stesso processo interrotto, che lo ha esplicitamente voluto (syscall, o una risposta ad una sue precedente richiesta di I/O, o comunque di risorse)
- per conto dello stesso processo interrotto, che non lo ha esplicitamente voluto(errore fatale o non fatale)
- per conto di qualche altro processo: un processo A fa una richiesta di I/O e viene messo in blocked; nel mentre viene eseguito un processo B. se la richiesta viene esaurita mentre il processo B è in esecuzione, l’interrupt handler viene chiamato per conto del processo B, ma per una risposta al processo A