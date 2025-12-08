---
related to:
created: 2025-12-08, 16:52
updated: 2025-12-08T17:28
completed: false
---
cryptography is the field that offers techniques and methods of managing secrets. its primary purpose is to alter a message so that *only the intended recipients* can alter it back and read the original message. its purposes are:
- preserving *confidentiality*
- *authenticate* senders and receivers 
- facilitate message *integrity*
- ensure that the sender will not be able to deny transfer of the message (*non-repudiation*)
## symmetric key cryptography
this type of cryptography makes use of a number of classical encryption techniques, such as:
- *substitution*: replacing each character in the text with another character of the same o different alphabet
>[!example] caesar cipher
an example of a substitution cipher, the characters are replaced with a the character $k$ (the key) positions forward
>this cyclic permutation makes it easy to find the key, as there are only $N$
- *transposition*: changing the order of the characters in the text, but not the value
 - *XOR*: the XOR operator between a text (cipher or plain)and the key
 - *modular arithmetic operations*
 these steps are repeated multiple times !

>[!info] definitions
>- secret key: $K$
>- encryption function: $E_{k}(P)$
>- decryption function: $D_{k}(P)$
>- *efficiency*: $E_{k}(P)$ and $D_{k}(P)$ should have efficient algorithms
>- *consistency*: decrypting the ciphertext should yield the plaintext ($D_{k}(E_{k}(P))= P$)

slide 5, 6
