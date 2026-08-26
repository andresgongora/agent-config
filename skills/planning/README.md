# Planning

Interactive runtime discipline: turn uncertain multi-step request into controlled, revisable execution.

<!------------------------------------------------------------------------------------------------->

## Design intent

<!------------------------------------------------------------------------------------------------->

Planning protects outcome, not literal wording or first route. Users often name activity, partial solution, or vague desire. Skill exposes underlying need before work commits to wrong target.

Small verified checkpoints preserve route during disorienting, deep work. They permit safe pause, resumption, and independent delegation without pretending later unknown work is settled. Evidence outranks draft history; replanning preserves achieved evidence while replacing invalid future route.

<!------------------------------------------------------------------------------------------------->

## Runtime shape

<!------------------------------------------------------------------------------------------------->

Workflow has five steps: goal-check, understand, draft, verify, iterate-or-finish. Goal-check confirms the desired outcome is clear, actionable, and realistic before any drafting effort — brainstorming, pushback, and pros/cons belong here. Understand resolves user-controlled decisions and turns expensive factual uncertainty into evidence milestones. Draft creates coarse outcome milestones and observable checkpoints. Verify checks the draft against the checklist in `SKILL.md`. Iterate-or-finish loops back to whichever step new evidence invalidates, repeating until the plan is solid, then returns it.

Skill authors the plan only. It does not supervise or execute the resulting plan; that is out of workflow scope by design.

Runtime's native task list is preferred live representation for tracking workflow progress itself, separate from the deliverable plan. If unavailable, track steps in-context. Both are transient control state, not durable plan documents.

<!------------------------------------------------------------------------------------------------->

## Interactive boundary

<!------------------------------------------------------------------------------------------------->

Skill requires the ability to inspect, challenge, and ask the user about material decisions mid-task. Before interactive choice, explain options, pros, cons, and recommendation in normal text; question records choice. Do not load where no mid-task user reply is possible — e.g. a bounded worker executing a fixed brief with no dialogue turn. Such workers execute bounded briefs; they do not reinterpret user intent or own plan-level authority.

<!------------------------------------------------------------------------------------------------->

## Durable-plan template

<!------------------------------------------------------------------------------------------------->

`templates/plan-document.md` belongs to durable-plan authoring. `../../agents/planning.md` reads it directly when creating or amending reviewed, cross-session plan documents under `.agent/plan/`. Session workflow neither reads nor writes that template.

<!------------------------------------------------------------------------------------------------->

## Maintainer constraints

<!------------------------------------------------------------------------------------------------->

- Goal extraction precedes drafting; inferred goal stays proposal until material rewrite is confirmed.
- User-controlled decisions never become silent assumptions. Large discovery remains explicit evidence milestone with conditional route.
- Preserve coarse-to-fine decomposition, visible parent route, live state, evidence-driven iteration, and anti-drift rule.
- Keep runtime state client-neutral; interactive requirement is capability-based (can the session ask and get a reply), not identity-based (no reliable "am I a subagent" signal at runtime).
- Keep runtime instructions in `SKILL.md`; rationale and template ownership stay here.

<!------------------------------------------------------------------------------------------------->

## See also

<!------------------------------------------------------------------------------------------------->

- `../../agents/planning.md`: durable-plan authoring agent.
- `../../commands/plan-execute.md`: durable-plan execution command.