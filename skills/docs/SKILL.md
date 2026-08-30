---
name: docs
description: "Discovers existing repository knowledge before exploration. Load before non-trivial unfamiliar-repo work (before a grep/glob/read of unfamiliar area), onboarding, answering how the repository works, or large repo task."
---

`.agent/` folder: at repo root, contains durable AI-facing knowledge.

## Discovery Workflow

1. From working repository root, once per session unless already scanned: run `scripts/inventory` (defaults to `./.agent`).
2. Full-read only docs with task-relevant description.
3. No docs found: fallback to closest `README.md`.

## Tools

- `scripts/inventory [directory=$PWD/.agent]`: scan `.agent/` for doc frontmatters, report all. Optional arg: path to specific `.agent/` instead of cwd's own.
- `scripts/get-frontmatter <file>`: retrieves only the frontmatter of a specified doc.

## Guardrails

- Script fails: name file and reason.
- Inventory unavailable (no `yq`, denied, other failure): read README and targeted `.agent/` paths direct; report blocked.

## Writing

Discovery gap or settled high-value knowledge: load `docs-write` to preserve knowledge.
