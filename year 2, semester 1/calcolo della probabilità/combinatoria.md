# principio fondamentale della combinatoria
dati 2 esperimenti:
- esp1 ha n1 esiti possibili, e **qualunque** sia l’esito di esp1, esp2 ha n2 esiti possibili.
Allora il numero delle coppie ($a_{1},a_{2}$) possibili con $a_i$ esito dell’esperimento i-esimo e’ 
$$n_{1}*n_{2}$$
>[!def]
> dato un insieme A, $|A|$ = cardinalita’ di A = $\#A$

## generalizzazione
dati r esperimenti:
- esp1 ha n1 esiti possibili. **Qualunque** sia la realizzazione di esp1, esp2 ha n2 esiti possibili. **Qualunque** sia la realizzazione dei primi 2 esiti, esp3 ha n3 esiti possibili, e cosi’ via.
Allora, il numero delle possibili stringhe ($a_1,a_2, a_3, …, a_n$) dove $a_i$ e’ l’esito dell’esp i-esimo ($\forall i=1,2,\dots,r$) e’ $$n_{1}*n_{2}*n_{3}\dots*n_{3}$$
>[!example]
>ho 120 ragazzi e 20 ragazze. in quanti modi posso scegliere un rappresentante e un vice di sesso diveso ?
>#{(a,b): a e’ rappr. e b e’ il vice}
>- per scegliere a ho sempre 140 modi, in quanto e’ la prima scelta. 
>- le scelte di b invece, dipendono da a! 
>	- se a maschio: 20
>	- se a femmina: 120
>non e’ quindi applicabile il princ.fond.comb.
>
>#{(a,b): a e’ rappr. e b e’ il vice} = #{(a,b): a e’ rappr. M e b e’ il vice F} $\cup$ #{(a,b): a e’ rappr. F e b e’ il vice M}
> con il pr.fond.comb, possiamo calcolare individualmente i due insiemi, e possiamo unirli sommando i risultati: $(120*20)+(20*120)=4800$

## bigezione
dati U e V insiemi, $$\exists f:U \to V$$ tale che f 
project is now abandoned lol