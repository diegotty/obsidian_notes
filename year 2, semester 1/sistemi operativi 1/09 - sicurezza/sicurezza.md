---
created: 2025-02-02T21:18
updated: 2025-03-28T19:16
---
>[!index]
>
>- [minacce](#minacce)
>- [asset](#asset)
>	- [relazione tra asset e la triade](#relazione%20tra%20asset%20e%20la%20triade)
>- [autenticazione](#autenticazione)
>- [mezzi per l’autenticazione](#mezzi%20per%20l%E2%80%99autenticazione)
>- [controllo di accesso](#controllo%20di%20accesso)
>	- [controllo di accesso discrezionale](#controllo%20di%20accesso%20discrezionale)
>	- [controllo di accesso basato su ruoli](#controllo%20di%20accesso%20basato%20su%20ruoli)
>- [meccanismi di protezione di UNIX](#meccanismi%20di%20protezione%20di%20UNIX)
>- [login](#login)
>- [accesso ai file](#accesso%20ai%20file)
>- [SETUID e STGID](#SETUID%20e%20STGID)

dal manuale sulla sicurezza informatica del NIST (national institute of standards and technology):
la **sicurezza** è la protezione offerta da un sistema informatico automatico al fine di conservare integrità, disponibilità e confidenzialità dalle risorse del sistema stesso
>[!info] la triade
>![[Pasted image 20241217171022.png]]
integrità, disponibilità e confidenzialità
esistono 2 obiettivi che vengono aggiunti al nucleo della sicurezza informatica: autenticità e tracciabilità (accountability)

**integrità**: riferita tipicamente ai dati, che non devono essere modificati senza le dovute autorizzazioni
**confidenzialità**: riferita tipicamente ai dati, che non devono essere letti senza le dovute autorizzazioni
**disponiblità**: riferita tipicamente ai servizi, che devono essere disponibili senza interruzioni
**autenticità**: riferita tipicamente agli utenti, che devono essere chi dichiarano di essere (per estensione, vale anche per dati e messaggi)
**tracciabilità**:
## minacce
l’RFC 2828 descrive quattro conseguenze delle minacce informatiche:
- **unauthorized disclosure**(accesso non autorizzato): un’entità ottiene l’accesso a dati per quali non ha l’autorizzazione (minacciando la confidenzialità)
	- alcuni degli attacchi usati per ottenere l’accesso non autorizzato sono:
		- esposizione 
		- intercettazione 
		- inferenza(non riesco ad accedere ai dati che mi servono, ma riesco a ricavarli da altre informazioni) 
		- intrusione (prepotenza)
- **deception**(imbroglio (lmao)): un’entità autorizzata riceve dei dati falsi e pensa che siano veri (minacciando l’integrità del sistema o dei dati)
	- alcuni degli attacchi usati to deceive sono:
		- mascheramento(un attaccante riesce ad entrare in possesso delle redenziali di un utente autorizzato: **trojan !**) 
		- falsificazione 
		- ripudio (un utente nega di aver ricevuto o inviato dei dati )
- **disruption**(interruzione): impedimento del corretto funzionamento dei servizi (minacciando l’integrità del sistema o la disponibilità dei servizi)
	- alcuni degli attacchi usati to disrupt sono:
		- incapacitazione (rompendo un qualche componente del sistema)
		- ostruzione, per esempio riempiendo il sistema di richieste(**DoS**: denial of service)
		- corruzione
- **usurpation**(usurpazione): il sistema viene direttamente controllato da chi non ne ha l’autorizzazione (minacciando l’integrità del sistema)
	- alcuni degli atttachi usati per usurpare sono:
		- appropiazione indebita, ovvero diventare amministratore di una macchina non propria
		- uso non appropriato (virus che cancella file o fa danni)

## asset
gli asset di un sistema computerizzato sono le sue risorse, e possono essere categorizzati come:
- hardware
- software
- dati
- linee di comunicazione e reti
>[!info] rappresentazione della protezione degli asset
![[Pasted image 20241217173108.png]]

### relazione tra asset e la triade
gli attacchi nella tabella danneggiano gli asset e minacciano l'elemento della triade di cui fanno parte

|                   | disponibilità                                                  | confidenzialità                                                     | integrità                                                                                     |
| ----------------- | -------------------------------------------------------------- | ------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| **hardware**      | workstation rubate o rese inutilizzabili                       |                                                                     |                                                                                               |
| **software**      | programmi cancellati                                           | copia non autorizzata dei programmi                                 | modifica dei programmi (per non farli funzionare o per fargli fare compiti indesiderati)      |
| **dati**          | file cancellati                                                | file letti senza autorizzazione. dati inferiti da analisi statisica | modifica di file esistenti o creazione di file                                                |
| **comunicazione** | messaggi distrutti. linee di comunicazione rese inutilizzabili | lettura dei messaggi o osservazione dei pattern                     | modifica, ritardo, riordino o duplicazone dei messaggi esistenti, creazione di messaggi falsi |
# autenticazione
l’autenticazione è il primo passo da parte del SO per protegere il sistema, e la base per la maggior parte dei tipi di controllo di accesso e tracciabilità
l’autenticazione ha 2 passi:
-  identificazione
- verifica
determina quindi se un utente è abilitato ad accedere al sistema, e determina anche i privilegi dell’utente abilitato (linux !!!!!!)
rende possibile il **discretionary control access**(controllo di accesso discrezionale), in cui un utente può decidere a quali utenti concedere determinati permessi
## mezzi per l’autenticazione
l’autenticazione può essere svolta in 3 fattori: almeno uno deve essere presente, ed è meglio se se ne usano 2 contemporaneamente (autenticazione a 2 fattori)
- qualcosa che sai (password)
- qualcosa che hai (chiave, badge RFID)
- qualcosa che sei (biometrica: impronta, retina, …)
bisogna comunque tenere in considerazione che questi fattori possono avere qualche problema (dimenticarsi la password, perdere un badge, cambiare i connotati (?????))
**autenticazione con password**: quella più nota ed usata, e spesso anche l’unica. è importante che le password siano memorizzate non in chiaro !
**autenticazione con token**: si usano oggetti fisici (**token**) posseduti da un utente per l’autenticazione, ad esempio:
- memory card: possono memorizzare i dati, ma senza elaborarli (es: bancomat tradizionali, carte per acceso a camere d’albergo)
	- svantaggi: serve un lettore apposito, si può perdere il token
- smartcard: hanno un microprocessore, memoria e porte I/O. ne esistono di diversi tipi, a seconda dei seguenti aspetti:
	- caratteristiche fisiche: possono presentarsi come una carta di credito, una chiavetta USB,..
	- interfaccia: spesso serve un lettore apposito
	- protocollo di autenticazione: ci può essere un vero protocollo di autenticazione(domanda-risposta, non possibile per le memory card), e quindi potrebbe esserci un generatore di password statico o dinamico
**autenticazione biometrica**: recentemente, la biometrica si è espansa in autenticazione tramite qualcosa che sei, e autenticazione con qualcosa che fai, che portano a rispettivamente:
- **autenticazione biometrica statica**: include il riconoscimento tramite caratteristiche facciali, impronte digitali, geometria della mano, retina e iride, ma anche riconoscimento basato su pattern, che però è complesso e costoso 
- **autenticazione biometrica dinamica**: include il riconoscimento tramite firma, voce, ritmo di battitura (wpm)
>[!info] costo vs accuratezza !
![[Pasted image 20241217180030.png]]
## controllo di accesso
il controllo di accesso determina quali tipi di accesso sono ammessi, sotto quali circostanze e da parte di chi. può essere:
- discrezionale: un utente può concedere i suoi stessi privilegi ad altri utenti(sulle cose che lui stesso ha creato)
- obbligatorio: un utente non può concedere i suoi stessi privilegi ad altri utenti (molto stringente, usato in ambienti militari (??))
- basato su ruoli
>[!info] info
![[Pasted image 20241217193725.png]]
le 3 modalità possono essere presenti contemporaneamente ! ovviamente applicate a insiemi di risorse diversi
### controllo di accesso discrezionale
>[!info] tabella di controlo direzionale
![[Pasted image 20241217193919.png]]

>[!info] organizzazione del controllo di accesso
![[Pasted image 20241217194306.png|500]]
quando viene fatta una richiesta, viene controllata la tabella (o la struttura che contiene queste informazioni (es, in Linux per i file abbiamo i 3 valori))
inoltre la tabella deve poter evolvere: deve essere possibile scrivere nella tabella (solo da chi ha il permesso)
### controllo di accesso basato su ruoli
 viene implementato il principio di minimo privilegio: esistono dei ruoli, e ciascun ruolo deve contenere il minimo insieme di diritti d’accesso per il ruolo stesso
 - ogni utente è assegnato ad uno o più ruoli, che lo abilitano ad effettuare le operazioni richieste per quel ruolo (ma solo mentre si sta agendo sotto quel ruolo)
 >[!info] rappresentazione grafica dei ruoli
 ![[Pasted image 20241217194925.png|350]]

>[!info] matrice del controllo di accesso: rappresentazione RBAC
in questo caso, sono necessarie 2 matrici: 
la prima identifica i permessi che ha ogni ruolo:
![[Pasted image 20241217195102.png]]
>
la seconda tiene traccia di che ruoli ha ogni utente:
![[Pasted image 20241217195047.png|300]]
# meccanismi di protezione di UNIX
in UNIX, la sicurezza è tipicamente basata sull’autenticazione dell’utente (**User-Oriented Access Control**)
- ci possono essere altri meccanismi (es: NIS, LDAP, Kerberos)
per ogni utente c’è uno *username*(alfanumerico) e un *uid*(numerico intero)
- lo uid è usato ogni volta che occorre dare un proprietario ad una risorsa (file, processi, etc)
ogni utente appartiene ad un gruppo, ed ogni gruppo è identificato da *groupname* e *gid*
le informazioni riguardo i gruppi stessi ed i gruppi a cui appartiene un utente sono contenute in alcuni file di sistema: `/etc/group`, `/etc/passwd`(talvolta in combinazione con `/etc/shadow`)
- dentro `/etc/passwd` potremmo trovare: `sabinar:x:6335:283:Sabrina Rossi:/home/sabinar:/bin/csh`
- dentro `/etc/group` potremmo trovare: `aan:x:283:`(*groupname:x:gid*)
## login
il login può essere fatto su un terminale della macchina (processo `getty`) o tramite rete (`telnet, ssh`)
- richiede una coppia username+password
- se la coppia corrisponde ad una entry di `/etc/passwd`, viene eseguita la shell indicata (`/bin/csh`nel caso di Sabrina Rossi)
- quando la shell esegue `exit`, si ritorna al `getty` o si chiude la connessione di rete
- all’interno di una shell si può cambiare identità con il comando `su` (i used this one !!)
## accesso ai file
per ogni file ci sono tre terne di permessi: **lettura, scrittura ed esecuzione**
- la prima terna è per il proprietario del file, la seconda per il gruppo a cui il proprietario del file appartiene, e la terza per tutti gli altri utenti
	- il proprietario è lo stesso del processo che ha creato il file, ma si può cambiare con `chown`(solo con i permessi sudo)
i diritti si possono cambiare con `chmod` !!

le terne di diritti sono usate ogni volta che un processo richiede l’accesso ad un file: si trova la terna a cui appartiene il processo e si prende l’elemento della terna corrispondente all’accesso richiesto
```
**esempio (federico è il proprietario, ed appartiene al gruppo em)
-rwxr-xr-x 1 federico em 5120 Nov 7 11:03 a.out
-rw-r--r-- 1 federico em 233 Nov 7 11:03 test.c
```

gli eseguibili hanno permesso `x`, e quando vengono eseguiti, il proprietario del processo creato è l’utente che ha eseguito il file (non l’utente che ha creato il file). ciò vale anche per i comandi (`ls` è un file creato da root, ma un utente lo può eseguire)
## SETUID e STGID
può capitare che un utente debba essere messo nelle condizioni di eseguire comandi o modificare file a cui, in generale, non ha permesso (in situazioni particolari)
- per rendere ciò possibile, alcuni comandi (generalmente creati da root ?) hanno come elemento nella terna `s`, un permesso speciale che permette agli utenti di eseguire il file con i permessi sul file del proprietario
```
-rwxr-xr-x 1 federico em 5120 Nov 7 11:03 a.out
-rw-r--r-- 1 root root 1715 Oct 12 2014 /etc/passwd
-r-sr-sr-x 1 root sys 21964 Apr 7 2002 /bin/passwd
```
se invece, al posto di `x`, è presente `s`, l’utente può eseguire il file, e quando viene eseguito, l’utente viene “castato” all’utente proprietario del file


>[!info] se il permesso `x` non è impostato, non è possibile eseguire un file ! (ma può essere possibile leggerlo e modificarlo, se permesso)

tali permessi possono esser accordati solo da un utente amministartore, con `chmod u+s nomefile` e/o `chmod g+s nomefile`
- con questi comandi, l’`uid` o il `gid` del processo non sono quelli dell’utente che lo ha lanciato, ma del proprietario del file eseguibile
>[!warning] meccanismo da usare con estrema cautela ! facile fare attacchi `rootkit`
