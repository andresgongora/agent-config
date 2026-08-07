---
name: artifact-vestige-hunt
description: "Find vestigial residue in code, docs, or agent-directed text: leftover comments, steps, notes describing removed/superseded behavior a from-scratch rewrite never includes. Trigger on post-rework residue cleanup, \"why is this still here\", negative documentation (what code no longer does), ghost steps in workflow, meta commentary explaining a file's own edit history. Not for code review, correctness checking, style, static dead-code/unused-import/unreachable-branch analysis, general refactor proposals."
license: MIT
metadata:
  author: andresgongora
---

# artifact-vestige-hunt

Detect, list deletable residue. Vestige: thing a from-scratch author, never told about removed behavior, would not write. Detection the deliverable — once seen, removal trivial.

## Core mechanic

Ask: *refactor artifact to byte-identical behavior/output, same shape/purpose recognizable — what cut IMMEDIATELY with guaranteed zero impact on outcome AND zero loss of maintainability?* Passes test → vestige. Question is judge. Taxonomy below scanning aid only, not the rule.

## Taxonomy

1. **Negative doc** — text on what artifact does NOT do / no longer does. Ex: comment "no longer validates email format". Counter (keep): "deliberately skips validation, caller already validated" — live constraint, not history.
2. **Ghost step** — sequenced item, whole content is own obsolescence. Ex: "5. No longer check connectivity, push fails anyway." Counter (keep): step still performs check, even changed form.
3. **Meta-residue in agent-directed text** — file explains to future agent why shaped this way. Ex: "removed retry logic per user request 2026-01-01." Counter (keep): routing/scope line executing agent needs right now.
4. **Dead scaffolding** — abstraction/param/flag/branch, comment or name still frames it around consumer gone by reading. Judge only what's evident reading, not build-tool data-flow — needs call-graph or compiler → out of scope, leave to static tooling. Ex: unused `retryCount` param, comment still explains absent retry path.
5. **Superseded wording** — old phrasing beside replacement, two sources of truth. Ex: rule restated two ways same file, one stale.
6. **Defensive apology** — "intentionally does not X" / "deliberately avoid Y", no live decision behind it — no one risks re-adding X/Y, no ambiguity without note.

## Runtime vs maintenance

| Context | Status | Action |
| --- | --- | --- |
| Runtime (executable code, agent instructions read at load/exec) | Obstacle — eats context, misroutes behavior | Cut |
| Maintenance (why changed, historical decision) | Real info, belongs git history/changelog not artifact | Cut from artifact |
| Inverse Chesterton's fence: note exists, removing thing once caused real documented failure | Genuine survivor | Keep, rewrite as current-state constraint ("do X, Y fails otherwise"), never history note ("used to do X") |

Third row narrow. Default cut. Claim survivor only with concrete failure mode reader must avoid repeating.

## Per-artifact-type notes

- **Code**: comments on removed behavior, unused params/branches/flags with caller gone, dead conditionals guarding path nothing triggers.
- **Docs/prose**: sentences justifying absence of arbitrary things ("does not cover X"), version-history asides in current-state description.
- **Agent-directed text**: workflow steps kept only to explain own removal; meta commentary aimed at maintaining agent not executing agent; "why" prose where file should carry only what/when/how.

## Output contract

Finding: `path:line — <label> — one-line why it passes zero-impact test`. Labels: `negative-doc`, `ghost-step`, `meta-residue`, `dead-scaffolding`, `superseded-wording`, `defensive-apology`.
Survivor: `path:line — KEEP — concrete failure mode this note prevents`.
Can't classify with evidence at hand: `path:line — UNRESOLVED — what's missing to decide`. Never force KEEP or vestige without concrete basis. Never silently drop candidate.
Zero findings: state plainly, don't force output.

## Workflow

1. Read target fully or by section. Grep hits alone insufficient — vestiges semantic.
2. Optional: `scripts/prefilter` for candidate lines. High recall, low precision — starting scan, not verdict.
3. Apply core mechanic per candidate, per suspicious taxonomy match.
4. Classify: vestige (list for deletion), survivor (concrete failure mode, narrow inverse-fence row), unresolved (state what's missing) if neither call confidently supportable.
5. Emit per contract. No deletion unless user/calling workflow asked direct edits — default read-only report.

## Boundaries

- Not code review, correctness check, style critique.
- Not static dead-code/unused-import analysis — linter/compiler job. This skill targets what tooling can't see: prose, intent, sequence, meta-commentary.
- Never relocates cut content to changelog/ADR. Git history is archive; skill only IDs what to cut, never where it should live.
- Distinct from correctness/alignment auditing of agent-directed instruction artifacts (AGENTS.md, agent defs, skills, commands): that asks artifact internally consistent + aligned with intent; this asks specific lines deletable with zero impact. Both can run same file, different question.

## Verification

- Every vestige finding passes core mechanic question explicitly, not pattern match alone.
- Every KEEP states concrete failure mode, not "seems important."
- No deletions unless explicitly requested.
