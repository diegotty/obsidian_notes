---
related to:
created: 2025-11-30, 13:45
updated: 2025-11-30T14:22
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
>    next_tag(str1);
>    gets(str2);
>
>    if (strncmp(str1, str2, 8) == 0) 
>        valid = TRUE;
>
>    printf("buffer1: str1(%s), str2(%s), valid(%d)\n", str1, str2, valid);
>}
>```
>
> execution:
```bash
$cc -g -o buffer1 buffer1.c$ ./buffer1
START
buffer1: str1(START), str2(START), valid(1)
$ ./buffer1
EVILINPUTVALUE
buffer1: str1(TVALUE), str2(EVILINPUTVALUE), valid(0)
$ ./buffer1
BADINPUTBADINPUT
buffer1: str1(BADINPUT), str2(BADINPUTBADINPUT), valid(1)
```