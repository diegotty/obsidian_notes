# ancitipare il jump
## perchè
la decisione di eseguire il jump viene presa dalla CU nella fase ID. nel frattempo, un’altra istruzione è stata già caricata (e potrebbe essere necessario annullarla.)
![[Pasted image 20240512222805.png]]
lo stallo necessario per eliminare l’istruzione implica annullare l’istruzione inutile e aggiornare il PC alla destinazione corretta.
## implementazione anticipo
per spostare il jump nella fase IF serve:
- anticipare il riconoscimento dell’istruzione(comparatore con il valore dell’OpCode del jump, 00010)
- spostare la logica di aggiornamento del PC alla fase IF
![[Screenshot 2024-05-12 (22.31.58).jpeg.png|300]]
# anticipare beq
## perchè
l’istruzione beq normalmente usa la ALU per fare il confronto, per cui:
- il salto avviene dopo la fase EXE (nella fase MEM), e in caso di salto, le 2 istruzioni seguenti (già caricate) vanno annullate
- la necessità di avere gli argomenti nella fase EXE porta ad aver bisogno di uno stallo se il salto è preceduto da una lw




## annullare le istruzioni 
per annullare le istruzioni:
- IF/ID.Istruzione viene azzerat → NOP(No Operation, un’istruzione di solo bit pari a 0: 0x00..0 = `ssl $zero $zero, 0`)
- ID/EXE.MemWrite e ID/EXE.RegWrite vengono azzerate
## implementazione anticipo
per anticipare l’istruzione beq bisogna non usare la ALU:
- inserendo un comparatore tra i due argomenti letti dal blocco registri
- spostando la logica di salto ed il calcolo del salto relativo dalla fase EXE alla fase ID
- è necessaria un’unità di forwarding apposita per la fase ID
si può anche notare il segnale IF.Flush, per azzerare ID/EXE.MemWrite e ID/EXE.RegWrite
![[Screenshot 2024-05-12 (22.55.03).jpeg.png]]
## conseguenze dell’anticipo
grazie all’anticipo, è necessario solo un solo(al posto di due) stallo in caso di salto !
![[Screenshot 2024-05-12 (23.01.44).jpeg.png]]

l’abbassamento del numbero di stalli nel caso di predizione sbagliata (da 2 a 1) non è gratuito.
infatti, la fase in cui i branch necessitano dei dati viene anticipata da EXE a ID.
ora servono quindi 2 stalli al posto di uno, quando il branch è preceduto da lw.
![[Screenshot 2024-05-12 (23.05.35).jpeg.png]]

inoltre, ora nel caso sotto serve uno stallo:
![[Screenshot 2024-05-12 (23.07.04).jpeg.png]]

# architettura con anticipi
![[Pasted image 20240512230857.png|700]]