#!/usr/bin/env bash
# Build one interactive Markmap page from a topic outline.
# Usage: ./scripts/mindmap.sh notes/<topic>/assets/<topic>.mindmap.md
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
usage() { echo "usage: ./scripts/mindmap.sh notes/<topic>/assets/<topic>.mindmap.md" >&2; exit 2; }
[ "$#" -eq 1 ] || usage
f="$1"
case "$f" in
  */../*|../*|*/..) usage;;
  notes/*/assets/*.mindmap.md) ;;
  *) usage;;
esac
[ -f "$f" ] || { echo "not found: $f" >&2; exit 2; }
out="${f%.md}.html"
npx -y markmap-cli@0.18.12 "$f" -o "$out" --offline --no-open >/dev/null 2>&1 \
  || { echo "markmap build failed" >&2; exit 1; }
echo "$out ($(du -k "$out" | cut -f1) KB)"
