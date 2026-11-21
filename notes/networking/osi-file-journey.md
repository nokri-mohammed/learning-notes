---
title: "OSI model: the journey of a file"
tags: [networking, osi]
date: 2026-11-15
description: Who does what (browser, kernel, network card, routers) as a file travels.
---

**Core:** A file is wrapped layer by layer on the sender (browser, kernel, network card), forwarded by routers that read only up to layer 3, then unwrapped in reverse on the receiver.

## Key points

**Sender: who does what**

| Layer | Who | What happens | Data |
|---|---|---|---|
| 7&nbsp;Application | Browser | Builds the HTTP POST with the file in the body | HTTP message |
| 6&nbsp;Presentation | Browser (TLS) | Encrypts the message | Encrypted bytes |
| 5&nbsp;Session | App and TCP | Connection state. In practice folded into the app and TCP | Byte stream |
| 4&nbsp;Transport | Kernel (TCP) | Handshake first. Splits the stream into segments (about 1460 bytes), adds ports and sequence numbers, waits for ACKs | Segments |
| 3&nbsp;Network | Kernel (IP) | Adds source and destination IP address | Packets |
| 2&nbsp;Data&nbsp;link | Driver and card | Adds MAC addresses, type and CRC. Payload at most 1500 bytes (MTU) | Frames |
| 1&nbsp;Physical | Network card | Bits become voltage (copper), light (fibre) or radio (WiFi) | Signal |

**Browser to kernel**
- The app calls `send()`. The bytes are copied into the kernel's send buffer, one per connection, in RAM.
- If the buffer is full, `send()` blocks (in Node, `write()` returns `false`: backpressure).
- Before data, the kernel did the TCP handshake (SYN, SYN-ACK, ACK), one round trip.
- TCP sends at most `min(cwnd, rwnd)` unacknowledged bytes. cwnd is the sender's own guess (slow start doubles it each round trip). rwnd is the receiver's free buffer, carried in every ACK.

**Network card**
- Sending: the driver hands over the IP packet. Header fields (MACs, type) and the CRC are added, and the PHY turns bits into a signal.
- Receiving: the PHY gives bits. Hardware spots the start marker (7 bytes of `10101010`, then `10101011`) and reads fields at fixed positions. It checks the destination MAC and the CRC, drops damaged frames, then copies the payload into RAM (DMA) and interrupts the CPU. It is mostly fixed hardware, not a general CPU.
- A frame has MAC addresses, type, payload and CRC. It carries no file identity.

**Routers in between**
- Each hop strips the old frame, reads the destination IP, picks the next hop from its routing table, and wraps the same packet in a new frame with new MAC addresses.
- MAC addresses change at every hop. IP addresses stay the same end to end.
- Routers work only up to layer 3 and never join the TCP handshake. Each hop adds processing, queuing and transmission delay.

**Receiver: the reverse**
- Network card: signal, bits, frames (CRC and MAC checked), then the packet goes to RAM.
- Kernel IP: checks the destination IP and strips the header.
- Kernel TCP: finds the connection by its 4-tuple (source IP, source port, destination IP, destination port), puts segments in order by sequence number, sends ACKs with its rwnd, and fills the per-connection receive buffer in RAM.
- App: reads the buffer (Node `'data'`, `recv()`), which frees space and grows rwnd. A slow reader leaves the buffer full, so rwnd shrinks to 0 and the sender stops.
- TCP has no message boundaries, so HTTP parses the stream: headers first, then the body length it announced.

## OSI vs TCP/IP

OSI has 7 layers and is used for teaching and naming problems. TCP/IP has 4 layers and is what the internet actually runs on.

<iframe src="assets/osi-vs-tcpip.html" width="100%" height="1200" style="border:0" loading="lazy" title="OSI model vs TCP/IP model"></iframe>

## Picture

The whole journey, from the typed address to the ACK.

<video src="assets/file-journey.mp4" controls preload="metadata" width="100%"></video>

<button type="button" onclick="var d=document.getElementById('journey-map'),f=d.querySelector('iframe');if(!f.getAttribute('src'))f.setAttribute('src',f.dataset.src);d.showModal();history.pushState({jm:1},'');window.addEventListener('popstate',function(e){e.stopImmediatePropagation();d.close();},{capture:true,once:true});" style="display:inline-flex;align-items:center;gap:6px;padding:6px 14px;border:1px solid var(--lightgray);border-radius:999px;background:var(--light);color:var(--dark);font-family:inherit;font-size:14px;font-weight:600;line-height:1.4;cursor:pointer">Open interactive map <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2.5 6V2.5H6M10 2.5h3.5V6M13.5 10v3.5H10M6 13.5H2.5V10"/></svg></button>&nbsp; Step through it, zoom and pan.

<dialog id="journey-map" onkeydown="if(event.key==='Escape'){event.preventDefault();this.close();}" aria-label="Interactive map: a file's journey through the OSI layers" onclose="if(history.state&&history.state.jm)history.back();" style="width:100vw;height:100dvh;max-width:none;max-height:none;margin:0;padding:0;border:0;background:var(--light);overflow:hidden"><div style="display:flex;flex-direction:column;height:100%"><div style="flex:none;display:flex;align-items:center;gap:12px;padding:8px 12px;border-bottom:1px solid var(--lightgray);background:var(--light)"><button type="button" onclick="this.closest('dialog').close()" style="display:inline-flex;align-items:center;gap:6px;padding:6px 14px;border:1px solid var(--lightgray);border-radius:999px;background:var(--light);color:var(--dark);font-family:inherit;font-size:14px;font-weight:600;line-height:1.4;cursor:pointer"><svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" aria-hidden="true"><path d="M4 4l8 8M12 4l-8 8"/></svg> Back to notes</button></div><iframe data-src="./file-journey" title="Interactive map: a file's journey through the OSI layers" style="display:block;flex:1 1 auto;width:100%;min-height:0;border:0"></iframe></div></dialog>

```mermaid
flowchart TD
  subgraph Sender
    A["7 App: HTTP message"] --> B["6 TLS: encrypted"]
    B --> C["4 Kernel TCP: segments"]
    C --> D["3 Kernel IP: packets"]
    D --> E["2 Driver and card: frames"]
    E --> F["1 Card PHY: signal"]
  end
  F --> R1["Router: layers 1 to 3"]
  R1 --> R2["Router: layers 1 to 3"]
  subgraph Receiver
    G["1 Card: bits"] --> H["2 Frames, CRC checked"]
    H --> I["3 Kernel IP: packets"]
    I --> J["4 Kernel TCP: in order, ACKs"]
    J --> K["7 App: HTTP parsed"]
  end
  R2 --> G
```

## Example
A 4000 byte `notes.txt` (HTTP and TLS overhead ignored): one HTTP message, then 3 TCP segments (1460 + 1460 + 1080 bytes), 3 IP packets, 3 frames, then bits as a signal. The receiver reverses each step and rebuilds the same 4000 bytes.

## Related
- [TCP](tcp-basics.md)
- [Routing](routing.md)
- [TCP animation](tcp.html)
- [Networking mind map](assets/networking.mindmap.html)
