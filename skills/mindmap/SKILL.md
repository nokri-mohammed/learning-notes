---
name: mindmap
description: Turn a topic's concepts into ONE interactive mind map page (Markmap) saved next to the notes. Use when the CEO asks for a "mind map", wants to "map out the concepts", or wants an "overview of a topic" in one picture, even if they do not name this skill. One map per topic: extend the existing outline, never add a second page.
---

# mindmap: one interactive map per topic

Goal: the whole topic on one clickable page. The outline is Markmap Markdown, the page is built by `./scripts/mindmap.sh`.

## Workflow
1. **Find or create** `notes/<topic>/assets/<topic>.mindmap.md`. There is ONE per topic: extend it, never add another page. No Mermaid mindmaps.
2. **Write the outline** (rules below).
3. **Validate**: exactly one `#` root, no empty headings, no private details. No staging or `check-public.sh` run is needed: just keep to generic content.
4. **Build** from the learning-notes project folder: `./scripts/mindmap.sh notes/<topic>/assets/<topic>.mindmap.md`. It writes `notes/<topic>/assets/<topic>.mindmap.html`, self-contained and offline.
5. **Open** it: `explorer.exe "$(wslpath -w notes/<topic>/assets/<topic>.mindmap.html)"`, and tell the CEO the path.

## Outline rules
- Frontmatter:
  ```
  ---
  markmap:
    initialExpandLevel: 3
  ---
  ```
  Level 3 shows root, branches and sub-branches on open. Level 2 shows only root and branches.
- One `#` root (the topic).
- 4 to 7 `##` branches (the big ideas).
- `###` sub-branches under them.
- `-` bullets under about 8 words each.
- Link to related notes with relative Markdown links where they exist.
- Generic examples only (`server`, `192.0.2.10`): the repo is PUBLIC.
- No em dashes. Use commas, colons or full stops.

## Limits
- Markmap draws a ONE-SIDED tree (root on the left, branches to the right), not a radial map.
- For a true radial map, propose a packetplay mind-map mode to the CEO instead of working around it.
- The engine is `markmap-cli@0.18.12` (MIT), pinned in the script. It is deprecated in favour of `@markmap/cli` 1.x, which is too new to adopt: revisit after 2026-11-20.
- Only the wrapper script is allowed for the build. Do not run `npx` directly or add other npm packages.
