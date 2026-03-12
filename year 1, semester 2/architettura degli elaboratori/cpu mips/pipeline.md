fasei dell’istruzione:
- **fetch** (**IF**): carica l’istruzione dalla memoria
- **instruction decode** (**ID**): la CU decodifica l’istruzione e vengono letti gli argomenti dai registri
- **execution** (**EXE**): l’ALU fa il calcolo necessario (tipo R o accesso alla memoria o branch)
- **memory access** (**MEM**): viene letta/scritta la memoria (lw e sw)
- **write back** (**WB**): il risultato dell’ALU o quello letto dalla memoria viene messo nel registro dest.

in una CPU a un ciclo di clock, in ogni momento è attiva solo un’unità funzionale.
per rendere il più efficiente possibile la nostra architettura, possiamo scomporre l’esecuzione di un’istruzione in una catena di montaggio (**pipeline**) dove ogni fase svolge il compito ad essa assegnatogli per poi passare il risultato alla fase successiva, procedendo ad elaborare già la stessa fase dell’istruzione successiva.

![[Pasted image 20240508134210.png]]

in questo modo:
- posso scegliere un periodo di clock molto più corto !! (da 800 ps a 200ps)
- riducendo il periodo di clock ad un quarto, quadruplico la velocità
## lettura e scrittura dal blocco Registri
si può notare come quando vengono eseguite 5 istruzioni contemporaneamente, il blocco dei Registri verrebbe usato 2 volte (in WB e in ID). Ciò è possibile perchè lavorando sui registri, sia WB che ID impiegano un tempo notevolmente minore (per esempio, la metà), e si possono fare entrambe le operazioni in un solo colpo di clock
![[Pasted image 20240508154944.png]]
in particolar modo possiamo eseguire la scrittura durante il rising edge e la leggura durante il falling edge.

# criticità(harzard)
tipi di hazard:
- strutturali: le risorse hardware non sono sufficienti(per esempio memoria dati e memoria istruzioni in una sola unità)
- sui dati: il dato necessario non è ancora pronto
- sul controllo: la presenza di un salto cambia il flusso di esecuzione delle istruzioni
## data harzard 
```asm
addi $s0,$s1,5
sub $s2,$s0,$t0
```

|                   | 1° CC | 2° CC | 3° CC  | 4° CC | 5° CC  | 6° CC |
| :---------------- | :---: | :---: | :----: | :---: | :----: | :---: |
| `addi $s0,$s1,5`  |  IF   |  ID   |  EXE   |  MEM  | **WB** |       |
| `sub $s2,$s0,$t0` |       |  IF   | **ID** |  EXE  |  MEM   |  WB   |
per via della scomposizione in fasi dell’esecuzione dell’istruzione, si verifica un *Data Hazard* sul registro `$s0`, il cui valore aggiornato non risulta ancora scritto, poiché la fase di WB dell’istruzione modificante non è ancora stato portato a termine. Di conseguenza, la fase di ID dell’istruzione direttamente successiva **leggerà il valore errato**

per risolevere la criticità, bisogna allineare le fasi di WB e ID delle due istruzioni. ciò si può fare introducendo due stalli nella pipeline, ossia un’istruzione finta, detta NOP(no-operation), che funge da rallentamento nel caricamento della pipeline, risolvendo il data hazard.

|                   | 1° CC | 3° CC | 2° CC | 4° CC | 5° CC  | 6° CC | 7° CC | 8° CC |
| :---------------- | :---: | :---: | :---: | :---: | :----: | :---: | ----- | ----- |
| `addi $s0,$s1,5`  |  IF   |  EXE  |  ID   |  MEM  | **WB** |       |       |       |
| `sub $s2,$s0,$t0` |       |   →   |   →   |  IF   | **ID** |  EXE  | MEM   | WB    |
## control hazard
quando deve essere effettuato un salto condizionale, potrebbero verificarsi due casistiche:
- il salto non viene eseguito, non modificando il flusso di esecuzione delle istruzioni (il control hazard si risolve da solo)
- il salto viene eseguito, modificando il flusso di istruzioni. in tal caso sarà necessario andare a lavorare sulla pipeline, poichè sarà necessario rimpiazzare l’istruzione attualmente caricata nella pipeline(quella appena sotto il branch) con l’istruzione su cui viene effettutato il salto.
in questo caso si devono usare delle bolle per creare del delay.
>[!tuff] il salto di un branch può essere deciso nella fase EXE, o anche nella fase ID !!
>ciò cambia il numero di bolle da dover utilizzare (se il salto viene deciso in ID devo usare una bolla in meno x allineare)

# forwarding
in alcuni casi, come l’esempio precedente, l’informazione necessaria è già presente nella pipeline, prima del WB.
in questi casi possiamo inserire nel [[progetto di CPU MIPS#unità funzionali necessarie|datapath]] delle “scorciatoie”, che recapitano il dato necessario all’unità funzionale che ne ha bisogno senza aspettare la fase di WB
![[Pasted image 20240508160032.png|650]]
in questo esempio non è necessario usare 2 stalli
>[!tuff] il dato non può essere propagato nello stesso colpo di clock in cui viene generato
>usare il forwarding è possibile quando la fase che deve ricevere il dato è successiva a quella che lo produce nel diagramma della pipeline !!
>

# bolle
se la fase che ha bisogno del dato si trova prima di quella che lo produce, sarà necessario inserire una attesa (stallo o bolla), per rallentare l’esecuzione in attesa che il dato venga generato, per poi recapitarlo con il forwarding.

![[Pasted image 20240508160735.png|650]]