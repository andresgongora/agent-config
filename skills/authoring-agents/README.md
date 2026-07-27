# authoring-agents skill

Workflow skill for creating, editing, or reviewing agent ecosystem artifacts: `SKILL.md` files, subagent files (`agents/*.md`), and primary agent definitions.

## Design intent

This skill exists because authoring these three file forms has consistent, repeatable patterns that a cheaper model can follow if given the right template and rules — but gets wrong without them. It distills:

- File-form guidance from Anthropic agent-skills best practices and OpenAI prompt-engineering guidance (vendor-neutral framing)
- Durable how-to rules previously in `.agent/notes/authoring-skills-and-subagents.md` (that note dissolved into this skill)
- Three self-informing templates that instantiate the taught form and can guide authoring from the template alone

The guiding rationale: context is the scarcest resource. Skills are read on every trigger — a skill 40% smaller means 40% cheaper each load, for the lifetime of the skill. The same applies to subagents encapsulating work that would otherwise pollute the main thread. Write for the smallest model that can still succeed. Template + explicit rules does the shape-work; model fills in the content.

## When it triggers

- Writing or editing a new `SKILL.md`
- Writing or editing a subagent file (`agents/*.md`)
- Writing or editing a primary agent definition
- Auditing any of the above for correctness, coupling, or bloat

## When it does NOT trigger

- AGENTS.md rule-policy work (which rules belong, reject-first discipline) — that is the AGENTS.md-maintenance skill's job
- Prose / reader-facing writing — reader-facing writing behavior
- General `.agent/` docs or architecture notes — docs discipline behavior

## Maintainer constraints

- **No name-coupling in SKILL.md body.** Reference other skills/subagents by behavior keyword. `deploy/AGENTS.md` is the only file allowed to name skills directly. Adding a hard skill name in the body creates coupling that breaks on rename.
- **Progressive disclosure.** SKILL.md stays ≤ ~500 lines. Templates, long examples, reference tables → one-level-deep reference files linked from SKILL.md. If SKILL.md grows past 500 lines: extract, do not inline.
- **Keep templates self-informing and in sync.** Templates carry pointer/reminder cues only — full rules stay in SKILL.md. If you change a rule in SKILL.md, check whether template inline cues still point correctly. Cues that restate or contradict SKILL.md rules diverge silently. Swap-test: SKILL.md must stand without the templates; templates must be usable with only their own inline cues.
- **Goals-vs-form separation.** SKILL.md body = post-load behavior (rules, workflow, output contract). Rationale, token economics, model-routing philosophy → this README. Do not move rationale into SKILL.md.
- **Reject-first discipline still applies.** This skill is authoring guidance, not a license to add. Check duplicates, evaluate whether an existing artifact can be extended instead.

## Reference files (one level deep)

- `templates/skill.md` — fillable `SKILL.md` skeleton with inline authoring cues
- `templates/subagent.md` — fillable subagent frontmatter + body scaffold
- `templates/agent-file.md` — fillable primary agent definition skeleton

## See also

- `AGENTS.md` (repo-local) — "Adding a New Skill" and "Adding a New Subagent" steps; repo rules this skill implements
- `deploy/AGENTS.md` — skill-triggers table; where `authoring-agents` is registered
- `.agent/notes/design-principles.md` — broader ecosystem why (layer model, memory placement, context pollution)
- AGENTS.md-maintenance behavior — AGENTS.md rule-policy, reject-first checklist (separate concern)
- Docs discipline behavior — `.agent/` documentation conventions
