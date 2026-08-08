---
name: agent-author
description: "Workflow for creating, editing, or reviewing agent ecosystem artifacts: skill files (SKILL.md), subagent files (agents/*.md), primary agent definitions, and slash commands (commands/*.md). Load when authoring or auditing any of these four file forms. Not for any file named `AGENTS.md` — rule policy, edits, audits, and creation all belong to the AGENTS.md-maintenance behavior. Not for prose writing, code, or general docs."
license: MIT
---

# agent-author

## Core rules

- Reject-first. Every new artifact must earn its place. Default answer: no. Bloat is the main failure mode.
- One job per artifact. Sharp boundaries beat overlapping capabilities.
- Decouple. Reference other skills/subagents by behavior keyword. Hard names only for `deploy/AGENTS.md` glue or same-family siblings.
- Cheap-model test. A correct artifact works with a smaller model than you used to write it. If it only works strong, tighten the prompt.
- Template-first. Copy the matching template from `templates/`, fill it, validate. Do not author from blank.
- Agent-facing prose: dense, imperative, exact. Fragments OK. Remove narration, filler, marketing, repeated rules. Preserve needed order and safety clarity.
- Steps, ordered instructions, warnings: apply STE100 (ASD Simplified Technical English) principles — one term per concept, active voice, short direct sentences — where ambiguity would cost the executing agent. Recommendation, not a gate: exact jargon or a denser precise term wins when STE100 phrasing would blur meaning. Skip for reference tables, frontmatter, and non-instructional prose.
- WHAT + HOW in artifact; WHY → README. Exception: keep WHY in artifact when executing agent needs it to act correctly; keep routing-relevant WHY in frontmatter.
- No stubs. Artifact holds only text the executing agent needs. Maintainer-facing meta — obsolete-decision residue, "no longer handles X", "removed per request", inverse rules with no active concern — goes to README, never the body.
- No dead refs. Every path, skill, tool named must exist at ship time.
- Ship paired: every skill folder needs both `SKILL.md` (LLM-facing) and `README.md` (human/maintainer). Subagents do NOT need a README.
- Check for duplicates before creating. Grep `skills/` and `agents/` first. Extend or replace; never add a competitor.

## Frontmatter

Primary routing surface. Always in scope. Specificity governs load correctness — vague loads when unneeded, narrow misses when needed. Applies to every file form's frontmatter (`description` and any routing field).

- One line per field. No line-wrapping a single value across multiple lines. Long `description` stays one physical line.
- Current-state only. The no-stubs rule above applies here; additionally no roadmap ("load when Z even if incomplete") and no "load other artifact instead".
- Information-dense. Concrete triggers + keywords highly correlated with the artifact's job. Include explicit non-triggers where a sibling scope could misfire.
- No hard coupling. Frontmatter names no other skill/subagent. Describe boundary scopes by behavior, never by artifact name.
- Same agent-directed style as body: dense, imperative, exact, fragments OK. Frontmatter WHY limited to routing rationale needed for correct loading.

## File placement

| Artifact                | Location                                                                    |
| ----------------------- | --------------------------------------------------------------------------- |
| Skill (LLM-facing)      | `skills/<name>/SKILL.md`                                                    |
| Skill README (human)    | `skills/<name>/README.md`                                                   |
| Skill executable assets | `skills/<name>/scripts/` — create only when needed; never beside `SKILL.md` |
| Subagent                | `agents/<name>.md`                                                          |
| Nested subagent family  | `agents/<family>/`                                                          |
| Primary agent           | `agents/<name>.md`                                                          |
| Slash command           | `commands/<name>.md`                                                        |

Prefer standalone files under `agents/` over inline blocks in client config. File is source of truth; client config handles cross-agent policy and MCP wiring only.

## Skill file form

Frontmatter (see Frontmatter section):
- `name`: lowercase-hyphenated, gerund preferred
- `description`: third-person, ≤4 sentences, trigger phrases + explicit non-triggers. Routing truth lives here; do NOT repeat in body.

Body rules:
- One `#` title, shallow `##` sections only (no `###`)
- Flat bullets for policy; numbered lists only for ordered workflow
- ≤ ~500 lines total; bulky templates/examples → one-level-deep reference files, link from body
- Body = post-load behavior (workflow, boundaries, decision rules, output contract). Never trigger text.
- Own-script refs: bare relative only (`scripts/foo`). Never `<skill-root>/scripts/foo` (unresolved placeholder, weak models run it literally), never hardcoded absolute deploy path (`~/.config/opencode/skills/foo/scripts/bar` — breaks under any other deploy root). Skill loader appends a base-dir footer at load time; bare relative is the one form that resolves against it everywhere.

