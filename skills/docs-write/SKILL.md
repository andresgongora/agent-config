---
name: docs-write
description: "Write side of repository knowledge: admit, shape, place, update, and prune durable `.agent/` docs. Load when a session has produced knowledge worth persisting because re-obtaining it later would be expensive — settled research conclusion, hard-won architecture or design fact, resolved root cause, accepted design decision, cross-session handoff, or bootstrapping a missing repo doc with a clear future consumer. Also load when starting or updating a costly-to-lose bug-attempt log (`.agent/bugs/`) or a task handoff note (`.agent/progress/`), or when a workflow needs the managed-doc frontmatter schema or `.agent/` placement rules. A bare documentation gap does not trigger this; establish the value first. Not for reading or discovery."
---

Persist knowledge future agents need, stored under repository `.agent/` folder.

## Admission Gate

Create durable note only when all hold:

1. Claim settled. Facts have matching evidence; decisions have accepted scope, rationale, and owner/source.
2. Recovery cost real. Future session would repeat costly research, exploration, debugging, or decision work.
3. Reuse survives session.

Handoff or bug log: create only when task state is costly to lose. Prompt/todo holds all other in-flight state.

Do not create: chat transcript, raw log, speculative note, duplicate, one-shot trivia, routine progress narration.

Gate fails: write no file.

## Core Rules

- Target audience: AI agents. Write ultra-condensed, preserve technical details.
- Keep `.agent/` small, factual, discoverable.
- Every managed doc follows placement and frontmatter contract.
- Facts state evidence. Never write hypothesis as fact.
- One doc, one topic. Split only at natural topic boundary.
- Link source or relevant existing doc. Do not copy large background.
- Valuable misplaced doc: move. Duplicate or valueless doc: delete or archive.
- Stale external claim: verify source before update.

## Placement

| Destination | Content | Lifecycle |
|---|---|---|
| `.agent/notes/` | Durable design, architecture, reference, decisions, settled research | Inactive: archive if reference survives; else delete |
| `.agent/progress/` | Handoff at task pause/stop/session boundary | Task ends: delete; reusable conclusion moves to `notes/` |
| `.agent/bugs/` | Debug evidence, failed attempts, root cause | Resolved: extract reusable root cause to `notes/`, delete execution-only attempt log; else delete whole |
| `.agent/plan/` | Decision-grade implementation plan | Decision ends: reusable decision moves to `notes/`; else delete |

## Frontmatter

Every managed `.agent/**/*.md` starts with required fields:

```yaml
---
title: <clear title>
description: "<1-2 sentence why-this-exists; the routing line>"
status: draft|active|stale|resolved|archived|done
updated: YYYY-MM-DD
---
```

- `description:` decides read-or-skip. One physical line, dense, concrete, double-quoted.
- `updated:` is date of last substantive change.
- External-source content needs `source: <canonical URL>`. `references:` is optional; never replaces `source:`.
- Run `scripts/check-frontmatter <file.md>` before finish. It checks required fields, `status`, `updated`, optional `source`; manually check remaining rules.

## When To Write

- Durable note: settled design, architecture, reference, decision, research, root cause; include title, purpose, durable facts/decisions, non-obvious conventions, source links.
- Handoff: task pauses, stops, or crosses session boundary; include goal, done, next step, blockers, touch points.
- Bug log: failed-attempt state risks loss; per attempt include symptom, hypothesis, tried, result, next. Resolution records root cause and fix.
- Plan: only placement, frontmatter, lifecycle here; plan-authoring workflow defines shape.
- Bootstrap repo doc: repo root, no existing coverage, non-trivial task, clear future reader.
- Update: source drift, architecture/design change, repeated exploration exposes durable gap.
- Prune: duplicate, low-value stale doc, scan noise, concluded task doc. Reusable conclusion moves to `notes/` before task doc deletion.
