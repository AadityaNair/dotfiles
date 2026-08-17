#!/usr/bin/env bash
# Searches past pi session JSONL files for a keyword and prints matching
# session paths with a short snippet of each hit. See SKILL.md for usage
# and the reasoning behind this two-pass grep-then-jq approach.
set -euo pipefail

QUERY="${1:?Usage: search.sh <query> [agent-dir]}"
AGENT_DIR="${2:-${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}}"
SESSIONS_DIR="$AGENT_DIR/sessions"

if [ ! -d "$SESSIONS_DIR" ]; then
	echo "No sessions directory at $SESSIONS_DIR" >&2
	exit 1
fi

# Pass 1: grep -l is much faster than starting jq per file when most files
# won't match at all - JSONL keeps message text inline as plain-ish JSON
# strings, so a raw case-insensitive grep is a good enough prefilter.
matches=$(grep -ril "$QUERY" "$SESSIONS_DIR" --include="*.jsonl" 2>/dev/null || true)

if [ -z "$matches" ]; then
	echo "No sessions matched '$QUERY'"
	exit 0
fi

while IFS= read -r file; do
	echo "=== $file ==="
	# Pass 2: jq only on files that already matched, to extract clean
	# role + timestamp + snippet instead of raw JSON lines.
	jq -r --arg q "$QUERY" '
    select(.type == "message" and (.message.role == "user" or .message.role == "assistant")) |
    (.message.content | if type == "string" then . else (map(.text? // empty) | join(" ")) end) as $text |
    select($text | test($q; "i")) |
    "\(.timestamp)  [\(.message.role)]  \($text[0:200])"
  ' "$file" 2>/dev/null || true
	echo
done <<<"$matches"
