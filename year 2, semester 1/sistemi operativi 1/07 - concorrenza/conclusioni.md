---
created: 2024-12-10
related to: "[[intro alla concorrenza]]"
updated: 2024-12-10T08:12
---
la condivisione di risorse può quindi essere implementata con 3 metodi diversi:
- [[mutua esclusione, soluzioni hardware|istruzioni hardware]](busy-waiting e starvation praticamente inevitabili)
- [[semafori|sincronizzazione]] (semafori)
- [[mutua esclusione, soluzioni software|message passing]]
>[!info] se si può implementare un’applicazione con uno qualsiasi dei 3 metodi, allora lo si può fare anche con gli altri 2
>un particolare meccanisco potrà rivelarsi più conveniente degli altri, in termini di facilità di sviluppo, di prestazioni, e di gestione