# Planning

Interactive workflow for planning medium-or-harder work with live checkpoints and evidence-driven
replanning.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

Planning protects the intended outcome rather than initial wording or first proposed route. It makes
user-controlled choices explicit, turns expensive uncertainty into evidence milestones, and
preserves validated work when later evidence changes the route.

Milestones stay coarse until execution approaches them. Observable checkpoints support safe pause,
resumption, and bounded delegation without pretending that unresolved work is settled.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

Load for medium-or-harder work in an interactive session where the agent can ask and receive user
replies mid-task. Typical signals: `todowrite`, dependencies, material uncertainty, risky forks,
delegation seams, scope-drift risk, a prior failed attempt, or open-ended research or documentation
planning.

<!------------------------------------------------------------------------------------------------->
## When it does NOT trigger
<!------------------------------------------------------------------------------------------------->

Do not load for a single quick step or where the `question` tool is unavailable. Bounded workers
with fixed briefs execute the supplied plan; they do not reinterpret user intent or take plan-level
authority.

<!------------------------------------------------------------------------------------------------->
## Runtime shape
<!------------------------------------------------------------------------------------------------->

The workflow validates the goal, inspects current state and uncertainty, locks stable intent, drafts
ordered milestones, verifies them, then revises only the invalidated route when evidence changes. It
maintains progress in the runtime task list and records blockers immediately.

Delegated execution receives a completed sub-plan in its prompt. The planning agent retains planning
authority; the delegated worker reports an unpredicted blocker instead of inventing a route.

<!------------------------------------------------------------------------------------------------->
## Durable-plan template
<!------------------------------------------------------------------------------------------------->

`templates/plan-document.md` supports reviewed, cross-session plan documents under `.agent/plan/`.
Session planning keeps transient state in the runtime task list and neither reads nor writes that
template.

<!------------------------------------------------------------------------------------------------->
## Maintainer constraints
<!------------------------------------------------------------------------------------------------->

- Keep runtime instructions, workflow steps, guardrails, and verification in `SKILL.md`.
- Keep this README human-facing: rationale, routing summary, template ownership, and durable
  maintenance constraints only.
- Preserve capability-based interactive routing; no reliable runtime identity test distinguishes a
  subagent.
- Keep goal extraction before drafting, explicit user-controlled decisions, coarse-to-fine
  milestones, visible live state, and evidence-driven replanning.

<!------------------------------------------------------------------------------------------------->

## See also

<!------------------------------------------------------------------------------------------------->

- `templates/plan-document.md`: durable-plan document structure.
- `../../agents/planning.md`: durable-plan authoring.
- `../../commands/plan-execute.md`: durable-plan execution.
