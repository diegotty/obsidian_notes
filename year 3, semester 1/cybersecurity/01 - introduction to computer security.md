---
related to:
created: 2025-03-02T17:41
updated: 2025-11-21T11:32
completed: false
---
>[!def] cybersecurity
>prevention of damage to, protection of, and restoration of computers, electronic communicaiton systems, electronic communications services, wire communication, and electronic communication, including information contained therein, to ensure its **availability**, **integrity**, **authentication**, **confidentiality**, and **nonrepudiation**

>[!def] computer security
measures and controls that ensure the C.I.A. properties on information system **assets**, including hardware, software, firm-ware and information being processed, stored and communicated

computer security fun facts are:
1. developing a particular security mechanism or algorithm, one must always consider potential attacks on those security features
2. procedures used to provide particular services are ofter counterintuitive
3. Physical and logical placement needs to be detected
4. security mechanisms typically involve more than a particular algorithm or protocol, and also require participants to be in possession of some secret information, which raises questions about the creation, distribution and protection of that secret information
5. attackers only need to find a single weakness, while the designer must find and eliminate all weaknesses to achieve protect security
6. security is still too ofter an afterthought to be incorporated into a system after the design is complete, rather than being an integral part of the design process
7. security requires regular and constant monitoring
8. there is a natural tendency on the part of the users and system managers to perceive little benefit from security until a security failure occurs
9. many users and even security administrators view string security as in impediment to efficient and user-friendly operation of an information system or use of information

>[!info] the key concepts of security and their relationships
![[Pasted image 20250929223323.png]]
>- **threat agent**: who conducts or has the intention to conduct detrimental activities
## C.I.A.
the acronym **C.I.A.** stands for: 
### confidentiality 
>[!def] definition
>avoiding unauthorized disclosure of information, protecting data and providing access for those who are allowed to see it, while disallowing others from learning anything about its content

the tools used to guarantee confidentiality are:
- **encryption**: the transformation of information using an *encryption key*, so that the transformed information can only be read using the *decryption key* (both keys are secret, and in some cases might be the same key)
- **access control**: rules and policies, that limit access to confidential information to those people that need to know
- **authentication**: the determination of the identity or role that someone has. this can be done in a number of different ways, but is usually a combination of: something the person *has*, *knows* and *is*
- **authorization**: the determination if a person or system is allowed access to resources, based on an*access control* policy
- **physical security**: the establishment of physical barriers to limit access to protected computational resources (faraday cages !!)
### integrity
>[!def] definition
>the property that something has not been altered (modified or destroyed) in an unauthorized way

tools used to guarantee integrity are:
- **backups**: the periodic archiving of data
- **checksums**: the computation of a function that maps the contents of a file to a numerical value. the function depends on the entire content of a file, and is designed in a way that even a small change to the input file is highly likely to result in a different output value
- **data correcting codes**: methods for storing data in such a way that small changes can be easily detected and automatically corrected
### availability
>[!def] definition
>the property that something is accessible and modifiable in a timely fashion by those authorized to do so

tools used to guarantee availability are:
- **physical protections**: infrastructure meant to keep information available even in the event of physical challenges
- **computational redundancies**: computers and storage devices that serve as fallbacks in case of failures
## more security concepts
### authenticity
>[!def] definition
the ability to determine that statements, policies and permissions issued by persons or systems are genuine

the primary tool used for authenticity is **digital signatures**, cryptographic computations that allow a person to commit to the authenticty of their documents in a unique way
### accountability
>[!def] definition
the security goal that generates the requirement for actions of an entity to be **traced uniquely to that entity**

to guarantee accountability, systems must keep records of their activities to permit later forensic analysis to trace security breaches or to aid in transaction disputes
### anonimity
>[!def] definition
the property that certain records or transactions not to be attributable to any individual

