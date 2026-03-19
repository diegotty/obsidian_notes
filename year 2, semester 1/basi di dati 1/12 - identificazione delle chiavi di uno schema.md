---
created: 2024-11-07
related to: 
updated: 2025-02-20T09:38
---

>[!index]
>
>- [test di unicità della chiave](#test%20di%20unicit%C3%A0%20della%20chiave)
>- [chiavi e 3FN](#chiavi%20e%203FN)

>[!example] esempio 1
dato il seguente schema di relazione:
$R = (A,B,C,D,E, H)$
e il seguente insieme di dipendenze funzionali:
$F = \{AB \to CD, C \to E, AB \to E, ABC \to D \}$
**calcolare la chiusura dell’insieme $ABH$**
>
>applicando l’arlgoritmo per il calcolo della chiusura di un insieme di attributi, inizializziamo $Z=ABH$, e inseriamo in $S=CDE$ . alla prima iterazione abbiamo già aggiunto tutti gli attributi dello schema in $Z$, e abbiamo quindi verificato $$(ABH)^+ = \{A,B,C,D,E,H\}$$
>
>$ABH$ potrebbe essere una chiave ? devono essere vere le condizioni: 
>1. $K \to R \in F^+$
>2. non esiste un sottoinsieme proprio $K’$ di $K$ tale che $K’ \to R \in F^+$

>[!info] osservazioni
>1. conviene partire dai sottoinisiemi di $ABH$ di cardinalità maggiore: se la loro chiusura non contiene $R$, è inutila calcolare la chiusura dei loro sottoinsiemi
>2. gli attributi che **non compaiono mai a destra delle dipendenze funzionali di F**, non sono determinati funzionalmente da nessun attributo, quindi **dovranno essere sicuramente in ogni chiave** (perchè rimarebbero fuori da qualunque chiusura transitiva, e una chiave deve determinare l’intero schema)
>3. gli attributi che compaiono sempre e solo come dipendenti non potranno stare in una chiave
>4. gli attributi che non compaiono mai( nè determinante, nè dipendente) nelle dipendenze funzionali in $F$, devono stare per forza nella chiave

>[!example] continuo dell’esempio 1
verifichiamo che $ABH$ è chiave: calcoliamo la chiusura dei suoi sottoinsiemi.
usando le osservazioni appena elencate, notiamo che $H$ non appare mai come dipendente (o determinante), quindi sicuramente farà parte della chiave. dobbiamo quindi calcolare la chiusura di $AH$ e $BH$
**blablabla non entriamo neanche nella prima iterazione. lame. L + not keys**
quindi inutile provare con sottoinsiemi di cardinalità minore. 
**$ABH$ è una chiave di $R$**
inoltre, tentando le chiusure di altri sottoinsiemi di $R$, si può arrivare alla conclusione che **$ABH$ è l’unica chiave**

dato uno schema $R$ ed un insieme di dipendenze funzionali su $R$, **possiamo avere più chiavi per $R$ !**

>[!example] esempio 2
dato il seguente schema di relazione:
$R = (A,B,C,D,E, G, H)$
e il seguente insieme di dipendenze funzionali:
$F = \{AB \to D, G \to A, G \to B, H \to E, H \to G, D \to H \}$
**determinare le 4 chiavi di $R$**
>
>cominciamo dagli attributi che ne determinano funzionalmente altri , e quelli che **NON** sono determinati funzionalmente dagli altri:
>nel nostro caso $AB, G, H, D$ sono buoni sottoinsiemi da cui iniziare, a cui però dobbiamo aggiungere $C$ che non appare nelle dipendenze funzionali in $F$( e quindi sarà in ogni chiave)
>calcolando le chiusure di $ABC, GC, CH, DC$, notiamo che la chiusura di ognuna comprende $R$: sono tutte superchiavi, e bisogna verificare la minimalità.
>per $GC, CH, DC$ è inutile farlo, in quanto sono necessari entrambi gli attributi.
>i sottoinsiemi di $ABH$ non sono chiavi, e quindi, pur avendo un attributo in più, anche $ABH$ è chiave di $R$
# test di unicità della chiave
(non necessario tipo)
dati uno schema $R$ e un insieme di dipendenze funzionali $F$
- calcoliamo l’intersezione degli insiemi ottenuti come sopra, cioè degli insiemi $X = R-(V-W)$, con $V \to W \in F$
- se l’intersezione di questi insiemi (gli attributi comuni a tutti gli insiemi che interseco) determina tutto $R$, allora questa intersezione è l’unica chiave di $R$, altrimenti esistono più chiavi
>[!warning] se esistono più chiavi vanno **TUTTE** identificate per poter testare se lo schema è in 3FN

>[!warning] questa descritta è una comoda verifica, ma se nel compito viene richiesto di verficare che un insieme di attributi sia chiave, o trovare la chiave, va usata **SOLO** la definizione (verificare la chiusura contenga R, e che i suoi sottoinsiemi non siano chiavi)

# chiavi e 3FN
una volta individuate le chiavi di uno schema di relazione, possiamo determinare se lo schema è in 3FN

>[!example] esempio 3
 dato lo schema di relazione $R=(A,B,C,D,E,H)$
 e l’insieme di dipendenze funzionali su $R$: $F = \{AB \to CD, EH \to D, D \to H\}$ (esempio in [[11 - chiusura di un insieme di attributi#esempio di chiusure di insiemi di attributi| lezione precedente]])
 ** determinare le chiavi e verificare che $R$ è in 3FN**
> - tentiamo le chiusure di $AB, EH, D$(determinanti) ma senza successo.
> - notiamo che $G$ non compare mai nelle dipendenze, quindi deve far parte della chiave, e l’attributo $E$ non compare mai a destra delle dipendenze, e farà quindi parte della chiave. 
> - troviamo un sottoinsieme che ha come determinante $R$: $(ABEG)^+_F = \{A,B,E,G,C,D,H\}$. 
> - calcoliamo le chiusure dei suoi sottoinsiemi: nessuno è chiave, quindi $ABEG$ è chiave !
> - calcoliamo altri sottoinsiemi di $R$, non troviamo chiavi
> - ora verifichiamo che $R$ sia in 3FN !
> - la dipendenza $AB \to CD$ viola la 3FN: $AB$ è contenuto propriamente nella chiave, e $CD$ non è primo: abbiamo una **dipendenza parziale**
>- notiamo anche che $EH \to D$ e $D \to H$ violano la 3FN. BIG SAD !
