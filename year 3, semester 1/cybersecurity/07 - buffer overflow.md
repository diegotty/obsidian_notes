---
related to:
created: 2025-11-30, 13:45
updated: 2025-11-30T14:38
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
```bash
## ok example
$cc -g -o buffer1 buffer1.c$ ./buffer1
START
buffer1: str1(START), str2(START), valid(1)

## 14bytes-long string, it corrupts str1
$ ./buffer1
EVILINPUTVALUE
buffer1: str1(TVALUE), str2(EVILINPUTVALUE), valid(0)
$ ./buffer1

## targeted overflow: input is 16bytes long, and the first half matches the second half. the latter half will overwrite the initial value of str1, changing the match parameter and forcibly making the condition true
BADINPUTBADINPUT
buffer1: str1(BADINPUT), str2(BADINPUTBADINPUT), valid(1)
```
`printf()` reads `str1` and `str2` until it encounters a NULL termination character 

if `gets()` was instead the function `read_password()` that read the saved a user’s logged password, then with this buffer