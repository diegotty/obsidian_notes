---
related to:
created: 2025-11-30, 21:05
updated: 2025-12-08T14:53
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
>[!info] burp suite
*burp* (*bollettino ufficiale regione puglia*) is an integrated platform for performing security testing of web applications.
from the initial mapping and analysis of an application’s attack surface, through to finding and exploiting security vulnerabilities, burp allows to combine advanced manual techniques with parts of automation
some of burp’s tools are:
>- intruder tool
>- repeater tool
>- sequencer tool

### cookie security
the security of [[04 - livello applicazione; HTTP#cookie|cookies]] is critical, as they are used for authentication of a session
>[!info] cookie attacks
>- *session hijacking*
![[Pasted image 20251130222732.png]]
> - *session prediction*: early PHP implementations of session were susceptible to this attack, as cookie ids could be a total of 1 million (which is not that much)
>- *session fixation*
![[Pasted image 20251130222753.png]]
>- *insecure direct object reference*
session cookies can be used in *IDOR* attacks, that happen when an application provides *direct access* to objects based on user-supplied input, without proper identification
this way, the user can directly access to information not intended to be accessible, bypassing the authorization check that would be needed
## same origin policy
most of the browser’s security mechanisms rely on the possibility of isolating documents *depending on the resource’s origin*. generally, the pages from different sources should not be allowed to interfere with each other.
- this means that a malicious website cannot run scripts that access data and functionalities of other websites visited by the user (impeding *cross-site scripting* (*XSS*))
this mechanism is part of the *same origin policy* (*SOP*), the single most important security concept in web browsers, that is designed to isolate docments from different websites to provent unauthorized data access.
- it was introduced by netscape in 1995
SOP’s simplicity is also its limit, as:
- we cannot isolate homepages of different users hosted on the same origin
- different domains cannot easily interact among each others if legitimately needed
	- solution: `document.domain` can be used to relax the SOP by reducing domain definitions to its parent domains, thereby matching other sibling subdomains that do the same
$$

the browser defines an *origin* based on the combination of three parts of the URL: *protocol*, *domain name* and *port*