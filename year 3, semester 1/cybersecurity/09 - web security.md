---
related to:
created: 2025-11-30, 21:05
updated: 2025-11-30T22:13
completed: false
---
## basic information
>[!info] URL structure
![[Pasted image 20251130210909.png]]
there are *non-allowed* characters: `:/?#[]@!$&'()*+,;=`, as in ASCII they are encoded with a `%` followed by two hexadecimal digits, and URLs nee

basics of [[04 - livello applicazione; HTTP#HTTP|HTTP protocol]]

>[!info] dynamic contents to HTTP requests
servers and clients use scripting languages to create dynamic content for web users. this can happen *client side* or *server side*:
>- *client side scripting*: downloaded from the server and executed on the client’s computer, it is completely visible and readable to the user. it can access the resources the browser is given permission to see (like cookies or local storage)
>	- javascript, VBscript, ActiveX, Ajax
>- *server side scripting*: it is executed entirely on the web server, before the final result is sent back to the client’s browser 
>	- PHP, ASP.NET, Java, Perl, Ruby, Go, Python, server-side javascript like node.js

## HTTP authentication
an authentication rarely used nowadays (with reason, who in our lords year 2025 (or ever) would authenticate through HTTP)
1. the browser starts a request without sending any client-side credentials
2. the server replies with a status message: *”401 Unauthorized”*, with a specific `WWW-Authenticate` header, which contains information on the authentication method. the browser then prompts the user for credentials.
3. the browser gets the client’s credentials and includes them in the `Authorization` header and sent back to the server (either base64-encoded (however this has to be done through HTTPS to encrypt the entire communication) or hashed with the username, password, (other things), and a *nonce* (random, one-time value))
