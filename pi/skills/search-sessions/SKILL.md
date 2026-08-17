---
name: search-sessions
description: "Use when the user references a previous conversation or asks you to find/recall something discussed in an earlier pi session (e.g. 'what did we decide about X before', 'find that session where we set up Y')."
---

# Search Sessions

Pi has no built-in full-text search across past sessions - `pi -r` only
browses/selects by name or date, not content (confirmed against
docs/usage.md and docs/sessions.md; nothing in pi's own SDK/RPC surface
does this either). This skill is a thin, dependency-free workaround: pi
sessions are just JSONL files under `<agent-dir>/sessions/<sanitized-cwd>/`,
one JSON object per line, so a keyword search is a grep+jq problem, not
something that needs new pi-level infrastructure.

## Script

- `search.sh` - two-pass search: `grep -l` first (fast prefilter across all
  session files), then `jq` only on the files that matched (to pull out a
  clean `timestamp [role] snippet` line instead of raw JSON). Requires `jq`.

## Usage

```bash
./search.sh "<query>"
```

The agent dir defaults to `$PI_CODING_AGENT_DIR` (or `~/.pi/agent` if unset)
- same resolution order pi itself uses. Pass a second argument to override:

```bash
./search.sh "tokyonight theme" /custom/agent/dir
```

## Output

For each matching session file:

```
=== /path/to/session.jsonl ===
2026-08-17T19:39:28.574Z  [user]  can you look at the tokyonight theme...
2026-08-17T19:41:02.101Z  [assistant]  Research done, verified against upstream...
```

Once you've found the right session, open it directly:

```bash
pi --session /path/to/session.jsonl
```

## Notes

- Matching is case-insensitive substring/regex (via `grep -i` then
  `jq test($q; "i")`), not semantic search - exact phrasing matters less
  than exact words. If this proves too limited in practice, the natural
  upgrade is embedding-based search, which is real added complexity
  (a vector store, an embedding model call per session) - deliberately
  not done here; see pi/plan.md's memory section for the same tradeoff
  reasoning applied to a different feature.
- Only searches `user`/`assistant` message entries, not tool calls/results
  or custom extension entries - keeps snippets readable. Adjust the `jq`
  filter in `search.sh` if tool output needs to be searchable too.
