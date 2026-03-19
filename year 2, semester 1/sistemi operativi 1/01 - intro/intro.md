>[!index]-
>
>- [componenti di un computer monoprocessore](#componenti%20di%20un%20computer%20monoprocessore)
>- [registri del processore](#registri%20del%20processore)
>	- [registri visibili all’utente](#registri%20visibili%20all%E2%80%99utente)
>	- [registri di controllo e di stato](#registri%20di%20controllo%20e%20di%20stato)
>	- [registri “interni”](#registri%20%E2%80%9Cinterni%E2%80%9D)
# sistema operativo
gestisce le risorse harware di un sistema:
- uno o piu’ processori
- memoria primaria (ram)
- dispositivi di i/o
## componenti di un computer monoprocessore
i componenti di un computer secondo il modello di Von Neumann sono:
- CPU → si occupa delle computazioni 
	all’interno della CPU ci sono parti importanti, tra cui:
	- PC(program counter): contiene l’indirizzo da prelevare dalla memoria
	- IR(instruction register):che contiene l’ultima istruzione prelevata dalla memoria
	- MAR(memory address register): indirizzo che si riferisce alla RAM
	- MBR(memory buffer register): buffer da usare con la RAM
	- I/O AR(i/o address register): indirizzo che si riferisce all’i/o module
	- I/O BR(i/o buffer register): buffer da usare con l’i/o module
- RAM(memoria principale) –> volatile, chiamata memoria principale o primaria
- dispositivi I/O → dispositivi di memoria secondaria non volatile(hdd), dispositivi per la comunicaizone, etc…
- bus → mezzo per far comunicare tra loro le parti interne del computer
## registri del processore
si dividono in:
### registri visibili all’utente
- gli unici che possono essere usati direttamente da chi programma in assembly o dai compilatori di linguaggi non interpretati. alcune istruzioni li usano in modo obbligatorio, altri possono essere usati per ridurre accessi alla memoria principale
- possono contere dati o indirizzi(puntatori diretti, registri-indice(che indicano l’offset), puntatori a stack($sp!), puntatori a segmento)

### registri di controllo e di stato
usati dal processore per controllare l’uso di se stesso, e da funzioni privilegiate del SO per controllare l’esecuzione dei programmi
vengono usualmente letti/modificati in modo implicito da opportune istruzioni assembly(come il jump modifica il PC)
- PC
- IR
- PSW → contiene informazioni di stato(es: interrupt disabilitati)
- codici di condizione(flag)
### registri “interni”
- registro dell’indirizzo di memoria(MAR), contiene l’indirizzo della prossima operazione di lettura/scrittura
- registro di memoria temporanea(MBR), contiene i dati da scrivere in memoria, o fornisce lo spazio dove scrivere i dati letti dalla memoria
- registro dell’indirizzo di i/o (I/O AR)
- registro di memoria temporanea per i/o(I/O BR)
