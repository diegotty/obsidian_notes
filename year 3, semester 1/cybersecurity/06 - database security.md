---
related to:
created: 2025-11-29, 16:22
updated: 2026-01-13T13:32
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
*SQLi* (*SQL injection*) attacks are one of the most prevalent and dangerous network-based security threats, and they are designed to exploit the nature of web application pages by sending malicious SQL commands to the database server.
- the most common attack goal is the bulk extraction of data, but it can also be to modify or delete data, execute arbitrary OS commands, or to laungh DoS attacks
they work by prematurely terminating a text string and appending a new command, and terminating the injected string with a comment mark `- -` (as the inserted command may have additional strings appended to it before it is executed)
### attack types
#### inband attacks
inband attacks use the same communication channel for injecting SQL code and retrieving results
some examples are:
- *tautology*: injects ode in more or more conditional statements so that they always evaluate to true
- *end-of-line comment*: after injecting code into a particular field, legitimate code that follows are nullified through usage of end of line comments (`- -`)
- *piggyback queries*: the attacker adds additional queries beyond the intended query
#### inferential attack
the attacker is able to reconstruct the information by sending particular requests and observing the resulting behavior of the website/db server. they include:
- *illegal/logically incorrect queries*: considered a preliminary, information-gathering step for other attacks, the attacker lets an attacker gather important information about the type and structure of the backend db
- *blind SQL injections*:  data is inferred bit-by-bit by observing subtle changes in the page content or response time 
- *out-of-band attacks*: data are retrieved using a different channel because the outbound connectivity from the database is lax: the malicious command forces the database engine to execute a function that attemps to contact a remote server
### SQLi sinks
*SQLi sinks* is the final location in an application’s code where untrusted, user-supplied data is executed as part of a SQL query
- the security goal is to ensure the *source* (the user input) never flows unchecked to the *sink* (the database execution function)
### SQLi sources
*SQLi sources* are the starting point where the unvalidated data enters the application. some sources are:
- *user input* (GET/POST)
- *HTTP headers* (User-Agent, Refer)
- *cookies* (they are just headers, and they come from the client: inserting the cookie’s value directly into a database, without validation, is DUMB)
- *the database itself* (*second order injection*): the attacker’s input is not executed immediately (which would be a *first order attack*), but is instead stored safely in the database, and executed later in a vulnerable query 
	- so the vulnerability is not the input handling, but the data retrieval
as a rule of thumb, *never trust input from a source* !
### attacker’s objectives

| target                                       | description                                                                                                                                                                                 |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| identify injectable params (sources / sinks) | the first step of reconnaissance. the attac,er finds the vulnerable sources that feed into an unsafe sink, by testing inputs with simple characters like `'`                                |
| database footprinting                        | find out which DBMS is in use. this is crucial because SQL synta differs betweeen systems. this step can be made easy by poorly configured applications that display verbose error messages |
| discover DB schema                           | find names of important tables and the columns within them                                                                                                                                  |
| data extraction                              | stealing the information. the attacker uses techniques like `UNION` to combine malicious queries with the original one                                                                      |
| data manipulation                            | the attacker modifies the database’s integrity by changing existing records, deleting data, inserting new malicious data                                                                    |
| denial of service                            | prevent legitimate user from using the web application by flooding the database with useless queries or deleting stuff or lock tables                                                       |
| authentication bypass                        | the attacker tricks the application into authenticating them without a valid password                                                                                                       |
| remote command execution                     | (highest impact target) some DMBS allow the execution of OS commands via SQL. if the attacker reaches this target, they can run commands directly on the server’s OS                        |
>[!example] SQLi example
>```SQL
>$q = "SELECT id FROM users WHERE user = '" .$user. "' AND pass = '" .$pass. "' ";
>
>-- sent parameters:
>$user = "admin"
>$pass = "' OR '1'='1'"
>
>-- executed query:
>$sq = "SELECT id FROM users WHERE user='admin' AND pass='' OR '1'='1'";
>```

