---
created: 2024-09-30T23:12
updated: 2025-02-20T09:38
---
>[!index]
>
>- [kernel](#kernel)
>- [sistema batch](#sistema%20batch)
>- [multiprogrammazione](#multiprogrammazione)
>- [sistemi time sharing](#sistemi%20time%20sharing)
>- [job vs processo](#job%20vs%20processo)
>- [elementi principali di un sistema operativo](#elementi%20principali%20di%20un%20sistema%20operativo)
>- [struttura di un sistema operativo](#struttura%20di%20un%20sistema%20operativo)
# sistema operativo
gestisce le risorse hardware di un sistema, per fornire un insieme di servizi agli utenti, ad esempio:
- esecuzioni di programmi
- accesso a dispositivi i/o
- accesso al SO stesso (shell)
- sviluppo di programmi
- rilevamento di e reazione ad errori
- accounting (collezione di statistiche, monitoraggio)
>[!figure] ![[Pasted image 20241006111535.png]]
strati di un SO

si puo’ quindi pensare come un’interfaccia tra le applicazioni e l’hardware, gestendo e controllando l’esecuzione dei programmi:
- e’ responsabile della gestione delle risorse
	- concede il controllo del processore ad altri programmi
	- controlla l’accesso alle altre risorse
di fatto, funziona allo steso modo del software normale: e’ un programma in esecuzione, tuttativa lo fa con privilegi piu’ alti
## kernel
il kernel(nucleo) e’ la parte di sistema operativo che si trova sempre in memoria principale, e contiene le funzioni piu’ usate
## sistema batch
(anni Cinquanta)
- viene usato un programma di monitoraggio (monitor)
- si possono raggruppare lavori (jobs) da eseguire “insieme”(penso intenda uno dopo l’altro, non insieme dato che non esistevano architetture multiprocessore)
- il programma, una volta concluso, ritorna il controllo al programma esterno di monitoraggio
- per gestire il monitor, non e’ permesso che la zona che lo contiene venga modificata
- per impedire che un job monopolizzi un intero sistema, un timer viene usato
- vengono implementate le interruzioni
alcune istruzioni possono essere eseguite solo dal monitor, quindi:
- i programmi utente vengono eseguiti in modalita’ utente (non possono eseguire alcune istruzioni)
- il monitor viene eseguito in modalita’ esterna(o modalita’ kernel), dove puo’ eseguire le istruzioni privilegiate e puo’ accedere alle aree protette della memoria
nei sistemi batch, piu’ del 96% del tempo e’ sprecato ad aspettare i dispositivi di i/o
# multiprogrammazione
un processore deve eseguire piu’ programmi contemporaneamente, e la sequenza con cui i programmi sono eseguiti dipende dalla loro priorita’ e dal fatto che siano o meno in attesa di input/output
per rendere “l’illusione” dell’esecuzione di molteplici programmi in contemporanea, viene usata la multiprogrammazione.
- al posto di aspettare che le istruzioni di i/o siano completate di procedere, il processore passa ad un altro processo.
in questo modo, la percentuale d’uso del processore(e del resto delle componenti) si alza, rendendo il ciclo di esecuzione piu’ efficace. inoltre i tempi per eseguire un insieme di processi diminuisce drasticamente
>[!figure] ![[Pasted image 20241006111437.png]]

alla fine della gestione di un’interruzione, il controllo potrebbe non tornare al programma che era in esecuzione al momento dell’interruzione

## sistemi time sharing
(anni Settanta)
sistemi a condivisione del tempo! uso della multiprogrammazine per gestire contemporaneamente piu’ jobs interattivi. in questo modo il tempo del processore e’ diviso tra piu’ utenti, e piu’ utenti contemporaneamente accedono al sistema tramite terminali

|                                   | batch                                                          | time sharing                     |
| --------------------------------- | -------------------------------------------------------------- | -------------------------------- |
| scopo principale                  | massimizzare l’uso del processore (?)                          | minimizzare il tempo di risposta |
| provenienza delle direttive al SO | comandi del job control language, sottomessi con il job stesso | comandi dati dal terminale       |
# job vs processo
il processo riunisce in un unico conetto il job non-interattivo e quello interattivo
- incorpora anche un altro tipo di job che comincio’ a manifestarsi dagli anni Settanta: quello transazionale real-time (ad es. prenotazione biglietti aerei)
il processo e’ un’unita di attivita’ caratterizata da:
- un singolo flusso (thread) di esecuzione
- uno stato corrente
- un insieme di risorse di sistema ad esso associate
dato che viene introdotto un nuovo tipo di job, la multiprogrammaziones sui processi ha delle difficolta’:
- errori di sincronizzazione
- violazione della mutua esclusione
- programmi con esecuzione non deterministica
- deadlock
## elementi principali di un sistema operativo
- scheduler (lungo termine, medio termine, breve termine)
- service call handler
- interrupt handler
- i/o queue
# struttura di un sistema operativo
il sistema operativo viene visto come una serie di livelli.
i livelli comunicano con i loro adiecenti !
1. circuiti elettrici
2. insieme delle istruzioni macchina
3. aggiunge il concetto di procedura
4. interruzioni
5. processo come programma in esecuzione, sospensione e ripresa dell’esecuzione del processo
6. dispositivi di memorizazione secondaria (dischi, etc),
7. organizza lo spazio degli indirizzi virtuali in blocchi 
8. comunicazioni tra processi
9. filesystem
10. acesso a dispositivi esterni
11. associazioni tra identificatori interni ed esterni
12. supporto di alto livello per i processi
13. interfaccia utente
>[!figure] ![[Pasted image 20241004111658.png]]
esempio dei livelli dell’architettura UNIX

i kernel dei sistemi operativi moderni possono essere di 2 tipi:
- monolitici: tutto il kernel viene caricato in memoria a boot e rimane li fino allo spegnimento(piu veloce, ma occupa più memoria)
- microkernel: solo una minima parte del kernel è in memoria, il resto viene caricato quando serve. (MacOS è microkernel!)
linux è principalmente monolitico, ma ha moduli, per (filesystem(mounting…), driver per determinati dispositivi di I/O, implementazione delle funzionalità di rete, etc)