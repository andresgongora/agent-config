# Agent Delegation

Decision workflow plus supervision discipline for context-preserving delegation.

## Design intent

Delegation pays only when worker starts from little context and returns less than main would consume exploring. This skill owns four things in order: the decision gate, the task brief, report evaluation, and the escalation ladder. Focused workflows retain worker selection and domain execution.

Three ideas do the work. A brief states goal and bounds but not method — under-specify and the worker runs off, over-specify and main already did the job. A report is judged on evidence and two mandatory fields (`status:`, `gap:`), because claims are unjudgeable. Retries must change the input, since an identical re-spawn reproduces the failure at full price.

`none` is deliberately not `done`. "Ran fully, found nothing" is a result; retrying it burns tokens on a settled question.

The envelope is enforced in worker definitions themselves, so the worker-authoring workflow carries the same token set. Changing the set means changing it in both places: every `agents/*.md` subagent, and the subagent-authoring contract/template that ships new ones. `.agent/notes/delegation-supervision-process.md` has the full build-and-validate trail if either surface needs revisiting.

## When it triggers

Generic delegation decisions, briefs, parallel work, judging a returned report, or worker failure. Mention alone does not recommend delegation.

## When it does NOT trigger

Named-worker selection, worker-definition authoring, plan lifecycle, or domain-specific research, code, and review routing.

## Maintainer constraints

- Keep thin. Add rule only after repeated delegation failure proves generic gap.
- Keep generic. Do not absorb named-worker catalogs, model policy, permissions, or domain routing.
- Preserve capability language. This skill must survive replacement of any worker set.
- Status token set is fixed at five. Adding a sixth means editing every worker definition; treat that as a real cost, not a tweak.
- Brief core stays at six fields. A template nobody fills is worse than no template.

## Files

- `templates/task-brief.md` — copy-and-fill brief; six-field core, optional blocks deleted when empty.

## See also

- `../../.agent/notes/design-principles.md` — context-pollution rationale.
