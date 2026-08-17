---
name: better-diffs
description: "Use when showing or reviewing a diff (git diff, git show, git log -p, or comparing two files) so output is syntax-highlighted and easy to read instead of raw +/- lines."
---

# Better Diffs

Pi's `edit` tool already renders its own diffs when it makes a change - this
skill is NOT about that. It's for the other case: when you run `git diff`,
`git show`, `git log -p`, or compare two arbitrary files yourself via `bash`
to review changes, prefer piping through a proper diff renderer over raw
`diff`/`git diff` output.

## DECISION: delta over difftastic

The TODO item that prompted this skill said "difftastic/delta" - either
would work, but `delta` (https://github.com/dandavison/delta) is already
installed on this machine (`git-delta` via Homebrew, confirmed `delta
0.19.2`), while `difft` (difftastic) is not. Zero-install wins for a first
pass. If structural/AST-level diffing turns out to matter more than
side-by-side + syntax highlighting, revisit with
`brew install difftastic` and add a section here for `difft <file_a>
<file_b>`.

## Usage

For anything git-based, pipe through delta rather than reading raw
`git diff` output:

```bash
git diff | delta
git diff --staged | delta
git show <commit> | delta
git log -p -- <path> | delta
```

For two arbitrary files that aren't in git:

```bash
diff -u file_a file_b | delta
```

`delta` reads unified diff format from stdin, so anything that already
produces standard unified diffs can be piped through it the same way.

## Notes

- This is a *bash-usage* convention, not a config change - it doesn't touch
  `git config core.pager`, so plain `git diff` outside of pi still behaves
  normally. Setting `core.pager delta` globally was deliberately left alone
  since that's a personal git config choice, not a pi-specific one.
- `delta` needs a real TTY-ish stdout to render its side-by-side layout well;
  if output looks flattened/uncolored, that's likely because it's being
  captured non-interactively - fall back to plain `git diff` output in that
  case rather than fighting it.
