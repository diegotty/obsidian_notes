---
related to:
created: 2025-03-02T17:41
updated: 2025-12-27T12:06
completed: false
---
# authentication
>[!def] authentication
the process of establishing confidence in user identities that are presented electronically to an information system

there are many identification requirements to protect data:
- *uniquely* identify and authenticate system *users* , and associate that unique identification with processes acting on behalf of those users
- *uniquely* identify and authenticate *devices* before establishing a system connection
- implement *replay-resistant* authentication mechanisms for access to privileged and non-privileged accounts
- obscure *feedback of authentication* information, during the authentication process
>[!info] replay attacks
a replay attack consists in capturing a valid message (/authentication data) and *resend* the same message later to the receiver, to illicitly repeat the original action (or in this case, gain access )
>- because the message is valid, the receiver may accept it as genuine and perform the requested action

so three things must be managed:
- *identifiers*
	- select and assign an indentifier that identifies an individual group, role, service or device
	- prevent the use of identifiers for a defined period of time
- *passwords*
	- maintain a list of commonly used, expected or compromised password (and frequently update the list), and verify that those passwords are not used when users create passwords
	- transmit passwords only over cryptographically protected channels
	- store passwords in a cryptographically protected form
	- select a new password upon first use after account recovery
	- enforcce composition and complexity rules for passwords
- *authenticator* (the element that allows to perform the authentication)
	- verify the identity of the individual receiving the authenticator 
	- didnt understand ngl TODO 
	- change or refresh authenticators frequently or when relevant events occur
	- protect authenticator content from unauthorized disclosure or modification
>[!info] digital identity guidelines architecture model
![[Pasted image 20251026160008.png]]
## means of authentication
the four means of authenticating user identity are based on:
- *password*: something the individual knows (PIN, secret answers)
- *token*: something the individual possesses (smart card, physical key)
- *biometrics*: something the individual is (fingerprint, iris, face)
- *dynamic biometrics*: something the individual does (voice pattern, handwriting, typing rhythm (*keystroke dynamics*), walking style (*gait recognition*))
*multifactor authentication* (the use of more than one authentication means) is advised 
## assurance leves for user authentication
an organization can choose from a range of authentication technologies, based on the *degree of condifence in identity proofing* and authentication processes
the three levels of *identity assurane levels* (*IAL*), or how strong you prove who you are, when getting an account/credentials (and so how verified is the identity of the account), are:
- *IAL 1*: no link from applicant to a specific real-life identity (no confidence or minimal confidence)
- *IAL 2*: idenity is verified using either remote or physically-present identity proofing (moderate to high-confidence)
- *IAL 3*: identity is verified  mandatorily through physical presence (high-confidence)

*authenticator assurance levels* (*AAL*) define how strong an authentication method is (this also works for multifactor authentication). they are options an organization can select,based on the need for assurance (which is based on their risk assessment and the potential harm caused by an attacker taking control of an authenticator)
- *AAL 1*: provides some assurance of authentication via user-supplied ID and password
- *AAL 2*: provides high confidence of authentication via proof of possession and control of two authentication factors
- *AAL 3*: provides very high confidence of authentication via proof of possession and control of two authentication factors
## passwords
password-based authentication has many vulnerabilities !
- also , passwords’ weakness is that they have to be stored in human memory! so they tend to be easy

>[!info]-  storing a password, UNIX-style
> - *legacy*
>	 - up to 8 printable characters in length
>	 - 12bit salt used to modify DES encryption into a one-way hash function
>	- zero value repeatedly encrypted 25 times
>	- output translated to a 11 character sequence
>- *today*	
>	-  you got me ….

### password strength
what makes a password strong ?
- UPPER/lower case characters
- special numbers
- numbers
- unpredictibility
- length


