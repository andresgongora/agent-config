---
name: delegation
description: "Agent delegation rules. Decides whether bounded work belongs in main or a worker, then supervises it: task brief, report evaluation, bounded retry, escalation. Load when generic delegation is considered, arranged, or fails, or when a worker report must be judged. Not for named-worker selection, planning, or focused code, research, or review routing."
---

## 1. Decision gate

| Task shape | Delegate? |
| --- | --- |
| Needs existing context main already holds | No |
| User decision or confirmation required | No |
| Ambiguity resolution or risky action  | No |
| Brief + report tokens match/exceed main's inline-work tokens | No |
| Bounded scope, checkable result, compact return | Yes |

Candidate for `delegation-nesting` skill: one complex self-contained mission; no open authority or user questions; broad judgment needed; implementation detail would pollute main context.

## 2. Brief

Read `templates/worker-prompt.md`. Fill every field, delete optional `Context` if left empty. Worker lacks caller-loaded rules; template supplies worker contract and report semantics.

Send only context worker cannot derive. For known file sites, give `path:line` plus relevance. Worker owns method. Preserve stricter worker-specific return contracts; append `status:` and `gap:` as final lines.

## 3. Chaining

- Chain only when each worker has a distinct completion condition. Do not pre-plan two workers for same completion condition; one worker's job.
- Retries and escalation are not chains. Section 6 governs them.
- Use a chain only when combined brief and report cost is lower than main doing delegated work inline.

Patterns:

- **Locate, act, verify:** worker A finds sites; main selects targets; worker B performs requested work; optional reviewer worker C verifies result.
- **Parallel scout:** not a chain. Every worker can start independently. Workers examine different questions or evidence angles; no shared mutable state or worker-to-worker dependency. Main aggregates.
- **Single-shot:** not a chain. One worker owns full task. Give `path:line` when site is known; otherwise worker locates it.
- **Nested delegation:** main coordinates full task using `delegation-nesting` skill, hands over bounded subtask to worker (aka delegation executor), which may spawn sub-workers.

## 4. Report envelope

Every worker report ends with two mandatory fields:

- `status:`: one of `done` `partial` `blocked` `refused` `none`.
- `gap:`: unfinished in-scope work, or `none`.

| Status    | Meaning  |
| --- | --- |
| `done`    | full scope covered |
| `partial` | some in-scope work unfinished; name it in `gap` |
| `blocked` | needs missing input, authority, or clarification |
| `refused` | scope, capability, or safety boundary prohibits work |
| `none`    | full search or check ran; found nothing |

Status records completion, not result quality. Failed test run: `done` with failure evidence, not `partial`.

## 5. Evaluate

- Judge evidence, never claims. Evidence: `path:line`, command plus exit code, exact quote, or URL.
- Claimed outcome lacks evidence: treat report as `partial`, regardless of declared status.
- `gap: none` with visible gaps: treat report as unreliable. Narrow brief, or take over.
- `none` settles searched scope. Do not rerun it; accept result or ask a different question.
- `refused` is routing signal. Re-route; do not retry same worker.
- Accept when evidence answers the brief. Extra polish is main's cost.
- Main gives user conclusion plus evidence. Never forward full worker output.

## 6. Escalate

`blocked`: main can supply missing facts or clarify existing scope: retry with it. User input or authority required: stop and ask.

For `partial`, or failed work without a `blocked` status, use ladder one rung at a time. Advance only when current rung cannot change outcome:

1. **Retry with changed input**: at most twice while each brief targets a plausible new cause. Narrow scope, add context, give known location or failure evidence, or split work. Never re-spawn identical brief.
2. **Tier up one model level**: same task, stronger worker. Use when no plausible changed brief remains, and return shape and evidence are sound but judgment is insufficient.
3. **Take over in main**: blocker is context, authority, or ambiguity.

Same blocker twice: stop, summarize, re-plan. Never override safety or authority refusal.
