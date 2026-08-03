---
name: docs
description: "Discover existing repository knowledge cheaply before broad exploration. Load on non-trivial repo work: scan `.agent/` docs via inventory script, read only task-relevant docs, fall back to README. For AI agents. Dense style. Not for writing/updating docs (that is the doc-writing discipline). Not for repo-state snapshots."
---

# Skill: docs

Discovery of repo knowledge. Find what repo already digested, skip costly re-exploration.

## Core Rules

1. Cheap discovery first. Source beats docs; digested docs beat blind re-scan.
2. Frontmatter routes. `summary:` decides if body worth reading.
3. Discover, not write. Persisting new knowledge is separate gated discipline.

## Discovery Workflow

Agent-directed documentation resides in `.agent/`.

Once per session, unless already scanned:

1. `.agent/` exists: run `<skill-root>/scripts/inventory`. Scan rows, full-read only task-relevant doc.
2. One file's full frontmatter, no body: `<skill-root>/scripts/get-frontmatter <file>`.
3. No relevant doc, `README.md` exists: read relevant section.
4. Script fails: it names file and reason. Repair write-side — load `docs-write`, rerun.
5. Inventory unavailable (no `yq`, denied, other failure): read README and targeted `.agent/` paths direct; report blocked.

## When to Switch to Writing

Discovery reveals a gap AND this session produced (or can cheaply settle) durable high-value knowledge worth persisting for future sessions — settled research, hard-won architecture facts, root cause, accepted decision, cross-session handoff: load `docs-write` skill. A bare gap with nothing worth persisting yet does not trigger writing.
