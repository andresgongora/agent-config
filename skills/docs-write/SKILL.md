---
name: docs-write
description: "Manage durable `.agent/` docs: admit, place, update, prune, and validate notes, costly handoffs or bug logs, and plan metadata."
---

Persist knowledge future agents need, stored under repository `.agent/` folder.

## Admission Gate

Create or expand a durable note only when all hold:

1. Information high-value and settled. Facts have matching evidence; decisions have accepted scope, rationale, and owner/source.
2. Recovery cost real. Future session would repeat costly research, exploration, debugging, or decision work.
3. Reuse survives session.

Create a handoff or bug log only when task state is costly to lose. Prompt/todo holds all other in-flight state.

Do not create: chat transcript, raw log, speculative durable note, duplicate, one-shot trivia, routine progress narration. Bug logs may record hypotheses only when labeled as hypotheses.

## Core Rules

- Target audience: AI agents. Write ultra-condensed, preserve technical details.
- Keep `.agent/` small, factual, discoverable.
- Every managed doc follows placement and frontmatter contract.
- Facts state evidence. Never write hypothesis as fact.
- One doc, one topic. Split independent high-value topics at a natural boundary. Update an existing doc when new durable information fits its topic.
- Link source or relevant existing doc. Do not copy large background.
- Valuable misplaced doc: move. Duplicate or valueless doc: delete or archive.
- Stale external claim: verify source before update.
- Do not run Markdown lint or formatting on `.agent/**.md`; run only `scripts/check-frontmatter`.
- Update: source drift, architecture/design change, or new durable information that fits an existing topic.
- Prune stale, duplicate, noisy, or wrong docs: correct, archive, or delete; move reusable content to `notes/` first.
- This skill owns plan placement, frontmatter, and lifecycle. The durable-plan workflow owns content and shape.
- No Revisions log, leads to cumulative meta residue.

## Placement

| Destination | Content | Lifecycle |
|---|---|---|
| `.agent/notes/` | Durable design, architecture, reference, decisions, settled research; include title, purpose, durable facts/decisions, non-obvious conventions, source links | Inactive: archive if reference survives; else delete |
| `.agent/progress/` | Handoff at task pause/stop/session boundary | Task ends: delete; reusable conclusion moves to `notes/` |
| `.agent/bugs/` | Debug evidence, failed attempts, root cause; per attempt include symptom, hypothesis, tried, result, next. | Resolved: extract reusable lessons to `notes/`, delete bug note. |
| `.agent/plans/` | Decision-grade implementation plan | Decision ends: reusable decision moves to `notes/`; else delete |

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
- `draft`: incomplete note or plan. `active`: current handoff, investigation, or plan. `stale`: source or relevance needs review. `resolved`: fixed bug. `archived`: inactive retained reference. `done`: completed task doc pending deletion or extraction.
- External-source content needs `source: <canonical URL>`. `references:` is optional; never replaces `source:`.
- Run `scripts/check-frontmatter <managed-doc.md>` before finish. It checks required fields, `status`, `updated`, optional `source`; manually check remaining rules.

## Boundaries

- Never write absolute home paths or usernames in `.agent/**` docs. Use `~/`.
