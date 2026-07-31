---
description: Execute a durable plan document from .agent/plan/
---
Plan path: `$ARGUMENTS`. If omitted, list `.agent/plan/` and ask.

Load multi-step execution workflow skill. Read plan fully. Extract: goal, hard constraints,
non-goals, locked decisions, next milestone, current progress (revision log or last status
note). Ask upfront only for outcome-changing or constraint-violating gaps. Never re-scope
settled decisions; never revisit locked ones.

Adapt table: reversible fork — decide, state why, continue. One-way door — present options,
recommend, ask. Missing material info — ask, no guess. Scope creep — pause, re-scope.
Same blocker twice — stop, summarize, re-plan with new evidence. Unrelated finding —
follow-up note only, no silent extra work. Current milestone only into todos; mark done live.

Honor plan's `Delegate:` cues. Bounded subagents for locate/edit/review; compressed output
saves context.

Close: changes, validation, open risks, deferred items. One optional next step. Scope
shifted — append dated entry to plan revision log.
