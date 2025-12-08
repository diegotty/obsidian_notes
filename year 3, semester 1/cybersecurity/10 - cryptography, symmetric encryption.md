---
related to:
created: 2025-12-08, 16:52
updated: 2025-12-08T18:11
completed: false
---
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
## symmetric key cryptography
this type of cryptography makes use of a number of classical encryption techniques, such as:
- *substitution*: replacing each character in the text with another character of the same o different alphabet
>[!example] caesar cipher
an example of a substitution cipher, the characters are replaced with a the character $k$ (the key) positions forward
>this cyclic permutation makes it easy to find the key, as there are only $N$ possibilities to try, where $N$ is the number of characters in the alphabet
>
>it is possible to improve the cipher by using a permutation of the original alphabet
![[Pasted image 20251208180142.png]]
- *transposition*: changing the order of the characters in the text, but not the value
 - *XOR*: the XOR operator between a text (cipher or plain)and the key
 - *modular arithmetic operations*
 these steps are repeated multiple times !
### encrypting natural languages
english is typically represented with 8-bit ASCII encoding, making, thus a message with $t$ characters corresponds to a $n$-bit array, with $n=8t$
however, due to redundancy (repeated words, patterns like “th”, “ing”, etc) english plaintexts are a *very small subset* of all n-bit arrays, thus making it easier to break the ciphers
#### frequency analysis
ciphertexts made by substitution (in a single alphabet) can be analyzed by calculating the frequencies of characters in a ciphertext, and comparing the frequencies of characters in typical text of the same language
>[!info] 
![[Pasted image 20251208180823.png]]
this way, it is possible to have an “accurate guess” of some of the substitution pairs in the ciphertext ! smart
of course this technique can be used for other languages, and even alphabets that use different characters
![[Pasted image 20251208181040.png]]
 


slide 5, 6
