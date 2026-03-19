
```armasm
.data
	vettore: .word 4, 6, -3, 12, 9, -1, 3
	N: .word 7
	somme: .word 0,0
	
.text
main:
	and $t0, $t0, $zero #index
	lw $t1, N           #N
	and $t2, $t2, $zero #somma[0]
	and $t3, $t3, $zero #somma[1]
for:
	bge $t0, $t1, endFor
	sll $t4, $t0, 2
	lw $t4, vettore($t4)
	andi $t5, $t0, 1
	beqz $t5, else
		add $t3, $t3, $t4 #dispari
		j endIf
	else: 
		add $t2, $t2, $t4 #pari
	endIf:
	addi $t0, $t0, 1
	j for
endFor:
	sw $t2, somme($zero)
	sw $t3, somme + 4
	#namooo
```