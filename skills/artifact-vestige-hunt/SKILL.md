---
name: artifact-vestige-hunt
description: "Find vestigial residue in code, docs, or agent-directed text: leftover comments, obsolete steps, outcome-neutral instruction/rationale excursions, paired deviations later canceled, and notes describing removed/superseded behavior. Trigger on post-rework cleanup, \"why is this still here\", negative documentation, ghost steps, and compensating rule paths. Not for ordinary control-flow loops, code review, correctness/style checks, static dead-code analysis, or general refactoring."
---

Vestige: thing a from-scratch author, never told about removed behavior, would not write.

## Core mechanic

Establish current purpose, outcomes, constraints, and relevant state only from explicit target text, supplied task/context, or supplied behavior/output evidence. Never infer desired design from structure alone. Ask: *what whole segment can disappear while every evidenced outcome/constraint, endpoint, and recognizable purpose stay identical, with no maintainability loss?* Passes test → vestige. Missing baseline or equivalence proof → UNRESOLVED. Any required redesign, new abstraction, or behavior change → refactor, out of scope. Question is judge; path shapes and taxonomy only scan aids.

## Path shapes

- **Outcome-neutral excursion**: path leaves main sequence, then rejoins at same evidenced state. Test whole excursion, not isolated lines. This is conceptual; ordinary `for`/`while` loops are not candidates without independent zero-impact evidence.
- **Canceling bend**: rule, branch, or rationale pushes away from stated outcome; later material compensates and restores it. Test deviation plus compensation as one unit. If cutting both preserves every evidenced outcome/constraint with no maintainability loss, vestige. If straightening needs redesign, not this skill.
- **Required detour**: current obstacle forces deviation. KEEP only when obstacle and failure caused by removing detour are concrete. Rewrite history as current-state constraint. Obstacle existence unknown → UNRESOLVED.

Shapes locate; taxonomy labels. One label per finding.

## Taxonomy

1. **Negative doc** — text on what artifact does NOT do / no longer does. Ex: comment "no longer validates email format". Counter (keep): "deliberately skips validation, caller already validated" — live constraint, not history.
2. **Ghost step** — sequenced item, whole content is own obsolescence. Ex: "5. No longer check connectivity, push fails anyway." Counter (keep): step still performs check, even changed form.
3. **Meta-residue in agent-directed text** — file explains to future agent why shaped this way. Ex: "removed retry logic per user request 2026-01-01." Counter (keep): routing/scope line executing agent needs right now.
4. **Dead scaffolding** — visible scaffold whose own comment or prose explicitly frames it around an absent consumer. Proving consumer absence through call-graph, data-flow, or compiler analysis is out of scope.
5. **Superseded wording** — old phrasing beside replacement, two sources of truth. Ex: rule restated two ways same file, one stale.
6. **Defensive apology** — "intentionally does not X" / "deliberately avoid Y", no live decision behind it — no one risks re-adding X/Y, no ambiguity without note.

## Runtime vs maintenance

| Context | Status | Action |
| --- | --- | --- |
| Runtime (executable code, agent instructions read at load/exec) | Obstacle — eats context, misroutes behavior | Cut |
| Maintenance (why changed, historical decision) | Real info, belongs git history/changelog not artifact | Cut from artifact |
| Current constraint: direct path causes concrete failure | Genuine survivor | Keep, state current obstacle + failure ("do X; Y fails otherwise"), never history note ("used to do X") |

Third row narrow. Claim survivor only with current obstacle + concrete failure mode; insufficient evidence → UNRESOLVED.

## Per-artifact-type notes

- **Code**: comments on removed behavior; visibly paired deviation/compensation; scaffolding whose own text declares its consumer absent. Consumer or reachability proof needing call-graph/data-flow analysis stays out of scope.
- **Docs/prose**: sentences justifying absence of arbitrary things ("does not cover X"), version-history asides in current-state description.
- **Agent-directed text**: workflow steps kept only to explain own removal; meta commentary aimed at maintaining agent not executing agent; "why" prose where file should carry only what/when/how.

## Output contract

Finding: `path:line — <label> — one-line why it passes zero-impact test`. Labels: `negative-doc`, `ghost-step`, `meta-residue`, `dead-scaffolding`, `superseded-wording`, `defensive-apology`.
Survivor: `path:line — KEEP — current obstacle + concrete failure mode this segment prevents`.
Can't classify admitted semantic candidate with evidence at hand: `path:line — UNRESOLVED — what's missing to decide`. Never force KEEP or vestige without concrete basis. Never silently drop admitted candidate; proven lexical false positive never enters classification.
No findings: say so; do not force findings.

## Workflow

1. Read target fully or by section. Grep hits alone insufficient — vestiges semantic.
2. Optional: `scripts/prefilter` for lexical history-marker hits in text selected by installed scanner defaults. High recall only within that selected text, low precision; no signal on structural paths, never verdict.
3. Read each hit in context. Clearly unrelated marker use → reject before candidate admission, no output. Plausible residue → admit semantic candidate.
4. Trace evidenced current path. Inspect suspicious line, step, or whole section as one candidate; look for outcome-neutral excursions, canceling bends, and required detours. Missing stated path/outcome/state → UNRESOLVED.
5. Apply core mechanic. Classify admitted candidate: vestige (list for deletion), survivor (concrete current obstacle + failure mode), unresolved (state what's missing) if neither call confidently supportable.
6. Emit per contract. No deletion unless user/calling workflow asked direct edits — default read-only report.

## Boundaries

- Not code review, correctness check, style critique.
- Not static dead-code/unused-import analysis — linter/compiler job. This skill targets what tooling can't see: prose, intent, sequence, meta-commentary.
- Never relocates cut content to changelog/ADR. Git history is archive; skill only IDs what to cut, never where it should live.
- Distinct from correctness/alignment auditing of agent-directed instruction artifacts (AGENTS.md, agent defs, skills, commands): that asks artifact internally consistent + aligned with intent; this asks specific lines deletable with zero impact. Both can run same file, different question.

## Verification

- Every vestige finding passes core mechanic question explicitly, not pattern match alone.
- Every path/state judgment names its explicit or supplied evidence; absent evidence produces UNRESOLVED.
- Every KEEP states concrete failure mode, not "seems important."
- No deletions unless explicitly requested.
