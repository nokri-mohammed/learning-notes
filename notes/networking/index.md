---
title: Networking
tags: [networking]
date: 2026-11-15
description: What networking is, and the few things worth remembering about speed, TCP, layers and routing.
---

**Networking** is how computers send data to each other: the rules (protocols) and the hardware (cables, cards, routers) that move bytes from one machine to another.

## Remember

- **Speed has two parts**
  - Latency: how long one packet waits to arrive. Usually the bottleneck.
  - Bandwidth: how much fits through the pipe per second. Your slowest link sets it.
  - Light in fiber sets a hard minimum delay, so cut round trips and use a CDN.
- **TCP makes the network reliable**
  - Handshake first (SYN, SYN-ACK, ACK): one round trip before any data.
  - It numbers segments, acknowledges them and resends lost ones.
  - Sender sends at most `min(cwnd, rwnd)`: cwnd is its guess of the network, rwnd is the receiver's free buffer.
- **Data is wrapped in layers**
  - App makes the message, TCP splits it into segments, IP adds addresses, the card adds a frame, then bits go out.
  - The receiver unwraps in reverse.
- **Routers move packets hop by hop**
  - A router reads only up to the IP address and picks the next hop from its routing table (longest prefix wins).
  - MAC addresses change at every hop. IP addresses stay the same end to end.
- **The internet is many networks joined together**
  - ISPs, carriers and cloud companies each run their own network and agree to pass traffic between them (BGP).

## Go deeper

- [Core concepts](core-concepts.md): latency, bandwidth and TCP in detail.
- [OSI model: the journey of a file](osi-file-journey.md): each layer step by step, with the animation and video.
- [TCP animation](tcp.html): handshake, segments, rwnd and cwnd.
- [Networking mind map](assets/networking.mindmap.html): the whole topic in one map.
- [Reverse proxy](reverse-proxy.md): one front door for many services.
