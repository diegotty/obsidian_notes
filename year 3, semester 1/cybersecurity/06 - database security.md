---
related to:
created: 2025-11-29, 16:22
updated: 2025-11-29T17:42
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
they work by prematurely terminating a text string and appending a new command, and terminating the injected string with a comment mark `- -` (as the inserted command may have additional strings appended to it before it is executed)
### attack avenues
- *user input*: attackers inject SQL commands by providing suitable crafted user input
- *server variables*: attackers can forge v
- *second-order injection*
- *cookies*: 
- *physical user input*: 
## attack types
### inband attacks
inband attacks use the same communication channel for injecting SQL code and retrieving results
some examples are:
- *tautology*: injects ode in more or more conditional statements so that they always evaluate to true
- *end-of-line comment*: after injecting code into a particular field, legitimate code that follows are nullified through usage of end of line comments (`- -`)
- *piggyback queries*: the attacker adds additional queries beyond the intended query
### inferential attack
the attacker is able to reconstruct the information by sending particular requests and observing the resulting behavior of the website/db server. they include:
- *illegal/logically incorrect queries*: considered a preliminary, information-gathering step for other attacks, the attacker lets an attacker gather important information about the type and structure of the backend db
- *blind SQL injections*:  data is inferred bit-by-bit by observing subtle changes in the page content or response time 
- *out-of-band attacks*: data are retrieved using a different channel because the outbound connectivity from the database is lax: the malicious command forces the database engine to execute a function that attemps to contact a remote server
### SQLi sinks
*SQLi sinks* is the final location in an application’s code where untrusted, user-supplied data is executed as part of a SQL query
- the security goal is to ensure the *source* (the user input) never flows unchecked to the *sink* (the database execution function)

- *user input* (GET/POST)
- *HTTP headers*
- *cookies*
- *the database itself* (*second order injection*): the input of the application is stored in the database