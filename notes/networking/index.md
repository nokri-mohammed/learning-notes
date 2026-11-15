---
title: Networking
tags: [networking]
date: 2026-11-15
description: What networking is, and the few things worth remembering about speed, TCP, layers, routing and the internet.
---

**Networking** is how computers send data to each other: the rules (protocols) and the hardware (cables, cards, routers) that move bytes from one machine to another.

## Remember

- **[Speed has two parts](speed.md)**
  - Latency: how long one packet waits to arrive. Usually the bottleneck.
  - Bandwidth: how much fits through the pipe per second. Your slowest link sets it.
  - Light in fiber sets a hard minimum delay, so cut round trips and use a CDN.
- **[TCP makes the network reliable](tcp-basics.md)**
  - Handshake first (SYN, SYN-ACK, ACK): one round trip before any data.
  - It numbers segments, acknowledges them and resends lost ones.
  - Sender sends at most `min(cwnd, rwnd)`:
    - cwnd: the sender's own guess of what the network can carry.
    - rwnd: the receiver's free buffer.
- **[Data is wrapped in layers](osi-file-journey.md)**
  - App makes the message.
    - Where: the browser or Node app.
  - TCP splits it into segments.
    - Where: the kernel.
  - IP adds addresses.
    - Where: the kernel.
  - The card adds a frame.
    - Where: the network card and its driver.
  - Bits go out as a signal.
    - Where: the network card (PHY).
  - The receiver unwraps in reverse.
- **[Routers move packets hop by hop](routing.md)**
  - A router reads only up to the IP address and picks the next hop from its routing table (longest prefix wins).
  - MAC addresses change at every hop. IP addresses stay the same end to end.
- **[The internet is many networks joined together](internet.md)**
  - ISPs, carriers and cloud companies each run their own network and agree to pass traffic between them (BGP).

## Mind map

<iframe src="assets/networking.mindmap.html" width="100%" height="640" style="border:0" loading="lazy" title="Networking mind map"></iframe>

## Also

- [Reverse proxy](reverse-proxy.md): one front door for many services.
