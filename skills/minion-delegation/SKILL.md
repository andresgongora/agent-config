---
name: minion-delegation
description: "Pick and drive bounded minion workers: locate code, edit, lint, review, cleanup, or execute a frozen multi-step mission. Load for any multi-step or context-heavy repository task, to-do item list execution, feature and refactor work, before choosing inline versus delegated work, or minion subagent delegation. Skip single-step answers and non-repository work."
---

## Decision Gate

Choose by needed evidence and authority, not convenience.

| Task step | Delegate to |
| --- | --- |
| Locate focused definitions, callers, usages, tests, imports, or structure | `@minion-investigator` |
| Make an obvious change in one or two known files | `@minion-builder` |
| Format or lint supplied targets with safe automatic fixes (batched: end of large chunk or pre-commit) | `@minion-linter`  |
| Find defects in a supplied diff or one bounded file after finished code edit | `@minion-reviewer` |
| Find removable residue after long session or long rework in a supplied area | `@minion-vestige-hunter` |
| Drive a Git or repository operation | `@minion-repomaster` |
| Read one quick `git status` or `git diff` to orient | Main thread; do not delegate |
| Locate code plus suggest fixes, explain architecture, or diagnose an unknown defect | Main thread or general exploration capability |
| Give broad review, design advice, or general feedback | Main thread or a suitable review capability |
| Run tests, builds, or installs; conduct external research; handle unclear or risky work | Main thread or a capability with required tools |
| Answer already known in one line | Main thread; do not delegate |

## Rules

- Spawn a minion for each bounded, independent step that matches a delegation row. Calling thread owns integration and final judgment.
- Give target, outcome, scope, and authoritative context. Omit only irrelevant fields.
- Choose smallest worker whose authority and output complete next step.
- Treat minion output as evidence, not a replacement for inspection, validation, or user-facing explanation.
- Pass only results, targets, and constraints next worker needs.
- Calling thread owns integration: after any minion edit, inspect the diff and run relevant validation before a later worker.
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

<Optional: any other relevant information deemed useful and appropriate for the mission; free format: text, bullet lists, checklists, etc.>.
```

### Reacting to Minion Output

Every minion returns `**status**`, `**gap**` (in-scope work not done), and `**issue**` (why it stopped). Act on status; do not re-prompt blindly.

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

### minion-investigator

- **What**: read-only locator. Returns definitions, callers, usages, tests, imports, or a directory map as path-based evidence.
- **When**: edit or review sites are unknown, or several independent lookups can run at once.
- **How**: give symbols, strings, paths, or an area, and name the evidence kind wanted.
- **Not when**: fix suggestions, architecture explanation, or defect diagnosis are wanted; it reports sites, not conclusions.

### minion-builder

- **What**: applies one decided change across at most two known files. Returns an edit receipt after re-reading them.
- **When**: target files and intended change are both already known.
- **How**: give exact paths, the change, and constraints. Authorize new files and destructive operations explicitly; silence means no.
- **Not when**: sites are unknown (investigate first), the change needs design decisions, or coupling spreads past two files.

### minion-linter

- **What**: selects project formatters and linters for supplied targets, applies presentation-only automatic fixes, reports each check. Handles repository-wide targets in one pass.
- **When**: batched at the end of a large chunk of work or right before a commit, so one pass covers every touched file.
- **How**: give explicit files, directories, or the repository area and permission to auto-fix.
- **Not when**: between small steps of an ongoing change; per-edit lint passes cost more than the single batched run. Never for behavior changes, dependency installs, or tool-config edits.

### minion-reviewer

- **What**: read-only defect check of one supplied diff or one bounded file. Returns severity-tagged verified findings plus any in-scope area left unreviewed.
- **When**: default after every `@minion-builder` edit, once main has inspected the diff and run validation.
- **How**: supply the diff or file, the review focus, and whether nits are wanted.
- **Not when**: design rationale, alternatives, or broad architecture opinion are wanted. Empty findings are a valid result, and no finding is an approval.

### minion-vestige-hunter

- **What**: read-only residue scan of a supplied area. Returns removal candidates, the zero-impact basis for each, and inspection coverage.
- **When**: after a long session or large rework lands, when accumulated leftovers are likely.
- **How**: give changed files, directory, or area plus current-purpose context so an active constraint is not read as residue.
- **Not when**: after each single edit, or when correctness analysis is the real need. Candidates are proposals; main thread verifies removal safety before any edit.

### minion-repomaster

- **What**: owns a whole Git or repository operation. Absorbs large Git output and returns a distilled receipt: commit-message proposal and commit transaction, revert or recovery plan and execution, history summary or commit comparison, secret and pre-commit preflight, `.gitignore`/`.gitattributes` correctness.
- **When**: the step needs many Git commands, approval back-and-forth, or Git output large enough to contaminate main context.
- **How**: give the mission kind, scope, and explicit authority for any state change. Silence means read-only.
- **Not when**: one quick `git status` or `git diff` is enough to orient; run that in main thread. It never pushes, tags, rebases, merges, rewrites history, or edits source files.

## Delegation Chaining

### Locate, fix, verify

1. `@minion-investigator` returns sites for a focused question.
2. Main thread selects one or two known edit sites and gives `@minion-builder` an exact prompt.
3. Main thread inspects the diff and runs relevant validation.
4. Give the resulting diff to `@minion-reviewer`.

### Parallel investigation

1. Split independent bounded questions, such as definitions, callers, and tests.
2. Parallelize each independent bounded question, batching only when available worker capacity requires it.
3. Aggregate evidence in the main thread before selecting a change or another worker.

### Direct edit

1. When exact edit sites and outcome are already known, give `@minion-builder` the prompt directly.
2. Main thread validates the resulting diff, then gives it to `@minion-reviewer`.

### Batched cleanup

1. At the end of a large chunk of work or right before a commit, give `@minion-linter` every touched path in one pass.
2. After a long session or large rework, give the touched area and current-purpose context to `@minion-vestige-hunter`.

### Git commit

1. When the caller or repository policy requires project validation, run each applicable check once over the coherent work package: use `@minion-linter` for presentation-only lint/format, and use the main thread or a capability with the required tools for tests, typecheck, or build. Run no checks by default for commit-only missions.
2. Give `@minion-repomaster` the exact scoped Git transaction and commit authority.

## Boundaries

- If next worker lacks target, outcome, or authoritative context, resolve it in main thread. Do not delegate an incomplete mission.
- If evidence reveals coupled change beyond worker scope, stop chain and re-plan in main thread. Do not split a coupled refactor to fit two-file limit.
- A nested `@minion-master` cannot perform or hand off Git state-changing work under its current authority; route it back to caller.
- If no decision-gate row fits, do not use a minion. Select another capability or continue in the main thread.
