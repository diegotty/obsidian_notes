---
related to:
created: 2025-11-29, 16:22
updated: 2025-11-29T16:54
completed: false
---
# database security
database security has not kept pace with the increased reliance on databases for a number of reasons:
- DBMS are much more complex than the security techniques used to protect them. their interation protocol (SQL) is complex, and effective DB security requires a strategy based on a full understanding of the security vulnerabilities of SQL.
- most enterprise environments consist of a heterogeneous mixture of database, enterprise and OS platforms, creating an additional complexity hurdle for security personnel.
- the intreasing reliance on cloud technology to host part of all of the corporate database
>[!info] DBMS architecture
![[Pasted image 20251129163905.png]]
## SQL injection attacks
*SQLi* (*SQL intejction*) attacks are one of the most prevalent and dangerous network-based security threats, and they are designed to exploit the nature of web application pages by sending malicious SQL commands to the database server.
- the most common attack goal is the bulk extraction of data, but it can also be to modify or delete data, execute arbitrary OS commands, or to laungh DoS attacks
they work by prematurely terminating a text string and appending a new command, and terminating the injected string with a comment mark `- -`
### injection techniques
