---
name: planning
description: "Plans medium-or-harder work in interactive sessions where the agent can ask the user mid-task. Establishes true desired outcome before route, creates ordered milestones with observable checkpoints in live task state, and replans from evidence. Load whenever a task exceeds a single quick step — signals include dependencies, material uncertainty, risky forks, delegation seams, scope-drift risk, a prior failed attempt, or deciding how to conduct an open-ended research or documentation effort. Do not load if question tool unavailable."
---

Mission: Author a multi-step plan with relevant checkpoints and ordered milestones to achieve requested goal. Skill's rules govern planning only; execution of the resulting plan is out of scope.

Plan = ordered milestones and checkpoints leading to defined outcome; breaking task into smaller, observable steps.

## Rules

- Deliverable plan takes form of a native tool task to-do list (preferred), plan file (only if instructed), or extensive and thorough chat message (fallback).
- Before interactive question offering choices, explain each question-tool-option's pros and cons plus recommendation in normal text. Ask before material outcome, scope, constraint, acceptance, approach, cost, or risk change; never guess.
- Use precise, unambiguous language for milestones, checkpoints, and evidence.

## Workflow

If a native task/todo tool is available, use it to track progress through this workflow itself (one entry per step below, updated as steps complete) — separate from the deliverable plan produced by the workflow. Fall back to tracking steps in-context if unavailable.

1. **Goal-check.** Confirm desired outcome is clear, actionable, and realistic. User wording may name an implementation, not the desired result — infer true intent only as a proposal, confirm with user. Brainstorm viable alternatives; challenge a weak or unrealistic goal instead of accepting it; state pros/cons of each viable option plus a recommendation before locking direction.
2. **Understand.** Inspect relevant current state. Establish observable success, hard constraints, preferences, non-goals, authority, assumptions, and unknowns. For a material or high-stakes goal, consult repo docs and run external research before locking intent — a single unverified pass is low-confidence. Resolve cheap facts now; costly discovery becomes an early evidence milestone with a conditional route. Ask user for material decisions; multiple question rounds allowed as new gaps surface from prior answers.
3. **Draft.** Lock stable intent:

   ```text
   Goal: <outcome>. Success: <evidence>. Constraints: <hard limits>. Out: <non-goals>.
   ```

   Create ordered outcome milestones. Each has a bounded result and an observable checkpoint. Order by dependency, uncertainty, risk, then value. State material assumptions. Add a failure signal, fallback, or branch only when route or stopping behavior changes. Keep roadmap coarse; detail only the next milestone.
4. **Verify.** Check the draft against `## Verification`. An unproven or hand-waved plan is not a finished plan.
5. **Iterate or finish.** If new evidence surfaced while drafting invalidates the goal, an assumption, or an ordering, return to the step it invalidates (goal-check, understand, or draft) and revise from there only; do not redo unaffected work. Keep iterating until the plan is solid. When solid, return the plan (see `## Guardrails` for how to judge solidity and when to ask).

## Guardrails

- Ambiguous material intent or requirement: ask; never silently choose.
- Reversible low-risk fork within granted authority: decide, record, continue.
- High-risk, irreversible, or authority-changing fork: recommend, ask.
- Material scope expansion: pause; re-scope with user before resume.
- Same blocker after two evidence-based attempts: stop, summarize evidence, choose new route or ask.
- Unrelated finding: record follow-up question; do not add to plan without user approval.
- Plan solidity unclear: ask user whether to finalize or keep iterating; if clearly solid or clearly not, decide and continue iterating without asking.

## Verification

- [ ] Goal is clear, actionable, and realistic.
- [ ] Every milestone maps to the stated outcome; no milestone is dead weight or scope creep.
- [ ] Every milestone has a bounded result and an observable, verifiable checkpoint (not a vague feeling).
- [ ] Milestone order respects dependency, uncertainty, risk, then value.
- [ ] Material assumptions are stated, not silently baked in.
- [ ] Hard constraints and non-goals from the goal line are honored, none silently dropped or violated.
- [ ] Material or high-stakes goal: repo docs/external research were actually consulted, not skipped.
- [ ] Open material questions were asked, not guessed.