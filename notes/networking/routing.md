---
title: Routing
tags: [networking, routing, ip]
date: 2026-11-15
description: How routers move a packet hop by hop, and why MAC addresses change while IP addresses do not.
---

**Core:** A router reads only up to the destination IP address, picks the next hop from its routing table and forwards the packet in a new frame. IP works end to end, MAC works per link.

## What a router does

- Receives a frame, checks the destination MAC is its own, strips the Ethernet header.
- Reads the destination IP and looks it up in its routing table.
  - Longest matching prefix wins.
- Subtracts 1 from the TTL (a packet is dropped at 0, so it cannot loop forever).
- Wraps the same packet in a new frame with new MAC addresses, then sends it to the next hop.
- Works only up to layer 3. It never joins the TCP handshake.
- Each hop adds processing, queuing and transmission delay.

## MAC vs IP

- MAC address: identifies a network card on one link. Changes at every hop.
- IP address: identifies the machine end to end. Stays the same the whole way.
- ARP finds the MAC address of the next hop for a given IP.
- A network card checks the destination MAC and drops frames that are not for it.

## Related

- [The journey of a file](osi-file-journey.md): routers in the full picture.
- [The internet](internet.md): who owns the routers in between.
- [Networking](index.md)
