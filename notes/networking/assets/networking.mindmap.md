---
markmap:
  initialExpandLevel: 4
---

# Networking: how the pieces connect

## 7 Application
### Browser and HTTP
- Makes the message, hands it to the kernel
### DNS
- Name to public IP (A record)
### Reverse proxy
- One front door, routes by hostname
### Signalling server
- Swaps peer addresses for a call

## 4 Transport (ports)
### TCP
- Handshake: SYN, SYN-ACK, ACK, one round trip
- rwnd protects the receiver, cwnd protects the network
- Slow start, then congestion avoidance, cut on loss
- Window / RTT sets speed, BDP = bandwidth x RTT
- Lost segment blocks later data (HOL)
- Reuse connections to avoid new handshakes
### UDP
- No handshake, no ACK, no ordering
- One message = one datagram
- Used for calls, games, DNS, QUIC
- Peer to peer runs on UDP: see NAT traversal
### Ports
- A port belongs to a connection, not an app
- Connection = source IP:port + destination IP:port

## 3 Network (IP)
### Router and routing table
- Reads up to layer 3, new frame at every hop
- Longest prefix match, TTL minus 1
### Subnet and gateway
- IP, mask, gateway set by hand or DHCP
- Same subnet: send directly
- Otherwise: send to the default gateway
### NAT
- Router table: private IP:port to public IP:port
- Entries expire when idle, so keepalives
- Unrequested packets dropped, so port forwarding
- CGNAT: no real public IP
### NAT traversal (peer to peer, UDP)
- Problem: both peers behind NAT cannot start
- STUN: learn my public IP:port
- Signalling: app server swaps the addresses
- Hole punching: both send, both NATs open
- TURN relay: fallback, also over TCP
- ICE: tries direct first, then relay
### The internet
- Independent networks (AS) joined by BGP
- Peering and transit

## 2 Data link
### Frames and MAC
- MAC works per link, IP works end to end
### ARP
- Problem: need the MAC for an IP
- Broadcast "who has this IP?", owner replies
- Only inside one subnet, so other subnets use the gateway's MAC

## 1 Physical
### Bits as a signal
- Fiber core, slow edge: the slowest link wins
### Latency and bandwidth
- Latency: propagation, transmission, processing, queuing
- Speed of light sets the floor
- CDN moves data closer
