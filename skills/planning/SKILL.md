---
name: planning
description: >
  Plan multi-step execution or create/review durable pre-implementation plan documents.
  Use for medium/complex work with dependencies, material uncertainty, risky forks, likely scope
  drift, prior failed attempts, or a requested plan doc. Builds shared scope, high-level milestones,
  native todos, and revisable execution direction. Skip trivial answers, exact bounded changes,
  and research with no intended decision or deliverable.
---

## First decision

Choose path before detail.

- **Session**: roadmap + native todos. Default for ordinary implementation.
- **Document**: create, amend, or review one durable plan document. No implementation.

Document path only for requested durable plan, cross-session work, architecture, migration, high-risk fork, or research needing preserved decision context.

## Shared core

### Scope

User wording != real goal. Extract:
- goal and expected outcome
- hard constraints, preferences, non-goals
- assumptions, unknowns, success evidence

Ask only outcome/cost/risk/approach-changing questions. Literal request misses better path: say so. Multiple material paths: give 2-3, one-line tradeoffs, recommendation, ask.

Lock one sentence before work:

```text
Goal: <outcome>. Constraints: <hard limits>. Out: <non-goals>.
```

### Shape

Plan 3-7 outcome milestones. Order: dependency, risk, value, question cost. Retire cheap unknowns early. No micro-steps before current milestone.

Every plan: observable success evidence, stated assumptions. Group mechanical work. "Wire module" beats "add import, save, lint".

### Guardrails

Both paths obey; session applies via adapt table:

- Unrelated finding: follow-up, never silent work. Anti-drift load-bearing.
- Low-risk reversible fork: decide, state why, continue.
- High-risk, one-way, user-visible fork: recommend, ask.
- Missing/ambiguous material requirement: propose interpretation, ask. Never guess.
- Two failed blocker attempts: stop, summarize, re-plan. Third needs new evidence.
- Discovery invalidates plan: show changed milestones/why; confirm material revision.

## Session path

`SCOPE → PLAN → EXECUTE → REVISE → CLOSE`

Native todos own state. Coarse-to-fine: roadmap first; decompose current milestone only when it starts. Document-mode research: treat plan draft as session with scope, todos, revision.

### Scope

Ask only unclear outcome/cost/risk/approach-changing questions. Enumerable options: multiple choice. Cover problem, success shape, hard constraints, explicit non-goals. Multiple valid paths: name 2-3, one-line tradeoff each, recommend one, allow override; no upfront deep dive. Wrong goal (XY problem, better path): say plainly. Lock sentence; confirm before work:

```text
Goal: <outcome>. Constraints: <hard limits>. Out: <non-goals>. Correct?
```

### Plan

Show goal, non-goals, assumptions, 3-7 milestones, verification, open questions. Todos hold through-line without fake precision; group mechanical work. Material scope/path open: wait approval. Else start milestone.

### Execute

Decompose only current complex milestone into todos. Mark done live; never batch-close. Trivial cluster: one todo. Complex child: recurse (mini-scope, mini-plan). Exactly one active item. Apply adapt table per obstacle:

| Situation | Action |
|---|---|
| Missing info | Ask. No guess. |
| Ambiguous requirement | Propose interpretation, ask to confirm. |
| Fork, low risk, reversible | Decide, state reasoning, continue. |
| Fork, high risk or one-way door | Present options, recommend, ask. |
| Scope creep detected | Pause. Re-scope with user. |
| Discovery invalidates plan | Update remaining milestones. Material change → confirm. |
| 2 failed tries, same blocker | Stop. Summarize. Re-plan. Third try needs new evidence. |
| Tempted to fix unrelated thing "since here" | STOP. Note as follow-up. Do not touch. |

Anti-drift load-bearing: work only current-plan items. Unrelated finding: follow-up note, never silent extra work. Context contamination main enemy. Never make silent irreversible decision.

### Revise

Re-enter Plan: discovery invalidates milestone, user changes requirement, scope changes order, blocker hits twice. Show diff: dropped/added/reordered milestones + why. Confirm material change.

