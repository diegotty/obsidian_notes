costituiscono la memoria privata di un oggetto ( sono [[private]] la maggior parte delle volte)
dichiarazione di un campo:
```java
private [final] [static] tipo_di_dati nome;
```
## final
un campo final è una costante(dopo il primo valore assegnatogli)
## static ( campo di classe)
un campo static è condiviso da tutti. è allocato una sola volta in memoria per tutti gli oggetti alcuni campi statici molto noti: 
- Math.PI
- Math.E
### importazione static
permette di importare i campi statici come se fossero definiti nella classe in cui si importano
```java
import static java.lang.Math.E;
import static java.lang.Math.*;
```