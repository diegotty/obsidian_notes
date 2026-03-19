# fase di instruction fetch
in questa fase si preleva la nuova istruzione da eseguire. i componenti necessari sono:
- il PC
- la [[progetto di CPU MIPS#memoria delle istruzioni, PC, adder| memoria istruzioni]], avente in input l’indirizzo di 32 bit in memoria dell’istruzione da prelevare e in output i 32 bit corrispondente a tale indirizzo
![[Pasted image 20240420123000.png|400]]

## fase di instruction decode
in questa fase l’istruzione viene scomposta in ognuno dei suoi campi, in modo da poterne prelevare i contenuti
![[Pasted image 20240507222740.png]]
poichè l’architettura deve essere in grado di poter lavorare con tutti e 3 i tipi di istruzione, sono necessari alcuni mux e segnali di controllo in modoc he ne modifichino il comportamento a seconda del tipo di istruzione
![[Pasted image 20240507223229.png|450]]
- registro di lettura 1: $rs
- registro di lettura 2: $rt
- registro di scrittura: $rd o $rt, a seconda di RegDst
## fase di instruction execute
in questa fase si va ad utilizzare l’ALU ed eventualmente ad accedere alla memoria dati.
![[Pasted image 20240507224059.png]]
a seconda dei 4 bit di controllo verrà svolta una delle 6 operazioni nell’alu

le uniche operazioni in cui MemWrite e MemRead sono asserite sono rispettivamente: sw e lw. inoltre le due linee di controllo non possono essere asserite contemporaneamente.
