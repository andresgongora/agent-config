---
name: minion-delegation
description: "Pick and drive bounded minion workers: locate code, edit, lint, review, cleanup, or execute a frozen multi-step mission. Load for any multi-step or context-heavy repository task, feature and refactor work, before choosing inline versus delegated work, or minion subagent delegation. Skip single-step answers and non-repository work."
---

## Decision Gate

Choose by needed evidence and authority, not convenience.

| Task step | Delegate to |
| --- | --- |
| Locate focused definitions, callers, usages, tests, imports, or structure | `minion-investigator` |
| Make an obvious change in one or two known files | `minion-builder` |
| Format or lint supplied targets with safe automatic fixes | `minion-linter` |
| Find defects in a supplied diff or one bounded file | `minion-reviewer` |
| Find removable residue after rework in a supplied area | `minion-vestige-hunter` |
| Execute a frozen, bounded multi-step repository mission | `minion-master` |
| Locate code plus suggest fixes, explain architecture, or diagnose an unknown defect | Main thread or general exploration capability |
| Deliver a feature, coupled 3+ file change, or cross-cutting refactor | Plan in main thread; use `minion-master` only after scope, authority, and proof are frozen |
| Give broad review, design advice, or general feedback | Main thread or a suitable review capability |
| Run tests, builds, formatters, installs, or external research | Main thread or a capability with required tools |
| Answer already known in one line | Main thread; do not delegate |

## Rules

- Delegate one bounded, independent step per minion. Calling thread owns integration and final judgment; `minion-master` owns local integration inside its frozen mission.
- Give target, outcome, scope, and authoritative context. Omit only irrelevant fields.
- Choose smallest worker whose authority and output complete next step.
- Delegate when the step costs more context to run than to describe: a search whose target file set is unknown, a review of a diff you would otherwise read whole, or an edit whose surrounding file you do not need in context. Do it inline when the target is one known file and one known range, or when writing the mission takes as long as the work.
- Treat minion output as evidence, not a replacement for inspection, validation, or user-facing explanation.
- Pass only results, targets, and constraints next worker needs.
- Calling thread owns integration: after any minion edit, inspect the diff and run relevant validation before a later worker. `minion-master` performs this locally inside its frozen mission.
- Parallel minions only on non-overlapping tasks. Spawned as multiple task calls in one message, then aggregate before choosing the next worker.

### Delegation prompt

Give each minion a bounded mission:

```md
Task: <one bounded outcome>.
Target: <paths, symbols, supplied diff, or repository area>.
Scope: <included work and explicit exclusions>.
Context: <authoritative facts and constraints; `none` if none>.
Parameters: <tool/access limits, execution constraints, required checks, and acceptance criteria>.
Return: <evidence focus caller needs next. It will still honor its own output contract>.
```

### Reacting to Minion Output

Every minion returns `**status**` plus `**gap**` (in-scope work not done) or `**issue**` (why it stopped). Act on status; do not re-prompt blindly.

| `status` | Main-thread response |
| --- | --- |
| `done` | Use evidence. Still owns validation. |
| `none` | Complete negative result: no change needed, no result found. Widen or re-approach only if your original objective is still unmet. |
| `partial` | Use delivered evidence. Cover the gap inline or in a narrower mission; for a valid attempt that broke, resolve its `issue` and retry at most once if the cause is resolved. |
| `blocked` | `issue` holds a question or missing authorization. Answer it in the retry prompt; a retry without the answer blocks again. |
| `refused` | Wrong worker or oversized mission. Re-read the decision gate, split, or stay in main thread. Never re-send to same worker. |
| `failed` | Use delivered evidence. Resolve its `issue`, then retry at most once if the cause is resolved; otherwise cover the `gap` inline or re-plan. |

- Minion status is self-report: `done` and `gap: none` mean the worker believes it finished, never that the change is correct, tested, or complete.
- `refused` with a split proposal is a plan suggestion; validate the split before delegating its parts.
- Same status twice on one mission: stop delegating, do the step inline.

## Minions

### minion-master

- Use only for one self-contained, bounded planning milestone with complete mission, scope, authority, context, validation, and receipt requirements.
- It loads this workflow, makes or follows an internal subplan, selects eligible leaf minions, integrates their work, and verifies the mission.
- Do not use for user dialogue, unresolved design, open-ended discovery, deploy/publish work, or recursive coordination.

### minion-investigator

- Prompt with symbols, strings, paths, or repository area; say whether you need definitions, callers, usages, tests, imports, or a directory map.
- Returns compact path-based evidence. Use its sites to narrow a later edit or review.
- Reports repository evidence only. Analysis beyond that evidence needs a general exploration capability.

### minion-builder

- Prompt with exact target file or files, desired change, and constraints. Explicitly authorize any new file or destructive operation. Limit scope to one or two files.
- Adds no comments, abstractions, or drive-by refactors. Returns a small edit receipt after re-reading changed files.
- Do not use before the edit sites are known; investigate first if needed.

### minion-linter

- Prompt with explicit files or directories and permission for presentation-only automatic fixes.
- Selects project tools, preserves semantics, and reports each check. It never installs dependencies or changes configuration.

### minion-reviewer

- Prompt with a supplied diff or one bounded readable file, review focus, and whether nits are requested.
- Returns verified, severity-tagged findings and any unreviewed in-scope area. Empty findings are valid.
- Reports correctness defects in the supplied target. Design rationale, alternatives, and broad architecture opinion go elsewhere.
- Reviewer findings and coverage inform acceptance, never approval.

### minion-vestige-hunter

- Prompt with changed files, directory, or repository area plus enough current-purpose context to distinguish a vestige from an active constraint.
- Returns removable candidates, their zero-impact basis, and inspection coverage.
- Reports residue and zero-impact dead code. Correctness analysis goes elsewhere.
- Vestige candidates are proposals. Verify removal safety in main thread before any edit.

## Delegation Chainning

### Locate, fix, verify

1. `minion-investigator` returns sites for a focused question.
2. Main thread selects one or two known edit sites and gives `minion-builder` an exact prompt.
3. Main thread inspects the diff and runs relevant validation.
4. Give the resulting diff to `minion-reviewer` when an independent defect check earns its cost.

### Parallel investigation

1. Split non-overlapping questions, such as definitions, callers, and tests.
2. Spawn two or three `minion-investigator` workers in parallel.
3. Aggregate evidence in the main thread before selecting a change or another worker.

### Direct edit

1. When exact edit sites and outcome are already known, give `minion-builder` the prompt directly.
2. Main thread validates the resulting diff. Review it independently when risk warrants.

### Cleanup after change

1. After validation, give touched area and current-purpose context to `minion-vestige-hunter`.
2. Treat candidates as proposals. Main thread verifies removal safety before any edit.

### Frozen multi-step mission

1. Main thread resolves user decisions and produces a complete mission package.
2. Dispatch `minion-master` only when scope, authority, validation, and receipt are frozen.
3. Master follows this workflow for leaf work, local integration, and proof; caller judges the receipt.

## Boundaries

- If next worker lacks target, outcome, or authoritative context, resolve it in main thread. Do not delegate an incomplete mission.
- If evidence reveals coupled change beyond worker scope, stop chain and re-plan in main thread. Do not split a coupled refactor to fit two-file limit.
- If no decision-gate row fits, do not use a minion. Select another capability or continue in the main thread.
- `minion-master` delegates only named leaf minions. Never use it to delegate another coordinator or itself.
