#!/usr/bin/env bash
# Publish notes: ./scripts/publish.sh "<message>"
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
msg="${1:?usage: publish.sh \"<message>\"}"
other=$(git status --porcelain | grep -v -E '^.. notes/|^\?\? notes/' || true)
if [ -n "$other" ]; then echo "refused: changes outside notes/ present" >&2; exit 1; fi
git add notes/
if git diff --cached --quiet; then echo "nothing to publish"; exit 0; fi
./scripts/check-public.sh
git commit -q -m "docs(notes): $msg"
git rev-parse --short HEAD
git push -q 2>&1 && echo "push ok"