### Execute an existing plan doc (coarse → fine)

When work starts from a `.agent/plan/<slug>.md`:

1. Read the plan. Treat its top-level execution plan as the milestone roadmap — do not re-scope settled decisions.
2. Take current milestone. Check availability, honor `Use:`/`Delegate:` cues. Prefer bounded worker for small structured evidence, parallel questions, context savings. Main thread: live synthesis, trivial work, broad cross-cutting changes. Subagent: delegate locate/edit/review; compressed output saves context.
3. Decompose omitted detail into fine native todos. Approved delegation: one todo with question, worker, expected return, fallback.
4. Confirm todos/interpretation gaps before execution, unless autonomy pre-granted.
5. Execute under adapt table and anti-drift.
6. Discovery invalidates coarse plan: surface it, feed revision back into plan doc (or hand to document-mode agent). No silent divergence.

### Close

After implementation: report changes, validation, risk, deferred follow-ups. Suggest optional next step. Planning-only turn ends at approved plan/open questions; no ceremonial recap, validation, state update without relevant change.

## Document path

Document path to write or maintain durable implementation-plan document. Read bundled `plan-template.md`; adapt, never fill empty headings. Inventory plans first. Reuse only same deliverable/boundary/active scope. Same topic, changed outcome/constraints: new plan; link predecessor if useful.

Draft captures decision-grade foundation:
- clearer goal and honest requirement rewrite
- hard/soft constraints, non-goals, assumptions, locked decisions (standing invariants, when any exist)
- observable success criteria and risk triggers
- top-level AI execution plan
- research, tools, leads, delegation only if they change execution
- follow-up questions and final deliverable format when useful

Research only decision-blocking unknowns. After scope, inspect approach-changing runtime skills, MCPs/tools, bounded workers. No exhaustive inventory/irrelevant reads. Per chosen capability: purpose, trigger, access, output, fallback. Per non-trivial milestone, assess delegation for context/parallelism/review; useful: record `Delegate:` (worker, bounded task, expected return, trigger). Tag `Delegate:` when milestone is isolatable: inputs nameable in the worker prompt, correct without dialogue/thread context, result verifiable on return. Keep in main when it needs live thread context, author intent, or unstated decisions — fresh worker guesses wrong. Deciding the split at plan time spares the executor when-to-delegate reasoning; executor holds more knowledge and may override. Put instructions beside milestone; centralize only shared setup, environment assumptions, fallbacks. Plan docs may name runtime capabilities: task-scoped, not reusable coupling. Runtime likely, not guaranteed: record material dependency + fallback. Direct-inspect one local fact. Isolate broad mapping, external research, independent review when result compact/useful. Keep source/path leads; no transcript dump. Non-trivial draft is session work: scope, todos, revise openly.

Before approval, run a clean-context pass: dispatch a bounded review worker on the finished plan doc, uncontaminated by dialogue. Author context is chat-polluted and blind to what the doc fails to state. Worker judges the doc as a document — stubs/dead-ends, cross-section contradictions (pass locked decisions to verify), leanness, precision. Feed findings back, revise, then approve. Skip only for a trivial plan (state the skip).

User approval: mark approved. Changed scope: amend plan, date revision, explain decision. Archive only after delivery/abandonment.

### Existing-plan review

Inspect before editing. Return:

```md
## Plan Review

**Alignment:** <aligned | partly aligned | misaligned> — <evidence>
**Major gaps:**
- <missing decision, validation, risk, or success check>
**Recommended review angles:**
- <highest-value unresolved angle>
**Next steps:**
- <amend | ask | research | approve>
```

Material scope conflict: ask before amendment. Minor clarity: amend, record revision.

## Boundaries

- Native todo mechanism owns session state.
- Durable plan document owns stable intent; task handoff/state snapshots own other memory.
- Delegation by capability, never mandatory or reflexive.
- Workflow only. Code style, tests, commits belong elsewhere. Plan-doc output stays dense/low-token (fragments, bullets, exact paths/commands); prose-style skill lives elsewhere but density is not optional.
- If planning cost exceeds task risk, execute direct.
