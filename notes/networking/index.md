---
title: Networking
tags: [networking]
date: 2026-11-15
description: "What networking is, and the packet's journey in a few lines: layers, ARP, routing, NAT and peer to peer."
---

**Networking** is how computers send data to each other: the rules (protocols) and the hardware (cables, cards, routers) that move bytes from one machine to another.

## Remember

**One packet, from my PC to a server**

1. **[Layers wrap it](osi-file-journey.md)**
   - The app makes the message (browser or Node app).
   - TCP splits it into segments with ports (kernel).
   - IP adds addresses (kernel).
   - The card adds a frame with MACs (network card and its driver).
   - Bits go out as a signal (network card, PHY).
   - The receiver unwraps in reverse.
2. **[Where to?](routing.md)**
   - Same subnet: send directly. Other subnet: send to my default gateway.
3. **Which MAC? ARP**
   - Problem: the frame needs the destination's MAC, but I only know its IP. ARP maps IP to MAC.
   - Where: in the kernel of every device on the LAN, including the router.
   - Look in my cache (IP to MAC). Missing: broadcast "who has this IP?", the owner replies, I cache it.
   - Other subnet: I ARP for the gateway's MAC only. The gateway ARPs on its own side for the final device.
   - Broadcasts never cross a router.
4. **Router hops**
   - Reads the IP, picks the next hop, builds a new frame. MAC changes every hop, IP stays.
5. **NAT at the edge**
   - Table: private IP:port, public IP:port, and who I am talking to. The reply is matched through it.
   - Idle too long: the entry expires, so send keepalives.
   - Nothing in the table for an incoming packet: dropped. Port forwarding is a permanent entry.
6. **Peer to peer** (both behind NAT, so neither can start)
   - STUN: learn my public IP:port. Signalling: swap addresses. Hole punching: both send, both NATs open. TURN: relay if that fails.

Also: [TCP](tcp-basics.md) is a handshake, then `min(cwnd, rwnd)` in flight. [Speed](speed.md) is mostly latency, not bandwidth.

## Mind map

<iframe src="assets/networking.mindmap.html" width="100%" height="640" style="border:0" loading="lazy" title="Networking mind map"></iframe>

## Flashcards

<iframe src="assets/networking.cards.html" width="100%" height="800" style="border:0" loading="lazy" title="Networking flashcards"></iframe>

## Also

- [TLS](tls.md): encryption and certificates on top of TCP.
- [Reverse proxy](reverse-proxy.md): one front door for many services.
- [The internet](internet.md): many networks joined by BGP.
