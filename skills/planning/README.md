# planning

Plan before execute. Two modes, one skill.

## What it does

Structured planning for multi-step work. Prevents two failure modes:

1. **Wrong goal** — agent builds something user did not want.
2. **Context contamination** — agent drifts into unrelated work mid-flight.

Two modes share the same planning rules but differ in output destination and write boundary.

## Modes

**Session mode** — ordinary in-thread planning. Native todos. Coarse roadmap, lazy decomposition, live adapt table for obstacles, hard anti-drift. This is the todo-list execution loop: scope questions → comprehensive-but-coarse todo list → confirm → execute → revise. Also drives info-gathering while drafting a plan doc. No plan doc created unless task crosses a durable-plan threshold (cross-session, high-risk, architecture, external research). Can also *execute* an existing plan doc: read it, decompose the current milestone to fine todos, confirm, run, feed revisions back — coarse-to-fine at higher resolution.

**Document mode** — deliberate pre-implementation workspace. Creates or amends a `.agent/plan/<slug>.md` durable plan document. Asks clarifying questions before writing. Stays draft until user approves. Execution belongs to a separate agent or session.

## Design intent

- **Plan → Execute → Revise loop.** Separated on purpose. Mid-execution exploration is what pollutes context.
- **Coarse-to-fine, two resolutions.** Document mode writes the coarse plan (3-7 milestones). Session mode writes the fine todos, either fresh or by decomposing a document-mode milestone. Same philosophy, finer grain. Sub-tasks born when a milestone starts. No fake precision upfront.
- **Revision is first-class.** Plan rarely survives contact with reality. Revise openly, not silently.
- **Scope first.** User words ≠ user goal. Lock it before any planning action.
- **Anti-drift is load-bearing.** The "stop, do not fix unrelated things" rule is why this skill exists. Do not soften it.
- **Delegation by role, not name.** Workers (locator, web researcher, reviewer) are referenced by behavior. Replace freely.
- **Runtime-aware, not static.** Planning inspects only capabilities that alter approach. Plan docs may name discovered skills/tools/MCPs/workers beside concrete milestones; shared assumptions and fallbacks stay in one small note. Runtime continuity is likely, never guaranteed.
- **Delegation cues, not quotas.** Every non-trivial milestone gets a delegation decision. Record a bounded worker only when it saves context, enables parallel work, or adds focused review. The plan says what/when/expected-return; never a worker count.

## Primary planning agent

`agents/planning.md` is a selectable primary agent for document mode. It:
- writes only `.agent/plan/*.md` — denied path proves boundary
- asks questions before writing false precision
- may use bounded locator, web-researcher, and reviewer workers
- cannot edit code, configs, or other docs
- cannot implement

The skill works without the primary agent. The agent loads the skill; the skill does not depend on the agent.

## Plan template

`skills/planning/plan-template.md` — use conditionally. Remove sections with no decision value. Never write `none` filler.

## Structure

- `SKILL.md` — LLM-facing instructions. Caveman style.
- `README.md` — this file. Human maintainer notes.
- `plan-template.md` — reusable plan document template.

## Revising this skill

- Do not couple to any specific subagent set. Workers are behavior-referenced.
- Do not couple to caveman. Style is separate.
- Keep mode selection as the first step in `SKILL.md`. Mode determines everything downstream.
- Anti-drift rule is load-bearing. Do not soften it.
- Session mode must not create plan docs, frontier churn, or implementation summaries by default.
- Session mode stays fat: scope questions, comprehensive coarse todo list, confirm-before-execute, offer-alternatives, live adapt table are load-bearing. Document mode having more lines than session mode is a smell.
- Document agent boundary (write only `.agent/plan/*.md`) must be testable.
- Capability reconnaissance stays targeted; delegation cues stay concrete (worker, task, return, trigger, fallback). No exhaustive skill/MCP inventories, no generic worker catalogs — they burn context and rot.

## See also

- `SKILL.md` — full LLM-facing instructions.
- `plan-template.md` — plan document shape.
- `../../agents/plan-doc.md` — primary document-mode agent.
