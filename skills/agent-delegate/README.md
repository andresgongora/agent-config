# Agent Delegation

Decision workflow plus supervision discipline for context-preserving delegation.

## Design intent

Delegation pays only when worker starts from little context and returns less than main would consume exploring. This skill owns four things in order: the decision gate, the task brief, report evaluation, and the escalation ladder. Focused workflows retain worker selection and domain execution.

Three ideas do the work. A brief states goal and bounds but not method — under-specify and the worker runs off, over-specify and main already did the job. A report is judged on evidence and two mandatory fields (`status:`, `gap:`), because claims are unjudgeable. Retries must change the input, since an identical re-spawn reproduces the failure at full price.

`none` is deliberately not `done`. "Ran fully, found nothing" is a result; retrying it burns tokens on a settled question.

The envelope is enforced in worker definitions themselves, so the worker-authoring workflow carries the same token set. Changing the set means changing it in both places: every `agents/*.md` subagent, and the subagent-authoring contract/template that ships new ones.

## Decision rationale

The SKILL.md table gives the decisions. Here's why each row exists.

- **Needs existing context** — worker starts cold. Transferring context costs tokens; if main already holds it, inline is cheaper.
- **User decision required** — worker can't ask the user. It either blocks (wasting a turn) or guesses wrong (wasting a turn and a fix).
- **Ambiguity / risky action** — worker lacks authority. Wrong call on ambiguous scope or risky operations costs more than main doing it.
- **Brief + report > inline** — pure cost math. Delegation has overhead (brief writing, context transfer, report reading). If the work itself is small, overhead exceeds savings.
- **Bounded, checkable, compact return** — the one "yes" row. Bounded = worker won't run off. Checkable = main can verify without redoing. Compact return = the result costs less context than doing it inline.

Parallelization adds a constraint: shared state between contracts means ordering dependencies, which means sequential execution or main-thread work. Only truly independent contracts parallelize.

## Anti-patterns

Failure modes observed in practice. These are philosophical — the SKILL.md rules already prevent them mechanically, but knowing the pattern helps recognize the temptation.

- **Delegating to avoid thinking.** Brief writing is design work. If you can't write the brief, you don't understand the task yet. Delegation doesn't fix that.
- **Delegating exploration then ignoring the report.** Main still eats tokens reading it. If you won't use the result, the spawn was net-negative regardless of outcome.
- **Forwarding worker's full output to user.** Main's job is integration. The user asked main, not the worker. Summarize.
- **Spawning for one-line answers.** If main already knows the answer, writing it costs fewer tokens than spawning, briefing, waiting, reading, and relaying.

## Coordinator rationale

A coordinator (worker that spawns workers) pays for its own model plus downward context transfer, and cannot ask the user. The three conditions in the SKILL.md are all necessary:

- **Three or more branches** — below three, the coordinator overhead exceeds the parallelism gain. Main doing them sequentially is cheaper.
- **Consolidation needed** — if branches are independent and don't need merging, main can spawn them directly without an intermediary.
- **Narrow domain** — coordinator has no main-thread history. If the domain requires broad context, the coordinator either gets a huge brief (defeating the purpose) or makes bad decisions.

A general-purpose coordinator at main's tier is always a loss: it pays the expensive model twice while main still holds the context. Coordinators sit at mid tier and copy existing patterns (e.g., research-coordination workers) rather than inventing generic ones.

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
