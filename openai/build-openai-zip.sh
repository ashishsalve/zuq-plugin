#!/bin/sh
# Builds the ChatGPT and Codex plugin ZIP (Agent Plugins format) from this
# repository. Claude Code never reads or runs this script.
#
# The ZIP root holds exactly:
#   plugin.json   from openai/plugin.json
#   mcp.json      from openai/mcp.json (-> https://zuq.si/mcp/openai)
#   skills/       from ../skills, shared with the Claude Code plugin
#   assets/       logo, logo-dark, icon, icon-dark (openai/assets/ first,
#                 then the shared assets/), plus screenshots only with
#                 --with-screenshots (only when the MCP server ships the widget)
# It never holds .claude-plugin/, .mcp.json, evals/, hooks or credentials.
#
# Usage: sh openai/build-openai-zip.sh [--with-screenshots] [--allow-placeholders]
# Output: openai/dist/zuq-openai.zip
#
# Needs only a POSIX shell plus either `zip` or `python3` (its built-in
# zipfile module). It installs nothing and fetches nothing.

set -eu

WITH_SCREENSHOTS=0
ALLOW_PLACEHOLDERS=0
for arg in "$@"; do
  case "$arg" in
    --with-screenshots) WITH_SCREENSHOTS=1 ;;
    --allow-placeholders) ALLOW_PLACEHOLDERS=1 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
OUT_DIR="$HERE/dist"
OUT="$OUT_DIR/zuq-openai.zip"

fail() { echo "build-openai-zip: $*" >&2; exit 1; }

[ -f "$HERE/plugin.json" ] || fail "missing openai/plugin.json"
[ -f "$HERE/mcp.json" ] || fail "missing openai/mcp.json"
[ -d "$ROOT/skills" ] || fail "missing skills/"

# Placeholder tokens (the to-do marker, matched as T[O]DO so this script does
# not match itself) the operator must replace before an upload.
if grep -n 'T[O]DO' "$HERE/plugin.json" "$HERE/mcp.json" >&2; then
  if [ "$ALLOW_PLACEHOLDERS" -ne 1 ]; then
    fail "replace every placeholder above first (or pass --allow-placeholders for a local test build)"
  fi
  echo "build-openai-zip: warning: building with placeholders" >&2
fi

# Upload validation accepts a ZIP without the demo recording; final MCP review
# does not ("A demo-recording URL that shows the main use cases and tools across
# supported platforms", submission-errors). Warn, do not fail.
if ! grep -q '"demo_recording_url"' "$HERE/plugin.json"; then
  echo "build-openai-zip: warning: review.demo_recording_url is not set in openai/plugin.json; add the HTTPS walkthrough URL before final submission" >&2
fi

STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT INT TERM

cp "$HERE/plugin.json" "$STAGE/plugin.json"
cp "$HERE/mcp.json" "$STAGE/mcp.json"
cp -R "$ROOT/skills" "$STAGE/skills"
mkdir -p "$STAGE/assets"

for name in logo logo-dark icon icon-dark; do
  if [ -f "$HERE/assets/$name.png" ]; then
    cp "$HERE/assets/$name.png" "$STAGE/assets/$name.png"
  elif [ -f "$ROOT/assets/$name.png" ]; then
    cp "$ROOT/assets/$name.png" "$STAGE/assets/$name.png"
  else
    fail "missing $name.png in openai/assets/ and assets/"
  fi
done

if [ "$WITH_SCREENSHOTS" -eq 1 ]; then
  [ -d "$HERE/assets/screenshots" ] || fail "missing openai/assets/screenshots/"
  cp -R "$HERE/assets/screenshots" "$STAGE/assets/screenshots"
fi

# Drop OS junk the directories reject.
find "$STAGE" \( -name '.DS_Store' -o -name 'Thumbs.db' -o -name 'desktop.ini' -o -name '__MACOSX' \) -exec rm -rf {} + 2>/dev/null || true

# Every ./assets path plugin.json names must be in the ZIP.
missing=0
for ref in $(grep -o '"\./assets/[^"]*"' "$STAGE/plugin.json" | tr -d '"'); do
  if [ ! -f "$STAGE/${ref#./}" ]; then
    echo "build-openai-zip: plugin.json references $ref, which is not in the ZIP" >&2
    missing=1
  fi
done
[ "$missing" -eq 0 ] || fail "fix the missing asset references above"

# Screenshots only ship with the widget, and plugin.json must then list them.
if [ "$WITH_SCREENSHOTS" -eq 0 ] && grep -q '"screenshots"' "$STAGE/plugin.json"; then
  fail "plugin.json lists screenshots; pass --with-screenshots or remove them"
fi

mkdir -p "$OUT_DIR"
rm -f "$OUT"
if command -v zip >/dev/null 2>&1; then
  (cd "$STAGE" && zip -q -r -X "$OUT" plugin.json mcp.json skills assets)
elif command -v python3 >/dev/null 2>&1; then
  (cd "$STAGE" && python3 -I -m zipfile -c "$OUT" plugin.json mcp.json skills assets)
else
  fail "needs zip or python3"
fi

entries=$(cd "$STAGE" && find plugin.json mcp.json skills assets -type f | wc -l | tr -d ' ')
bytes=$(wc -c < "$OUT" | tr -d ' ')
echo "build-openai-zip: wrote $OUT ($entries files, $bytes bytes)"
