---
name: agent-delegate
description: "Agent delegation rules. Decides whether bounded work belongs in main or a worker, then supervises it: task brief, report evaluation, bounded retry, escalation. Load when generic delegation is considered, arranged, or fails, or when a worker report must be judged. Not for named-worker selection, planning, or focused code, research, or review routing."
---

# Agent Delegation

Four questions, in order: delegate or not → what goes in the brief → is this report acceptable → retry, tier up, or take over.

## 1. Decision gate

- Mentioning delegation does not justify it.
- Delegate only bounded, isolatable, independently checkable work when compact return saves more main-context cost than setup and transferred context.
- Brief costs more tokens than the expected result: do it in main.
- Keep in main: needs existing context, authority, synthesis, user decisions, ambiguity resolution, risky action, or authorial voice.
- Describe needed capability and output shape, not worker name.
- Parallelize independent contracts only. To-do list with independent tasks, or one task that splits cleanly: consider a wave.
- Main integrates conclusion, evidence, blockers; discard exploration detail.

## 2. Brief

Template: `templates/task-brief.md`. Mandatory core is six fields; optional blocks are omitted when empty.

- State goal and bounds; worker owns method. Under-specified brief causes runoff; over-specified brief means main already did the work.
- Send needed context only. Worker has none of main's history.
- Name the return shape explicitly, including the report envelope below.
- Give one done-condition and one escalation trigger. Absent them, a worker grinds.
- Files of interest: give `path:line` plus why it matters. Paths without reasons get scanned blindly.

## 3. Report envelope

Every worker report ends with two mandatory fields, whatever else its own contract specifies:

- `status:` — exactly one of `done` `partial` `blocked` `refused` `none`
- `gap:` — in-scope work not finished, or `none`

Token strings are fixed. Field formatting follows the worker's own style.

| Status    | Meaning                                             |
| --------- | --------------------------------------------------- |
| `done`    | full scope covered                                  |
| `partial` | some in-scope work unfinished; `gap` says what      |
| `blocked` | cannot proceed; needs input, confirmation, or scope |
| `refused` | outside this worker's scope or capability           |
| `none`    | ran fully, found nothing                            |

Status is orthogonal to payload. A test worker whose tests failed is `done` with a failing result, not `partial`.

## 4. Evaluate

- Judge evidence, never claims. Acceptable evidence: `path:line`, exact command output, exit code, verbatim quote, URL.
- Report asserts an outcome with no evidence: treat as `partial` regardless of declared status.
- `gap: none` on work that visibly had gaps: treat as unreliable, re-drive with narrowed scope.
- `none` is a result. Do not retry it. Reconsider the question instead.
- `refused` is a routing signal, not a failure. Re-route, do not retry.
- Accept and move on the moment evidence answers the brief. Extra polish is main's cost.

## 5. Escalate

`blocked` first: if the missing piece is scope, context, or a guidepost main can supply, retry with it added — that's step 1 below. If the missing piece is user input, confirmation, or authority, stop and ask; retrying or tiering up a model never obtains what only the user can give.

For `partial` and ordinary failure, ordered ladder. Never skip more than one rung without stating why.

1. **Retry with materially changed input** — max two. Change means narrower scope, added context, added guidepost, or split into steps. Identical re-spawn is forbidden; it reproduces the failure at full price.
2. **Tier up one model level** — same brief, stronger worker. Use when output shape was right but judgment was thin.
3. **Take over in main** — use when the blocker is context, authority, or ambiguity. These never resolve by retrying.

Same blocker twice: stop, summarize, re-plan with new evidence. Never bypass a safety or authority refusal.

## Domain coordinator

A worker that itself spawns workers pays for its own model plus downward context transfer, and cannot ask the user. Worth it only when all hold:

- three or more independent branches
- branches need consolidation into one compact answer
- the domain is narrow enough that the coordinator needs no main-thread history

Then: coordinator sits at mid tier, not main's tier; children never recurse; branch count is capped; a wave completes before synthesis. Existing research-coordination workers implement this pattern — copy it rather than inventing a generic one. A general-purpose coordinator at main's tier is a loss: it pays the expensive model twice while main still holds the context.
