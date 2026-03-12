---
related to:
created: 2025-03-02T17:41
updated: 2026-01-22T21:57
completed: true
---
# shell
la shell è un’interprete di comandi: un programma che esegue altri comandi
esistono vari tipi di shell: 
- Thompson/Bourne shell: sh
- Bourne-Again shell: bash
- KornShell: ksh
- zsh (extended and improved bash shell, con feature da ksh, bash, tcsh)
## comandi
le opzioni possono essere specificate in 2 modi:
- `-carattere` (vecchia versione) (es: `-r`)
- `--parola` (nuova versione) (es: `--recursive`)
le opzioni possono avere un argomento, specificato in modi diversi:
  - `--key=1`
  - `-k 1`
  - `-k1`
  - le opzioni senza argomento sono raggruppabili come `-b -r -c` che è equivalente a `-brc`
  - esistono anche le opzioni BSD-style, che sono senza dash come `tar xfz nomefile.tgz`
>[!example] comando `man`
`man` sta per manuale, e ci permette di avere più informazioni sul comando specificato come argomento
sinossi del comando `man`: `man [sezione] comando`
`man man`: 
![[Pasted image 20250304212204.png]]
>>[!info] man **sections**
>>- `1`: user commands
>>- `2`: system calls
>>- `3`: library calls
>>- `4`: devices and special files
>>- `5`: file formats
>>- `6`: games
>>- `7`: misc
>>- `8`; system admin commands
>>- `9`: kernel routines
# utenti

> [!warning] non tutti gli utenti possono fare login !
>  **l’utente `root` non può fare login** ma un utente può acquisire i diritti di `root` mediante i comandi `su` e `sudo`

- ogni utente appartiene almeno ad un gruppo
- esistono molti gruppi definiti per scopi “amministrativi”
## su e sudo
utente **sudoer**: utente che appartiene al gruppo predefinito`sudo`
- `sudo`: usato dagli utenti che appartengono al gruppo `sudo`, permette di eseguire **un comando** da `root`
	- con flag `[-u] username` permette di specificare l’utente da impersonare
- `su [- / -l / --login] nomeutente`: usato per **cambiare utente**
	- `su -`, `su - root`, `su -l root` permettono di diventare root per il resto della sessione sulla shell ! 
