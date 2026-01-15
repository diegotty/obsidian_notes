---
related to:
created: 2025-11-30, 13:45
updated: 2026-01-15T22:11
completed: false
---
vv
>”a condition at an interface under which *more input* can be placed into a buffer or data holding area than the capacity allocated, *overwriting other information*
>- attackers exploit such a condition to crash a system or to insert specially crafted code that allows them to gain control of the system

when a process attemps to store data beyond the limits of a fixed-sized buffer, it overwrites adjacent memory locations that could hold variables, parameter or program control flow data
- this could happen on the stack, in the heap, or in the data section of the process
>[!example] basic overflow example
>vulnerable code:
>```c
>int main(int argc, char *argv[]) {
>    int valid = FALSE;
>    char str1[8];
>    char str2[8];
>
>    next_tag(str1); // function call to populate str1 with a known value to match
>    gets(str2); //unsafe function to read user input into a fixed-size buffer
>
>    if (strncmp(str1, str2, 8) == 0) 
>        valid = TRUE;
>
>    printf("buffer1: str1(%s), str2(%s), valid(%d)\n", str1, str2, valid);
>}
>```
>(we assume that `str1` and `str2` are adjacent !)
>the buffers are of fixed size, and the function `gets()` reads input until it encounters a newline character or end-of-file, therefore performing *no bounds checking*
>- if the user provides an input string longer than 8 bytes, the excess data overflows `str2` and overwrites adjacent variables on the stack(e.g. `str1`, the return address of the function)
>
> execution:
>```bash
>## ok example
>$cc -g -o buffer1 buffer1.c$ ./buffer1
>START
>buffer1: str1(START), str2(START), valid(1)
>
>## 14bytes-long string, it corrupts str1
>$ ./buffer1
>EVILINPUTVALUE
>buffer1: str1(TVALUE), str2(EVILINPUTVALUE), valid(0)
>$ ./buffer1
>
>## targeted overflow: input is 16bytes long, and the first half matches the second half. the latter half will overwrite the initial value of str1, changing the match parameter and forcibly making the condition true
>BADINPUTBADINPUT
>buffer1: str1(BADINPUT), str2(BADINPUTBADINPUT), valid(1)
>```
>`printf()` reads `str1` and `str2` until it encounters a NULL termination character 
>
>if `gets()` was instead the function `read_password()` that read the saved a user’s logged password, then with this buffer overflow exploit we could log into an account without knowing the password !

## attacks
to exploit a buffer overflow, an attacker needs to identify the vulnerability and how the buffer is stored in memory to determine its potential for corruption
identifying vulnerable programs can be done by:
- inspection of program source code
- tracing the execution of programs as they proces oversized input
- using tools such as *fuzzing* (automatically providing invalid, unexpected or random data as input to a program to find vulnerabilities) to automatically identify potentially vulnerable programs
## stack buffer overflows
*stack smashing* (stack buffer overflows) happen when the buffer is located on *stack*. they are still being widely exploited !
>[!def] stack frame
a section of the program’s call stack that is allocated specifically to hold all the information required for a single function or subroutine to execute, including its local variables and the data needed to return control to the function that called it

>[!example] stack overflow example
the vulnerable code:
>```c
>void hello(char *tag)
>{
>    char inp[16]; // Fixed-size buffer of 16 bytes
>
>    printf("Enter value for %s: ", tag);
>    gets(inp); // VULNERABILITY: No bounds checking
>
>    printf("Hello your %s is %s\n", tag, inp);
>}
>```
>
>the execution:
>```bash
>$ cc -g -o buffer2 buffer2.c 
>
>## tt apposto
>$ ./buffer2
>Enter value for name: Bill and Lawrie
>Hello your name is Bill and Lawrie
>
>## the input overflows and continues writing across the stack frame, until it hits and overwrites the return address (and potentially other data). this causes the sex fault
>$ ./buffer2
>Enter value for name: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
>Hello your name is XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
>Segmentation fault (core dumped)
>
>## the perl script takes a string of hexadecimal bytes, covertes them into binary data and pipes that binary data directly as the input of ./buffer2
>
>## notice tahat the program calls hello() twice, and the second time is completely unintended: the attackers have injected a return address that points to a memory location which causes the program to jump back to the start of the `hello()` function
>$ perl -e 'print pack("H*", "41424344454647485152535455565758616263646566676808fcffbf948304080a4e4e4e4e4e0a")' | ./buffer2
>Enter value for name: Hello your Re?pyyJuEa is ABCDEFGHQRSTUVWXYZabcdefguyuy
>Enter value for Kyyu: 
>Hello your Kyyu is NNNN
>Segmentation fault (core dumped)
>```
the attacker’s attempt (if any) to execute their payload ultimately failed, as the execution flow eventually hit an invalid memory address or attempted an illegal operation

### common unsafe C stdlib functions 

