# planning

Plan before execute. Session planning skill; durable plans belong to planning agent.

## What it does

Structured session planning for multi-step work. Prevents two failure modes:

1. **Wrong goal** — agent builds something user did not want.
2. **Context contamination** — agent drifts into unrelated work mid-flight.

Session workflow: scope, coarse roadmap, lazy `todowrite` decomposition, live adaptation, anti-drift. Never executes plan documents.

## Design intent

- **Plan → Execute → Revise loop.** Separated on purpose. Mid-execution exploration is what pollutes context.
- **Coarse-to-fine.** Roadmap first; task detail begins only when current milestone starts. No fake precision upfront.
- **Revision is first-class.** Plan rarely survives contact with reality. Revise openly, not silently.
- **Scope first.** User words ≠ user goal. Lock it before any planning action.
- **Anti-drift is load-bearing.** The "stop, do not fix unrelated things" rule is why this skill exists. Do not soften it.
- **Delegation by role, not name.** Workers are optional bounded evidence sources; main owns live synthesis.

## Primary planning agent

`agents/planning.md` creates or amends decision-grade `.agent/plan/<slug>.md` documents. It writes plans only; implementation session consumes them. Agent reads `assets/planning/plan-template.md` directly; no runtime-skill dependency.

## Plan template

`assets/planning/plan-template.md` — planning agent uses conditionally. Remove sections with no decision value. Never write `none` filler.

## Structure

- `SKILL.md` — LLM-facing session workflow.
- `README.md` — this file. Human maintainer notes.
- `assets/planning/plan-template.md` — reusable plan document template.

## Revising this skill

- Do not couple to any specific subagent set. Workers are behavior-referenced.
- Do not couple to caveman. Style is separate.
- Anti-drift rule is load-bearing. Do not soften it.
- Session workflow must not create or amend plan docs, frontier churn, or implementation summaries by default.
- Keep session workflow lean: scope questions, coarse todo list, alternatives, live adapt table.
- Document agent boundary (write only `.agent/plan/*.md`) must be testable.

## See also

- `SKILL.md` — full LLM-facing instructions.
- `assets/planning/plan-template.md` — plan document shape.
- `../../agents/planning.md` — primary durable-plan agent.
