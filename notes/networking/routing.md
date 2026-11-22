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

- **Problem:** to build a frame, the sender needs the destination's MAC, but it only knows the IP.
- **Solution:** ARP, which maps an IP to a MAC address.

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

## NAT: many devices, one public IP

- IPv4 has only about 4.3 billion addresses, so devices behind a router use private addresses and share one public IP.
- NAT lives in the router or firewall at the edge, where the private network meets the internet. At home, that is the internet router. In the cloud, it is a NAT gateway.
- The router keeps a table mapping private IP and port to its public IP and port.
- Example (generic addresses):
  - Laptop `192.0.2.10:50000` calls `198.51.100.7:443`.
  - The router rewrites the source to `203.0.113.5:61001` and records it in its table.
  - The reply returns to `203.0.113.5:61001`. The router looks it up, rewrites it back to `192.0.2.10:50000` and delivers it.
- Where the ports come from:
  - The device's kernel picks a free random port for each connection.
  - The router picks its own free public port for each mapping, because two devices may use the same local port.
  - The server's port is fixed, such as 443 for HTTPS.
- Devices behind NAT cannot be reached from outside unless you add a port-forwarding rule. This is a side effect of the table, not a security feature: a firewall is for that.

### NAT timeouts

- **Problem:** NAT table entries expire when a connection is idle (no packets in either direction) for too long. A later packet finds no matching entry and is dropped, so the connection silently breaks.
  - NAT needs to know when a connection starts and ends, to create and remove entries.
  - TCP has a handshake and a close, so NAT can follow it.
  - UDP has neither, so NAT guesses with a timer, and the length differs from device to device.
  - Many NAT devices apply similar timers to TCP too, so long-lived idle TCP connections can also drop.
- **Solution:** keepalives. Send small packets now and then in both directions to reset the timers along the path.
- Clue: if long-lived connections get dropped without warning, suspect a NAT timeout.

### Ports

- A port belongs to a connection, not to an app: one app with ten connections uses ten ports.
- Each device manages its own ports. The kernel keeps a table of used ports and gives each new connection a free random port from the OS's default range. DHCP and the gateway do not assign ports.
- Two devices can use the same port number. A connection is identified by the full 4-tuple (source IP and port, destination IP and port), so different IPs keep them apart.
- Behind NAT:
  - **Problem:** two devices may use the same local port, and both appear as the same public IP.
  - **Solution:** the NAT router gives each connection its own public port and records the mapping.
- A server app listens on one fixed port (443 for HTTPS, 80 for HTTP). Browsers add the default port for you. Any other port is written in the address, for example `:8443`.

## Public and private addresses

- Private ranges (`10.x`, `172.16.x` to `172.31.x`, `192.168.x`) are reserved for local networks and are not routed on the internet.
- A public IP is unique worldwide. The internet routes packets to the network that owns it, and that network's last router uses ARP to deliver the frame.
- DNS only turns a name into a public IP (an A record). It knows nothing about local servers or ports.

### Reaching a server from the internet

- **Problem:** a device behind NAT cannot be reached, because an unrequested incoming packet finds no table entry and is dropped.
- **Solution 1, public IP on the server:** give the server its own public IP, as in a data centre. Packets arrive directly, with no NAT. A firewall controls which ports are open.
- **Solution 2, port forwarding:** a permanent entry in the router's table, such as public `203.0.113.5:443` to private `192.0.2.20:443`. The sender uses the router's public IP and port. The server stays private.
- Cloud VMs: the provider keeps a 1-to-1 mapping from the public IP to the VM's private IP.
- Who gives a public IP: your ISP (a static IP, sometimes extra), or a hosting or cloud provider. Some ISPs use CGNAT, so your router has no real public IP and forwarding cannot work. A tunnel (such as Cloudflare Tunnel) avoids open ports.

### NAT traversal for peer-to-peer

**Goal:** two people, Peer 1 and Peer 2, want to talk directly (a call, a game, file sharing). Each is behind their own home router with NAT.

**The normal case: client and server**
- The client (a browser) behind NAT calls a server, such as `198.51.100.7:443`.
- The client sends first. Its NAT creates a table entry on the way out, so the server's reply finds the entry and gets in.
- The server has a public IP and a fixed port that everyone knows, so the client always knows where to send. No problem.

**The peer case: why it breaks**
- Both peers are behind NAT, so neither has a public server address.
- Whoever sends first, the packet reaches the other NAT, which has no entry for it and drops it.
- Nobody can be "the server", because neither is reachable from outside.

Each solution below creates the next problem.

1. **Problem:** each NAT drops packets from outside that it has no record of, and the only way to get a record is to send out first.
   - Sending out needs the other peer's public IP and port. Peer 1 knows neither its own nor Peer 2's.
2. **Problem:** I do not know my own public IP and port. The app only sees its private address.
   - **Solution:** ask a public STUN server. It reports the source IP and port it sees on the packet, after NAT rewrote it. Send it from the same socket the call will use, so the NAT mapping stays the same.
3. **Problem:** I do not know Bob's address, and he does not know mine.
   - **Solution:** signalling. Both apps are already clients of the app's own public server.
     - You call Bob in the app. The server tells Bob's app, and when he accepts, each peer's IP and port go to the other.
     - It must be public, because both peers connect to it outward through their NATs.
     - It is not the STUN server. STUN only answers "what address do you see for me?".
     - It could even be done by hand: send each other the address over chat.
4. **Problem:** both NATs still have no record, so the first packets are dropped.
   - **Solution:** hole punching. Both peers send UDP packets to each other's address in a loop. Each outgoing packet creates an entry in its own NAT, so the other's packets then get through. There is no ACK in UDP: the app treats any packet from the peer as the signal that it worked.
5. **Problem:** NAT entries expire when idle, and a new mapping may get a different port.
   - **Solution:** keepalives while the session is open. When the call ends they stop, and the next call repeats the steps.
6. **Problem:** some NATs give a different public port for each destination, so the STUN port is wrong and the direct path fails.
   - **Solution:** a TURN relay, a public server that forwards the traffic between both peers. It always works, but costs bandwidth and adds delay.
     - Both peers send an allocate request to the TURN server, agree permissions, then send their data through it.
7. **Problem:** some firewalls (common in company networks) block UDP altogether, so even a direct path or STUN fails.
   - **Solution:** TURN also works over TCP, so it is the fallback of last resort.

ICE is the logic that tries the options in order (direct first, then relay) and picks the best. WebRTC uses it.

- The STUN request to the server also creates the NAT entry, and STUN has its own keepalive pings.
- In Google's libjingle (an old figure), about 92% of connections went direct and 8% needed a relay.
- Do not build this yourself: use an existing ICE library.

## Related

- [The journey of a file](osi-file-journey.md): routers in the full picture.
- [The internet](internet.md): who owns the routers in between.
- [Networking](index.md)
