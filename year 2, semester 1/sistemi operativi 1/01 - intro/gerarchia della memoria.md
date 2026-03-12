>[!index]
>- [outboard memory](#outboard%20memory)
>- [inboard memory](#inboard%20memory)
>- [cache](#cache)

>[!figure] ![[Pasted image 20241006111648.png]]

dall’alto verso il basso:
- diminuisce la velocita di accesso
- diminuisce il costo al bit
- aumenta la capacita’
- diminuisce la frequenza di acesso alla memoria da parte del processore
## outboard memory
- offline storage: memoria ausiliaria ed esterna
- non volatile
- usata per contenere files contenenti programmi e dati
## inboard memory
anche nella inboard memory ci sono importanti differenze di velocita’, infatti la velocita del processore e’ maggiore della velocita di accesso alla RAM.
per evitare eccessivi tempi di attesa, i computer hanno una memoria cache, piccola e veloce, che sfrutta il principio di localita’
>[!figure] ![[Pasted image 20241006111736.png]]
# cache
contiene copie di porzioni della memoria principale, e quindi il processore controlla prima se un dato e’ nella cache.
- se il dato non e’ nella cache (MISS), il blocco di memoria viene caricato in essa, dato che secondo il principio della localita’, e’ probabile che il dato appena caricato serva ancora nell’immediato futuro
il programmatore non vede la cache, neanche su assembly. viene unicamente gestita dall’HW della CPU (quindi neanche compilatore o SO)
>[!figure] ![[Pasted image 20241006111246.png]]
lettura dalla cache

caratteristiche cache:
- i dati scambiati tra memoria e cache sono in quantita’ multiple di blocchi.
- anche una cache molto piccola puo’ fare un grande impatto
- esiste una funzione di mappatura, che determina la locazione della cache nel quale andra messo un blocco
- i blocchi vengono rimpiazzati (quando la cache e’ piena) da un algoritmo di rimpiazzamento (es: LRU)
- esiste una politica di scrittura, in caso un dato venga aggiornato nella cache e vada aggiornato anche nella memoria(linux sceglie sempre il write-back)
un SO puo’ disattivare il caching!(linux non lo fa)