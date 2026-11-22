---
title: "Speed: latency and bandwidth"
tags: [networking, latency, bandwidth]
date: 2026-11-15
description: Why network speed is mostly about waiting (latency), not pipe width (bandwidth).
---

**Core:** Network speed has two parts. Latency is the waiting, bandwidth is the pipe width, and latency is usually the bottleneck.

## Latency

- Time from sending a packet to it being received. RTT (round-trip time) is there and back.
- Total latency is the sum of four delays:
  - Propagation: distance / signal speed.
  - Transmission: packet size / link rate.
  - Processing: a router reads the header.
  - Queuing: waiting in a buffer (oversized buffers cause bufferbloat).
- Every router on the path repeats the last three.
- Light in fiber is about 200,000 km/s, so distance sets a hard minimum that no hardware beats.
  - New York to London is about 56 ms round trip at best.
- People notice lag at 100 to 200 ms, find it sluggish above 300 ms, and lose focus around 1 s.
- Last mile: home to ISP often adds 10 to 65 ms. `traceroute` shows each hop.

## Bandwidth

- Maximum throughput of a path. Rates are in bits per second, file sizes in bytes.
  - 1 byte = 8 bits, so 10 MB over a 1 Mbps link takes 80 s.
- Core networks are fiber. Wavelength-division multiplexing sends many wavelengths down one fiber, so capacity is huge and cheap to grow.
- The edge (home, mobile, local router) is far slower.
  - Your usable bandwidth is the slowest link between you and the server.

## What to do about it

- **Problem:** bandwidth keeps growing, but latency cannot beat the speed of light, so a faster link does not fix a slow page.
- **Solution:** cut round trips, move data closer (CDN), cache and prefetch.

## Example

New York to London is about 56 ms round trip. Handshake, TLS and the request take about 3 round trips, roughly 170 ms before the first byte, on any bandwidth. A server in London removes the crossing.

## Related

- [TCP](tcp-basics.md): where the round trips come from.
- [Networking](index.md)