| function                                     | description                                           |
| -------------------------------------------- | ----------------------------------------------------- |
| `gets(char *str)`                            | read line form standard input into str                |
| `sprintf(char *str, char *format, ....)`     | create str according to supplied format and variables |
| `strcat(char *dest, char *src)`              | append contents of string src to strind dest          |
| `strcpy(char *dest, char *src)`              | copy contents of string src to string dest            |
| `vsprintf(char *str, char *fmt, va_list ap)` | create str according to supplied format and variables |
### shellcode
shellcode is code supplied by the attacker, often saved in the buffer being overflowed. it is machine code, and it is specific to the processor and the OS it is run on.
 - traditionally it transferred control to a shell
 it must be:
 - *self-contained*: it cannot rely on external shared libraries or system files.
 - *position independent code* (*PIC*): it must be able to run corettly no matter where it is located in the process’s memory space. since the stack address can shift, the shellocode needs to calculate its own location at runtime ! also, only relative address references.
 - *no null bytes* (*\x00*): the `gets()` function stops reading input when it encounters a null byte, therefore shellcode cannot contain any
shellcode functions can do many things:
- launch a remote shell when an attacker connects to it
- create a reverse shell that connects back to the hacker
- use local exploits that establish a shell
- fulsh firewall rules the currently block other attacks
- break out of a chroot environment, giving full access to the system
>[!example] actual stack overflow attack
the shellcode executes the `/bin/sh` shell
>
>```c
>int main(int argc, char *argv[]) {
>
>// sets the path
>char *sh = "/bin/sh";
>
>// creates an array of arguments that terminates with a NULL pointer
>char *args[2];
>args[0] = sh;
>args[1] = NULL;
>
>// replaces the current running process with the new process (sh)
>execve(sh, args, NULL);
>}
>```
>
>this code is then translated into *PIC* assembly code.
>- in particular, it uses the syscall `execve`
>the hexidecimal values for the compiled machine code is the *shellcode*, which is fed as an input

### defenses
there are two approaches to buffer overflow defense:
x### compile-time defense
compile-time defenses include:
- *using a modern high-level language*, that is not vulnerable to overflow attacks, whose compiler enforces range checks and permissible operations on variables
	- this implies additional code to impose checks, which cost resources. also the distance from the underlying machine language and architecture means no access to some instructions and hardware resources
- *safe coding techniques*: prorammers need to inspect the code and rewrite any unsafe coding
	 - an example is the *OpenBSD* project. programmers audited the existing code base, including the OS, std libraries, and common utilities, making it one of the safest OS in widespread use
- *language extensions / safe libraries*: without knowing the size at compile time, the C compiler cannot insert automatic checks to prevent a buffer overflow in dynamically allocated memory, which makes heap overflows harder to mitigate. “fixing” this requires an extension and the use of some libraries’s functions
	- also, because C has many unsafe stdlib functions, safe libraries that implement such functions in a safe way have been created (e.g. `libsafe`)
 - *stack protection*: compilers can use *stack canaries* which are small, unique (unpredictable) and secret values placed on the stack, to detect if an overflow has occurred. the *canary* (the value) is placed immediately beofre the crucial control data (such as the return address), an just before the function returns control, the code checks the canary’s value. if the value has been altered, the system knows the stack has been corrupted.
	 - another technique is storing a backup copy of the return address (the most critical target of an overflow) in a safer location, to prevent an overflow attack. *stackshield* and *RAD* (*return address defender*) are compiler extensions that use this method. the return address in the active stack frame is then checked against the saved copy, and if the two values do not match the program is aborted
#### run-time defenses
- *executable address space protection*: a hardware and software defense that marks certain regions of memory as *non-executable*: memory is split into regions that can be *either* writeable *or* executable, *but not both simultaneously*. since user input is injected in areas like the stack or the heap, the OS marks these regions as writeable, but non-exectuable. trying to run code in a non-executable region triggers a segmentation fault and halts the attack !
 - *address space randomization*: randomess is introduced to the memory addresses of key program components (they are loaded into random memory locations). this prevents the attacker from reliably guessing the target address to place the shellcode
 - *guard pages*: guard pages can be placed between critical memory segments, such as between the end of the stack and the start of the heap. these pages are marked as *non-accessible*, triggering a hardware exeption if a buffer overflow tries to spill into one.
9oszd./sd ## buffer overflow variants
- *stack frame smashing*: instead of just overwriting the return address, the attacker overwrites the entire top portion of the current function’s stack fram and constructs a new, *fake stack frame* on the stack
- *return-to-libc*: instead of injecting custom shellcode, the attacker overwrites the return address with the address of an *existing, legitimate function* that already exists in the program’s memory. the attacker sets up the stack such that when the system function is called, the required arguments for that function are waiting immediately behind the overwritten address 
	- the most common target is a system function like `system()`
	- this attack bypasses the *executable address space protection* technique
- *heap overflow*:
- *global data*
BASTA