### crafting the query
#### UNION query
the `UNION` construct can be used to achieve data extraction:
>[!example] example
>```SQL
>$q = "SELECT id, name, price, description FROM products WHERE category='" .$cat. "' ";
>
>$cat = "' 1 UNION SELECT 1, user, 1, pass FROM users --";
>
>-- query (the MySQL performs a cast)
>$q = "SELECT id, name, price, description FROM products WHERE category=1 UNION SELECT 1, 1, user, pass FROM users"
>
>-- 1's are placeholders for fields we don't know or care about, so we ensure compatibility with the original query's columns
>```

>[!warning] the number and *type* of the columns returned by the two `SELECT` queries must match
>- in MySQL, if the types do not match, a cast is performed automatically
#### SQLi tautologies
here are the most common malicious input lines an attacker can use to cause a SQLi:
```SQL
// choosing "blindly" the first available user
$pass ="' OR 1=1#";
$user = "' OR user LIKE '%' #";
$user = "' OR 1 #";

//choosing a known user
$user = "admin' OR 1#";
$user = "admin'#";

//IDS (intrusion detection system) evasion
$pass = "'OR 5>4 OR password='mypass";
$pass = "' OR 'vulnerability' > 'server' ";
```
#### second order inject
to perform the attack, a user with a malicious name is registered. later on, the attacker ascks to change the password of its malicious user, so the web app fetches info about the user from the DB and uses them to perform another query
>[!example] example
>```SQL
>-- malicious user 
>$user = "admin' #";
>
>-- update password query
>$q = "UPDATE users SET pass='"$._POST['newPass']."' WHERE user='".$row['user']."'";
>
>-- query if the data coming from the database is not properly sanitized
>$q = UPDATE users SET pass='password' WHERE user='admin'#";
>```
##### ending the query
to make sure that the final, concatenated statement runs without generating a syntax error, attacker use *comment symbols* to ensure syntactically correct query termination.
- the goal is to lcose the string literal and eliminate all the remaining, unwanted code from the developer’s original query
the comment symbols used are:
- `--` (single-line comment)
- `#` (single-line comment, mySQL only)
- `/* ... */` (multi-line comment)
#### information schema attacks
*information schemas* are metadata about the objects within a database. they can be used to gather data about any tables from the available databases. they store:
- what databases exist
- what tables exist in each database
- what columns exist in each table
- the privileges granted to users
information schemas are attacked to gather infomation about the DB structure
>[!example] example
>```SQL
>-- vulnerable query
>$q = "SELECT username FROM users WHERE user id=$id";
>
>-- step 1: get the table's name
>$id = "- 1 UNION SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE table_schema != 'mysql' AND table_schema != 'information_schema' -- ";
>
>-- step 2: get the name of the columns inside the tables
>$id = "-1 UNION SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'users' LIMIT 0,1 --";
>
>-- using '-1' as the ID makes the query result for the original query to be empty, forcing the db to rely on the results of the UNION SELECT
>```
#### blind SQLi
its the third major category of SQLi (the other two are *error-based SQi* and *Union-Based SQLi*), and its the most common type found in modern, well-defended web applications: the attacker cannot directly see the output of the database query on the web page.
there are two types of blind SQLi:
- *boolean-based*
- *time-based*: it is used when there are absolutely no visible differences in the page content or status to indicate a TRUE or FALSE result. the attacker uses *conditional time-daly* functions (`IF` clauses + `SLEEP`), and measures the response time to determine the outcome of the query. this way, the attacker slowly extracts data one character at a time 
#### SQLi file operations
achieving remote command execution, the attacker can read/write files using OS commands.
- the database user account being used by the application has filesystem privileges
- the database server i sconfigured with certain built-in functions enabled
>[!example] file operation examples
>```SQL
>-- vulnerable query
>$q = "SELECT username FROM users WHERE user id = $id";
>
>-- LOAD_FILE() returns NULL upon failure
>-- read file
>$id = " -1' UNION SELECT LOAD_FILE('/etc/passwd')";
>
>-- INTO OUTFILE can trigger a MySQL error
>-- write file
>$id = "-1 UNION SELECT 'hi' INTO OUTFILE  '/tmp/hi'";
>```

