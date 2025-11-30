---
related to:
created: 2025-11-30, 13:45
updated: 2025-11-30T16:53
completed: false
---
>[!def] buffer overflow (NIST)
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
 beacuse the attacker generally cannot determine in advance exactly where the targeted buffer will be located in the stack frame of the function in which it is defined, *the shellocde must be able to run no matter where it is located in memory*
 - this means that only relative address references and offets to the current instruction address can be used
 - the attacker is not able to precisely specify the starting address of the instructions in the shellcode