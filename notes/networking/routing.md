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
- A network card checks the destination MAC and drops frames that are not for it.

## Same subnet or not

- Each device stores its IP, its subnet mask (prefix, such as `/24`) and its default gateway. They are set by hand or by DHCP.
- The kernel turns this into a small routing table and checks it on every send:
  - Destination in my subnet: send directly on the LAN.
  - Anything else (another subnet or the internet): send to the default gateway.
- Check yours: `ip addr` and `ip route` on Linux, `ipconfig` on Windows.

## ARP: finding the MAC for an IP

- ARP runs in the kernel of every device on a LAN, including routers. It maps an IP to a MAC.
- Steps on the same subnet:
  - Check the ARP cache (the IP to MAC table) first.
  - If missing, broadcast "who has this IP?" to the broadcast MAC (ff:ff:ff:ff:ff:ff).
  - Only the owner replies, directly to the sender, with its MAC. The sender caches it and sends the frame.
- ARP broadcasts never cross a router, so ARP only works inside one subnet.

## Different subnet: through the gateway

- The sender does not ARP for the destination. It ARPs for the gateway's MAC.
- The frame is addressed to the gateway's MAC, and the IP packet inside still carries the real destination IP.
- The router:
  - Matches the destination IP against its routing table. It has one leg (interface) per subnet and picks the right one.
  - Uses ARP on that leg only to find the destination's MAC.
  - Builds a new frame with the destination's MAC and sends it.
- Sender and receiver never learn each other's MAC. Each knows only the router's MAC on its own side, so every packet goes through the router, in both directions.
- The router keeps an ARP table per interface. After the first packet its entries are cached, so later packets skip the ARP step.

## Related

- [The journey of a file](osi-file-journey.md): routers in the full picture.
- [The internet](internet.md): who owns the routers in between.
- [Networking](index.md)
