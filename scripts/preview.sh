#!/usr/bin/env bash
# Live Quartz preview of notes/ (rebuilds on every change).
# Usage: ./scripts/preview.sh start|stop|status
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
usage() { echo "usage: ./scripts/preview.sh start|stop|status" >&2; exit 2; }
[ "$#" -eq 1 ] || usage
cache="$HOME/.cache/learning-notes"
q="$cache/quartz"
pidf="$cache/preview.pid"
logf="$cache/preview.log"
port=8790
url="http://localhost:$port/"
running() {
  [ -f "$pidf" ] || return 1
  local p; p="$(cat "$pidf")"
  case "$p" in ''|*[!0-9]*) return 1;; esac
  kill -0 "$p" 2>/dev/null
}
case "$1" in
  start)
    if running; then echo "running: $url"; exit 0; fi
    [ -x "$q/quartz/bootstrap-cli.mjs" ] || { echo "quartz not installed at $q" >&2; exit 1; }
    cp quartz/quartz.config.yaml "$q/quartz.config.yaml"
    : > "$logf"
    ( cd "$q" && setsid bash -c 'echo $$ > "$1"; shift; exec nohup "$@"' _ "$pidf" \
        ./quartz/bootstrap-cli.mjs build -d "$OLDPWD/notes" -o "$cache/public" \
        --serve --port "$port" --wsPort 3001 >> "$logf" 2>&1 < /dev/null & )
    sleep 1
    echo "starting: $url (log: $logf)"
    ;;
  stop)
    if running; then
      p="$(cat "$pidf")"
      kill -- "-$p" 2>/dev/null || kill "$p" 2>/dev/null || true
    fi
    rm -f "$pidf"
    echo "stopped"
    ;;
  status)
    if running; then echo "running: $url"; else echo "not running"; fi
    ;;
  *) usage;;
esac
