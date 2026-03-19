---
created: 2024-10-31
related to: "[[09, 10 - 3FN]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [condizioni della decomposizione](#condizioni%20della%20decomposizione)
>- [forma normale di Boyce-Codd](#forma%20normale%20di%20Boyce-Codd)
# decomposizione
se uno schema non è in 3FN, esso può essere **decomposto** per creare un insieme di schemi in 3FN.
esistono diversi modi per decomporre uno schema, ma è necessario che ogni dipendenza originaria (in $F$) sia rispettata negli schemi decomposti, anche se gli attributi interessati dalle dipendenze funzionali sono distribuiti in relazioni diverse.

>[!example] esempio 1
Consideriamo lo schema R=$ABC$ , con l’insieme di dipendenze funzionali $F=\{A \to B, B \to C\}$
lo schema non è in 3FN per la presenza in $F^+$ della dipendenza transitiva $B \to C$, dato che la chiave è evidentemente $A$
$R$ può essere decomposto in:
>	$R1 = AB$ con $\{A \to B\}$ e $R2 = BC$ con $\{B \to C\}$
>**oppure**
>	$R1 = AB$ con $\{A \to B\}$ e $R2 = AC$ con $\{A \to C\}$
>entrambi gli schemi sono in 3FN, tuttavia la seconda soluzione non è soddisfacente, infatti:
>consideriamo due istanze legali degli schemi ottenuti	
![[Pasted image 20241031075006.png]]
l’istanza dello schema originario R che posso ricostruire da questa (e l’unico modo per ricostruirla è facendo un join naturale) è la seguente:
![[Pasted image 20241031075109.png]]
**MA** questa non è un’istanza legale di R, in quanto non soddisfa la dipendenza funzionale $B \to C$( che anche se transtiva, va soddisfatta comunque!!)
**occorre quindi preservare TUTTE le dipendenze in $F^+$**

>[!example] esempio 2
Consideriamo lo schema R=$ABC$ , con l’insieme di dipendenze funzionali $F=\{A \to B, C \to B\}$
lo schema non è in 3FN per la presenza in $F^+$ della dipendenze parziali $A \to B$ e $C \to B$, dato che la chiave è evidentemente $AC$(applico aumento con $A$ sulla dipendenza $C \to B$)
$R$ può essere decomposto in:
>	$R1 = AB$ con $\{A \to B\}$ e $R2 = BC$ con $\{C \to B\}$
tale schema, pu preservando tutte le dipendenze in $F^+$, non è soddisfacente, infatti:
consideriamo l’istanza **legale** di R
![[Pasted image 20241031080146.png]]
in base alla decomposizione data, questa istanza si decompone in:
![[Pasted image 20241031080232.png]]
e, in teoria, dovrebbe essere possibile ricostruirla **esattamente** tramite join naturale.
invece, effettuando il join tra le due istanze **legali** risultanti della decomposizione, si ottiene:
![[Pasted image 20241031080346.png]]
** occorre quindi garantire che il join delle istanze risultanti dalla decomposizione non riveli <u>perdita di informazione</u>** 

>[!example] esempio 3
Consideriamo lo schema R=$ABC$ , con l’insieme di dipendenze funzionali $F=\{\varnothing \}$ (lo schema è ovviamente in 3FN (e ovviamente $F^+$ non è vuoto !!!))
$R$, per motivi pratici può essere decomposto in:
>	$R1 = AB$ con $\{\varnothing\}$ e $R2 = BC$ con $\{\varnothing\}$
tale schema, pu preservando tutte le dipendenze in $F^+$(che sono quelle banali), non è soddisfacente, infatti:
consideriamo l’istanza **legale** di R:
![[Pasted image 20241031080836.png]]
in base all decomposizione data, questa istanza si decompone in:
![[Pasted image 20241031080902.png]]
e, in teoria, dovrebbe essere possibile ricostruirla **esattamente** tramite join naturale.
invece, effettuando il join tra le due istanze **legali** risultanti della decomposizione, si ottiene:
![[Pasted image 20241031081005.png]]
**stessa situazione dell’esempio 2!!!**

# condizioni della decomposizione
quando si decompone uno schema per ottenerne uno in 3FN bisogna tenere presente altri due requisiti dello scempa decomposto:
- deve **preservare le dipendenze funzionali** che valgono su ogni istanza legale dello **schema originario**
- deve permettere di **ricostruire mediante join naturale** ogni **istanza legale dello schema originario**(senza aggiunta di informazione estranea)
# forma normale di Boyce-Codd
la 3FN non è la più restrittiva che si può ottenere. ne esistono altre, tra cui la forma normale **Boyce-Codd**:
una relazione è in forma normale Boyce-Codd (BCNF) quando in essa **ogni determinante è una superchiave**(forzo una delle due condizione sufficienti della 3FN)

perchè?
>[!warning] se tutte le dipendenze hanno come determinante una superchiave, non posso violare le dipendenze funzionali

quindi una relazione in BCNF è **anche** in 3FN, ma non viceversa!
>[!example]
>consideriamo ora una relazione che descrive l’allocazione delle sale operatorie di un ospedale:
$Interventi( Paziente, DataIntervento, OraIntervento, Chirurgo, Sala)$
possiamo determinare le dipendenze funzionali in base a le seguenti informazioni date:
nel corso di una giornata una sala operatoria è occupata **sempre** dal medesimo chirurgo che effettua più interventi, in diverse ore.
$\{Chirurgo, DataIntervento \to Sala\}$
$\{Chirurgo, DataIntervento, OraIntervento \to Sala, Paziente\}$
$\{Paziente, DataIntervento \to Chirurgo, OraIntervento, Sala\}$ (diamo per scontato che un paziente non si può operare 2 volte lo stesso giorno)
$\{Sala, DataIntervento, OraIntervento\to Paziente, Chirurgo\}$
ci sono tre insiemi di attributi che possono fungere da chiave:
$K1 =\{Chirurgo, DataIntervento, OraIntervento\}$
$K2 = \{Paziente, DataIntervento\}$
$K3 = \{Sala, DataIntervento, OraIntervento\}$
qualunque sia la chiave primaria che scegliamo, i determinanti nelle ultime 3 dipendenze funzionali sono insiemi di attributi che possono svolgere la funzione di chiave, e quindi la BCNF non è sicuramente violata in questi casi
la BCNF **non è rispettata** nella prima dipendenza funzionale, che ha come determinante un insieme di attributi **non chiave**
la relazione Interventi **non è** quindi in BCNF
**MA**
la relazione interventi è in 3FN in quanto la prima dipendenza non viola la definizione ($Sala$ è primo) (però, non essendo BCNF, la prima dipendenza funzionale non è gestita “automaticamente”, e bisogna quindi aggiungere un constraint quando si crea la base di dati)

attraverso altri esempi, si può notare che:
**può non essere possibile** decomporre uno schema non BCNF ottenendo sottoschemi BCNF, e preservando allo stesso tempo tutte le dipendenze originarie
**MA** ciò è **sempre** possibile per la 3FN (che è comunque soddisfacente), quindi nel seguito contiueremo a prendere in considerazione solo la 3FN
