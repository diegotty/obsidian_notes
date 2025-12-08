---
related to:
created: 2025-12-08, 16:52
updated: 2025-12-08T20:53
completed: false
---
# introduction
cryptography is the field that offers techniques and methods of managing secrets. its primary purpose is to alter a message so that *only the intended recipients* can alter it back and read the original message. its purposes are:
- preserving *confidentiality*
- *authenticate* senders and receivers 
- facilitate message *integrity*
- ensure that the sender will not be able to deny transfer of the message (*non-repudiation*)
>[!info] definitions
>- secret key: $K$
>- encryption function: $E_{k}(P)$
>- decryption function: $D_{k}(P)$
>- *efficiency*: $E_{k}(P)$ and $D_{k}(P)$ should have efficient algorithms
>- *consistency*: decrypting the ciphertext should yield the plaintext ($D_{k}(E_{k}(P))= P$)
# symmetric key cryptography
this type of cryptography makes use of a number of classical encryption techniques, such as:
- *substitution*: replacing each character in the text with another character of the same o different alphabet
- *transposition*: changing the order of the characters in the text, but not the value
 - *XOR*: the XOR operator between a text and the key (both encoded ad binary sequences)
 >[!example] binary encoding + XOR
 ![[Pasted image 20251208193759.png]]
 
 - *modular arithmetic operations*
 these steps are repeated multiple times !
## substitution ciphers
>[!example] caesar cipher
an example of a substitution cipher, the characters are replaced with a the character $k$ (the key) positions forward
>this cyclic permutation makes it easy to find the key, as there are only $N$ possibilities to try, where $N$ is the number of characters in the alphabet
>
>it is possible to improve the cipher by using a permutation of the original alphabet
![[Pasted image 20251208185200.png]]
## encrypting natural languages
english is typically represented with 8-bit ASCII encoding, making, thus a message with $t$ characters corresponds to a $n$-bit array, with $n=8t$
however, due to redundancy (repeated words, patterns like “th”, “ing”, etc) english plaintexts are a *very small subset* of all n-bit arrays, thus making it easier to break the ciphers
### frequency analysis
*frequency analysis* is a kind of *cryptanalisis*, the study of methods for defeating cryptographic systems (by finding weaknesses in the ciphers, protocols to discover a secret key, etc …)
ciphertexts made by substitution (in a single alphabet) can be analyzed by calculating the frequencies of characters in a ciphertext, and comparing the frequencies of characters in typical text of the same language
>[!info] english frequency analyis
![[Pasted image 20251208180823.png]]

this way, it is possible to have an “accurate guess” of some of the substitution pairs in the ciphertext ! smart
>[!info] frequency analysis on other languages
![[Pasted image 20251208181040.png]]
of course this technique can be used for other languages, and even alphabets that use different characters

it can also be used on gropus of characters to get better results
>[!info] distribution of 2-character pairs
![[Pasted image 20251208181557.png]]
###  poly-alphabetic ciphers
single-alphabet  ciphers, even with random permutations of them, are relatively easy to break.
to make a stronger substitution cipher, (to defeat frequency analysis) we need something like a *poly-alphabetic* (as in, multiple different alphabet shifts for a character) substitution cipher
- we use a word as a key, and the characters in the key determine displacement: 
- this way, the same character in the plaintext *may be represented by a different designated character* ! fire
>[!example] poly-alphabetic cipher example
![[Pasted image 20251208182345.png]]

this way, cryptanalysis is difficult, but not impossible
>[!info] vigenere code
vigenere cipher (*le chiffre indèechiffrable*) is a type of poly-alphabetic cipher in which all possible cyclic permutations of the alphabet come to play
>- columns: current plaintext character
>- rows: current key character
>- table[i][j]: current ciphertext character
![[Pasted image 20251208183005.png]]
>>[!example] example
>>![[Pasted image 20251208183210.png]]

