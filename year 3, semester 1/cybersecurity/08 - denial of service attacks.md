---
related to:
created: 2025-11-30, 18:35
updated: 2025-11-30T20:59
completed: false
---
>[!def] DoS attack (NIST)
“an action that prevents or *impairs* the authorized use of networks, systems, or applications by *exhausting resources* such as CPUs, memory, bandwidth, and disk space”

>[!info] example of DoS network
![[Pasted image 20251130183811.png]]

## flooding attacks
the intent behind flooding attacks is to overload the network capacity on some link to a server. 
they are classified based on *the network protocol used*
>[!info] source address spoofing
the act of deliberately forging the source IP address field in the header of a network packet. it is used for two primary goals:
>- *obfuscation*: by changing the source IP address, the attacker makes it virtually impossible for the victim to block the traffic based on a single source IP address, and far more difficult to ttrace the attack back to the original machine.
>- *amplification*: spoofing allows the attacker to redirect the victim’s responses to a third party.
>
>ISPs can prevent many spoofing attacks using *ingress filtering* (routers check packets as they enter the network: packets must originate from an IP that belongs to the network’s segment, otherwise they are dropped)

### SYN flood attack
also called *protocol exhaustion attack*, it targets TCP handshake mechanisms, aiming to exhaust the server’s connection resources.
it attacks the ability of a server to respond to future connection requests, by *overflowing the tables used to manage them*
1. the attacker sends a massive flood of `SYN` packets to the server, often using *spoofed* source IP addresses
2. for every `SYN` packet, the server responds with a `SYN-ACK` and places the connection in a queue of half-open connections, waiting for the final `ACK` packet
3. since the source IPs are spoofed, the final `ACK` packet never arrives. the server’s connection queue quickly fills up with half-open connections, consuming all available memory and processing resources
### ping flood attack
also called *ICMP flood attack*, it is a volumetric attack that attemps to saturate the victim’s network bandwith using [[12 - livello di rete; DHCP, NAT, forwarding, ICMP#ICMP|ICMP]] (`ping` command sends an ICMP echo request, and the target replies with an echo reply)
1. the attacker sends a massive stream of `ping` commands to the victim’s machine.
2. the victim is forced to dedicate all its bandwith to receiving the incoming flood and generating echo replies, unable to reply to legitimate user traffic
### DDoS
*distributed denial of service* attacks use *multiple systems* to generate attacks. this is done by exploiting a flaw in the OS or in a common application, gaining access and installing a *zombie* program on it (the attacker’s).
large collections of these corrupted systems, that are under the control of one attacker create a *botnet*
>[!info] DDoS attack architecture
![[Pasted image 20251130201511.png]]

>[!info] rent-a-ddos-botnet
you can rent a botnet such as *moobot* on the dark web.
10$ gets you a one-hour attack at a rate of 10-50k requests per second !

## HTTP-based attacks
### HTTP flood
it is a classic DoS attack, where the attacker temps to overwhelm a web server by maximizing the volume of requests it receives.
- some of the tools used to generate these flood attacks are LOIC and HOIC.
- to make the flood traffic look more realistic, the *spidering* technique is used: bots start from a single page and follow all links provided on the website, in a recursive way. this mimics the behavior of a legitimate search engine crawler, making it harder for simple firewalls to distinguish malicious from normal traffic.
### slowris 
also called *low-and-slow attack*, it is a low-bandwith attack that aims to consume server resources through persistence rather than volume.
1. it attemps to monopolize by *sending HTTP* requests that never complete, keeping the connection alive by periodically sending tiny, non-closing pieces of data
2. these half-finished connections rapidly exhaust the server’s connection pool (the finite number of concurrent connections a server can maintain)
existing intrusion detection/prevention solutions that rely on signatures to detect attacks will generally not recognize slowirs, as the attack does not contain malicious code or high volume traffic.
*R.U.D.Y* (*r-u-dead-yet*) is a similar tool that executes a *low-and-slow* attack specifically targeting POST requests
## reflection attacks
reflection attacks use a legitimate third-party server (*the reflector*) to redirect traffic toward the victim. this hides the true source of the attack.
1. the attacker sends a request to a public service (e.g. DNS server), spoofing the source IP address of the request, *replacing it with the victim’s IP adress*.
2. the reflector receives the request and sends the standard response directly back to the victim. by doing so, the attack traffic appears to be coming from the reflector, not the actual attacker.
## amplification attacks
amplification attacks aim to exploit network protocols that turn *small requests* into *large responses*, thus maximizing the volume of traffic sent to the victim. with a small number of machines and low bandwith, the attacker is able to launch a high-volume DDoS attack
- for instance, 60-byte DNS requests might generate 4000-byte responses
- *memcached DDoS attacks* can bring and amplification factor of 5000 !
# DoS attack defenses 
DoS attacks cannot be prevented entirely, as high traffic volumes may be legitimate. however, there are four lines of defense against DDoS attacks:
- *attack prevention and preemption*
- *attack detection and filtering*
- *attack source traceback and identification*: ISPs could be able to tracke packet flow back to source (although difficult and time consuming)
- *attack reaction*: implement a contingency plan (commissioning new servers at a new site with new addresses, switching to alternate backup servers)
### attack prevention
it is possible to
- use ISP’s *ingress filtering* to block spoofed IP addresses
- use filteres to ensure the path back to the claimed source is the one that is being used to send the current packet. (filter must be applied to traffic before it leaves the IPS’s network, or at the point of entry to their network)
- use services that act as proxy layers between the attacker and your server (such as cloudlfare, AWS shield, …). they have enough network capability to filter the malicious traffic before it ever reaches the target server.
- block IP directed broadcasts
- *captcha* puzzles to distinguish legitimate human requests
- network monitors and IDS to detect and notify abnormal traffic patterns