Companion README must include: one-line what, design intent, trigger summary, maintainer constraints, see-also. Write it human-facing and readable — plain prose, no AI slop.

Where a skill's own workflow has a step that a bounded worker could run standalone (locate, mechanical edit, isolated review): add a one-line delegation hint at that step, only when the split earns its place — do not invent a step just to hint delegation.

See template: `templates/skill.md`.

## Agent file form

Covers both primary agent definitions and subagents (bounded workers invoked by another agent). One template, one section — shared rules first, then a subagent-only delta.

Shared:
- `name`, `description`. Primary agent: role boundary, not implementation. Subagent: routing truth — first sentence exact task, second when-to-pick-this-agent, optional third non-uses. Optimize subagent description for correct delegation, not brevity.
- Runtime configuration: target-client schema. Pin model explicitly with target runtime field. Sampling: omit by default; set only deliberate, tested behavior. Least privilege; broad denial before specific grants when schema has ordered permission rules.
- Body: role boundary, what it does NOT do, output contract if structured, stopping/refusal conditions. Do NOT restate `AGENTS.md` rule-policy in the body.

Subagent-only delta:
- Tools: default-deny, enable only needed access. Command access: narrow. Delegation: named children only; never broad grant. Ordered permissions: deny before grant.
- Locked-down agent: lead bash block `"*": deny`/`ask` — outranks global allows, forces full self-declared allowlist. Use when tight.
- Nested subagents: default cannot spawn subagents. Enable per-subagent via `permission.task` allowlist. Depth cap: 5, scoped to specific children only. Global `permission.task: "allow"` enables unbounded recursion — never do this.
- Mandatory report envelope — every subagent report ends with:
  - `status:` — exactly one of `done` `partial` `blocked` `refused` `none`
  - `gap:` — in-scope work not covered, or `none`

  Token strings are fixed; field formatting follows the agent's own style. `none` (ran fully, found nothing) is distinct from `done`. Refusal or terminal tokens the agent defines map onto a status value — bind them in one line, never restate their meaning. Envelope wraps the bespoke contract; it does not replace it.

  Envelope placement is load-bearing, not cosmetic. Agents copy the fenced example and ignore adjacent prose, so:
  - Put `status:`/`gap:` INSIDE the fenced output template, as its last two lines. A prose rule above the fence does not bind.
  - Ship a second fenced example for the empty-result or refusal path with the literal token (`status: none`, `status: refused`). A success-only example teaches `done` as the default.

See template: `templates/agent.md`.

## Command file form

Slash commands are agent-directed instructions invoked by name. No model, no tools, no output contract — just behavior the agent must follow when the command fires.

Decision checklist — write a command only if:
- Behavior is invoked by explicit user trigger (slash name), not by autonomous routing (that's a skill's job).
- The steps are a fixed one-off sequence run by that trigger, not a reusable policy consulted across many unrelated tasks. A reusable decision framework, admission bar, or checklist meant to be loaded and applied repeatedly → that's a skill, not a command.
- Body fits one screen even with ordered steps included.
- Needs tools/model/permissions of its own → that's a subagent, not a command.

Frontmatter:
- `description`: one sentence. What this command does. Shown in command picker; routing truth.

Body rules:
- Imperative dense prose or a numbered list when order matters. No headers.
- State what to do, in what order, under what conditions. No narration, no filler.
- Use `$ARGUMENTS` for user-supplied input. Handle missing gracefully (fallback or ask).
- Reference skills by behavior keyword, not hard name.
- No output contract section — command body IS the contract.
- Target length: fits on one screen. Long commands signal over-scoping; split or trim.
- Multi-step command with real delegation tradeoffs: add a minimal per-step `Delegate: allow|encourage|prohibit — reason` line. Skip entirely on a short/simple command — do not force it.
- Any command body written or edited: apply dense, compressed, low-filler phrasing — the same terse register a user gets by asking for fewer tokens or a briefer reply.

Dos: one clear trigger, one job, explicit `$ARGUMENTS` handling, ordered steps when order matters.
Don'ts: no README, no output contract section, no restating a skill's policy instead of pointing at it, no hard skill/subagent names.

No README needed. See template: `templates/command.md`.

## Workflow