#### one-time pad
a vigenere cipher that uses a key as long as the ciphertext, resulting in a *mathematically unbrekable* cipher. the conditions for its perfect secrecy are:
- the pad (key) used is generated using a genuine source of randomness
- the pad has the same length as the plaintext
- the pad is destroyed immediately after use, and never reused for any other mesage
for any given ciphertext, *every possible plaintext message of the same length is equally likely*, breaking frequency analysis
the main drawbacks of the one-time pad are:
- the key distribution problem
- the key size
- the reusage problem
however, they also have weaknesses:
- the key has to be as long as the plaintext
- keys can never be reused
## transposition ciphers
>[!example] rail fence cipher
also called the zigzag cipher, it consist in arranging in a zig-zag pattern and reading the message by row
![[Pasted image 20251208185409.png]]
### permutation
the message is split in blocks of length $m$, and each block is rearranged with the same permutation (algebra !!), which is the key
- to decrypt, just apply the reverse permutation on the blocks of the ciphertext
>[!example] permutation cipher
![[Pasted image 20251208185633.png]]

### columnar transposition
the message is split in rows of length $n$ (which is the key), and then read by columns
- to decrypt, just divide the message length for the key to find the number of columns, then write the ciphertext by columns and read by row
>[!example] 
![[Pasted image 20251208185822.png]]
### keyed columnar transposition
the plain text is written by row, then the columns are rearranged according to a permutation
>[!example]
![[Pasted image 20251208190340.png]]

## modern cryptography
because of the high redundancy of natural language, historic codes are often breakable by analysing, using statistics the cipher
thus, *more complex codes are needed !*
the basic ideas to modern codes are:
- *diffusion*: spread redundancy around the ciphertext
- *confusion*: make encryption function as complex as possible, making it difficult to derive teh key analyzing the ciphertext
>[!info] computational security
encryption is computationally secure if:
>- the cost of breaking cipher exceeds the value of information
>- the time required to break a cipher exceeds the useful lifetime of the information

>[!info] feistel network
in 1973, Feistel proposed the concept of a *product cipher*: the execution of two or more simple ciphers in a sequence, in such a way that the final result is cryptographically stronger than any of the component ciphers
## block cipher
in a *block cipher*, the plaintext of length $n$ is partitioned into a sequence of $m$ blocks, and is encrypted/decrypted in terms of these blocks
- if the last block is shorter, extra bits are used as padding
>[!info] S-boxes
### DES
*data encryption standard* (*DES*) is a scheme developed by IBM. it uses *64-bit blocks* and *56-bit keys*
it uses the *DEA* (algorithm), a set of three steps. its heart is the feistel cipher !
### 2DES
the small key space makes a search attack feasible 
in 1992 it was shown that DES is not a group: two DES encryptions are not equivalent to a single encryption, thus making multiple enchipherment effective
#### meet in the mdidle attack
however, the *meet in the middle attack* proved that the secuirty of double DES was not as expected:
with a key size of 112, the expected security is bruteforcing $2^{112}$ keys. however, the encryption process can be spit into two independent parts, making the complexity of the attack only *additive*, not multiplicative
by starting with a *known-plaintext attack* (*PDA*), the attacker can:
- meet from the left: encrypt the the plain text once, to a intermediate value $I$
- meet from the right: decrypt the cipher once, to an intermediate value $I'$
- both operations must equal the same intermediate value (for reason i kinda understand but cba to write it), so $I=I'$
to encrypt and decrypt, the attacker uses every possible key in the $2^{56}$ key space for both $K_{1}$ and $K_{2}$ to find the match (the two keys that calculate the same $I$ value)
- the total computational effort is $2\cdot 2^{56}$, which is exponentially smaller than $2^{112}$
### 3DES
this block cipher was developed as a direct and immediate fix for the security weaknesses found in the DES, to provide a transition period until a completely new cipher (AES) could be standardized
it uses a triple *encryption-decryption-encryption* sequence to encrypt, and the reverse order (*decryption-encryption-decryption*) to decrypt.
it can be used with either two or three independent keys

| option               | keys used                                                            | effective key length     | security status                                                                             |
| -------------------- | -------------------------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------- |
| *3TDES (triple-key)* | $K1, K2, K3$ are all independent.                                    | $56 \times 3 = 168$ bits | strongest: resists MITM attacks.                                                            |
| *2TDES (two-key)*    | $K1$ and $K3$ are the same, $K2$ is independent ($K1 = K3 \neq K2$). | $56 \times 2 = 112$ bits | still strong enough to resist brute force and MITM attacks. the most common implementation. |
| *1TDES (single-key)* | $K1 = K2 = K3$                                                       | 56 bits                  | equivalent to single DES (used for backward compatibility).                                 |
despite its strength to basic brute-force attacs
### AES

>[!info] brute forcing modern block ciphers
![[Pasted image 20251208201524.png]]
