---
description: One-time bootstrap of an agent-naive or agent-stale repo: AGENTS.md, .agent/ ignore, stale-artifact triage
---
Bootstrap this repo to an agent-compliant baseline. One-time init, not documentation upkeep → durable-doc maintenance stays out of scope here.

`$ARGUMENTS` given as a subdir path: scope orientation exploration and the nested `AGENTS.md` target to that subdir only; root `.gitignore` and root `AGENTS.md` stay in scope regardless. Given as an ignore opt-out: skip step 4. Absent: full-repo default, no opt-out.

In order:

1. Compliance check first: `.agent/` already ignored, no stale agent cruft. Never auto-stop on `AGENTS.md` alone, even if present and well-formatted — step 3 always runs and always asks. Delegate: encourage — bounded read-only check.
2. Bounded orientation exploration: entry points, top-level layout, language/tooling, unspoken boundaries. Not a full codebase read. Delegate: encourage — bounded read-only locate.
3. `AGENTS.md`: apply this per file in scope (root always; nested target too when `$ARGUMENTS` gave a subdir). None exists at that scope — create via AGENTS.md-maintenance behavior, no prompt needed. File exists — state compliance verdict (compliant / stale / malformed) in one line, then always ask interactive regardless of verdict: FULL REFACTOR, LEAVE UNTOUCHED, DELETE AND START FRESH. Never skip this prompt or silently pass through on a compliant file. LEAVE UNTOUCHED: stop this step for that file, report as skipped. Otherwise treat old file as draft/reference only, never edit in place — write a fresh `AGENTS.md` via AGENTS.md-maintenance behavior, then fold in only the rules from the old draft still worth keeping (durable, non-stale, no dead refs, if unsure move into documentation). DELETE AND START FRESH: skip migration, drop old file, write fresh only. Show intended diff, get approval before any change. Never blind-overwrite. Delegate: prohibit — one-way door, main thread only.
4. `.gitignore`: append a `.agent/` entry; create the file if missing. Non-git repo: skip this step, do not fail. Never rewrite existing `.gitignore` content. Delegate: allow — mechanical single-file edit.
5. Stale-artifact triage: flag old or foreign agent tooling found (outdated rule files, orphaned config). Report only; delete on explicit approval. Delegate: encourage flagging — prohibit deletion.

Report: files created, files refactored, ignore entries added, stale artifacts flagged, actions declined, and steps skipped with reason (non-git, opt-out, already compliant). No commit, staging, push, or unrelated edits.
