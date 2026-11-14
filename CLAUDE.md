# learning-notes: project rules

- This repo is PUBLIC. Never commit private details: addresses, hostnames, usernames, emails,
  tokens, or anything from the CEO's private setup. Use generic examples (`server`, `192.0.2.10`).
- Run `./scripts/check-public.sh` (staged) or `--all` before every commit. It must exit 0.
- Publish notes only through `./scripts/publish.sh "<message>"`.
- The private blocklist is shared across projects at `~/.config/private-patterns/patterns.txt` (outside every repo, one regex per line, never print its values). `check-public.sh` refuses to run without it. Keep `private/` in `.gitignore` as a safety net.
- The tutor's memory (`~/.claude/agent-memory/tutor/`) is private and not part of this repo.
- Conventional Commits, no co-author trailer, no em dashes. Commit email is the repo-local noreply.
- The team-wide rules in `homelab-team-all/CLAUDE.md` apply.