1. Classify request: create, edit, or read-only audit. Identify file form, target client, intended reader, and success evidence. Target basename is `AGENTS.md`: stop here and load `agent-agents-md` instead (same family; it owns that file entirely).
2. Inspect target and governing local rules. For creation, grep `skills/` or `agents/` for collision. For edit/audit, read current artifact first; never replace it with a fresh template.
3. Create: choose location. Skill: copy `templates/skill.md` + `templates/skill-readme.md`. Subagent/primary agent: copy `templates/agent.md`. Command: copy `templates/command.md`. Edit: change smallest affected surface. Audit: make no mutations; collect `path:line` evidence, impact, and fix direction.
4. Write or revise body first. Use form rules; dense agent-facing language. Write routing frontmatter last. Configure runtime fields against target-client schema, not template defaults.
5. Trim: if body exceeds ~500 lines, extract reference file. Add `scripts/` only for owned executables. If replacing/obsoleting: grep inbound refs; update/remove same change.
6. Run verification. Cheap-model test: would smaller model succeed? If no, tighten.
7. Ready-to-ship artifact: delegate clean-context final review to a read-only artifact evaluator. Give target, intent, scope, and applicable rules. Incorporate justified findings; re-verify. Skip only trivial, mechanical edits; state skip reason.

## Decoupling checklist

Before naming any other skill/subagent:
- Is this a dependency (breaks if referenced artifact removed) or an example (survives swap)?
- If dependency: decouple — describe by behavior keyword instead.
- Swap test: if the referenced artifact were replaced by an equivalent, would this artifact still work?

Same-family exception: permit artifacts in one family (e.g. `cavecrew-*`, `agent-*`) to name each other. Cross-family stays behavior/trigger-only.

## Risks

| Risk                                          | Mitigation                                                |
| --------------------------------------------- | --------------------------------------------------------- |
| Hard-name coupling                            | Reference by behavior keyword; swap-test before shipping  |
| Duplicate skill/agent                         | Grep before creating; extend or replace                   |
| Verbose skill (marketing prose)               | Enforce dense fragment style; reject if reads like a blog |
| Wide bash allowlist in subagent               | Narrow allowlist; default-deny + explicit allows          |
| Command allowlist ignores compound commands   | Grant shell no-ops (`exit`, `true`, `continue`, `test`); clients match per sub-command |
| Baseline grants copied into every primary agent or subagent | Baseline belongs in runtime config; each carries role deltas only |
| Subagent spawns subagents by default          | Scope `permission.task` to specific children only         |
| Skill without README                          | Always ship both for skills                               |
| Inline template cue contradicts SKILL.md rule | Cues are pointers only; full rules stay in SKILL.md       |
| Dead ref after note/artifact deletion         | Grep all inbound refs; fix in same change                 |

## Verification

After creating or editing:
- [ ] Frontmatter YAML parses cleanly
- [ ] Each frontmatter field on one physical line (no wrapped values)
- [ ] No stubs or maintainer-facing residue in frontmatter or body (README only); frontmatter also free of roadmap and "load other artifact instead"
- [ ] Frontmatter names no other skill/subagent; boundary scopes by behavior
- [ ] `description` dense with correlated keywords + explicit non-triggers where a sibling could misfire
- [ ] No placeholders, scaffold comments, or template-only examples remain; required values are concrete
- [ ] README (skills): human-facing, readable, no AI slop
- [ ] Skill: `SKILL.md` + `README.md` both present
- [ ] Command: no README, fits one screen, `$ARGUMENTS` handled, dense/compressed phrasing throughout
- [ ] Command: `Delegate:` per-step tags present only where a real tradeoff exists, never forced on a trivial command
- [ ] `description` is routing truth; no trigger phrases duplicated in body
- [ ] Named skills/subagents use behavior keywords unless same-family exception passes swap test
- [ ] Subagent: report ends with `status:` (one of `done` `partial` `blocked` `refused` `none`) and `gap:`; every refusal or terminal token maps to a status and is payload, not a replacement
- [ ] Subagent: envelope sits inside the fenced output template, and a second fence shows the empty-result or refusal path with a literal non-`done` token
- [ ] No dead refs to paths/skills/tools that don't exist
- [ ] Templates reference one level deep (not inlined)
- [ ] Skill's own script refs are bare relative (`scripts/foo`), no `<skill-root>` placeholder, no hardcoded absolute deploy path
- [ ] If replacing an artifact: all inbound refs updated or removed
- [ ] Ready-to-ship non-trivial artifact received clean-context read-only evaluation; justified findings resolved or recorded

## Boundaries

- Not for files named `AGENTS.md` — rule policy, edits, audits, creation. Hand off to `agent-agents-md`.
- Not for prose/documentation writing — use reader-facing writing behavior.
- Not for general repo docs (`.agent/notes/`, architecture) — use docs discipline behavior.
- Stop if asked to rewrite existing skills as part of a new-skill task — log as follow-up, do not touch.
