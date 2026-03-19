## prestazioni
per misurare le prestazioni di una cpu si usano i seguenti parametri:

| compotente delle prestazoni               | unità di misura                               |
| ----------------------------------------- | --------------------------------------------- |
| tempo di esecuzione della cpu x programma | secondi                                       |
| numero di istruzioni                      | istruzioni eseguite per singolo programma     |
| cicli di clock x istruzione (CPI)         | numero medio di cicli di clock per istruzione |
| durata del ciclo di clock                 | secondi per ciclo di clock                    |

in generale il tempo di esecuzione di un programma dipende da 
- numero istruzioni di un programma
- numero medio di clock per istruzione
- velocità clock
***
## legge di amdahl
$$
\text{Tempo di esecuzione dopo il miglioramento}=
$$$$
=\frac{\text{Tempo di esecuzione influenzato dal miglioramento}}{\text{Miglioramento}}\,+\,
\begin{split}
&\text{Tempo di esecuzione non}\\
&\text{influenzato dal miglioramento}
\end{split}
$$
in pratica: make the common case fast