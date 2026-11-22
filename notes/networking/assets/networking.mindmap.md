---
markmap:
  initialExpandLevel: 4
---

# Networking

## Speed
### Latency
- Four delays: propagation, transmission, processing, queuing
- Speed of light is the floor, RTT is there and back
- Last mile, CDN
### Bandwidth
- Core is fiber (WDM), the edge is the limit
- The slowest link wins

## TCP
### Three-way handshake
- SYN, SYN-ACK, ACK: one round trip
### Flow and congestion control
- rwnd: free space in the receiver buffer, sent in every ACK
- cwnd: sender's own estimate, stays on the sender
- Slow start, congestion avoidance, loss
### Bandwidth-delay product
- Bandwidth x RTT: data needed in flight
### Head-of-line blocking
- A lost segment makes later data wait
### TCP vs UDP
- TCP: ordered and complete, resends lost data
- UDP: no handshake, no ACK, no waiting
- UDP datagram: one message, one packet
- UDP for calls, games, DNS, QUIC
### Optimizing for TCP
- Fewer round trips, data closer to the user

## Layers (file journey)
### 7 Application
- Browser, HTTP message
### 4 Transport
- Kernel TCP, segments
### 3 Network
- Kernel IP, packets
### 2 Data link
- Driver and network card, frames (MAC, CRC, MTU)
### 1 Physical
- Bits as a signal

## Routing
### Router
- Works on layers 1 to 3
- New frame at every hop
### Routing table
- Longest prefix match, next hop, TTL minus 1
### MAC vs IP
- MAC works per link, IP works end to end
### Same subnet or not
- Same subnet: send directly
- Otherwise: send to the default gateway
### ARP
- Problem: need the MAC for an IP
- Broadcast "who has this IP?", owner replies
- Only works inside one subnet

## NAT
### Many devices, one public IP
- Router table: private IP and port to public IP and port
- Entries expire when idle, so keepalives
### Ports
- A port belongs to a connection, not an app
- Connection = source IP and port, destination IP and port
### Reaching a server from outside
- Problem: unrequested packets are dropped
- Public IP, or port forwarding, or a tunnel
- CGNAT: no real public IP, forwarding fails
### NAT traversal (peer to peer)
- Problem: both peers behind NAT cannot start
- STUN: learn my public IP and port
- Signalling: app server swaps the addresses
- Hole punching: both send, both NATs open
- TURN relay: fallback, also over TCP
- ICE: tries direct first, then relay

## The internet
### Owners
- ISPs, carriers, cloud companies
### Backbone routers
- Core of the carrier networks
### AS and BGP
- Networks agree to exchange traffic
