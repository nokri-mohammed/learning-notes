#!/usr/bin/env bash
# Usage: postbuild.sh <notes-dir> <public-dir> <site-base-path, e.g. learning-notes>
# Quartz copies every non-Markdown file but drops the ".html" extension from its name, so a hand-made
# animation "x/file-journey.html" would be served as an extensionless file with no content type.
# Turn each such file into a folder "x/file-journey/index.html" so "x/file-journey" opens it as a page.
# index.html files in the notes folder are ignored by the build and skipped here.
set -euo pipefail
notes="$1"; pub="$2"; base="$3"
find "$notes" -type f -name '*.html' ! -name 'index.html' -print0 | while IFS= read -r -d '' f; do
  rel="${f#"$notes"/}"
  dest="$pub/${rel%.html}"
  rm -rf "$dest"
  mkdir -p "$dest"
  cp "$f" "$dest/index.html"
  echo "animation page: ${rel%.html}/"
done
# Quartz v5.0.0 search, explorer and graph fetch "/static/contentIndex.json" from the domain root,
# which is wrong for a project site served under /<base>/. Point them at the real folder.
sed -i "s#fetch(\"/static/contentIndex.json\")#fetch(\"/$base/static/contentIndex.json\")#g" "$pub"/*.js
if grep -q 'fetch("/static/contentIndex.json")' "$pub"/*.js; then echo "contentIndex patch failed" >&2; exit 1; fi
# Quartz v5.0.0 explorer links, search result cards (tags too) and the search preview fetch are built
# from the domain root ("/" + slug). Prefix them with the site base. Do not touch the tab bar's
# new URL(`/${slug}`): its slug comes from location.pathname, which already holds the base.
sed -i -e "s#\.href=\"/\"+#.href=\"/$base/\"+#g" -e "s#new URL(\"/\"+#new URL(\"/$base/\"+#g" "$pub"/postscript.js
if grep -q -e '\.href="/"+' -e 'new URL("/"+' "$pub"/postscript.js; then echo "root link patch failed" >&2; exit 1; fi
touch "$pub/.nojekyll"
