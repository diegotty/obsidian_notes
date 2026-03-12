# intro
un design pattern è un modo di pensare il codice e la struttura ad oggetti !
- i pattern sono il succo dei principi di progettazione orientata agli oggetti
# strategy pattern
esempio: 
![[Pasted image 20240523190726.png]]
data questa gerarchia di classi, mi viene chiesto di aggiungere la funzionalità di volare, con il metodo vola().
## idea 1
istintivamente, verrebbe da aggiungere un metodo vola() alla classe Anatra.
- in questo modo modo però, se venisse aggiunta un’altra sottoclasse (per esempio, AnatraDiPlastica), avremmo dei problemi in quanto essa non vola. ora immaginiamo di avere altri 20 tipi di anatre che non volano ma ereditano il metodo vola() ….
>[!tuff] l’ereditarietà è utile per il riuso, ma meno per la manutenzione !
>mettendo un metodo vola() nella classe Anatra, mi sto mettendo i bastoni tra le ruote per eventuali nuove anatre che non volano

## idea 2
creiamo delle interfacce per ogni comportamento dell’anatra.
![[Pasted image 20240523191234.png]]
in questo modo, le sottoclassi possono implementare solo i comportamenti che effettivamente deve modellare !
- in questo modo però, distruggo ogni possibile **riuso** del codice, in quanto se non si riesce a definire un metodo di default, dobbiamo reimplementare le interfacce per ogni sottoclasse
>[!tuff] le interfacce sono utili per implementare comportamenti, ma distruggono ogni possibile riuso del codice

## soluzione
principio di design: identifica gli aspetti della tua applicazione che variano e separali da quelli che rimangono uguali.
- come separarli ? incapsulandoli
![[Pasted image 20240523225856.png]]
in questeo modo possiamo implementare l’interfaccia per ogni tipo di comportamento possibile
![[Pasted image 20240523225936.png]]
ora la classe Anatra può delegare i suoi comportamenti di volo e starnazzo, invece di implementarli direttamente
![[Pasted image 20240523230019.png]]
il comportamento di volo specifico verrà impostato nel costruttore di ciascuna sottoclasse !

questo pattern si chiama Strategy Pattern, il cui principio consiste nel preferire la composizione all’ereditarietà, in quanto invece di ereditare il comportamento, le anatre ottengono il loro comportamento mediante una composizione di oggetti di comportamento
- implementa il principio della delega (delegation), spostando le responsabilità sulla classe delegata
# observer pattern