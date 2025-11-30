---
related to:
created: 2025-11-30, 18:35
updated: 2025-11-30T19:59
completed: false
---
>[!def] DoS attack (NIST)
“an action that prevents or *impairs* the authorized use of networks, systems, or applications by *exhausting resources* such as CPUs, memory, bandwidth, and disk space”

>[!info] example of DoS network
![[Pasted image 20251130183811.png]]

## classic DoS attacks
### SYN flood attack
also called *protocol exhaustion attack*, it targets TCP handshake mechanisms, aiming to exhaust the server’s connection resources.
it attacks the ability of a server to respond to future connection requests, by *overflowing the tables used to manage them*
1. the attacker sends a massive flood of `SYN` packets to the server, often using *spoofed* source IP addresses
2. for every `SYN` packet, the server responds with a `SYN-ACK` and places the connection in a queue of half-open connections, waiting for the final `ACK` packet
3. since the source IPs are spoofed, the final `ACK` packet never arrives. the server’s connection queue quickly fills up with half-open connections, consuming all available memory and processing resources
## ping flood attack
also called *ICMP flood attack*, it is a volumetric attack that attemps to saturate the victim’s network bandwith using [[12 - livello di rete; DHCP, NAT, forwarding, ICMP#ICMP|ICMP]] (`ping` command sends an ICMP echo request, and the target replies with an echo reply)
1. the attacker sends a massive stream of `ping` commands to the victim’s machine.
2. 