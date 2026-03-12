---
created: 2024-10-15
related to: "[[gestione dei processi]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [motivi per usare i thread](#motivi%20per%20usare%20i%20thread)
>- [tipi di thread](#tipi%20di%20thread)
>- [ULT (User Level Thread)](#ULT%20(User%20Level%20Thread))
>- [KLT (Kernel Level Thread)](#KLT%20(Kernel%20Level%20Thread))
>- [thread in Linux](#thread%20in%20Linux)
>- [ambiguità dei nomi](#ambiguit%C3%A0%20dei%20nomi)
>- [stati dei processi in Linux](#stati%20dei%20processi%20in%20Linux)
# thread
fino a quanto studiato, ogni processo compete con tutti gli altri per l’esecuzione: grazie a una parallelizzazione che può essere:
- finta: c’è solo un processore, i processi vengono swappati troppo in fretta perchè l’utente se ne accorga
- vera: ci sono più processori (o un processore con più core)
per alcune applicazioni, però, è importante che esse siano a loro volta organizzate in parallelo
>[!example] esempio
per esempio, un’applicazione grafica potrebbe essere suddivisa in 3 computazioni: una che ascolta input, una che ridisegna la finestra, e un’altra che fa i calcoli necessari

alcune applicazioni vengono suddivise a loro volta in più esecuzioni: i thread
i diversi thread in un processo condividono quasi tutte le risorse(tra cui memoria, files, dispositivi di I/O), tranne:
- stack delle chiamate e quindi variabili locali
- il processore

>[!figure] ![[Pasted image 20241015085415.png]]
>modi diversi di gestire i thread 

>[!figure] ![[Pasted image 20241014195251.png]]
user addres space: la parte dell’immagine condivisa tra i thread
thread control block: gestisce solo la parte di scheduling
## motivi per usare i thread
- è più efficiente la creazione, terminazione, fare lo switching e farli comunicare
	- infatti spawn (operazione per creare un nuovo processo su un thread) è più leggera di fork, in quanto devo “fare meno cose” (a livello di scrittura di PCB)
altre operazioni possibili su thread:
- spawn 
- block: non per I/O, ma esplicito (es: deve aspettare un alto thread)
- unblock: esplicito
- finish
# tipi di thread
>[!figure] ![[Pasted image 20241014195754.png]]
ULT: i thread vengono gestiti a livello utente, quindi il SO non ha idea dell’esitenza di essi
KLT: il SO è a conoscenza e gestisce i thread dei processi
## ULT (User Level Thread)
vantaggi degli ULT:
- switch tra thread più efficiente: non devo fare il mode switch al kernel
- permettono di usare i thread in sistemi operativi che non li offrono nativamente
svantaggi degli ULT:
- se un thread si blocca (blocked, non block chiamato dal processo), tutti i thread si bloccano perchè il SO non sa che ci sono altri thread di quel processo da poter eseguire
- se ci sono più cores, il SO pensa che ci sia comunque un solo thread, quindi è meno efficiente
## KLT (Kernel Level Thread)
vantaggi dei KLT: 
- se un thread si blocca, si blocca solo il thread richiedente (dato che SO sà dell’esistenza degli altri thread del processo)
# thread in Linux
Linux deriva da Unix, che non aveva i thread
i thread si chiamano LWP in linux, e sono possibili sia i KLT(usati principalmente dal SO) che gli ULT(che vengono però poi mappati in KLT)
## ambiguità dei nomi 
usando il comando `ps` su terminale, possiamo vedere il PID dei processi: esso è unico per tutti i thread del processo
i vari thread del processo vengono identificati con il **tid(task identifier)**. il tid non è un numero che va da 1 a n, bensì è strettamente collegato al PID che vediamo con `ps` :
- il pid(entry del PCB) è unico per ogni thread, proprio perchè l’unità base, LWP, coincide con il processo di thread.
- l’entry del PCB che dà il PID comune a tutti i thread di un processo (e quindi quello che vediamo con `ps`) è il **tgid(thread group identifier)**: il tgid coincide con il PID del primo thread del processo, e per questo esiste sempre un thread con PID uguale al tgid
- una chiamata a getpid() restituisce il tgid
- c’è un PCB per ogni thread, quindi diversi thread di uno stesso processo duplicheranno diverse informazioni, ma visto che si tratta di puntatori l’overhead è basso
quindi: PID di `ps` è il tgid. il PID vero (quello dei LWP) è indicato come LWP o SPID o TID
>[!figure] ![[Pasted image 20241015091559.png]]  
> - la struttura `thread_info` è organizzata per contenere anche il kernel stack(lo stack delle chiamate da usare quando il processo passa in kernel mode)
> - `thread_group` punta agli altri thread in questo stesso processo
> - `parent` e `real_parent` puntano al padre del processo
> - ci sono anche puntatori per fratelli e figli
![[Pasted image 20241015092351.png]]

## stati dei processi in Linux
Linux usa sostanzialmente un sistema a 5 fasi (quindi senza menzione esplicita a processi suspended), inoltre:
- non c’è distinzione tra ready e running
- il blocked del modello a 5 stati è diviso a seconda del motivo per cui sono blocked
- esiste lo stato `TASK-UNINTERRUPTIBLE`: se un processo ha questo stato, esso non si può uccidere (sta facendo cose importanti)