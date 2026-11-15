---
title: The internet
tags: [networking, internet, bgp]
date: 2026-11-15
description: The internet is many independent networks that agree to pass traffic between each other.
---

**Core:** No one owns the internet. It is many independent networks joined together, and they agree to exchange traffic using shared rules.

## Who runs it

- ISPs, carriers and cloud companies each own and run their own network.
- Each network is an autonomous system (AS) with its own number.
- Backbone routers form the core of the carrier networks and carry traffic over long distances.
- Your packet crosses only the routers on its path, never other homes' routers.

## How networks agree

- BGP is the protocol where networks announce which addresses they can reach.
- Peering: two networks swap traffic directly, usually without payment.
- Transit: a smaller network pays a larger one to carry its traffic.

## Who sets the rules

- IETF writes the standards.
- IANA and the regional registries (RIRs) hand out IP address blocks and AS numbers.

## Related

- [Routing](routing.md)
- [Networking](index.md)
