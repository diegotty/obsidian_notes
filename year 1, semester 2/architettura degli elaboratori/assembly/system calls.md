## syscall
richieste al sistema operativo
 - input:
	 - `$v0` : operazione richiesta
	 - `$a0,.., $a2, $f0` : eventuali parametri
- output:
	- `$v0, $f0` : eventuale risultato



| syscall($v0) | service      | argomenti($a0, ..)                                          | risultato($v0, …)            |
| ------------ | ------------ | ----------------------------------------------------------- | ---------------------------- |
| 1            | print_int    | `$a0` = integer                                             |                              |
| 2            | print_float  | `$f12` = float                                              |                              |
| 3            | print_double | `$f12` = double                                             |                              |
| 4            | print_string |                                                             |                              |
| 5            | read_int     |                                                             |                              |
| 6            | read_float   |                                                             | float(in`$f0`)               |
| 7            | read_double  |                                                             | double (int `$f0`)           |
| 8            | read_string  | `$a0` = buffer, `$a1` = length                              |                              |
| 9            | sbrk         | `$a0` = amount                                              | address(in `$v0`)            |
| 10           | exit         |                                                             |                              |
| 11           | print_char   | `$a0` = char                                                |                              |
| 12           | read_char    |                                                             | char (in `$a0`)              |
| 13           | open         | `$a0` = filename(string),<br>`$a1` = flags, `$a2` = mode    | file descriptor (in `$a0`)   |
| 14           | read         | `$a0` = filename(string),<br>`$a1` = buffer, `$a2` = length | num chars written (in `$a0`) |
| 15           | write        | `$a0` = filename(string),<br>`$a1` = buffer, `$a2` = length | num chars written (in `$a0`) |
| 16           | close        | `$a0` = file descriptor                                     |                              |
| 17           | exit2        | `$a0` = result                                              |                              |

### syscall 10
la syscall 10 viene usata perchè in assembly non esiste uno scope, quindi di solito i programmi sono strutturati in questo modo:
```armasm
.text
main:
	li $v0, 10
	syscall
#funzioni varie !
func1:
	code ...
```