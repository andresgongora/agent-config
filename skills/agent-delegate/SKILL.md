---
name: agent-delegate
description: "Agent delegation rules. Decides whether bounded work belongs in main or a worker, then supervises it: task brief, report evaluation, bounded retry, escalation. Load when generic delegation is considered, arranged, or fails, or when a worker report must be judged. Not for named-worker selection, planning, or focused code, research, or review routing."
license: MIT
---

# Agent Delegation

Four questions, in order: delegate or not → brief → evaluate report → retry, tier up, or take over.

## 1. Decision gate

Evaluate the work, not the question.

| Task shape                                      | Delegate? |
| ----------------------------------------------- | --------- |
| Needs existing context main already holds       | No        |
| User decision or confirmation required          | No        |
| Ambiguity resolution or risky action            | No        |
| Brief + report tokens > inline tokens           | No        |
| Bounded scope, checkable result, compact return | Yes       |

Describe needed capability and output shape, not worker name.

## 2. Brief

Template: `templates/task-brief.md`. Six required fields; optional blocks deleted when empty.

- State goal and bounds; worker owns method.
- Send needed context only. Worker has none of main's history.
- Name the return shape explicitly, including report envelope (§4).
- One done-condition, one escalation trigger.
- Files of interest: `path:line` plus why it matters. Paths without reasons get scanned blindly.

## 3. Chaining

Chain when each hop has a different done-condition. Same condition twice → one worker's job.

**Locate → act → verify:** worker finds sites → main picks targets → worker acts → optional audit.

**Parallel scout:** 2–3 workers, different angles, no shared state. Aggregate in main.

**Single-shot:** site known → skip locate, hand `path:line` directly.

Each hop pays context transfer. Ensure net savings.

## 4. Report envelope

Every worker report ends with two mandatory fields:

- `status:` — one of `done` `partial` `blocked` `refused` `none`
- `gap:` — in-scope work not finished, or `none`

| Status    | Meaning                                        |
| --------- | ---------------------------------------------- |
| `done`    | full scope covered                             |
| `partial` | some in-scope work unfinished; `gap` says what |
| `blocked` | needs input, confirmation, or scope            |
| `refused` | outside worker's scope or capability           |
| `none`    | ran fully, found nothing                       |

Status orthogonal to payload. Tests failed = `done` with failing result, not `partial`.

## 5. Evaluate

- Judge evidence, never claims. Evidence: `path:line`, command output, exit code, verbatim quote, URL.
- Outcome asserted without evidence → `partial` regardless of declared status.
- `gap: none` on work with visible gaps → unreliable, re-drive narrowed.
- `none` is a result. Don't retry. Reconsider the question.
- `refused` is routing signal. Re-route, don't retry.
- Accept when evidence answers the brief. Extra polish is main's cost.
- Main integrates conclusion + evidence. Never forward worker's full output to user.

## 6. Escalate

`blocked`: missing piece is scope/context main can supply → retry with it. Missing piece is user input/authority → stop and ask.

`partial` / failure ladder (never skip more than one rung):

1. **Retry with changed input** — max two. Narrow scope, add context, add guidepost, or split. Identical re-spawn forbidden.
2. **Tier up one model level** — same brief, stronger worker. Output shape right, judgment thin.
3. **Take over in main** — blocker is context, authority, or ambiguity.

Same blocker twice → stop, summarize, re-plan. Never bypass a safety or authority refusal.

## 7. Coordinator

Worker that spawns workers; cannot ask user. Worth it only when all hold:

- Three or more independent branches
- Branches need consolidation
- Domain narrow enough coordinator needs no main-thread history

Then: coordinator at mid tier; children never recurse; branch count capped; wave completes before synthesis. Copy existing coordinator pattern rather than inventing one.