attacks include:
- *social engineering*: attempts to use various psychological conditions in humans to get hold of confidential information (es: pretexting, baiting, quid pro quo)
- *dictionary attacks*: used when the password’s hash is already obtained. a large dictionary of possible (common) passwords is tried against the password file. this way, each password must be hashed using each salt value, and then compared to stored hash values (so you need the salt and the hash of the password you want to crack
- *rainbow table attacks*: also used when the password's hash is already obtained. huge table of hash values is pre-computed (using all salts)
## password selection strategies
- *user education*: users can be told the importance of using hard to guess passwords, and can be provided with guidelines for selecting strong passwords
- *computer generated passwords*: however, users have trouble remembering them
- *reactive password checking*: system periodicaly runs its own password cracker to find guessable passwords
- *complex password policy*: system checks to see if the password selected by the user is allowable, and if not, rejects it. the goal is to eliminate guessable passwords while allowing the user to select a password that is memorable
	- hard to strike a balance + a disadvantage is the space required by dictionaries and the time to check
>[!info] periodically changing password
requiring users to change passwors periodically, while intuitive, is not a good practice, as, because of the added burden of the periodical change, incentivizes weaker passwords that are easier for people to set and remember (thus diminishing secuirty)
## tokens
lets talk about the only cool tokens: *smart tokens*
- they include an embedded microprocessor
- are small portable objects and can look like bank cards, calculators, keys
- they may include keypads or a display for human/token interaction
- they require an electronic interface (contact or contactless) to communicate with compatible reader/writer
- can use different authentication protocols: static, dynamic password generators, and challenge-response
## smart cards
they are the most important category of smart tokens. with the appearance of a credit card, an electronic interface and an entire microprocessor (with processor, memory and I/O ports)
- it usually contains three types of memory:
	- *ROM*: stores data that does not change during the card’s life
	- *EEPROM* (electrically erasable programmable ROM): holds application data and programs
	- *RAM*: holds temporary data generated when applications are executed
>[!info] workflow
![[Pasted image 20251026160138.png]]

*password authenticated connection establishment* (*PACE*) is used to ensure that the contactless RF(radio-frequency) chip in the card cannot be read without explicit access control:
- for online applications, access is established by the user entering the six-digit PIN, known only to the holder of the card
- for offline applications, either the *machine-readable zone* (*MRZ*) on the back of the card, or the six-digit *card access number* (*CAN*) printed on the front is used
### OTPs
*one-time password* devices have a secret key to generate an OTP, that the user enters and the system valides
- such devices use a block cipher/hash function to combine secret key and time or nonce (coined for one occasion) value to create the OTP
- they contain a tamper-resistant module (TRSM) to store the secret key securely 
#### TOTPs
such OTPs can be time-based (*TOTPs*), used in many hardware tokens and by many mobile authenticator apps
the client and the server both share a secret key and a time step (in seconds). both the client and the server calculate a `T` value (`current_unix_time/time_step`).
`T` is then used in the HMAC (hash-based [[02 - cryptography#MAC|MAC]]) as the message, and the secret key is used as, well, the secret key, to get an authentication tag (that, as we know, ensures authenticity)
- TOTPs are safe to replay attacks ! as the code changes every 30 seconds
an open standard for secure authentication is *FIDO2*
## mobile phones
mobile phones can be used as an authentication device by:
- using authentication codes via*SMS*
- using authentication apps
## biometrics
biometric refers to any measure used to uniquely identify a person based on biological or physiological traits.
- such systems are based on pattern recognition
- they are technically complex and expensive when compared to passwords and tokens

biometric systems incorporate sensors or scanners to read biometric information, then compare this information to stored tempates of accepted users before granting access (as seen below, the feature vector is different from the reference vector, and a comparison algorithm is used to define if they match)
>[!info] representation
![[Pasted image 20251026160104.png]]
in fact, the *biometric accuracy dilemma* consists in determing the right threshold $(t)$ to separate impostors from genuine users
![[Pasted image 20251026160306.png]]
>>[!example]- example for a face recognition system
>![[Pasted image 20251026160436.png]]

### security vs convenience
the following graph shows, in log-log scale:
- on the *x-axis*, the false match rate
- on the *y-axis*, the false nonmatch rate
by convenience, we mean user-friendliness
>[!figure]- graph
>![[Pasted image 20251026160808.png]]

>[!info] flow of biometric systems
![[Pasted image 20251026162149.png]]
## remote user authentication
its authentication over a network, the internet or a communication link
 - it is subject to many security threats (eavesdropping, capturig a password, replay attacks)
 - it generally relies on some form of a challenge-response protocol to counter threats
 >[!info] diego learns what SSH is
 *secure shell* (*SSH*) was born as a replacement for telnet (client-server application provides remote access to a terminal) and such protocols, as they trasmitted authentication tokens (username and password) as plaintext through unsecure public networks.
 SSH mitigates this risk through the use of encryption mechanisms to hide the contents of the transmission
 SSH uses public-key cryptography to authenticate the remote computer 

>[!figure] basic challenge-response protocol for remote user authentication
>password and token:
![[Pasted image 20251026163239.png]]
>
>static and dynamic biometric: 
![[Pasted image 20251026163358.png]]
## authentication security issues
ho mollato …..
>[!info] attacks table
![[Pasted image 20251026163715.png]]
![[Pasted image 20251026163743.png]]