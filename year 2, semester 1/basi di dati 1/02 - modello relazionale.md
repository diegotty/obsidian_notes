---
created: 2024-11-21T14:24
updated: 2025-02-20T09:38
---
>[!index]
>- [relazioni](#relazioni)
>- [dominio](#dominio)
>	- [NULL](#NULL)
>		- [grado e cardinalita’ di una relazione](#grado%20e%20cardinalita%E2%80%99%20di%20una%20relazione)
>- [attributi](#attributi)
>- [dati fra relazioni diverse](#dati%20fra%20relazioni%20diverse)
>- [vincoli di integrita’](#vincoli%20di%20integrita%E2%80%99)
>- [tipi di vincoli](#tipi%20di%20vincoli)
>	- [vincoli intrarelazionali](#vincoli%20intrarelazionali)
>	- [vincoli interrelazionali](#vincoli%20interrelazionali)
>- [chiavi](#chiavi)
>	- [chiave primaria](#chiave%20primaria)
>- [dipendenze funzionali](#dipendenze%20funzionali)

- proposto per favorire l’indipendenza dei dati
- basato sulla nozione matematica di relazione. le relazioni si traducono in maniera naturale in tabelle
## relazioni
la parola relazione puo’ essere usata per indicare concetti diversi:
- relazione matematica: come nella teoria degli insiemi
- relazione, secondo il modello relazionale dei dati (?)
- relazione(associazione) nel modello concettuale Entity-Relationship, che rappresenta un tipo di collegamento concettuale tra Entita’ diverse.
## dominio
tutti i valori (possibilmente infiniti) di un insieme (che poi detteranno i valori assumibili da un attributo)
- una relazione matematica e’ un qualsiasi sottoinsieme del prodotto cartesiano di uno o piu’ domini !
- una tupla e’ un elemento del prodotto cartesiamo dei domini dello schema (e di conseguenza non ci possono essere duplicati tra le tuple). ovviamente non tutti i valori del prodotto cartesiano dei domini dello schema hanno un senso compiuto.
- le tuple non hanno un ordinamento
di solito si usano i domini predefiniti: String, Integer, Real, etc….
### NULL
inoltre, tutti i campi (se non specificato altrimenti o se non esistono altri vincoli impliciti (chiavi)) possono avere il valore NULL, che rappresenta mancanza di informazione o il fatto che l’informazione non sia applicabile per quella tupla
NULL, infatti, non appartiene a nessun dominio ma puo’ sostituire valori in qualsiasi dominio
>[!info] e’ meglio usare null per rappresentare la mancanza di informazione, al posto che valori del dominio inutilizzati(potrebbero falsare i calcoli/dare problemi)
- inoltre, due valori NULL, anche se sullo stesso dominio, sono considerati diversi
### grado e cardinalita’ di una relazione
- grado → numero dei domini (attributi)
- cardinalita’ → numero di tuple
## attributi
un attributo e’ definito da un nome A(univoco in una tabella) e dal suo `dominio` , che viene indicato con dom(A)
ennupla → funzione che, dato un insieme di attributi R, associa ad ogni attributo A in R un elemento di dom(A)
>[!info] 
>l’insieme di attributi di una relazione e’ detto schema, e data una relazione R e i suoi attributi A1, A2, ….., Ak, e’ indicato da R(A1, A2, …., Ak)
>- lo schema descrive quindi la struttura della relazione (aspetto intensionale), mentre l’istanza della relazione e’ l’aspetto estensionale

## dati fra relazioni diverse
nel modello relazionale i riferimenti fra dati in relazioni diverse sono rappresentati per mezzo di valori dei domini che compaiono nelle ennuple

# vincoli di integrita’
proprieta’ che deve essere soddisfatta da ogni istanza della base di dati, che scrive proprieta’ specifiche del campo, e quindi delle informazioni ad esso relative, modellate attraverso la base di dati (a ““priori”””, quindi)
per essere corretta, una base di dati deve soddisfare tutti i vincoli di integrita’
>[!example] 
>(Voto ≥ 18) AND (Voto ≤ 30)
>COD2 UNIQUE
>DIP REFERENCES DIPARTIMENTO.NUMERO
## tipi di vincoli 
### vincoli intrarelazionali
definiti sui valori di singoli attributi, tra valori di attributi di una stessa tupla o tra tuple della stessa relazione
- vincoli di dominio → ASSUNZIONE > 1980
- vincoli di tupla → (Voto = 30) OR NOT (Lode = “si”)
- vincoli tra tuple della stessa relazione → COD2 UNIQUE
- vincolo di chiave primaria
- vincolo di unicita’
- vincoli di esistenza del valore per un certo attributo
- espressioni sul valore di attributi sulla stessa tupla
i vincoli intrarelazionali vengono formalizzati usando le [[#dipendenze funzionali]]
### vincoli interrelazionali
definiti tra piu’ relazioni
- vincoli tra valori in tuple di relazioni diverse → Studente references Studenti.Matricola
- #### vincolo di integrita’ referenziale(foreign key)
	porzioni di informazione in relazioni diverse sono correlate attraverso valori di chiave
	- e’ possibile definire “azioni” compensative a seguito di violazioni
## chiavi
attributo/insieme di attributi con cui e’ possibile identificare univocamente le tuple di una istanza di relazione
- ci possono essere piu’ chiavi in una relazione
consentono di mettere in relazione dati in tabelle diverse
### chiave primaria
la chiave piu’ robusta, composta da un numero minore di attributi
- non ammette valori null
## dipendenze funzionali
stabilisce un particolare legame semantico tra 2 insiemi non-vuoti di attributi X e Y, appartenenti ad uno schema R
X → Y si legge X determina Y
>[!example]
>supponiamo di avere uno schema di relazione VOLI(CodiceVolo, Giorno, Pilota, Ora)
>intuitivamente, possiamo dedurre che: 
>- un volo con un certo codice parte sempre alla stessa ora
>- esiste un solo volo con un dato pilota, in un dato giorno ad una data ora
>- c’e’ un solo pilota di un dato volo in un dato giorno
>- quindi:
>CodiceVolo → Ora
>{Giorno, Pilota, Ora} → CodiceVolo
>{CodiceVolo, Giorno} → Pilota

una relazione r con schema R soddisfa la dipendenza funzionale X → Y se:
- (i) la dipendenza funzionale X → Y e’ applicabile ad R, nel senso che sia X sia il Y sono sottoinsiemi di R;
- (ii) le ennuple in r che concordano su X concordano anche su Y, cioe’ per ogni coppia di ennuple t2 e t2 in r:
- t1[X] = t2[X] → t1[Y] = t2[Y]