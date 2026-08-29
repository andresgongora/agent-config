---
name: planning
description: "Plans medium-or-harder work in interactive sessions where the agent can ask the user mid-task. Establishes true desired outcome before route, creates ordered milestones with observable checkpoints in live task state, and replans from evidence. Load when using todo list tool (`todowrite`) for medium-or-harder work; signals of that threshold include dependencies, material uncertainty, risky forks, delegation seams, scope-drift risk, a prior failed attempt, or deciding how to conduct an open-ended research or documentation effort. Do not load for a single quick step, or if `question` tool unavailable."
---

Author multi-step plan with checkpoints and ordered milestones to achieve intended goal, then maintain and replan as execution surfaces new evidence or obstacles.

## Rules

- Before interactive question offering choices, explain each question-tool-option's pros and cons plus recommendation in normal text. Ask before material outcome, scope, constraint, acceptance, approach, cost, or risk change; never guess.
- Use precise, unambiguous language for milestones, checkpoints, and evidence.
- Output plan format: update native tool task to-do list, or use requested output format if provided; if doubt: ask.

## Planning workflow

1. **Goal-check**: Confirm desired outcome clear, actionable, realistic. User wording may name an implementation, not the desired result; infer true intent only as a proposal, confirm with user. Brainstorm viable alternatives; challenge a weak or unrealistic goal before locking direction.
2. **Understand**: Inspect relevant current state. Establish observable success, hard constraints, preferences, non-goals, authority, assumptions, unknowns. Material or high-stakes goal: consult repo docs and run external research before locking intent. Resolve cheap facts now; costly discovery becomes an early evidence milestone with a conditional route. Ask user for material decisions; multiple question rounds allowed as new gaps surface from prior answers.
3. **Lock stable intent**: `Goal: <outcome>. Success: <evidence>. Constraints: <hard limits>. Non-goal: <non-goals>`.
4. **Draft plan**: Create ordered outcome milestones. Each has a bounded result and an observable checkpoint. Order by dependency, uncertainty, risk, then value. State material assumptions. Add a failure signal, fallback, or branch only when route or stopping behavior changes. Keep roadmap coarse; detail only the next milestone. Format: `<Milestone expressed as verb + object>. Success: <evidence>. Constraint: <hard limit, or omit>. Assume: <material assumption, or omit>.>`; omit empty categories, ultra condensed prose.
5. **Verify**: Check draft against `## Verification`.
6. **Iterate or finish**: New evidence invalidates goal, assumption, or ordering: return to the step it invalidates and revise from there only; do not redo unaffected work. When solid, return the plan (see `## Guardrails` for how to judge solidity and when to ask).

## Execution upkeep

- Tick checklist item done right after it completes; no batching.
- No parallel task execution unless each parallel branch runs via separate delegated subagent.
- Milestone fails or unforeseen blocker hits: record evidence, notify user, propose alternate route, return to workflow step 6 (Iterate) to replan.

### Delegation

If delegating a milestone execution:

- Coarse to fine: delegating agent (not the subagent) executes full planning workflow on target task to create comprehensive sub-plan; same rules apply.
- Completion differs: do not return the sub-plan to the user as final output; carry it into the delegation prompt instead.
- Subagent does not load this skill; it must receive the finished sub-plan spelled out, not by reference.
- Append verbatim to delegation prompt, substituting only the two placeholders (mission statement, milestones):
  ```md
  ## Execution plan

  <Sub-mission statement, format as in Step 3 (Lock stable intent)>

  - [ ] <One or more milestones, format as in Step 4 (Draft plan)>

  Plan hits an unpredicted blocker or turns out not actionable: stop, do not improvise a new route, report evidence, report status (`blocked` or `partial`).
  ```

## Guardrails

- Ambiguous material intent or requirement: ask; never silently choose.
- Reversible low-risk fork within granted authority: decide, record, continue.
- High-risk, irreversible, or authority-changing fork: recommend, ask.
- Material scope expansion: pause; re-scope with user before resume.
- Same blocker after two evidence-based attempts: stop, summarize evidence, choose new route or ask.
- Unrelated finding: record follow-up question; do not add to plan without user approval.
- Plan solidity unclear: ask user whether to finalize or keep iterating; if clearly solid or clearly not, decide and continue iterating without asking.
- External research tool unavailable on material or high-stakes goal: state gap, proceed on repo docs plus explicit low-confidence assumption flagged to user; never treat unverified pass as settled.

## Verification

- [ ] Goal clear, actionable, realistic.
- [ ] Every milestone maps to stated outcome; none is dead weight or scope creep.
- [ ] Every milestone has bounded result and observable, verifiable checkpoint.
- [ ] Milestone order respects dependency, uncertainty, risk, then value.
- [ ] Material assumptions stated, not silently baked in.
- [ ] Hard constraints and non-goals honored, none silently dropped or violated.
- [ ] Material or high-stakes goal: repo docs/external research consulted, not skipped.
- [ ] Open material questions asked, not guessed.
