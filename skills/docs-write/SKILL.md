---
name: docs-write
description: "Write side of repository knowledge: admit, shape, place, update, and prune durable `.agent/` docs. Load when a session has produced knowledge worth persisting because re-obtaining it later would be expensive — settled research conclusion, hard-won architecture or design fact, resolved root cause, accepted design decision, cross-session handoff, or bootstrapping a missing repo doc with a clear future consumer. Also load when starting or updating a costly-to-lose bug-attempt log (`.agent/bugs/`) or a task handoff note (`.agent/progress/`), or when a workflow needs the managed-doc frontmatter schema or `.agent/` placement rules. A bare documentation gap does not trigger this; establish the value first. Not for reading or discovery."
---

# Skill: docs-write

Persist session knowledge as durable `.agent/` docs. Two tiers: Tier 1 rules apply to every write; Tier 2 value bar gates creating a new note.

## Admission Gate

Tier 1 (Placement, Frontmatter, Doc Shape, Maintenance): every write, including updates and prunes.

Tier 2 (value bar): only when creating a new durable `.agent/` note. All three required:

- Confidence high. Evidence type matches claim type. Factual conclusion: proof exists, doubt cleared — never persist hypothesis as fact. Decision/design record: explicitly accepted, with rationale, scope, and owner/source — not "provable", but settled.
- Recovery cost real. A future session would repeat costly exploration, online research, or debugging (factual) OR re-litigate a settled choice and lose its rationale (decision).
- Value outlives session.

Never create a note for: in-flight progress narration, chat transcript, raw log, speculative "maybe useful" note, duplicate of README/comment/existing doc, one-shot trivia.

Exception — skip Tier 2, still follow Tier 1:

- Handoff (`.agent/progress/`): task pauses, stops, or crosses session boundary. Not continuous narration.
- Bug log (`.agent/bugs/`): only when attempt state is costly to lose — multiple failed approaches, likely session boundary, or explicit handoff need. Not every non-trivial bug; a bug solved within the session needs no file.

Bar not met, no exception: keep in prompt/todo. Create no file.

## Placement

| Destination | Content | Lifecycle |
|---|---|---|
| `.agent/notes/` | Durable design, architecture, reference, decisions, settled research | Inactive: archive if reference survives; else delete |
| `.agent/progress/` | Handoff at task pause/stop/session boundary | Task ends: delete; reusable conclusion moves to `notes/` |
| `.agent/bugs/` | Debug evidence, failed attempts, root cause | Resolved: extract reusable root cause to `notes/`, delete execution-only attempt log; else delete whole |
| `.agent/plan/` | Decision-grade implementation plan (authored by the durable-planning capability, not here) | Decision ends: reusable decision moves to `notes/`; else delete |

`notes/` is catch-all for durable knowledge. Add no new top-level folder per content kind. `.agent/frontier.md` is repo-state discipline, not here. Plan authoring (shape, template) belongs to the durable-planning capability; for `.agent/plan/` this skill owns only placement, frontmatter, and lifecycle. Create a folder only with its first real doc. Adapt to project; force-fit nothing.

## Frontmatter (Managed-Doc Contract)

Every managed `.agent/**/*.md` starts with:

```yaml
---
title: <clear title>
description: <1-2 sentence why-this-exists; the routing line>
status: draft|active|stale|resolved|archived|done
updated: YYYY-MM-DD
# External-source metadata — `source:` REQUIRED if any content came from outside:
source: https://example.com
references: https://example.com/spec   # optional supplementary
---
```

- `description:`: written so a future agent decides read-or-skip without opening body. Same routing job as a skill's `description`; one physical line, dense, concrete. Value contains `: ` or starts with a YAML indicator: double-quote it. Never fold across lines.
- `updated:`: real date of last substantive change.
- Any external-source content (web, manual, API, spec) MUST carry `source:`. `references:` never substitutes for it. No source = unverifiable claim.
- Managed docs use canonical keys. Discovery tolerates aliases (`name`, `summary`, `lastmod`, `date`) on foreign files only.
- Before finishing a managed-doc edit: `<skill-root>/scripts/check-frontmatter <file.md>`. Silent success; failures name only invalid fields.

## Doc Shape

Durable note (`.agent/notes/`): title, purpose, durable facts/decisions, non-obvious conventions, source links if external. Route to source or other docs, do not inline large background. Terse, exact, high-signal.

Handoff (`.agent/progress/`, one file per task): goal, done, remaining next step, blockers, touch points.

Bug log (`.agent/bugs/`): per attempt — symptom, hypothesis, tried, result, next. Record failures. Resolved: root cause + fix.

Plan (`.agent/plan/`): shape not defined here — the durable-planning capability owns the template. This skill only ensures managed-doc frontmatter and lifecycle.

## Bootstrap

New repo doc only when: at repo root, no existing doc covers it, task non-trivial, clear future consumer. Else write nothing.

## Maintenance

Update on: source drift, architecture/design change, repeated exploration exposing durable missing info. Not on tiny churn or one-off trivia.

Delete or archive: duplicate, stale-not-worth-keeping, scan-noise, misplaced, concluded low-value. Split multi-domain doc at natural seams; keep single-topic whole. Few sharp docs over many weak. Stale doc: verify from source, then update.
