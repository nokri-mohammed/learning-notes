#!/usr/bin/env bash
# Run the newest installed flashdeck plugin on a deck in notes/: validate or build.
# Usage: ./scripts/flashdeck.sh validate notes/<topic>/assets/<name>.cards.yaml [--json]
#        ./scripts/flashdeck.sh build    notes/<topic>/assets/<name>.cards.yaml
# build always writes the .html next to the deck (same name, .html).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
usage() { echo "usage: ./scripts/flashdeck.sh validate|build notes/<topic>/assets/<name>.cards.(yaml|yml|json) [--json]" >&2; exit 2; }
cmd="${1:-}"; deck="${2:-}"
case "$cmd" in validate|build) ;; *) usage;; esac
case "$deck" in
  *..*) usage;;
  notes/*/assets/*.cards.yaml|notes/*/assets/*.cards.yml|notes/*/assets/*.cards.json) ;;
  *) usage;;
esac
[ -f "$deck" ] || { echo "no such deck: $deck" >&2; exit 2; }
base="$HOME/.claude/plugins/cache/flashdeck/flashdeck"
ver=$(ls "$base" 2>/dev/null | sort -V | tail -1)
[ -n "$ver" ] || { echo "flashdeck plugin not installed" >&2; exit 2; }
tool="$base/$ver/skills/flashdeck/flashdeck.js"
if [ "$cmd" = validate ]; then
  if [ "${3:-}" = "--json" ]; then exec bun "$tool" validate "$deck" --json; fi
  exec bun "$tool" validate "$deck"
fi
out="${deck%.*}.html"
exec bun "$tool" build "$deck" -o "$out"
