---
related to:
created: 2025-12-08, 16:52
updated: 2025-12-15T12:46
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
## characteristics
symmetric cryptography is used because:
- it is understandable and easy to use
- it is efficient (which is a key consideration when messages are transmitted frequently or/and are lengthy)
- the keys used are relatively short
- can be used for many applications and can be easily combined
however, it has many limitations:
- the users must share the same key
- during transmission of the key, someone may intercept it (big challenge: a *KDC* (*key distribution center*: a trusted third party) may be used for managing and distributing keys)
- the number of keys needd increases at rapid rate as the number of users in the network increases
- secret key cryptography cannot provide an assurance of authentication
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
## block ciphers
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
despite its strength to basic brute-force attacks, it is considered *legacy* technology beacause of its slow speed and small block size, which makes it susceptible to modern attacks such as *sweet32*
### AES
the *advanced encryption standard* (*AES*) is a block cipher that operates on *128-bit blocks*, and can use keys that are *128, 192 or 256 bits long*
- this renders an exhaustive search attack currently impossible
#### round structure
128bit AES uses 10 rounds, and each round is an invertible transformation
- the starting value is $X_{0}$, which is the XOR of the plaintext and the key ($X_{0} = P \,\oplus K$)
- the ciphertext $C$ is $X_{10}$
each round is built from *four basic steps*:
- *SubBytes*: S-box substitution
- *ShiftRows*: permutation
- *MixColumns*: matrix multiplication
- *AddRoundKey*: XOR with a round key, derived from the 128-bit encryption key

>[!info] brute forcing modern block ciphers
![[Pasted image 20251208201524.png]]

## block cipher modes
a block cipher algorithm is not sufficient to encrypt a large file: as block ciphers are deterministic, encrypting the same 128-bit block of plaintext twice, with the same key, will result in the same 128-bit block of ciphertext.
- if a message contains repeated blocks of data (as we saw, very common in natural languages !), these blocks would create a pattern that a cyptanalyst could exploit.
we solve this isssue by introducing *randomness* and *dependency between blocks*

a block cipher mode describes the way a block cipher encrypts and decrypts a *sequence of messsage blocks* (longer than the cipher’s fixed block size),  between the five *modes of operation* defined by NIST
### electronic code book
*ECB* is the most simple mode, but also the most insecure: each plaintext block is encrypted entirely independently of all other blocks:
$$
C[i] = E_{k}(P[i])
$$
the same happens for decryption:
$$
P[i] = D_{k}(C[i])
$$
>[!info] graphic
>![[Pasted image 20251210224033.png]]
the block cipher algorithm is used on every block independently

this mode allows for parallel encryption of the blocks of plaintext, and it can tollerate the loss/damage of a block (as there are no dependencies)
however, encryption patterns in the plaintext are repeated in the ciphertext !
### cipher block chaining
in *CBC*, each plaintext block is XORed with the previous ciphertext block *before* it is encrypted
$$
C[i] = E_{k}(P[i] \oplus C[i-1])
$$
the very first block uses a random, non-secret block of data, called *initialization vector*, that was separately transmitted
$$
C[-1] =  V
$$
$$
C[i] = E_{k}(P[i] \oplus C[i-1])
$$
the same happens for decryption:
$$
P[i] = C[i-1] \oplus D_{k} (C[i])
$$
this mode introduces dependency, hiding patterns in the plaintext. it is fast and relatively simple, which makes it the most common mode.
its weaknesses are the requirement on reliable transmission of all the blocks *sequentially*, which makes it not suitable for applications that allow packet loss
### cipher feedback
a mode that is designed to make a block cipher behave like a *stream cipher*.
it uses the previous ciphertext block to determine the *encryption state* for the next block, creating a strong dependency chain
it starts with a *initialization vector* (*IV*), which is encrypted with the secret key to make a *keystream block*
$$
$$
the keystream block is XORed with the first block of plaintext to produce the first block of ciphertext, which is used as *the input* (or feedback) for the next encryption step
$$
C[0]
$$
$$
C[i] = P[i] \oplus C[i-1]
$$

### output feedback
### counter
like *cipher feedback*, i
>[!info] summary
>![[Pasted image 20251210223118.png]]
## stream ciphers
a *stream cipher* treats the message to be encrypted as one continous stream of characters
it achieves this by generating a long stream of *pseudorandom bits*, the *keystream*, which is then combined with the plaintext 
- the security of a stream cipher relies entierly on the quality and unpredictability of the keystream generator !

 stream ciphers they can be thought of block ciphers with block size of one (one-time pad cipher can be considered a stream cipher where the key length equals the message length !)
 - useful when plaintext needs to be processed one symbol at a time or the message is short (as short messages with block cipher need padding)
 stream ciphers have different characteristics from block ciphers. they:
 - should have long periods without repetition (sequence of bits) in the keystream
 - need to depend on a large enough key (128 or 256 bits)
 - the logic used to generate the next bit of the keystream must be complex: a single change in the *cryptovariables* (a set of internal state variables used to generate the keystream) or the initial key should *radically change* the resulting keystream ($\implies$ high complexity and good diffusion)
 - should be statistically unpredictable (can’t be inferred from a segment of the keystream)
 - the *keystream* should be statistically unbiased: it should contain a equal number of 0s and 1s
 >[!info] block vs stream ciphers
>stream ciphers favoured because they:
>- are generally much faster as the operation is a simple XOR instead of multiple rounds of complex substitutions
>-dont allow for *error propagation*, as if a single bit corrupts, it doesnt affect the rest of the plaintext. block ciphers can corrupt the entire current block and possibly subsequent blocks
>
>however, they are :
>- *low diffusion*, making them less robust against certain types of attacks
>subject to *malicious insertion and modification*: since the encryption process is linear, an attacker can easily manipulate the ciphertext to change the plaintext in a predictable way, without ever knowing the key
>	- lack of integrity !!

### RC4
*RC4* is a proprietary stream cipher, owned by RSA and developed by Ron Rivest in 1987. it can have a *variable key size* (from 1 to 256 bytes), and performs byte oriented operations
- it was widely used but is now considered insecure and should not be used !!!

>[!info] the core mechanism
the KSA (key scheduling algorithm) inizialises a secret internal state `S`, based on the user-supplied secret key `K`

```python
## KSA
for i = 0 to 255 do
	S[i] = i; ## identity permutation
	T[i] = K[i mod keylen]; ## repeated key

j = 0;
for i = 0 to 255 do
	j = (j + S[i] + T[i]) mod 256;
	Swap(S[i], S[j]);
	
## PRGA
i, j = 0
while(true)
	i = (i + 1) mod 256;
	j = (j + S[i]) mod 256;
	Swap(S[i], S[j]);
	t = S(S[i] + S[j]) mod 256;
	k = S[t];
	Output k;
```


>[!info] block vs stream ciphers: speed comparison
![[Pasted image 20251210222010.png]]