the tools used to guarantee anonimity are:
- **aggregation**: combining data from many individuals, so that disclosed sums or averages cannot be tied to any individual
- **mixing**: intertwining of transactions, information or communications in a way that cannot be traced to any individual
- **proxies**: trusted agents that are willing to engage in actions for an individual in a way that cannot be traced back to that person
- **pseudonyms**: fictional identities, that can fill in for real identities in communication, but known only to a trusted entity
## attacks
attacks can be:
- **active attacks**: attempt to alter system resources or affect their operation (involves some modification of the data stream or the creations of a false stream)
- **passive attacks**: attempt to learn or make use of information from the system, but does not affect system resources (eavesdropping, monitoring transmissions)
and depending on the attacker:
- **inside attacks**: initiated by an entity inside the security perimeter, an “insider” who is authorized to access system resources
- **outside attacks**: initiated from outsied the permitere, by an unauthorized user of the system

### threats
>[!info] levels of impact
depending on how much the systems is compromised, there are three levels of impact:
>- **low**: minimal adverse effects
>- **moderate**: serious adverse effects
>- **high**: severe or catastrophic adverse effects

#### unauthorized disclosure
it is a threat to confidentiality, as an entity gains access to data for which the entity is not authorized. it may happen through:
- **exposure**: sensitive data are directly released to an unathorized entity
- **interception**: the u.e. directly acceses sensitive data that is travelling between authorized sources and destinations (ex: eavesdropping)
- **interference**: an u.e. indirectly accesses sensitive data (not necessarily the data contained in the communication) by reasoning from characteristics or by-products of communications (uses multiple data streams to determine the source of a particular piece of imformation)
- **intrusion**: an u.e. gains access to sensitive data by circumventing a system’s security protections
#### deception
it is a threat to either system integrity or data integrity: an authorized entity receives false data and believes it to be true. it may happen though:
- **masquerading**: an u.e. gains access to a system or performs a malicious act by posing as an a.e.
- **falsification**: false data deceive an a.e. (ex: man-in-the-middle attack, where a network stream in intercepted, modified and retrasmitted)
- **repudiation**: an entity deceives another by falsely denying responsibility for an act, which can lead to misleading log data (this way, malicious actors can get away with actions because they can’t be proven to have been the ones ho performed them. this exploits a weakness of the attacked system)
#### disruption
it is a threat to availability or system integrity: it’s an event that interrupts or prevents the correct operation of system services and functions. it may happen though:
- **incapacitation**: a system operation is prevented or interrupted by disabling a system component
- **corruption**: a system operation gets undesirably altered by adversely modifying system functions or data
- **obstruction**: a threat action that interrupts delivery of system services by hindering system operation (Dos attacs !)
#### usurpation
it is a threat to system integrity: an unauthorized entity gains control of system services or functionsi. it may happen though:
- **misappropriation**: an entity assumes unauthorized logical or physical control of a system resource
- **misuse**: causes a system component to perform a function or service that is detrimental to system security
>[!info] the security principles
![[Pasted image 20251013085258.png|450]]
### attack surfaces
the attack surfaces consist of the reachable and exploitable vulnerabilities in a system, and are:
- **network attack surfaces**: vulnerabilities over an enterprise network, wide-area network, or the internet. in this category are included *network protocol vulnerabilities*, such as those used for a Dos attack
- **software attack surfaces**: vulnerabilities in application, utility, or operating system code. a particular focus is web server software
- **human attack surfaces**: vulnerabilities created by personnell or outsiders (social engineering, human error, trusted insiders)
## computer security strategies
- **security policy**: a formal statement of rules and practices that specify or regulate how a system or organization provides security to protect sensitive and critial system resources
- **security implementation**: implementation of the security policies, though 4 complementary courses of action:
	- prevention
	- detection
	- response
	- recovery
- **assurance**: an attribute of an information system that provides grounds for having confidence that the system operates such that the sytem’s security policy is enforced
- **evaluation**: the process of examining a computer product with respect to certain criteria. involves testing and formal analytic/mathematical techniques
### standards
standards have been developed to cover management practices and the overall achitecture of security mechanisms and services. the most important are:
- **NIST**: national institute of standards and technology
- **ISOC**: internet society
- **ITU-T**: international telecommunication union
- **ISO**: international organization for standardization