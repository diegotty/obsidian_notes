---
created: 2024-12-21
related to: "[[25 - controllo della concorrenza]]"
updated: 2025-02-20T09:38
---
>[!index]
>
>- [serializzabilità](#serializzabilit%C3%A0)
>- [read timestamp, write timestamp](#read%20timestamp,%20write%20timestamp)
>- [controllo della serializzabilità](#controllo%20della%20serializzabilit%C3%A0)
>- [algoritmo](#algoritmo)
# timestamp
il timestamp identifica una transazione, ed è assegnato alla transazione dallo scheduler quando la transazione ha inizio
esso può essere:
- il valore di un contatore
- l’ora di inizio della transazione
quindi: il timestamp della transazione $T_{1}$ è minore del timestamp della transazione $T_{2}$, la transazione $T_{1}$  è iniziata prima della transazione $T_{2}$
- quindi, se la transazioni fossero eseguite in modo seriale, verrebbe eseguita $T_{1}$ e poi $T_{2}$
## serializzabilità
uno schedule è serializzabile se è equivalente allo schedule seriale in cui le transazioni compaiono ordinate in base al loro timestamp
>[!important] quindi uno schedule è serializzabile se per ciascun item acceduto da più di una transazione, l’ordine con cui le transazioni accedono all’item è quello imposto dai timestamp !!

>[!example] esempio 1
consideriamo le seguenti transazioni:
![[Pasted image 20241221091242.png]]
con `TS(T1) = 110, TS(T1) = 100`
in questo caso, uno schedule è serializzabile se è **equivalente** allo schedule seriale $T_{2}T_{1}$(in cui l’item $X$ è acceduto prima da $T_{2}$ e poi da $T_{1}$, seguendo l’ordine dei timestamp)
>
>consideriamo il seguente schedule:
![[Pasted image 20241221091514.png|200]]
lo schedule non è serializzabile, in quanto $T_{1}$ legge $X$ prima che $T_{2}$, l’abbia scritto (quindi per accesso si intende `read + write`)

>[!example] esempio 2
consideriamo le seguenti transazioni:
![[Pasted image 20241221091808.png]]
con `TS(T1) = 110, TS(T1) = 100`
>
>il cui schedule seriale $T_{1}T_{2}$ è:
![[Pasted image 20241221091838.png|200]]
>
>consideriamo il seguente schedule:
>![[Pasted image 20241221092118.png|200]]
lo schedule è serializzabile solo se **non viene eseguita** la scrittura di $X$ da parte di $T_2$, in quanto $T_{2}$ dovrebbe accedere prima a $X$ (anche se solo con `write`), invece in questo schedule accede prima $T_{1}$. quindi $T_{2}$ non dovrebbe accedere a $X$ per rendere lo schedule equivalente a $T_{1}T_{2}$
## read timestamp, write timestamp
a ciascun item $X$ vengono associati due timestamp:
- **read timestamp** di $X$ (`readTS(X)`), cioè il più grande fra tutti i timestamp di transazioni che hanno letto con successo $X$
- **write timestamp** di $X$ (`write_TS(X)`), cioè il più grande fra tutti i timestamp di transazioni che hanno scritto con successo $X$
>[!warning] è importante che sia il più grande e non l’ultimo !!!

ogni volta che una transazione $T$ cerca di eseguire un `read(X)` o un `write(X)`, occorre confrontare il timestamp $TS(T)$ di $T$ con il read timestamp e il write timestamp di $X$, per assicurarsi che l’ordine basato sui timestamp non è violato

>[!example]- esempi con read e write timestamp
esempio 1:
![[Pasted image 20241221092838.png]]
>
> esempio 2:
![[Pasted image 20241221092922.png]]

# controllo della serializzabilità
## algoritmo
quando $T$ cerca di eseguire una `write(X)`:
1. se `read_TS(X) > TS(T)`, $T$ viene rolled back
2. se `write_TS(X) > TS(T)`, l’operazione di scrittura non viene effettuata
3. se nessuna delle condizioni precedenti è soddisfatta, allora:
	- `write(X)` viene eseguita
	- `write_TS(X) := TS(X)`

quando $T$ cerca di eseguire una `read(X)`:
1. se `write_TS(X) > TS(T)`, $T$ viene rolled back
2. se `write_TS(X) <= TS(T)`, allora:
	- `read(X)` viene eseguita
se `read_TS(X) < TS(T)` allora `read_TS(X) := TS(X)`
>[!example] esempio
![[Pasted image 20241221093607.png]]
con `TS(T1) = 100, TS(T2) = 100, TS(T3) = 105`
>assumiamo che:
>- i valori inziali degli item $X$ e $Y$ nella memoria condivisa siano $x0$, $y0$
>- all’inizio, `RTS(X) = 0, RTS(Y) = 0, WTS(X) = 0, WTS(Y) = 0`
>
![[Pasted image 20241221093959.png]]
al passo 9 la transazione $T_{2}$ viene abortita. dovrebbe eseguire `write(X)`, ma `TS(T2) < RTS(X)`. ciò significa che una transazione che ha iniziato le proprie operazioni dopo $T2$ ha gia letto il valore dell’item $X$, mentre secondo ordine di esecuizone avrebbe dovuto leggere il valore di $X$ già modificato da $T2$. per questo motivo, è necessario il roll-back di $T2$

>[!info] osservazione
>nell’esempio precedente (e in generale), lo schedule delle trasazioni superstiti è equivalente allo schedule seriale delle transazioni eseguite in ordine di arrivo

>[!info] domanda 
>come mai possiamo saltare l’operazione di scrittura di una transazione $T$ senza violare la proprietà di **atomicità** ?
>la proprietà di atomicità serve a garantire la coerenza dei dati nella base di dati. dal punto di vista degli effetti della transazione sulla base di dati e di questa coerenza, le transazioni che potrebbero trovare una situazione incoerente sono quelle che avre //cba + QUESTION

>[!osservazione]
supponiamo di avere, rispetto al timestamp $T_{1} < T_{2} < T_{3}$, il seguente schedule:
![[Pasted image 20241221095657.png]]
cosa succederebbe se `WTS(X)` e `RTS(X)` fossero il timestamp dell’ultima transazione che ha avuto accesso con successo all’item, anzichè il timestamp della transazione più giovane che ha avuto accesso all’item ?
>secondo l’algoritmo della scrittura,  $T_{2}$ scriverebbe, ma sarebbe sbagliato, perchè $T_{3}$ ha già letto $X$, nello schedule seriale avrebbo dovuto leggere il valore di $T_{2}$