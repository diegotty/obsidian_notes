---
related to:
created: 2025-03-02T17:41
completed: true
updated: 2025-11-21T11:32
---
>[!index]
>- [filesytem](#filesytem)
>	- [mounting](#mounting)
>		- [tipi di filesystem](#tipi%20di%20filesystem)
>	- [file `passwd` e `group`](#file%20%60passwd%60%20e%20%60group%60)
>	- [i file](#i%20file)
>	- [`ls`](#%60ls%60)
>	- [permessi di accesso a file](#permessi%20di%20accesso%20a%20file)
>		- [permessi speciali](#permessi%20speciali)
>			- [sticky bit](#sticky%20bit)
>			- [setuid bit](#setuid%20bit)
>			- [setgid bit](#setgid%20bit)
>	- [comandi](#comandi)
# filesystem
i file regolari contengono sequenze di bit dell’area di memoria sulla quale c’è il filesystem **
- possono essere ASCII o binari
esiston anche **file non regolari, o speciali**, che modellano unità di I/O
- possono essere a blocchi/caratteri
>[!tip] ~ equivale a /home/userX
>ed è la home directory del current user
i comandi che iniziano con `~` sono comunque considerati path assoluti (oltre ai comandi che iniziano con `/home/userX/`)

>[!info] fun facts
 >- path assoluto è valido qualunque sia la `cwd`, mentre il path relativo può non essere valido quando si cambia `cwd`
 >- per visualizzare l’albero delle directory, si usa il comando `tree [-a] [-L maxdepth] [-d] [-x] [nomedir]`
 >	- `-d` mostra solo le directory
 >	- `-x` si usa per rimanere nel filesystem  corrente (se incontra un mount point di un altro filesystem, non lo esplora)

## mounting
li filesystem root (`/`) contiene elementi eterogenei: 
- disco interno
- filesystem su disco esterno
- filesystem di rete
- filesytem virtuali (usati dal kernel per gestire risorse)
- filesystem in memoria principale..
una qualsiasi directory $D$ dell’albero gerarchico può diventare il punto di mount per un altro (nuovo) filesystem $F$ se e solo se la directory root di $F$ può essere accessibilie d $D$
- se $D$ è vuota, dopo il mount conterrà $F$
- se $D$ non è vuota, dopo il mout conterrà $F$, ma ciò non significa che i dati che vi erano dentro sono persi: saranno di nuovo accessibili dopo l’unmount di $F$

| directory | spiegazione                                           | montata           |
| --------- | ----------------------------------------------------- | ----------------- |
| `/boot`   | kernel e file di boot                                 | no                |
| `/bin`    | binari (eseguibili) di base                           | no                |
| `/dev`    | periferiche hardware e virtuali (devices)             | boot              |
| `/etc`    | file di configurazione di sistema                     | no                |
| `/proc`   | dati e statistiche di processi e parametri del kernel | boot              |
| `/sys`    | informazioni e statistiche di device di sistema       | boot              |
| `/media`  | mountpoint per device di I/O                          | quando necessario |
| `/mnt`    | come `/media`                                         | quando necessario |
| `/sbin`   | binari di sistema                                     | no                |
| `/var`    | file variabili (log, code di stampa, mail...)         | no                |
| `/tmp`    | file temporanei                                       | no                |
| `/lib`    | librerie                                              | no                |


>[!summary] esempi di opzioni di mounting comuni
>
> | opzione    | significato                                                            |
> | ---------- | ---------------------------------------------------------------------- |
> | `ro`       | read-only                                                              |
> | `rw`       | read-write                                                             |
> | `noexec`   | non permette l'esecuzione di file binari                               |
> | `nosuid`   | disabilita i bit SUID e SGID (vedi [[#permessi speciali|sotto]] )                               |
> | `nodev`    | non permette dispositivi a livello di file                             |
> | `relatime` | aggiorna il tempo di accesso solo se più vecchio del tempo di modifica |
> | `noatime`  | non aggiorna il tempo di accesso                                       |
> | `sync`     | tutte le scritture avvengono in modalità sincrona                      |
> | `user`     | permette agli utenti normali di montare il filesystem                  |
> | `uid=1000` | imposta l'utente proprietario                                          |
> 

>[!info] partizioni e mounting
un singolo disco può essere diviso in due o più partizioni ! e ciò ha molto senso. presumiamo che una partizione $A$ contenta il SO e la partizione $B$ contenga i dati degli utenti.
>- se devo reinstallare il SO in $A$, non tocco i dati e mi basta rimontare $B$, e se voglio installare diverse distro di linux in altre partizioni (es: $C$), posso allo stesso modo avere i dati degli utenti senza copiarli, ma semplicemente montando $B$
### tipi di filesystem
come sappiamo da [[filesystem in UNIX, Windows, Linux|os1]], esistono diversi tipi di filesystem. dal punto di vista del programmatore, il tipo di filesystem definisce la codifica dei dati, mentre dal punto di vista dell’utente cambiano la dimensione massima di una partizione, di un file, di un nome di file, e se usa il journaling oppure no
>[!example] filesystem non linux
>esistono ovviamente filesystem “non linux”: NTFS, MSDOS, FAT32, FAT64
>- FAT ed NTFS possono essere montati su di un filesystem linux (lo sappiamo già !)

`mount` è il comando per montare un filesystem, e visualizzare i filesystem montati
## file `passwd` e `group`
si trovano entrambi in `/etc/`, e il loro uso rappresenta una delle filosofie di linux: usare file di testo con una struttura definita e conosciuta dai programmi che devono interagire con quei file (in questo caso, `adduser` conosce la struttura di questi due file)
la struttura è stata spiegata in [[passwords]]
## i file
come visto in [[filesystem in UNIX, Windows, Linux#inode]], ogni file nel filesystem è rappresentato da una struttura dati **inode**, e ogni file è unicamente identificato da un **inode number**. 
- la cancellazione di un file libera l’inode number che verrà riutilizzato quando necessario per un nuovo file
>[!info] come viene seguito un path
![[Pasted image 20250315190353.png]]
### inode
i principali attributi degli inode sono:
- **type** ⟶ tipo di file (regular, block...)
- **user ID** ⟶ ID del proprietario del file
- **group ID** ⟶ ID del gruppo a cui appartiene il proprietario
- **mode** ⟶ permessi (read, write, exec) di accesso per proprietario, gruppo e tutti gli altri
- **size** ⟶ dimensione in byte del file
- **timestamps**
	- *ctime* ⟶ modifica di metadati
	- *mtime* ⟶ modifica (solo scrittura)
	- *atime* ⟶ access time (solo lettura)
- **link count** ⟶ numero di hard links
- **data pointers** ⟶ puntatore alla lista dei blocchi che compongono il file (se si tratta di una directory, il contenuto su disco è costituito da due colonne: nome del file/directory e relativo inode number)
## `ls`
per visualizzare gli inode, basta usare il flag `-i` con il comando `ls`
>[!info] ls -l
![[Pasted image 20250315190629.png]]
>- la dimensione (quinta colonna) indica quanto effettivamente è occupato dal file: per le directory, la dimensione del file speciale, contenente la lista di coppie è solitamente 4kb, ma più file ci sono più la dimensione è grande (es: `/lost+found`)
>- il numero dopo i diritti di accesso invece indica il numero di directory all’interno della directory, in cui vengono contate anche `.` e`..` (infatti per il file è 1)
>- la prima riga invece, `totale 44` indica la dimensione della directory in blocchi su disco (tipicamente un blocco ha dimensione tra 1kb e 4kb). ma solo della directory attuale, non per tutto il sottoalbero !! per ogni sottodirectory, considera solo la dimensione del file speciale contenente le coppie

### ls flags
- `[-a/--all]`: permette di vedere anche i file nascosti (che iniziano con `.`)
- `[-i/--inode]`: mostra l’inode number di ogni file
- `[-n]`: visualizza GID e UID come numeri invece del nome esteso 
- `[-t/--time=WORD]`: ordina per timestamp (`WORD`indica per quale timestamp. x default `--time=mtime`)
- `[-r/--reverse]`: reverse order
- `[-R/--recursive]` visualizza ricorsivamente il contenuto delle sottodirectory
- `[-s/--size]`: mostra dimensione, in blocchi, di ogni file
- `[-d/--directory]`: mostra le informazioni sulla directory stessa e non sui suoi contenuti
- `[--hide=PATTERN]`: non mostra le entry che corrispondono al pattern
- mostra timestamps (flags da usare con `[-l]`):
	- `[-c]`: ctime
	- `[-u]`: atime
	- default è mtime
## permessi di accesso a file
it pains me to write it a 3rd time, here is a table
>[!info]- @@@@
![[Pasted image 20250315191911.png]]
![[Pasted image 20250315191857.png]]

>[!info] permessi in dir
>- `r`: permette di elencare i file all’interno della cartella, ma non di accedere ai loro contenuti ne metadati (quindi no `ls -la`)
>- `w`: permette di creare, rinominare o eliminare file, **se è presente anche `x`**
>- `x`: permette di entrare nella dir (`cd`), usare i file al suo interno (anche se non si possono elencare i file (assenza di `r`))
>
>se `r-x`, è possibile usare i file, entrare nella dir, ma non creare/rinominare o eliminare file
### permessi speciali
esistono permessi speciali, applicabili a file e directory, ed esiste un quarto bit the prende come valore la somma tra i valori dei permessi speciali attivi 
#### setuid bit (4)
si usa solo per file eseguibili: quando vengono eseguiti, i privilegi con cui opera il corrispondente processo non sono quelli dell’utente che esegue il file, bensì quelli dell’utente proprietario del file ! (se il proprietario è `root`, il processo viene eseguito con i privilegi di `root` indipendentemente da chi lo ha eseguito)
- es: il comando `passwd` ha il setuid, che permette ad un utente di modificare la propria password (il proprietario del comando è root)
il setuid bit viene visualizzato al posto del bit di esecuzione nella terna `user`, con la lettera `s` se `x` è attivo, o la lettera `S` se `x` non è attivo
#### setgid bit (2)
simile al setuid bit, ma in questo caso i privilegi del processo sono quelli del gruppo che è proprietario del file
- può essere applicato anche ad una directory, e allora ogni file creato al suo interno ha il gruppo della directory, anzichè quello primario di chi crea i files !
il setgid bit viene visualizzato al posto del bit di esecuzione nella terna `group`, con la lettera `s` se `x` è attivo, o la lettera `S` se `x` non è attivo
#### sticky bit (1)
viene applicato su directory (inutile su file) per correggere il comportamento di `w+x` che permette la cancellazione di file all’interno della directory anche se non si hanno i permessi di scrittura sui file stessi
- grazie allo sticky bit, per cancellare un file $f$, un utente non proprietario **deve** avere i permessi di scrittura su $f$, e non solo sulla directory a cui $f$ appartiene
lo sticky bit viene visualizzato al posto del pbit di esecuzione nella terna `other` con la lettera `t` se `x` è attivo, o la lettera `T` se `x` non è attivo
## comandi
>[!info] comandi
>### $\verb |chmod [mode] filename|$
>può settare i diritti di accesso in formato ottale:
>- primo numero rappresenta `setuid`(4)+`setguid`(2)+`sticky`(1)
>-  gli altri 3 bit rappresentano user, group, other
>### $\verb |chmod [mode simbolica]|$
>può settare i diritti di acesso usando simboli con aggiunta di `[lettere tra {ugoa}] [+-=] [0 o più lettere tra {rxwXst}]`
>### $\verb |chown [-R] propietario {file}|$
>cambia proprietario del file
> - `-R`: recurisve (si applica a tutte le sottodirectory)
>### $\verb |chgrp [-R] gruppo {file}|$
>cambia il gruppo 
>### $\verb |umask [mode]|$
>setta la maschera dei file(cioè i diritti di accesso al file o alle directory nel momento della loro creazione) a `mode`
>- per i file però, il diritto di esecuzione non viene settato (quindi le opzioni speciali non hanno effetto, in quanto prendono il posto del bit di esecuzione in terne diverse)
>
> la maschera può essere:
>- un numero ottale da uno a 4 cifre, secondo la rappresentazione dei permessi, che indica i permessi che si desidera **negare** (quindi, per esempio, `1` negherà il permesso di esecuzione)
>- una stringa secondo la rappresentazione simbolica dei permessi che indica l’insieme dei permessi che possono essere **concessi**
>### $\verb |cp [-r] [-i] [-a] [-u] {filesorgenti} filedestinazione|$
>- `-r`: recursive, per directory
>- `-i` interactive, per essere avvisati in caso di sovrascrittura
>- `-u` la sovrascrittura avviene solo sel l’`mtime` del sorgente è più recente di quello della destinazione (cool !)
>- `-a`: archive: i file copiati vengono mantengono i loro permessi, proprietari, timestamp e altri attributi
>- `-b`: fa un backup dei file già esistenti nella destinazione (in modo tale che non vengano sovrascritti)
>- `-l`: invece di copiare, crea hard link
>- `-s`: invece di copiare, crea symlink
>- `--preserve=ATTR_LIST`: permette di preservare gli attributi specificati (es: `mode, ownership, timestamps, all, ...`)
>### $\verb |mv [-i] [-u] [-f] {filesorgenti} filedestinazione|$
>sposta un file o lo rinomina !
>- `-i` e`-u` hanno lo stesso significato che hanno in `cp`
>- `-f`: non chiede prima di sovrascrivere (force). è di default !
>### $\verb |rm [-f] [-i] [-r] {file}|$
>- `-f` forza la cancellazione (senza chiedere)
>### $\verb | ln [-s] sorgente [destinazione]|$
>-`-s` per symbolic link, altrimenti hard link
>>[!info] reminder
>>l’hard link crea un file che punta all’inode del file referenziato, mentre il symlink crea un file che contiene il path the file referenziato
>### $\verb |touch [-a] [-m] [-t timestamp] {file}|$
>serve per creare un file, o modificare il suo timestamp
>- può essere applicato anche su dir
>- `-t` setta il timestamp desiderato
>- `-m`: cambia solo il modified time
>- `-a`: cambia solo l’access time
>### $\verb |du [-c] [-s] [-a] [-h] [--exclude=PATTERN] [files]|$
>calcola la dimensione dei file e/o dir dati come argomento 
>- `-c/--total`: restituisce **anche** la somma totale delle dimensioni
>- `-s/--summarize`: invece di dimostrare la dimensione di ogni file (e diirectory) all’interno di ogni directory in input, mostra la dimensione totale per ogni directory in input (non cambia nulla se in input vengono passati dei file)
>- `-a/--all`: mostra anche sottodirectory (quindi tutti **i file** in esse, in quanto `du` è già ricorsivo per le directory)
>- `-h/--human-readable`: mostra le dimensioni in formati leggibili: mb, gb, etc
>### $\verb |df [-h] [-l] [-i] [file]|$
>mostra la dimensione e l’atttuale uso del filesystem
>- `-h` come in `du`
>- `-i/--inodes`: mostra le informazioni sugli inode invece che sui blocchi
>- `-l/--local`: mostra solo i filesystem locali
>- se viene passato un file in input, mostra le informazioni relative al filesystem che contiene il file fornito in input
>### $\verb | dd [opzioni] |$
>**convert and copy a file**
>- serve per creare file in modo elaborato: le opzioni sono una sequenza `variabile=valore`, e le variabili più importanti sono:
>- - `bs`: dimensione di un singolo blocco in lettura/scrittura  in byte (default è 512 byte)
>- `count`: numero di blocchi da copiare dall’input
>- `conv`: il valore specifica una conversione, per esempio di codifica (`ucase/lcase/noerror`(skip bad blocks))
>- `if` file di input (se non dato, legge da tastiera)
>- `of` file di output (se non dato, scrive su schermo)
>- `skip`: skippa i primi N blocchi del file di input
>- `seek`: skippa i primi N blocchi del file di output
>oltre che per le conversioni, si usa per copiare file speciali che non possono essere copiati con `cp`
>### $\verb |mkfs [-t type fsoptions] device|$
>crea un filesystem su device (prepara i file a memorizzare file secondo un dato formato, es [[filesystem in UNIX, Windows, Linux#gestione file system in Linux|ext4]])
>- `-t`: type, specifica il tipo di filesystem da creare
>- `fsoptions`: `ro` oppure `rw`
>- `device`: nome del dispositivo

>[!info] file e gruppi
>oltre all’`owner`, esiste anche un `group owner` per ogni file e directory. il group owner identifica il gruppo proprietario del file
>- di default, il group owner di un file è il gruppo primario dell’utente che lo crea
il group owner determina chi altro può accedere al file, based on the group (è il gruppo a cui si riferiscono le group permission)