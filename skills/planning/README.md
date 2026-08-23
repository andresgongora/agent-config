# Planning

Interactive runtime discipline: turn uncertain multi-step request into controlled, revisable execution.

## Design intent

Planning protects outcome, not literal wording or first route. Users often name activity, partial solution, or vague desire. Skill exposes underlying need before work commits to wrong target.

Small verified checkpoints preserve route during disorienting, deep work. They permit safe pause, resumption, and independent delegation without pretending later unknown work is settled. Evidence outranks draft history; replanning preserves achieved evidence while replacing invalid future route.

## Runtime shape

Session plan has five states: understand, draft, execute, replan, close. Understand resolves user-controlled decisions and turns expensive factual uncertainty into evidence milestones. Draft creates coarse outcome milestones and observable checkpoints. Execution expands only current complex milestone. Replanning changes remaining route when evidence demands it. Closure proves outcome against success and constraints, not checklist exhaustion.

Runtime's native task list is preferred live representation. If unavailable, equivalent visible plan board suffices. Both are transient control state, not durable plan documents.

## Interactive boundary

Skill requires session able to inspect, challenge, and ask user about material decisions. Before interactive choice, explain options, pros, cons, and recommendation in normal text; question records choice. Never use it in delegated workers or subagents unable to ask user questions. Those workers execute bounded briefs; they do not reinterpret user intent or own plan-level authority.

## Durable-plan template

`templates/plan-document.md` belongs to durable-plan authoring. `../../agents/planning.md` reads it directly when creating or amending reviewed, cross-session plan documents under `.agent/plan/`. Session workflow neither reads nor writes that template.

## Maintainer constraints

- Goal extraction precedes drafting; inferred goal stays proposal until material rewrite is confirmed.
- User-controlled decisions never become silent assumptions. Large discovery remains explicit evidence milestone with conditional route.
- Preserve coarse-to-fine decomposition, visible parent route, live state, evidence-driven replanning, and anti-drift rule.
- Keep runtime state client-neutral and delegation capability-based.
- Keep runtime instructions in `SKILL.md`; rationale and template ownership stay here.

## See also

- `../../agents/planning.md`: durable-plan authoring agent.
- `../../commands/plan-execute.md`: durable-plan execution command.
