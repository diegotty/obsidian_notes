---
related to:
created: 2025-11-03, 18:33
updated: 2026-01-22T21:57
completed: false
---
# access control
the goal of *access control* is to protect confidentiality and integrity of information, by controlling what a subject can do, to prevent damage to the system
- in practice, we regulate the operations that can be executed by subjects on data and resources
- access control is typically provided as part of OS and DBMS
>[!def] RFC 4949
a process by which use of system resources is regulated according to a *security policy* and is permitted only by *authorized entities* (users, programs, processes, or other systems) according to that policy

>[!info] the flow
![[Pasted image 20251103184625.png]]
## access control models
we had a high level introduction to this topic at the end of the [[sicurezza|os1 course]]
### DAC
*discretionary access control* (*DAC*) controls access based on the identity of the requestor, and on access rules stating what thre requestors are allowed to do
such rules are often provided using an *access matrix* or an *access control list* (*ACL*) or an *extended access control matrix*
>[!info] access matrix
![[Pasted image 20251103185039.png]]

>[!info] access control list
![[Pasted image 20251103185204.png]]
it defines, for each object, a list of subjects that have access rights to the object, and the access rights for each subject to that object
>- this approach takes a subject-centered approact to access control, as it can also be seen as this:
![[Pasted image 20251103185655.png]]

>[!info] extended access control matrix
![[Pasted image 20251103185742.png]]
it defines, for each subject, its abilites in regards to all other subjects, files, processes and drives
>
> these permissions in the matrix translate to the following rules:
![[Pasted image 20251103185927.png]]
i aint reading allat ngl. happy 4 u though
>
>with this approach, every access by a subject to an object is mediated by the *controller* for that object. its decision is based on the current content of the matrix
and as we already said, some subjects have the authority to make *specific changes* to the access matrix

many modern UNIX systems support ACLs, like freeBSD, openBSD, linux and solaris
### MAC
*mandatory access control* (*MAC*) controls access based on comparing *security labels* with *security clearances*
each subject and each object is assigned a security class, and in the simplest formulation, security classes form a *strict hierarchy* and are referred to as *security levels*
- es: top secret < secret < confidential < restricted < unclassified
a subject is said to have a *security clearance* of a given level, and an object is said to have a *security classification* of a given level.
- unlike *DAC*, users cannot decide to share or change the access permissions of data they own
- access is enforced by the system, not by the owner of the resource

>[!info] multilevel security
the goal of *MAC* is to enforce *multilevel security*: to manage and protect data across different hierarchical classification levels within one system

>[!example] Bell-LaPadula model
the *Bell-LaPadula model* (*BLP*) is an example of MAC. it defines two crucial rules to maintain confidentiality: 
>- *no read up* (*ss-property*): a subject can only read an object if the subject’s clearance level is greater than or equal to the object’s classification level
>- *no write down* (*\*-property*): a subject can write to an object if the subject’s clearance level is less than or equal to the object’s classification level
>	- this prevents high-level information from being copied/written-down to a low-level file that a low-clearance user could then read !! genius !
>
BLP has many limitations due to its very rigid structure

there are many implementations of MAC, the most recent being SELinux (NSA’s implementation of MAC for linux) and AppArmor for linux, and Mandatory Integrity Control for windows
### RBAC
*role-based access control* (*RBAC*) controls access based on the roles that users have within the systems, and on rules stating what accesses are allowed to users in given roles. its goals are:
- describe organizational control *policies*
- be based on job function (not on identity or clearance, but their role)
- increase flexibility/scalability in policy administration (easy to change secuirty requirements)
>[!info] i like graphs
![[Pasted image 20251103192734.png]]

>[!info] ACL matrix representation of RBAC
![[Pasted image 20251103192955.png]]


#### families of role-based access control models
>[!figure] img
![[Pasted image 20251106161955.png]]

