---
related to:
created: 2025-11-30, 21:05
updated: 2025-11-30T21:58
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