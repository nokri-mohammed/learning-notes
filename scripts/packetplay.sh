#!/usr/bin/env bash
# Run the newest installed packetplay plugin: validate, build, export or icons.
# Usage: ./scripts/packetplay.sh validate|build|export|icons [args...]
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
case "${1:-}" in
  validate|build|export|icons) ;;
  *) echo "usage: ./scripts/packetplay.sh validate|build|export|icons [args...]" >&2; exit 2;;
esac
base="$HOME/.claude/plugins/cache/packetplay/packetplay"
ver=$(ls "$base" 2>/dev/null | sort -V | tail -1)
[ -n "$ver" ] || { echo "packetplay plugin not installed" >&2; exit 2; }
exec bun "$base/$ver/skills/packetplay/packetplay.js" "$@"
