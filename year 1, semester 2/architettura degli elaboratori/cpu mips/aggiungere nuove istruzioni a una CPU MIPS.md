per aggiungere una nuova istruzione bisogna:
- definire la sua codifica
- definire cosa faccia
- individuare le unità funzionali necessarie (e se sono già presenti)
- individuare i flussi delle informazioni necessarie
- individuare i segnali di controllo necessari
- calcolare il tempo necessario per la nuova istruzione e se modifica il tempo totale
### esempio
aggiungere il jump

### codifica
![[Pasted image 20240507235342.png]]
### descrizione di cosa fa
il jump assoluto deve spostare il PC a un indirizzo assoluto(invece che relativo(aggiungere con una somma al PC)). per fare ciò bisogna:
- prendere i 26 bit di indirizzo dell’istruzione
- shiftarli di 2 bit
- fare un or con i primi 4 bit di PC + 4(per specificare il banco di memoria in cui bisogna saltare (256mb))
### unità funzionali necessarie
per implementare il jump abbiamo tutte le unità funzionali necessarie, tranne un mux per selezionare il nuovo PC
### flussi di informazioni necessarie
Istruzione[25-0] → SL2 → (OR con  i 4 MSBs di PC+4) → MUX → PC

### segnali di controllo
serve il segnale di controllo del nuovo mux. il segnale si chiama Jump. inoltre ci dobbiamo garantire che RegWrite = 0 e MemWrite = 0 per evitare modifiche a registri e MEM.
### tempo necessario
fetch e in parallelo il tempo dell’adder che calcola PC+4

### risultato
![[Pasted image 20240507235733.png]]

sulle slide ci sono anche esempi per `jal` ,`jr` e `addi`