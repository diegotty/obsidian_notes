---
created: 2025-04-08T12:18
updated: 2025-05-09T10:56
---
## diagramma delle classi
- se un dato può essere calcolato, non va interpretato come attributo. bensì, si deve creare un’operazione che permette di ottenere il risultato del calcolo
- i range sono usato solo con interi

>[!warning] attributi opzionali potrebbero hintare a generalizzazioni non fatte ! 
>è sempre meglio modellare la struttura, senza perderla in ragionamenti impliciti (es: `CrocieraPerFamiglie`)


### modifiche
- `fine()`: la data di fine della crociera è calcolabile(calcolabile → operazione)
- `posti_disponibili(t: DataOra): Intero >= 0`: modelliamo un’operazione, in modo da sapere il numero di posti disponibili in un istante di tempo
- tipo di luna di miele: `tipo(): {trad, alt}`, perchè bisogna contare le tappe (è quindi un calcolo → operazione)
- `durata_g()`: durata in giorni del'l’itinerario
- l’ordine delle tappe si gestisce da solo, in quanto sappiamo in che giorno (giorno relativo all’inizio) si arriva e si riparte da ogni tappa
- `Continente` viene modellato come classe in quanto, in questo caso ci interessano i continenti “a se stanti” (magari per qualche interrogazione), e se non ci fosse una destinazione in uno dei continenti, tale continente non sarebbe presente (e ciò sarebbe errato)
- `estotica()`: avendo il continente, possiamo calcolare se una destinazione è esotica (quindi non è un attributo, ma un’operazione)
- `partenza_iniziale` e `arrivo_finale` vengono usate per specificare in modo diverso da delle tappe intermedie la partenza e l’arrivo. vengono usate association class per aggiungere attributi rilevanti 
- `TipoDestinazione`: modellamo la classe e instanzieremo poi a livello estensionale i due tipi (divertente, romantica)



molteplicità 0..1 → 1 oppure 1 → 1 descrive il fatto che una classe è parte di un altra classe praticamente (o, nel caso della prima molteplicità, che è praticamente un attributo opzionale)

requisiti riguardo all’overlapping di ore va sempre modellato come requisito esterno