the diagram above shows how different RBAC models build upon each other, starting from the base model $RBAC_{0}$:
- $RBAC_{0}$ is the *base model*, which includes the core concepts of users, roles, permissions, and their assignment
- $RBAC_{1}$ extends it by introducing *hierarchical roles*: roles can inherit permissions from other roles (e.g. a manager role inherits all the permissions of a employee role)
- $RBAC_{2}$ adds *constraints* that restrict the relationships. a common example is the *separation of duty* (*SoD*) policy, which prevents a single user from possessing conflicting roles (e.g. a “check issuer” and a “check approver”). other types of  constraints are:
	- *mutually exclusive roles*: they enforce separation of duty. a user can only be assigned to one role in the set (either during a session, or statically)
	- *cardinality*: setting a maximum number with respect to roles given to a user
	- *prerequisite roles*: dictates that a user can only be assigned to a particular role if it is already assigned to some other specified role
- $RBAC_{3}$ combines the features of $RBAC_{1}$ and $RBAC_{2}$

>[!figure] img
![[Pasted image 20251106162058.png]]

the diagram above details the entities and their relationships in a typical RBAC system:
- *user assignments* (*UA*) connect users to roles
- *role hierarchies* (*RH*) are relationships within the roles set, defining which roles inherit permissions from others
- *permission assignments* (*PA*) connect roles to the permissions, that define which operations can be executed on an object
### ABAC
*attribute-based access control* (*ABAC*) controls access based on attributes of the user, the resource to be accessed, and *current enviromental conditions*
it can define authorizations that express conditions on properties of both the resource and the subject
- flexible, however its main downside is the performance impact of evaluating predicates on both resource and user properties for each access
we define the parts of this approach:
- *subject attributes*: a subject is active entity that causes information to flow among objects or changes the sytem state. the attributes define the identity and characteristics of the subject
- *object attributes*: an object is a passive information, system-related entity containing or receiving information. the attributes are "leverages" to make access control decisions
- *environment attributes*: they describe the operational, technical and even situational context in which the information access occurs. these attributes have, so far, been largely ignored in most access control policies

ABAC relies up on the evaluation of:
1. attributes of the subject
2. attributes of the object
3. an access control rule defining the allowable operations for subject-object attribute combinations *in a given environment*
we can enfore DAC, RBAC and MAC concepts, as it allows an unlimited number of attributes to be combined to satisfy any policy of privilege
- *policy*: a set of rules and relationship that govern allowable behaviour within an organization, based on the privileges of subjects and how objects are to be protected under which environment conditions
	- typically written from the perspective of the object that needs protecting and the privileges available to subjects
- *privilege*: authorized behaviours of subjects. they defined by an authority and embodied in a policy
>[!info] picture
![[Pasted image 20251103194700.png]]

#### ABA policies model
- $S$, $O$ and $E$ are subjects, objects and environments
- $SA_{k}(1\dots k\dots K)$ are the pre-defined attributes for subjects (they contain information about the subject)
- $OA_{m}(1\dots m\dots M)$ are the pre-defined attributes for objects (they contain information about the object)
- $EA_{n}(1\dots n\dots N)$ are the pre-defined attributes for environments (they contain information about the context under which the access attempt is made)
- the *access rule* states the decision of whether a subject $\text{can\_access}$ an object in a given environment. it is determined by a function $f$ that evaluates the collection of attributes for subject, object and environment
	- e.g.: a subject with `role` = `admin` can access a `filesecuritylevel`= `confidential` *only if* `currenttime`is in between `9am` and `5pm`
	- this is more flexible than RBAC, as it can incorporate many dynamic factors (e.g. time, location, or resource data) into access decision
$$
\text{can\_access(s,o,e)$\leftarrow$f(ATTR(s),ATTR(o), ATTR(e))}
$$

>[!example]- gemini example
![[Pasted image 20251106164410.png]]
>
![[Pasted image 20251106164521.png]]
>
![[Pasted image 20251106165420.png]]
IF ….. THEN DENY

>[!example]- slides example
![[Pasted image 20251106165451.png]]

>[!example]- another slides example (i kinda want to move on ngl)
![[Pasted image 20251106165843.png]]
![[Pasted image 20251106165852.png]]

>[!info] ABAC vs RBAC
>in RBAC, as the number of attributes increases to accomodate finer-grained policies, the number of roles and permissions grows *exponentially*
instead, the ABAC model deals with additional attributes in an efficient way