## countermeasures
there are three type of countermeasures to SQLis.
### parameterized queries
*parameterized queries* are the gold standard for defense against SQLis, as they address the fundamental flaw of SQLis: the ambiguity between code and data.
 they work by forcing the application to send the SQL command structure to the database *separately* from any user-supplied data:
```SQL
$q = "SELECT * FROM users WHERE user_id = ? and password = ?";
```
the application then sends the user’s input variables to those placeholders, and the db *treats the input strictly as data*, regardless of what it contains:
```SQL
-- if the input is "' OR 1=1 --", the db sees it as a single, long string literal
$q = "SELECT * FROM users WHERE user_id = '' OR 1-=1 -- ' AND password='user-password' ";
```
#### manual defensive coding practices
*supplementary* to parameterized queries or used in scenarios where the parameterization is impossible, they articulate in:
- *escaping user input*: the code manually iterates through the user input and prepends a `\` to any special characters(like `'` or `"`)
- *type enforcement*: ensuring that if the code expects a number, any non-numeric characters are immediately rejected or cast to an integer, which strips injection payloads
- *whitelisting*: only allowing input that matches a strict set of approved characters or values
- *principle of least principle*: acts on the configuration of a db to limit the impact of a successful SQLi attack: the application’s db should only have *the minimum privileges necessary for its operation*
### SQL DOM
*SQL DOM* (*data-oriented modeling*) is a more formal, academic approach to preventing SQL. it enforces a fundamental rule: *query structure must be defined separately from query data*.  this design pattern is typically implemented as a framework. instead of letting developers build queries using string concatenation, the language environment requires the use of *constructor methods* to build the query piece by piece.
- this way, the environment always knows which input is meant t
the SQL DOM system can automatically enfore parameterization on all data variables.
this approach makes it virtually impossible for developers to accidentally create an unsafe sink !
#### database access control
database access control can support a range of administrative policies, such as:
- *centralized administration*: a small number of privileged users may grant/revoke access rights
- *ownership-based administration*: the creator of a table may grant/revoke access rights to the table
- *decentralized administration*: the owner of a table may grank/revoke permissions to other users, allowing them to grant/reoke access rights to the table
	- in this case, *cascading authorization* happens. if access rights cascade through a number of users, the revocation of privileges also cascades: when user A revokes an access right, any cascaded access right is also revoked, unless that access right would exist even if the original grant from A had never occurred
#### inference detection
>[!def] inference in db security
> the process of performing authorized queries and deducing unauthorized information from the legitimate responses received

*inference detection* is a set of techniques used to identify and prevent inference. they work by monitoring query patterns and applying limitations or noise. this is possible:
- during *database design*: methods that address the underlying relationships in the database schema that make inference possible
- at *query time*: methods that attempt to mask the true data when a query (or set of queries) is too specific
#### database encryption
while protected by multiple layers of security (firewalls, authentication, various access control systems), it is possible to encrypt the database as a last line of defense. it can be applied to the entire database, at the record level, the attribute level, or the level of the individual field.
encryption causes two main disadvantages: 
 - *key management*: authorized users must have access to the decryption key for the data to which they have access
 - *inflexibility*: it is more difficult to perform record searching
to provide more flexibility, it must be possible to work with the database in its encrypted form!
#### attribute-based range indexing
this technique allows range queries without ever decrypting the entire database.
1. each row is encrypted, using a key $K$, to produce the encrypted block $E(K, B_{i})$. this way the db cannot search or index individual attributes, as only random-looking ciphertext is available
2. the system defines a set of partitions (ranges) for every attribute, and gives each partition an index value: $I_{1}, I_{2}, \dots,I_{n}$
3. for each row and for each of its attributes, the systems stores the index value corresponding to the field value.
this way, when a user asks to search for a range, the system translates that range into the corresponding index values and the db executes a simple, fast query on the unencrypted index column.
>[!example] encrypted database example
![[Pasted image 20251130124049.png]]