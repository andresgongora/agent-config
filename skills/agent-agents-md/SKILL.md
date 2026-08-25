---
name: agent-agents-md
description: "Manage `AGENTS.md`: create, change, trim, or audit at any scope. Execute immediately after repo rules, shape, entry points, or boundaries change to update applicable files. Assign rules to correct scope; reject misplaced, duplicate, or weak rules. Trigger: `AGENTS.md`, agent rule, agent policy file, repo/global agent instructions."
---

## Admission gate

`AGENTS.md` loads every session in its scope. Every line is a permanent tax on every future session. Admission bar is higher than any other artifact.

Any ONE of these is sufficient to reject. Do not add silently; state which applied.

- **One-off instruction**: belongs in the current prompt, not a durable file.
- **Task-scoped note / handoff**: write instead into the repo's progress-notes location (e.g. `.agent/progress/`).
- **Design decision / architecture / ADR**: write instead into the repo's durable-notes location (e.g. `.agent/notes/`).
- **Procedure with steps**: belongs in a skill. `AGENTS.md` keeps only the trigger + pointer.
- **Wrong scope**: repo fact in a cross-project file, or cross-project habit in a repo file.
- **Already implied**: a parent or broader rule in the chain covers it.
- **Duplicate / reword of a working rule**: merge into the stronger wording or leave alone.
- **Vague slogan**: "be careful", "think harder". Unactionable.
- **Soon-stale**: describes a moving target.
- **Unverifiable ref**: names a skill, tool, or path that does not exist.

Borderline on a soft criterion (vague slogan, soon-stale) and the user insists: add, say which criterion it strains. Hard criteria — wrong scope, unverifiable ref, already implied, duplicate — never yield to insistence; fix the underlying problem first.

## Rules

### General

- `AGENTS.md` routes and constrains. It never stores low-signal procedures, reference material, or explanations.
- Long procedure → move body to a skill or write a doc, keep one trigger line here. Creating or editing that other artifact is outside this skill: report the need and hand off or ask first. Never author it silently.
- Rule needs a "why" to be obeyed correctly → one clause, inline. Otherwise the why goes in a doc.

### Information to store

`AGENTS.md` may store information or facts besides routing and instructions. All must hold:

- **Near-certain need**: agents likely to benefit from this fact if touching the repo.
- **Not derivable**: not obtainable faster by glob/read than by reading the line.
- **Stable**: likely unmutable long-term, like general repository information, goals, or general structure.

Fails any check: put it in agent docs, not `AGENTS.md`.

Orientation facts (the `## Info` block) update only on: init (creating the file), user asks to refresh, or repo shape/entry-points/boundaries just moved. No other trigger re-probes them — re-exploring "to keep fresh" costs more than the section saves.

### Scope selection

| Rule type | Scope |
|---|---|
| Personal cross-project habit | User-global `AGENTS.md` |
| Repo workflow / style / tool | Project `AGENTS.md` |
| Subdir-only constraint | Nested `AGENTS.md` in that subdir |

Ambiguous and the wrong pick changes blast radius: ask one short question, never guess. No file exists at the warranted scope: create it (see Creation).

### Nested chain

`AGENTS.md` files combine while traversing upward from the current directory to system-level rules. Instructions can conflict; there is no runtime "nearest wins" mechanism.

- Read the whole chain before adding a new rule.
- Parent already covers it: don't duplicate. Parent is weaker: child may use stronger wording.
- Duplicate meaning across the chain: keep the clearer one, delete the other, inform user.
- New rule must not silently widen an existing rule's scope.
- Child rule conflicts with a parent rule: warn, don't silently override.
- Harmful rule requested: say so plainly, offer the safer version.

## Workflow

### Creation

Create `AGENTS.md` at a scope only if all hold:

- No `AGENTS.md` in the chain already covers this scope's routing needs.
- At least one durable, non-placeholder fact or rule exists to put in it now.
- Scope is unambiguous (see Scope selection).

Steps:

1. Copy `AGENTS.template.md`. Delete the header comment and every section the project does not need; empty or placeholder-only section is worse than no section.
2. Fill remaining sections with project-specific facts only: purpose, top-level dirs, entry points, boundaries, build/test reality if non-obvious. Do not invent facts; unknown value: ask or omit the line. `## Info` is mandatory at project scope — fill it before anything else.

### Update

Applies whenever an existing `AGENTS.md` changes, at any scope.

1. Read the chain (target + parents).
2. Extract durable *intent* from the request. Paste user wording only when the wording itself matters.
3. Run admission checklist. Reject or relocate before writing.
4. Pick scope (see Scope selection).
5. Write dense. Existing neighbor bullet covers the idea: merge into it instead of adding a line.
6. Verify every skill / tool / path the rule names actually resolves in the scope that loads this file. Dead ref: fix or drop the rule.
7. Re-read the whole file. Trim duplicates, weak lines, bloated examples introduced earlier.
8. Report: changed, rejected, relocated, why.

## Guardrails

- Only touch files named `AGENTS.md`. Other artifacts: hand off.
- File grows past what its readers can hold in head: split or trim, do not append.
