---
name: docs
description: "Discover existing repository knowledge cheaply before spending context on exploration. Load on non-trivial repo work: before a grep/glob/read sweep of an unfamiliar area, before answering how something works in this repo, when a past session may already have settled the question, when onboarding to a repo, or when a repo has an `.agent/` directory. Not for writing, updating, or pruning docs; not for trivial one-answer requests or an already-known file path."
---

`.agent/` folder: at repo root, contains durable AI-facing knowledge.

## Discovery Workflow

- Once per session, unless already scanned: run `scripts/inventory`.
- Full-read only docs with task-relevant description.
- No docs found: fallback to closest `README.md`.

## Tools

- `scripts/inventory`: scans repo `.agent/`, reports all doc frontmatters.
- `scripts/get-frontmatter <file>`: retrieves only the frontmatter of a specified doc.

## Guardrails

- Script fails: name file and reason.
- Inventory unavailable (no `yq`, denied, other failure): read README and targeted `.agent/` paths direct; report blocked.

## Writing

Discovery gap or settled high-value knowledge: load `docs-write` to preserve knowledge.
