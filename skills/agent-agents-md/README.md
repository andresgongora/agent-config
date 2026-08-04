# agent-agents-md

Keeps `AGENTS.md` files lean. Member of the `agent-*` authoring family — the specialization that handles one filename, `AGENTS.md`, while `agent-author` handles skills, subagents, agent definitions, and commands.

## Why it exists separately

`AGENTS.md` is not just another agent-facing file. It loads on every session inside its scope, and it exists in a chain — user-global, project, nested. That gives it two problems no other artifact has:

- **Permanent cost.** A mediocre rule in a skill costs nothing until the skill loads. A mediocre rule in `AGENTS.md` costs tokens forever. So the admission bar is higher, and the default answer is no.
- **Scope choice.** The same rule can be right in one file and actively harmful one level up. Picking the wrong scope is worse than not writing the rule.

Everything else — reject-first instinct, dense style, no dead refs, no stubs — comes from the generic authoring workflow. This skill deliberately does not repeat it.

## Structure

- `SKILL.md` — admission checklist, scope selection, inheritance rules, edit workflow.
- `AGENTS.template.md` — scaffold for a new file. Section shape matches the convention used by the real `AGENTS.md` files in this repo.
- `README.md` — this file.

## Maintainer notes

- **Admission checklist stays at the top.** It is the main value. Buried, it does not fire.
- **Any single criterion rejects.** Dead refs and one-off instructions fail admission.
- **Do not re-add generic authoring rules.** If a rule applies to skills and subagents too, it belongs in `agent-author`, not here.
- **Template must track reality.** If real `AGENTS.md` files grow a new convention, update the template. A template that misleads is worse than none.
- **Keep placement paths as examples.** `.agent/progress/` and friends are this repo's convention; the skill is used in other repos too, so they are written as examples, not requirements.

## See also

- `../agent-author/` — the generic sibling: skill files, subagent files, agent definitions, commands.
- `../docs-write/` — durable `.agent/` documentation, where relocated content usually lands.
