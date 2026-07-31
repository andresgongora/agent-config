---
name: authoring-agents
description: >
  Workflow for creating, editing, or reviewing agent ecosystem artifacts: skill files
  (SKILL.md), subagent files (agents/*.md), primary agent definitions, and slash commands
  (commands/*.md). Load when authoring or auditing any of these four file forms. Not for
  AGENTS.md rule-policy work (reject-first checklist, which rules belong — that is the
  AGENTS.md-maintenance behavior). Not for prose writing, code, or general docs.
---

# authoring-agents

## Core rules

- Reject-first. Every new artifact must earn its place. Default answer: no. Bloat is the main failure mode.
- One job per artifact. Sharp boundaries beat overlapping capabilities.
- Decouple. Reference other skills/subagents by behavior keyword, never hard name. `deploy/AGENTS.md` is the only glue point that may name skills.
- Cheap-model test. A correct artifact works with a smaller model than you used to write it. If it only works strong, tighten the prompt.
- Template-first. Copy the matching template from `templates/`, fill it, validate. Do not author from blank.
- No dead refs. Every path, skill, tool named must exist at ship time.
- Ship paired: every skill folder needs both `SKILL.md` (LLM-facing) and `README.md` (human/maintainer). Subagents do NOT need a README.
- Check for duplicates before creating. Grep `skills/` and `agents/` first. Extend or replace; never add a competitor.

## File placement

| Artifact | Location |
|---|---|
| Skill (LLM-facing) | `skills/<name>/SKILL.md` |
| Skill README (human) | `skills/<name>/README.md` |
| Skill executable assets | `skills/<name>/scripts/` — create only when needed; never beside `SKILL.md` |
| Subagent | `agents/<name>.md` |
| Nested subagent family | `agents/<family>/` |
| Primary agent | `agents/<name>.md` |
| Slash command | `commands/<name>.md` |

Prefer standalone files under `agents/` over inline blocks in client config. File is source of truth; client config handles cross-agent policy and MCP wiring only.

## Skill file form

Frontmatter:
- `name`: lowercase-hyphenated, gerund preferred
- `description`: third-person, ≤4 sentences, trigger phrases + explicit non-triggers. Routing truth lives here; do NOT repeat in body.

Body rules:
- One `#` title, shallow `##` sections only (no `###`)
- Flat bullets for policy; numbered lists only for ordered workflow
- ≤ ~500 lines total; bulky templates/examples → one-level-deep reference files, link from body
- Body = post-load behavior (workflow, boundaries, decision rules, output contract). Never trigger text.

Companion README must include: one-line what, design intent, trigger summary, maintainer constraints, see-also.

See template: `templates/skill.md`.

## Subagent file form

Frontmatter fields (all required unless noted):
- `description`: routing truth — first sentence exact task, second when-to-pick-this-agent, optional third non-uses. Optimize for correct delegation, not brevity.
- `mode: subagent`
- `model`: pin explicitly. Tier: cheap for locators/reviewers, balanced for general execution, strong only when justified.
- `temperature`: low (0.1–0.3) for exact bounded output; higher when useful diversity > variance.
- `tools`: default-deny. Enable only what the subagent truly needs.
- `permission`: narrow allowlist for `bash`; scoped allowlist for `task`. Never `"*": "allow"`.

Nested subagents:
- Default: subagents cannot spawn subagents.
- Enable per-subagent via `permission.task` allowlist.
- Depth cap: 5. Scope `task` to specific children only.
- Global `permission.task: "allow"` enables unbounded recursion — never do this.

Body: output contract + behavior. Short. Define output shape, stopping conditions, refusal triggers.

See template: `templates/subagent.md`.

## Agent file form

Primary agent / AGENTS.md-adjacent definition:
- `name`, `description` (role boundary, not implementation)
- `model`, `temperature`: pin explicitly
- `tools` + `permission`: permission profile by role (cli / build / files / chat / narrow). Rule order: broad `"*": deny` first, specific overrides last.

Body: role boundary, what it does NOT do, output contract if structured, stopping/refusal conditions. Do NOT restate AGENTS.md rule-policy in the body — that is the AGENTS.md-maintenance behavior.

See template: `templates/agent-file.md`.

## Command file form

Slash commands are agent-directed instructions invoked by name. No model, no tools, no output contract — just behavior the agent must follow when the command fires.

Frontmatter:
- `description`: one sentence. What this command does. Shown in command picker; routing truth.

Body rules:
- Imperative dense prose. No bullet lists unless order matters. No headers.
- State what to do, in what order, under what conditions. No narration, no filler.
- Use `$ARGUMENTS` for user-supplied input. Handle missing gracefully (fallback or ask).
- Reference skills by behavior keyword, not hard name.
- No output contract section — command body IS the contract.
- Target length: fits on one screen. Long commands signal over-scoping; split or trim.

No README needed. No template — commands are too short to warrant one.

## Authoring workflow

1. Check for name collision: grep `skills/` or `agents/` for existing artifact.
2. Decide file type (skill / subagent / primary agent / command) and location.
3. Copy the matching template from `templates/` (skills/subagents/agents); commands have no template — write directly.
4. Fill frontmatter: `name`/`description` are routing truth — write these last, after body is stable.
5. Write body following the form rules above.
6. Trim: if body exceeds ~500 lines, extract to reference file and link.
7. Add `scripts/` only when skill owns executables; place every executable there. Pure Markdown skills keep no empty folder.
8. Ask before shipping: would a cheaper model succeed with this prompt? If no, tighten.
9. Verify (see section below).
10. If replacing/obsoleting an existing artifact: grep for all inbound refs; update or remove in the same change.

## Decoupling checklist

Before naming any other skill/subagent:
- Is this a dependency (breaks if referenced artifact removed) or an example (survives swap)?
- If dependency: decouple — describe by behavior keyword instead.
- Swap test: if the referenced artifact were replaced by an equivalent, would this artifact still work?

Same-family exception: artifacts in one family (e.g. `cavecrew-*`) may name each other. Cross-family stays behavior/trigger-only.

## Risks

| Risk | Mitigation |
|---|---|
| Hard-name coupling | Reference by behavior keyword; swap-test before shipping |
| Duplicate skill/agent | Grep before creating; extend or replace |
| Verbose skill (marketing prose) | Enforce dense fragment style; reject if reads like a blog |
| Wide bash allowlist in subagent | Narrow allowlist; default-deny + explicit allows |
| Subagent spawns subagents by default | Scope `permission.task` to specific children only |
| Skill without README | Always ship both for skills |
| Inline template cue contradicts SKILL.md rule | Cues are pointers only; full rules stay in SKILL.md |
| Dead ref after note/artifact deletion | Grep all inbound refs; fix in same change |

## Verification

After creating or editing:
- [ ] Frontmatter YAML parses cleanly
- [ ] Skill: `SKILL.md` + `README.md` both present
- [ ] Command: no README, fits one screen, `$ARGUMENTS` handled
- [ ] `description` is routing truth; no trigger phrases duplicated in body
- [ ] No hard-name coupling to other skills (behavior keywords only)
- [ ] No dead refs to paths/skills/tools that don't exist
- [ ] Templates reference one level deep (not inlined)
- [ ] If replacing an artifact: all inbound refs updated or removed

## Boundaries

- Not for AGENTS.md rule-policy (which rules belong, reject-first discipline) — use the AGENTS.md-maintenance behavior.
- Not for prose/documentation writing — use reader-facing writing behavior.
- Not for general repo docs (`.agent/notes/`, architecture) — use docs discipline behavior.
- Stop if asked to rewrite existing skills as part of a new-skill task — log as follow-up, do not touch.
