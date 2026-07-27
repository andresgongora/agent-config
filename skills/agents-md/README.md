# agents-md

Guardrails for maintaining `AGENTS.md` files. Prevent bloat, keep rules durable.

## What it does

Gives the agent a rejection-first workflow for updates to `AGENTS.md`:

1. **Reject checklist** first — most requests to "add a rule" belong somewhere else (docs, one-shot prompt, or a durable rule at a different scope). Skill catches these before they pollute the file.
2. **Scope selection** — decides whether a rule belongs in the Home, project, or nested `AGENTS.md`. Wrong scope = worse than no rule.
3. **Dead-ref detection** — catches rules that reference skills/tools/paths that don't exist. Dead refs cost tokens every load, forever.
4. **Caveman rewrite** — user wording → compact durable intent. Fewer tokens per read.

Design intent:

- **AGENTS.md is high-leverage, easy to misuse.** It loads every session. Every extra line is a permanent tax. Skill's job is to say NO by default.
- **`AGENTS.md` is a router, not a warehouse.** Put durable behavior there; put deep procedures and reference material in skills or `.agent/`.
- **Layered memory model.** `AGENTS.md` (behavior) / `.agent/` (reference, handoff, bug logs). Rules that fit the wrong layer make the wrong layer worse.
- **Dead refs are the silent killer.** A trigger like "load `parallel-workflow` skill" that points at a non-existent skill wastes tokens every trigger attempt. Skill actively checks.

## How to invoke

Loads when the request mentions `AGENTS.md`, adding/changing/trimming a rule, agent policy, or creating a new `AGENTS.md`.

Also worth loading proactively when auditing an existing `AGENTS.md` for bloat or stale refs.

## Structure

- `SKILL.md` — LLM-facing. Reject checklist, workflow, style rules.
- `README.md` — this file. Human-facing.
- `AGENTS.template.md` — starting point for a new `AGENTS.md`. Keep aligned with the actual convention used in real files.

## Layered Memory Model (Reference)

| Layer | Purpose | Loaded when |
|---|---|---|
| Home `AGENTS.md` | Cross-project behavior | Every session (loaded by the AI-agent client) |
| Project `AGENTS.md` | Repo-local workflow, style, tooling | Every session in that repo |
| Nested `AGENTS.md` | Subdir-only constraints | When working in that subdir |
| `.agent/` | Architecture, reference, ADRs, project state, task handoff, bug attempts | On demand |

Rule of thumb for placement:

- **Durable + cross-project** → Home
- **Durable + repo-specific** → project
- **Durable + subdir-specific** → nested local
- **Design / reference / task handoff / bug log** → `.agent/` (owned by the docs skill)

## Revising this skill

- **Keep caveman.** SKILL.md loads on every trigger. Verbose prose = permanent tax.
- **Reject checklist stays at the top.** It is the primary value of the skill. Buried, it does not fire.
- **Do not couple to caveman skill.** SKILL says "caveman-compressed style" as an outcome. If caveman is swapped for another compression style, skill still works.
- **Template must match reality.** If real `AGENTS.md` files evolve conventions (new section, different structure), update `AGENTS.template.md` too. Template that misleads = worse than no template.
- **Dead-ref rule is load-bearing.** If skill starts letting dead refs slip, AGENTS.md rots. Do not soften.

## Common Failure Modes (What This Skill Prevents)

- `AGENTS.md` grows to 300+ lines of half-forgotten rules
- Same rule stated three different ways in three sections
- Rule triggers a skill that does not exist
- Task-scoped note ends up in a permanent file
- Project quirk pollutes the Home file
- Vague slogans nobody follows ("be thoughtful", "consider carefully")

## See also

- `SKILL.md` — the workflow
- `AGENTS.template.md` — bootstrap template
- `../authoring-agents/SKILL.md` — skill for creating/editing skill files, subagent files, agent definitions
- `../docs/SKILL.md` — sister skill for `.agent/` maintenance
