---
name: agents-md
description: >
  Maintain `AGENTS.md` files. Choose right scope. Reject bloat. Rewrite user
  wording into compact durable intent. Detect dead skill refs. Trigger:
  add/change/trim rule, create/audit `AGENTS.md`.
---

# Skill: agents-md

Keep `AGENTS.md` lean, sharp, honest. Never grow it.

## When to load

- User asks to add / change / remove a rule
- User asks to trim / audit / clean `AGENTS.md`
- User asks to create new `AGENTS.md`
- User asks to change agent policy / behavior
- Working across many files, agent seems to drift → check if AGENTS.md needs a rule to prevent it

## Reject Checklist (Do This First)

Before `AGENTS.md` edit: reject if:

1. **One-off instruction** — current prompt, not durable rule.
2. **Task-scoped note** — `.agent/progress/` or equivalent handoff.
3. **Design decision** — `doc/`: architecture, ADR.
4. **Repo fact in global file** — project `AGENTS.md`.
5. **Already implied** — parent/general rule covers it.
6. **Duplicate rule** — merge, do not add.
7. **Rewords working rule** — leave unless clearer.
8. **Vague slogan** — "be careful", "think harder": useless. Reject.
9. **Soon-stale** — moving target, not durable.
10. **Dead skill/tool/path ref** — verify first.

≥2 apply: push back explicitly. Never silently add.

## Core Principles

1. Broad rule: highest valid scope. Local only narrows/overrides.
2. One strong rule beats overlap.
3. `AGENTS.md` routes/constrains; never warehouses procedures. Detail belongs in skill/doc: trigger + pointer.
4. Dense rules. Reader AI, not human.
5. Push back noisy/redundant/wrong-scope request.

## Scope Selection

Read chain first: nearest target, parent, Home. Scope by blast radius:

| Rule type | Scope |
|---|---|
| Personal cross-project habit | Home `AGENTS.md` (whatever the client loads by default) |
| Repo workflow / style / tooling | Project `AGENTS.md` |
| Subdir-only constraint | Nested local `AGENTS.md` |

Ambiguity changes blast radius: ask one short question. Never guess.

Absent warranted local target: create from `AGENTS.template.md`.

## Edit Workflow

1. Extract durable *intent*. Never paste wording unless wording matters.
2. Run Reject Checklist above.
3. Check parent/sibling/section conflicts.
4. Long procedure: move detail to skill/doc; keep short trigger/rule.
5. Rewrite dense. Existing neighbor covers idea: merge.
6. Verify every referenced skill/tool/path. Dead refs waste tokens forever.
7. Re-read full file. Trim duplicates, weak lines, bloated examples.
8. Report changed, rejected, relocated, why.

## Detect Dead Refs

Add/audit rules: check:

- `AGENTS.md` trigger skills exist in client-loaded Home and/or project skills dir.
- Tool/command exists in shell.
- Referenced path exists.

Dead reference: fix ref or remove rule. Never leave "just in case".

## Conflict Rules

- Parent never absorbs repo quirks.
- Child never restates parent unless narrowing/overriding.
- New rule never accidentally widens scope.
- Duplicate meaning: keep stronger, clearer rule.
- Harmful rule request: say plainly; suggest safer alternative.
- Session-state/project-handoff rule: check `doc/` conventions; never invent parallel mechanism.

## Creation Rules

New `AGENTS.md`:
- Start from `AGENTS.template.md`.
- Delete unneeded sections.
- Keep placeholders minimal.
- Do not invent project facts.
- Keep lean, expandable.

## Style

Dense `AGENTS.md`: short bullet, present tense, imperative action, fragments allowed.

Bad: "The agent should always ensure that a proper todo list is created."
Good: "Non-trivial work → todo list."

## Boundaries

- Skill absent: apply manually.
- Unclear-impact broad cross-project policy: ask first.
- `AGENTS.md` beyond reader head-space: split/trim.
