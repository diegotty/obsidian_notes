## codifica
![[Pasted image 20240317130603.png]]
## cosa fa
esegue l’istruzione PC+4+registri[rs]
serve un mux messo dopo il mux del jump, che ha come entrata, quando la linea di selezione è 1, PC+4 + registri[rs]

## a
![[Screenshot 2024-05-08 (00.20.22).jpeg.png]]
## b

| istruzione | RegDst | ALUSrc | MemtoReg | RegWrite | MemRead | MemWrite | Branch | Jump | jrr | ALUOp1 | ALUOp2 |
| ---------- | ------ | ------ | -------- | -------- | ------- | -------- | ------ | ---- | --- | ------ | ------ |
| jrr        | 1      | x      | x        | 0        | 0       | 0        | 0      | 0    | 1   | x      | x      |

## c
100+100 ns = 200 ns (non è necessario incrementare il periodo di clock)