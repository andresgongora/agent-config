---
name: planning
description: "Plans medium or complex work in interactive sessions where user questions are possible. Establishes true desired outcome before route, creates ordered milestones with observable checkpoints in live task state, and replans from evidence. Use for dependencies, material uncertainty, risky forks, delegation seams, scope-drift risk, or failed attempts. Never load in delegated workers or subagents without user dialogue; skip exact low-risk work, durable plan-document authoring, and research without an intended decision or deliverable."
---

## Core

- Plan = ordered milestones and checkpoints leading to defined outcome; keep route visible while working current part.
- **Confirmation.** Before interactive question offering choices, explain each option's pros and cons plus recommendation in normal text. Ask before material outcome, scope, constraint, acceptance, approach, cost, or risk change; never guess.
- User wording may name implementation, not desired result. Infer better path only as proposal.
- Use runtime's native live task list; if absent, use equivalent visible plan board. Plan may be task list or standalone route, never stale chat recap.

## Workflow

1. **Understand.** Inspect relevant current state. Establish desired outcome, observable success, hard constraints, preferences, non-goals, authority, assumptions, and unknowns. Resolve material user decisions before drafting. For material alternatives: offer 2–3 options. Resolve cheap facts now; costly discovery becomes early evidence milestone with conditional route. Multiple question rounds allowed if new gaps arise from prior answers.
2. **Draft.** Lock stable intent before execution:

   ```text
   Goal: <outcome>. Success: <evidence>. Constraints: <hard limits>. Out: <non-goals>.
   ```

   Create ordered outcome milestones. Each has bounded result and observable checkpoint. Order dependency, uncertainty, risk, then value. Start next milestone only when prerequisites and prior checkpoint hold. State material assumptions. Add failure signal, fallback, or branch only when route or stopping behavior changes. Keep roadmap coarse; detail current milestone only.
3. **Execute.** Keep one main-thread executable leaf active. Expand current complex milestone into child items; retain parent route. Child completion does not complete parent; parent checkpoint does. Complete item only when checkpoint holds; update plan state immediately. Before pause, record active leaf, passed checkpoints, pending delegation, and open decisions. On resume, reconcile plan state, pending delegation, and checkpoint evidence before activating work; stale or invalid evidence requires replan. Delegate only isolated, bounded child work with fixed input, authority, expected return, and integration point. Serial delegation follows prerequisite checkpoint. Parallelize only independent children; shared decision, file, mutable state, or ordered evidence stays serial.
4. **Replan.** Pause when evidence invalidates assumption, milestone, order, method, or scope. Keep completed evidence; replace current and future route. State added, removed, or reordered milestones and why. Confirm material revision before resume. Sync plan state, then resume.
5. **Close.** Verify outcome against success evidence and constraints. Completed actions without proven outcome are not success.

## Decision rules

- Ambiguous material intent or requirement: ask; never silently choose.
- Reversible low-risk fork within granted authority: decide, record, continue.
- High-risk, irreversible, or authority-changing fork: recommend, ask.
- Material scope expansion: pause; re-scope with user before resume.
- Same blocker after two evidence-based attempts: stop, summarize evidence, choose new route or ask.
- Unrelated finding: record follow-up; do not add or execute.
