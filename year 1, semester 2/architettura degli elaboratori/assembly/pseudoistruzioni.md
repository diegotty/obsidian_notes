![[Pasted image 20240317165259.png]]
ble(branch if less than) è fittizio. in realtà è stato implementato come le 2 istruzioni a sinistra.

ragionamento:
```armasm
slt $1, $8, $17 
#setta $at($1) a 1 se $t0($8) è minore di $s1($17)
beq $1, $0, 0x00000001
#se $at è uguale a $0, vuol dire che $t0 è maggiore di $s1, e quindi $s1 è minore di $t0, quindi il branch è vero, e salta all'etichetta checkC(0x00000001)
```