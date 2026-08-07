---
name: docs
description: "Discover existing repository knowledge cheaply before spending context on exploration. Load on non-trivial repo work: before a grep/glob/read sweep of an unfamiliar area, before answering how something works in this repo, when a past session may already have settled the question, when onboarding to a repo, or when a repo has an `.agent/` directory. Scans `.agent/` doc frontmatter via inventory script, full-reads only task-relevant docs, falls back to README. Not for writing, updating, or pruning docs; not for trivial one-answer requests or an already-known file path."
license: MIT
metadata:
  author: andresgongora
---

# Skill: docs

Discovery of repo knowledge. Find what repo already digested, skip costly re-exploration.

## Core Rules

1. Cheap discovery first. Source beats docs; digested docs beat blind re-scan.
2. Frontmatter routes. `description:` decides if body worth reading.
3. Discover, not write. Persisting new knowledge is separate gated discipline.

## Discovery Workflow

Agent-directed documentation resides in `.agent/`.

Once per session, unless already scanned:

1. `.agent/` exists: run `scripts/inventory`. Scan rows, full-read only task-relevant doc.
2. One file's full frontmatter, no body: `scripts/get-frontmatter <file>`.
3. No relevant doc, `README.md` exists: read relevant section.
4. Script fails: it names file and reason. Repair write-side — load `docs-write`, rerun.
5. Inventory unavailable (no `yq`, denied, other failure): read README and targeted `.agent/` paths direct; report blocked.

## When to Switch to Writing

Discovery reveals a gap AND this session produced (or can cheaply settle) durable high-value knowledge worth persisting for future sessions — settled research, hard-won architecture facts, root cause, accepted decision, cross-session handoff: load `docs-write` skill. A bare gap with nothing worth persisting yet does not trigger writing.
