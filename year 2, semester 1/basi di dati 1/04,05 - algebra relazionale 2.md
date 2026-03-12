---
created: 2024-10-10
related to: 
updated: 2024-11-18T19:59
---
>[!index]
>
>- [condizioni che richiedono il prodotto di una relazione con se stessa](#condizioni%20che%20richiedono%20il%20prodotto%20di%20una%20relazione%20con%20se%20stessa)
## relazioni che usano il quantificatore universale
fino ad ora abbiamo visto query che implicavano condizioni equivalenti al quantificatore universale:
$$\exists \text{(esiste almeno un)}$$
ciò ci è comodo perchè:
>[!info] in qualunque posizione appaiano nell’espressione di algebra relazionale, la valutazione delle condizioni avviene in sequenza, tupla per tupla, e quando si incontra una tupla che soddisfa le condizioni, viene inserita nel risultato

>[!example] query: Codici dei clienti che hanno effettuato un ordine per più di 100 pezzi
>![[Pasted image 20241010073654.png]]
>(se poi non ci interessano i duplicati, possiamo proiettare su C#)

alcune query, però, potrebbero richiedere la valutazione di gruppi interi di tuple, prima di decidere se inserirle tutte, qualcuna o nessuna nel risultato. però:
- le tuple non sono ordinate
- la valutazione, come definito prima, avviene in sequenza, tupla per tupla, e una volta inserita una tupla nel risultato, non possiamo più eliminarla
in questo caso, la condizione equivale a valutare il quantificatore universale 
$$\forall \text{ (per ogni)} \text{ o } \not\exists \text{ (non esiste nessun)}$$
>[!example] query: nomi e città dei clienti che hanno SEMPRE ordinato più di 100 pezzi per articolo
iin questo caso non ci basta fare una selezione sul join di Ordine e Cliente
![[Pasted image 20241010074534.png]]
in quanto: dato che non esiste un ordine, per il cliente di C#=C1, potrebbero accadere 2 cose:
>- durante la selezione, viene considerata per prima la tupla in cui C1 ordina 200 pezzi: inserirla è sbagliato, in quanto nelle tuple succesive C1 fa ordini ≤ 100
>- durante la selezione, viene considerata per prima la tupla in cui C1 ordina ≤ 100 pezzi. in questo caso, dovremmo memorizzare il fatto che C1 compare in una tupla che non soddisfa la condizione, per poi non aggiungerlo al risultato quando viene valutata la tupla in cui C1 ordina 200 pezzi
soluzione: risolviamo il problema usando la doppia negazione
- eseguiamo la query con la condizione negata, e troviamo gli oggetti che ALMENO una volta soddisfano la condizione CONTRARIA: questi elementi non devono apparire nel risultato della query originale. li ELIMINIAMO con l’operatore differenza dalla relazione Clienti.
quindi:
$$\sigma_{N-pezzi \leq 100}(Cliente \bowtie Ordine)$$
![[Pasted image 20241010075413.png]]
facciamo poi la proiezione su Nome, Citta, per aver la possibilità di fare una differenza (è necessaria l’union compatibilità)
$$\pi_{Nome, Citta}(Cliente\bowtie Ordine) - \pi_{Nome, Citta}(\sigma_{N-pezzi \leq 100}(Cliente \bowtie Ordine))$$

>[!warning] in questo caso, è necessario sottrarre al join tra Cliente e Ordine: altrimenti, sottraendo solo a Cliente, includeremmo anche i clienti che NON hanno fatto nessun ordine, e sono solo stati registrati in Cliente
>inoltre, sempre in questo caso, se avessimo proiettato suolo sul nome, (dal minuendo o sottraendo) avremmo perso delle informazioni: il Rossi di milano sarebbe stato un duplicato. 
>ATTENZIONE quando si proietta su un gruppo di attributi non unici, c’è il rischio di perdere informazioni
## condizioni che richiedono il prodotto di una relazione con se stessa
come negli esempi precedenti abbiamo visto casi in cui oggetti di relazioni diverse vengono associati, ci sono anche casi in cui sono in qualche modo associati oggetti nella relazione. Cioè query in cui confronto campi di tuple diverse nella stessa relazione.
>[!example] query: nomi e codici degli impiegati che guadagnano quanto o più del loro capo
![[Pasted image 20241010080735.png]]
in questo caso le informazioni sullo stipendio di un impiegato e quello del suo capo si trovano in tuple diverse, ma per poter confrontare valori di attributi diversi, questi devono trovarsi nella stessa tupla.
soluzione: creiamo una copia della relazione 
>- con un nome diverso (per questo esempio, ImpiegatiC)
>- dato che avrò una tabella con campi dello stesso nome, è meglio rinominare un set di campi per poterli distinguere durante le interrogazioni
>usando un operatore di join, collego le due tabelle: in questo caso uso un [[03 - algebra relazionale#$ theta$ join]] per combinare le tuple con C# = Capo#: in questo modo accodiamo i dati del capo a quelli dell’impiegato.
>![[Pasted image 20241010081309.png]]
>a questo punto, basta confrontare Stip con CStip per selezionare gli impiegati che ci interessano, e infine proiettare :)
![[Pasted image 20241010082535.png]]

>[!example] query: nomi e codici dei capi che guadagnao più di tutti i loro impiegati
devo ancora usare la doppia negazione, quanto le tuple vengono scandite una volta in modo sequenziale bla bla bla
riprendiamo la query dell’ultimo esempio: i capi che compaiono in quella query (di codice CC#) guadagnano meno di almeno uno dei loro impiegati. Questi sono i capi che NON ci servono nel risultato di questa query.
quindi, per trovare il risultato, sottraiamo r (proiettato su CNome, CC#) al theta join fatto nell’esempio sopra (altrettanto proiettato su Cnome, CC#)
$$\pi_{CNome, CC\#}()\sigma_{Capo\#=CC\#}(Impiegati x ImpiegatiC)) - \pi_{CNome, CC\#}(r)$$

>[!warning] in questo caso, non basta sottrarre alla tabella Impiegati: esistono impiegati che non sono capi, e sottraendo r a Impiegati, nel risultato rimarrebbero impiegati che non sono capi.