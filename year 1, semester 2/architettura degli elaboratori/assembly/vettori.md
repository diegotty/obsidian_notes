
si possono definire staticamente nella sezione .data del programma assembly !
l’etichetta indicherà l’indirizzo del primo elemento del vettore
[!tuff] per indirizzare l’elemento i-esimo, bisogna aggiungere l’offset
i * dimensione_elemento


## strings
```armasm
label2: .asciiz "sopra la panca"
```
vettore di caratteri (ongi carattere è un byte) seguiti da /0 al termine 

## ordinamento byte di word

il processore MIPS permette l’ordinamento dei byte di una word in 2 modi:
### big-endian
i byte della word sono memorizzati dai **most** signficant byte al **last** significant byte
![[Pasted image 20240317175058.png]]
è l’ordinamento più intuitivo (il vettore contiene 1, 2, 3, 4, 5, 6)
### little-endian
i byte della word sono memorizzati dal **least** signficant byte al **most** signficant byte 
![[Pasted image 20240317175138.png]]
molto meno intuitivo (il vettore contiene 1, 2, 3, 4, 5, 6)
![tuff] mars usa l’ordinamento little-endian !!

more on slides 05-11

## accesso agli elementi per indice
esistono 2 modi per scorrere i vettori nei cicli:
### scansione per indice
tengo traccia dell’indice, e ogni volta che devo accedere agli elementi mi calcolo l’offset corrispondente
pro:
- comodo se si deve usare l’indice per controlli o altro
- l’incremento dell’indice non dipende dalla dimensione degli elementi !
- comodo se il vettore è allocato staticamente
contro:
- ogni volta che devo accedere agli elementi bisogna calcolare l’offset corrispondente

```armasm
vettore: .word 1,2,3,4,5,6,7,8,9
N:       .word 9
Somma:    .word 0
.text
main:
	li $t0, 0 #index
	lw $t1, 0 #N
	li $t2, 0 #somma
loop:
	bge $t0, $t1, endLoop
	sll $t3, $t0, 2       #offset di 1 word  |SCANSIONE
	lw $t3, vettore($t3)  #riuso t3 !!       |CON INDICE !
	addi $t2, $t2, $t3
	addi $t0, $t0, 1
endLoop:
	sw $t2, Somma
```
### scansione per puntatore
manipolo direttamente il registro che indica l’indirizzo in memoria
pro:
- si lavora direttamente su indirizzi di memoria
- meno calcoli nel ciclo
contro:
- non si ha a disposizione l’indice dell’elemento
- l’incremento del puntatore dipende dalla dimensione degli elementi(non so che contro sia in verità)
- bisogna calcolare l’indirizzo successivo all’ultimo elemento (per uscire dal ciclo)
```armasm
vettore: .word 1,2,3,4,5,6,7,8,9
N:       .word 9
Somma:    .word 0
.text
main:
	lw $t1, N
	li $t2, 0
	la $t0, vettore         #carico indirizzo del vettore !(non byte     |WHOLE                                                                corrispondente)
	ssl $t1, $t1, 2         #calcolo offset out of bounds                |LOTTA
	add $t1, $t1, $t0       #indirizzo out of bouds (x il vettore)       |INSTRUCTIONS
loop:
	bge $t0, $t1, endLoop   #confronto indirizzi, non indici
	lw $t3, ($t0)           #non devo calcolare offset                   |NGL
	add $t2, $t2, $t3
	addi $t0, $t0, 4        #incremento l'indirizzo(scorro 1 word alla   |!!                                                                 volta)
	j loop
endLoop:
	sw $t2, Somma
```

## matrici
### matrici 2d
una matrice M x N è una successione di M vettori, ciascuno di N elementi.
la dimensione totale è M * N * dimensione_elemento
```àrmasm
	Matrice: .word 0:91        #spazio per una matrice 7 * 13
```
di base nella memoria non cambia nulla, è solo un vettore molto lungo per il quale offset è relativamente più facile da calcolare perchè lo immaginiamo in questo modo:
![[Pasted image 20240317182706.png]]
l’elemento e si trova a (2 * 13) + 9 = 35 word di offset

### matrici 3d
una matrice 3D di dimensioni M x N x P è una successione di P matrici 2D grandi M x N
![[Pasted image 20240317182947.png]]
elemento a coordinate x,y,z:
- si trova nella z-esima matrice M x N
- alla y-esima riga di quella matrice
- all’ x-esima posizione di quella riga
z * (M x N) + (y * N) + x * dimensione_ elemento = offset !
[!tuff] fuck me