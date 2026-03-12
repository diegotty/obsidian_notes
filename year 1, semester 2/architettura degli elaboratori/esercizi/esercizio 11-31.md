---
undefined: ""
---

| istruzione | codice binario | RegDst | ALUSrc | MemtoReg | RegWrite | MemRead | MemWrite | Branch | ALUOp1 | ALUOp0 |
| ---------- | -------------- | ------ | ------ | -------- | -------- | ------- | -------- | ------ | ------ | ------ |
| tipo R     | 000000         | 1      | 0      | 0        | 1        | 0       | 0        | 0      | 1      | 0      |
| lw         | 100011         | 0      | 1      | 1        | 1        | 1       | 0        | 0      | 0      | 0      |
| sw         | 101011         | 0      | 1      | 0        | 0        | 0       | 1        | 0      | 0      | 0      |
| beq        | 000100         | 0      | 0      | 0        | 0        | 0       | 0        | 1      | 0      | 1      |
