---
name: planning
description: "Plan multi-step execution at runtime. Use for medium/complex work with dependencies, material uncertainty, risky forks, likely scope drift, or prior failed attempts. Builds shared scope, high-level milestones, native todo state, and revisable execution direction. Skip trivial answers, exact bounded changes, requested plan documents, and research with no intended decision or deliverable."
license: MIT
---

## Core

### Scope

User wording != real goal. Extract:

- goal and expected outcome
- hard constraints, preferences, non-goals
- assumptions, unknowns, success evidence

Ask only outcome/cost/risk/approach-changing questions. Literal request misses better path: say so. Multiple material paths: give 2-3, one-line tradeoffs, recommendation, ask.

Lock one sentence before work:

```text
Goal: <outcome>. Constraints: <hard limits>. Out: <non-goals>.
```

### Shape

Plan 3-14 outcome milestones. Order: dependency, risk, value, question cost. Retire cheap unknowns early. No micro-steps before current milestone.

Every plan: observable success evidence, stated assumptions. Group mechanical work. "Wire module" beats "add import, save, lint".

### Guardrails

- Unrelated finding: follow-up, never silent work. Anti-drift load-bearing.
- Low-risk reversible fork: decide, state why, continue.
- High-risk, one-way, user-visible fork: recommend, ask.
- Missing/ambiguous material requirement: propose interpretation, ask. Never guess.
- Two failed blocker attempts: stop, summarize, re-plan. Third needs new evidence.
- Discovery invalidates plan: show changed milestones/why; confirm material revision.

## Session path

`SCOPE → PLAN → EXECUTE → REVISE → CLOSE`

OpenCode `todowrite` owns state. Other clients: use equivalent live task list. Coarse-to-fine: roadmap first; decompose current milestone only when it starts.

### Plan

Show goal, non-goals, assumptions, 3-10 milestones, verification, open questions. Todos hold through-line without fake precision; group mechanical work. Material scope/path open: ask. Else start milestone.

### Execute

Decompose only current complex milestone into todos. Mark done live; never batch-close. Trivial cluster: one todo. Complex child: recurse (mini-scope, mini-plan). Exactly one active item. Apply adapt table per obstacle:

| Situation                                   | Action                                                  |
| ------------------------------------------- | ------------------------------------------------------- |
| Missing info                                | Ask. No guess.                                          |
| Ambiguous requirement                       | Propose interpretation, ask to confirm.                 |
| Fork, low risk, reversible                  | Decide, state reasoning, continue.                      |
| Fork, high risk or one-way door             | Present options, recommend, ask.                        |
| Scope creep detected                        | Pause. Re-scope with user.                              |
| Discovery invalidates plan                  | Update remaining milestones. Material change → confirm. |
| 2 failed tries, same blocker                | Stop. Summarize. Re-plan. Third try needs new evidence. |
| Tempted to fix unrelated thing "since here" | STOP. Note as follow-up. Do not touch.                  |

Anti-drift load-bearing: work only current-plan items. Unrelated finding: follow-up note, never silent extra work. Context contamination main enemy. Never make silent irreversible decision.

### Revise

Re-enter Plan: discovery invalidates milestone, user changes requirement, scope changes order, blocker hits twice. Show diff: dropped/added/reordered milestones + why. Confirm material change.

### Close

After implementation: report changes, validation, risk, deferred follow-ups. Suggest optional next step. Planning-only turn ends at open questions; no ceremonial recap, validation, state update without relevant change.

## Boundaries

- OpenCode `todowrite` or client equivalent owns session state.
- Workflow only. Code style, tests, commits belong elsewhere.
- If planning cost exceeds task risk, execute direct.

## Durable plan document

Big plan, worth surviving session end (cross-session, high-risk, architecture, migration): hand off to `agents/planning.md`, not this skill's session flow. That agent uses `templates/plan-document.md` (path relative to this skill dir) to write `.agent/plan/*.md`. This skill never writes plan documents itself.
