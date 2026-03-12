---
created: 2024-11-25
related to: "[[gestione della memoria secondaria]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [inode](#inode)
>	- [directory](#directory)
>- [gestione file condivisi](#gestione%20file%20condivisi)
>- [gestione dei file su windows](#gestione%20dei%20file%20su%20windows)
>- [FAT](#FAT)
>	- [regioni del volume](#regioni%20del%20volume)
>	- [limitazioni](#limitazioni)
>- [NTFS](#NTFS)
>	- [MFT](#MFT)
>		- [record di MFT](#record%20di%20MFT)
>		- [files in MFT](#files%20in%20MFT)
>- [gestione file system in Linux](#gestione%20file%20system%20in%20Linux)
# gestione dei file in UNIX
in UNIX ci sono 6 tipi di file:
- normale
- directory
- speciale (i file che mappano su nomi di file i dispositivi di I/O,etc )
- named pipe (per far comunicare i processi tra loro)
- hard link (collegamenti, per dare un nome di file alternativo)
- symbolic links
## inode
sta per “**index node**”, è una struttura dati che contiene informazioni essenziali per un dato file (simile al PCB ! ma per i file)
- ogni inode è associato ad un solo file, ma grazie agli hard link in UNIX un dato inode può essere associato a più **nomi** di file
viene mantenuta dal SO, in memoria principale, una tabella di tutti gli inode corrispondenti a file aperti
- tutti gli altri inode sono in una zona del disco dedicata (**i-list**) (in LINUX si trova all’inizio del disco !)
>[!info] gestione dei file aperti
![[Pasted image 20241123125404.png]]
il kernel unix usa due strutture di controllo separate per gestire file aperti e descrittori inode: 
>- puntatore a descrittori dei file attualmente in uso, salvato nel [[gestione dei processi#process control block|PCB]]
>- una tabella globale di descrittori di file aperti, mantenuto in una apposita struttura dati (quella in mezzo credo)

ogni inode è associato ad un **inode number** (incrementale)
>[!info] rappresentazione inode
![[Pasted image 20241123085909.png]]
>l’inode è la parte a sinistra dell’immagine (contiene quindi diverse informazioni)
>- le celle `direct(0), direct(1)` contengono puntatori a effettivi indirizzi del disco (quindi per i file piccoli (di massimo 13 blocchi), verrano utilizzati SOLO le celle `direct`). esse contengono i blocchi in ordine !
>- esistono poi altri puntatori: `single indirect, double indirect, triple indirect`
>- `single indirect`: punta ad un blocco nel disco, che è indicizzato (contiene le posizioni dei blocchi nel disco che contengono dati del file, come in [[#allocazione indicizzata]])
>- `double indirect`: funziona allo stesso modo del `single indirect` ma con un livello di blocco indicizzato in più
>- `triple indirect`: funziona allo stesso modo del `double indirect` ma con un livello di blocco indicizzato in più
>
> ovviamente non serve tenere conto del fatto che un blocco sia dato o tabella, in quanto, questa informazion si conosce già, in base a da cosa viene puntato il blocco

l’inode contiene:
- 3(3 in Linux, 4 in UNIX) time stamp: ultimo accesso in lettura, ultimo accesso in scrittura, metadati(?)
- identificatore dell’utente proprietario e del gruppo a cui tale utente appartiene
- informazioni sul controllo di accesso (permessi)
- tempo di creazione e di ultimo accesso
- flag utente e flag per il kernel
- numero sequenziale di generazione del file
- dimensione delle informazioni aggiuntive
- altri attributi (controllo di accesso e altro)
- dimensione
- numero di blocchi, o numero di file
- dimensione dei blocchi
- sequenze di puntatori a blocchi
l’allocazione è quindi: a blocchi, dinamica, e indicizzata (anche se parte dell’indice è memorizzata nell’inode)
>[!info] risultati con inode
![[Pasted image 20241123091622.png]]
### directory
le directory sono una lista di coppie (nome di file, puntatore ad inode)
>[!example]
quind se un file si chiama “pippo” e il suo inode number è 100, basta andare nella **i-list** e prendere l’inode 100 (che è facile, basta saltare i primi 99 (che immagino abbiano tutti la stessa dimensione, quindi dovrebbe essere veramente facile)), e una volta ottenuto l’inode abbiamo tutte le informazioni che ci servono sul file

più file sono messi in una directory, più grande è la directory (anche se di solito bastano i puntatori `direct` per gestire una directory)
>[!info]  rappresentazione directory
![[Pasted image 20241123084739.png|350]]

>[!info] regioni del volume
![[Pasted image 20241123124845.png]]
**regione boot sector**: simile a blocco di boot per [[#FAT]], contiene le informazioni e i dati necessari per il bootstrap
**regione superblock**: contiene informazioni sui metadati del filesystem (dimensione della partizione, dimensione dei blocchi, puntatore alla lista dei blocchi liberi, etc). esistono copie multiple di questa regione, in caso di corruzione, e sono salvate in gruppi di blocchi sparsi nel file system (la prima copia è sempre in una parte prefissata della partizione, in modo da consentire recovery in modo semplice)
**regione lista degli inode**: la i-list !!
## gestione file condivisi
come gestire i file che devono essere condivisi in più directory ? fare una copia del file è inutilmente costoso. esisono 2 soluzioni:
**symbolic links**: esiste un solo descrittore (inode) del file originale, e i symlinks contengono il cammino completo sul filesystem verso tale file (stanno quindi dove dove NON si trova il file, altrimenti sarebbe inutile)
- possono esiste symlinks a file non più esistenti
**hard links**: sono un puntatore diretto al descrittore del file originale(inode), e il file condiviso non può essere cancellato finchè esiste un hard link collegato ad esso
- per gestire ciò, l’inode contiene un contatore dei file che lo referenziano
# gestione dei file su windows
esistono 2 tipi di file system su windows:
- FAT(file sytem vecchio): si basa su allocaz*ione concatenata, con blocchi (chiamati **cluster**) di dimensione fissa
- NTFS(file system nuovo): si basa su alloaczione **con bitmap**, con cluster di dimensione fissa
## FAT
è molto limitato (andava bene per i vecchi dischi, soprattutto i floppy), ma è usato ancora oggi per le chiavette USB
- inoltre l’approccio in sè non è scalabile, in quanto la FAT stessa può occupare molto spazio
esiste una parte di disco usata per l’area riservata, che contiene dei dati
la FAT (**file allocation table**) è memorizzata all’inizio della partizione su disco, e ce ne sono 2 copie (per ridondanza)
- essa è costituita da una sola colonna, ed ogni riga contiene un valore intero a 12,16 o 32 bit (FAT-12, FAT-16, FAT-32)
- ci sono tante righe quanti ci sono cluster, e ogni cluster ha dimensione fissa, che viene scelta dall’utente in fase di formattazione e può andare da 2KB a 32KB
	- di conseguenza, la tabella cresce con la grandezza della partizione
- ogni cluster è costituito da settori di disco contigui
>[!info] rappresentazione FAT
![[Pasted image 20241123101452.png]]
ogni file ha una specie di inode che contiene il nome del file e l’entry (nella FAT) collegata al cluster che contiene quel file
il FAT funziona similarmente alla [[#allocazione concatenata]], ma i puntatori non sono dentro la partizione, ma sono i valori della FAT
per ogni entry della FAT, ci possono essere 3 opzioni riguardo al valore di una riga (cluster): 
>- se la i-esima entry è zero, il blocco i-esimo è libero
>- se la i-esima entry non è zero e non è un valore speciale, allora il cluster associato contiene il file e il valore della riga è la prossima riga che contiene il file
>- ci sono diversi valori speciali (per valori riservati, cluster danneggiati, etc) ma a noi interessa il valore speciale `FFFF` (nel FAT-16, cioè tutti 1), che vuol dire che quella riga era l’ultimo blocco del file

ciò consente di identificare i blocchi di un file e accedervi seguendo sequenzialmente i collegamenti nella FAT
>[!warning] la parte della FAT relativa ai file aperti deve essere sempre mantenuta interamente in memoria principale
### regioni del volume
>[!info] rappresentazione delle regioni di un volume FAT
![[Pasted image 20241123101018.png]]
>- **regione boot sector**: contiene informazioni necessarie per l’accesso al volume, tra cui il tipo (del volume ? \\QUESTION) e puntatori alle altre sezioni del volume
> - **regione FAT**: due copie della FAT, in caso la tabella principale sia corrotta
> - **regione root directory**: è una **directory table** che contiene tutti i file entry per la directory root del sistema (la dimensione della table è limitata a 256 entry in FAT-12 e FAT-16, mentre in FAT-32 è inclusa nella regione dati, insieme a file e directory normali, e non ha limitazioni sulla dimensione)
> - **regione dati**: è la regione del volume in cui sono effettivamente contenuti i dati dei file e directory

per le directory, al posto di essere una lista con entrate del tipo “nomefile-numero inode", le directory sono liste con entrate del tipo “nomefile-insieme di dati”, e l’insieme di dati è il seguente:
>[!info] 
>![[Pasted image 20241123115042.png|900x500]]
>- 32 byte in tutto
>- quindi l’illustrazione nella rappresentazione del FAT è una semplificazione !
### limitazioni
- supporta file di dimensione massima 4GB (32 bit nel campo dimensione file nelle directory)
- non implementa journaling
- non consente alcun meccanismo di controllo di accessi ai file/directory
- limite dimensione partizioni: 2TB ($2^{32}$ settori da 512B)
## NTFS
 sta per **new technology file system**, è il file sytem adottato a partire da Windows NT in poi
 - usa UNICODE per l’encoding dei nomi dei file, con 255 caratteri come limite massimo
 - i file sono definiti da un insieme di attributi, che sono rappresentati come un **byte stream**
 - supporta hard e soft link 
 - implementa journaling
 >[!info] formato del volume
 ![[Pasted image 20241123121915.png]]
 **regione boot sector**: basata sull’equivalente FAT, alcuni campi sono in posizioni diverse ma per il resto è uguale
 **master file table**: contiene la MFT
### MFT
la **master file table** è la principale struttura dati del file system: è unica per ciascun volume, ed è implementata come un file
- la MFT è una sequenza lineare di record (massimo $2^{48}$, la cui dimensione va da 1KB a 4KB(penso funzioni a scelta in fase di formattazione come in FAT)), e ogni record descrive un file
#### record di MFT
ogni record è identificato da un puntatore di 48bit, mentre i rimanenti 16bit sono usati come numero di sequenza
- ogni record contiene una lista di attributi (nella forma “attributo(intero, che indica il tipo di attributo)-valore(sequenza di byte)”)
- il contenuto di un file è anch’esso un attributo !(`$DATA`)
- il valore dell’attributo può essere incluso direttamente nel record (**attributo residente**), oppure può essere un puntatore ad un record remoto (**attributo non residente**) se il valore dell’attributo è troppo grande e non sta nel record (il caso di `$DATA`)
i primi 27 record sono riservati per i metadati del file system:
- il record 0 descrive l’MFT stesso (in particolare, tutti i file nel volume (damn))
- il record 1 contiene una copia dei primi record dell’MFT, in modo non residente
- il record 2 contiene le informazioni di journaling (metadata-only !)
- il record 3 ha le informazioni sul volume (id, label, versione del file system, etc)
- il record 4 è una tabella degli attributi usati nella MFT (definisce un intero per ogni attributo)
- il record 6 definisce la lista dei blocchi liberi, usando una bitmap
dal record 28 in poi, ci sono i descrittori dei file normali (sempre in forma di record)
>[!info] rappresentazione MFT
>![[Pasted image 20241123123045.png|500]]
#### files in MFT
NTFS cerca sempre di assegnare ad un file sequenze contigue di blocchi
- per i file piccoli (< 1KB), i dati sono salvati direttamente nell’MFT (nel record penso intenda, in particolare nell’attributo `$DATA`)
- per i file grandi, il valore dell’attributo(`$DATA`) indica la sequenza ordinata dei blocchi sul disco dove risiede il file
per ogni file, esiste un record base nell’MFT
>[!info] record base
![[Pasted image 20241123123952.png]]
in questo esempio, il file ha dimensione 9 blocchi, divisi in 3 **run** (dal blocco 20, 4 blocchi contigui hanno dati del file. dal blocco 64, 2 blocchi contigui hanno dati del file, etc)
il record base è un descrittore singolo sufficiente per l’intera lista di run, infatti consente di descrivere file di dimensione potenzialmente illimitata: dipende tutto dalla contiguità dei blocchi
>- con blocchi da 1KB, un file da 20GB diviso in 20 run da 1M di blocchi ognuna, richiede 20 coppie di 64 bit (ogni coppia determina una run), più un’altra coppia \\QUESTION(credo c’entri con lo 0), quindi in totale il record base occupa **336B**
>- sempre con blocchi da 1KB, un file da 64KB, con 64 run da 1 blocco occupa **1040B**

file di larghe dimensioni (e/o sfortunati con la contiguità), possono necessitare di più record, e per gestire ciò NFTS usa una tecnica simile agli inode di UNIX:
- il record base ““diventa” un puntatore a $N$ record secondari, ed eventuale spazio rimanente nel record base contiene le prime sequenze del file (very cool !!)
- se i record estesi non rientrano in MFT per mancanza di spazio, vengono trattati come attributo non residente, e quindi salvati in un file dedicato, con un apposito record salvato nell’MFT
>[!info] record con estensioni
![[Pasted image 20241123124504.png]]

# gestione file system in Linux
il file system originario di Linux è **ext2**, che è l’evoluzione (se non la copia) del file system originario di UNlX
in seguito, è stato creato **ext3**, che aggiungeva il journaling all’ext2
ancora in seguito, è stato creato **ext4**(l’attualmente più utilizzato), una versione migliore dell’ext3 in grado di memorizzare singoli file più grandi di 2TB e filesystem più grandi di 16TB
in generale, quindi, il file sytem di Linux è fortemente basato sugli inode, che sono memorizzati nella parte iniziale del file sytem
>[!info] linux può tranquillamente utilizzare i filesystem FAT e NTFS
>sorge un problema, in quanto FAT e NTFS non sono basati su inode: per rimediare, gli inode vengono creati on-the-fly su una cache quando vengono aperti i file o viene letta una directory