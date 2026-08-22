---
name: delegation
description: "Agent delegation rules. Decides whether bounded work belongs in main or a worker, then supervises it: task brief, report evaluation, bounded retry, escalation. Load when generic delegation is considered, arranged, or fails, or when a worker report must be judged. Not for named-worker selection, planning, or focused code, research, or review routing."
---

## 1. Decision gate

| Task shape                                      | Delegate? |
| ----------------------------------------------- | --------- |
| Needs existing context main already holds       | No        |
| User decision or confirmation required          | No        |
| Ambiguity resolution or risky action            | No        |
| Brief + report tokens > inline tokens           | No        |
| Bounded scope, checkable result, compact return | Yes       |

Describe capability + output shape, not worker name.

Nested execution candidate: one complex self-contained mission, no open authority or user questions, broad judgment needed, implementation detail would pollute main context. Route through nested delegation execution before choosing executor or writing mission package.

## 2. Brief

After gate returns yes, read `templates/worker-prompt.md`; fill required fields, delete empty optional fields. Template carries worker contract and report semantics unavailable from caller's loaded skill state.

Send only context worker cannot derive. Files of interest need `path:line` plus reason. Worker owns method. Preserve stricter worker-specific output contracts; mandatory `status:` and `gap:` remain final lines.

## 3. Chaining

Chain when each hop has a different done-condition. Same condition twice → one worker's job.

**Locate → act → verify:** worker finds sites → main picks targets → worker acts → optional audit.

**Parallel scout:** 2–3 workers, different angles, no shared state. Aggregate in main.

**Single-shot:** site known → skip locate, hand `path:line` directly.

Chain only for net context savings.

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
