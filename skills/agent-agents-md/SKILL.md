---
name: agent-agents-md
description: "Maintain any file named `AGENTS.md` at any scope: add, change, trim, audit, or create. Decide which scope in the inheritance chain owns a rule. Reject rules that belong elsewhere. Rewrite user wording into durable dense intent. Trigger: `AGENTS.md`, agent rule, agent policy file, repo/global agent instructions. Not for skill files, subagent files, primary agent definitions, slash commands, or general project docs."
license: MIT
---

# Skill: agent-agents-md

Specialization of the generic agent-artifact authoring workflow. That workflow's rules (reject-first, dense agent-facing style, no dead refs, no stubs, frontmatter/body split) still apply — not repeated here. This file covers only what is specific to `AGENTS.md`.

`AGENTS.md` loads every session in its scope. Every line is a permanent tax on every future session. Admission bar is higher than any other artifact.

## Admission: reject or relocate

Any ONE of these is sufficient to reject. Do not add silently; state which applied.

1. **One-off instruction** — belongs in the current prompt, not a durable file.
2. **Task-scoped note / handoff** — belongs in the repo's progress-notes location (e.g. `.agent/progress/`).
3. **Design decision / architecture / ADR** — belongs in the repo's durable-notes location (e.g. `.agent/notes/`).
4. **Procedure with steps** — belongs in a skill. `AGENTS.md` keeps only the trigger + pointer.
5. **Wrong scope** — repo fact in a cross-project file, or cross-project habit in a repo file.
6. **Already implied** — a parent or broader rule in the chain covers it.
7. **Duplicate / reword of a working rule** — merge into the stronger wording or leave alone.
8. **Vague slogan** — "be careful", "think harder". Unactionable.
9. **Soon-stale** — describes a moving target.
10. **Unverifiable ref** — names a skill, tool, or path that does not exist.

Borderline and the user insists: add, but say which criterion it strains.

## Router, not warehouse

- `AGENTS.md` routes and constrains. It never stores procedures, reference material, or explanation.
- Long procedure → move body to a skill/doc, keep one trigger line here. Creating or editing that other artifact is outside this skill: report the need and hand off or ask first. Never author it silently.
- Rule needs a "why" to be obeyed correctly → one clause, inline. Otherwise the why goes in a doc.

## Scope selection

Read the whole chain first: target file, its parents, up to the user-global file. Then place by blast radius.

| Rule type                    | Scope                                       |
| ---------------------------- | ------------------------------------------- |
| Personal cross-project habit | User-global `AGENTS.md`                     |
| Repo workflow / style / tool | Project `AGENTS.md`                         |
| Subdir-only constraint       | Nested `AGENTS.md` in that subdir           |

- Scope is ambiguous and the wrong pick changes blast radius: ask one short question. Never guess.
- Broad cross-project policy with unclear impact: ask before writing.
- No suitable file exists at the warranted scope: create it from `AGENTS.template.md`.

## Inheritance and conflicts

- Nearest applicable file wins. A child narrows or overrides its parent.
- Child never restates a parent unless it narrows or overrides.
- Parent never absorbs a single repo's quirks.
- Duplicate meaning across the chain: keep the clearer one, delete the other.
- New rule must not silently widen an existing rule's scope.
- Harmful rule requested: say so plainly, offer the safer version.

## Edit workflow

1. Read the chain (target + parents).
2. Extract durable *intent* from the request. Paste user wording only when the wording itself matters.
3. Run admission checklist. Reject or relocate before writing.
4. Pick scope.
5. Write dense. Existing neighbor bullet covers the idea: merge into it instead of adding a line.
6. Verify every skill / tool / path the rule names actually resolves in the scope that loads this file. Dead ref: fix or drop the rule.
7. Re-read the whole file. Trim duplicates, weak lines, bloated examples introduced earlier.
8. Report: changed, rejected, relocated, why.

## Orientation facts (project scope only)

Exception to *router, not warehouse*: orientation facts ARE routing — tell agent where go before it asks. Project `AGENTS.md` must carry them.

Admit fact only if all hold:
- **High signal** — changes where agent goes or what it touches.
- **High veracity** — stable across months, not moving target.
- **Not self-evident from names** — bare path list derivable; ROLE, ownership, boundary not. Store role, not listing.

Typical set (5-12 lines total): purpose; top-level dirs, one clause role each; entry points to read first; unspoken boundaries (generated, vendored, protected, not-source-of-truth); build/test reality if non-obvious.

Never: file-by-file inventory, counts, anything regenerable, aspirational structure.

Write triggers — only three; outside them leave section alone:

1. **Init** — creating file. Explore enough to fill set honestly.
2. **Manual** — user asks refresh.
3. **Shape shift** — work just moved dirs, entry points, boundaries. Update moved fact only; no re-audit.

Exploration costs. Facts already in context: write them. Trigger 2/3, not in context: probe shifted area only.

## Creation

- Start from `AGENTS.template.md`. Delete the header comment and every section the project does not need.
- Empty or placeholder-only section is worse than no section.
- Do not invent project facts. Unknown value: ask or omit the line.
- `## Info` is mandatory at project scope: fill the orientation set above before anything else.

## Boundaries

- Only touch files named `AGENTS.md`. Other artifacts: hand off.
- File grows past what its readers can hold in head: split or trim, do not append.
