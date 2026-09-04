---
name: agent-author
description: "Workflow for creating, editing, or auditing agent-ecosystem artifacts: skills (SKILL.md), subagents and primary agents (agents/*.md), slash commands (commands/*.md), plus their routing frontmatter, description fields, output contracts, permissions, and companion READMEs. Load when any of these four file forms is authored, reviewed, or its trigger/description tuned."
---

## Core rules

- One job per artifact. Sharp boundaries beat overlapping capabilities.
- Strive for cheap AI-model compatibility. A correct artifact works with a smaller model than you used to write it. If it only works with large models, tighten the prompt.
- Template-first. Copy the matching template from `templates/`, fill it, validate. Do not author from blank. Inline template cues are pointers only — full rules stay in this SKILL.md; a cue never overrides a conflicting rule here.
- No stubs. Artifact holds only text the executing agent needs.
- `README.md`: each artifact has a human-facing companion README with relevant information that does not belong in the AI-facing artifact itself (eg obsolete-decision residue, "no longer handles X", "removed per request", inverse rules with no active concern). WHAT + HOW + WHEN relevant to runtime → artifact; WHY and everything else → README. Exception: keep WHY in artifact when executing agent needs it in frontmatter or to act correctly.

### Language

- Agent-facing prose: write artifacts with dense, imperative, exact language. Remove narration, filler, marketing, repeated rules. Preserve needed order and safety clarity.
- Simple beats specific language. Each rule must read clear to a non-expert; depth comes from combining simple rules, not one rule covering every case. Plain word beats jargon unless jargon is the precise term or saves a much longer explanation. Unambiguous means no unintended or contradictory reading, not maximum precision; context sets the agent's remaining freedom. Literal tokens, schema fields, routing keywords, and ordered steps still stay exact.

### Directives

- **Rules**: set default behavior and may state explicit exceptions. If following a rule would lead to a worse behavior, the agent may plainly state so and ask for override. This flexibility must be written into the artifact.
- **Guardrails**: set hard limits on unsafe, unauthorized, or out-of-scope actions. Guardrails override conflicting rules. Never infer exceptions to guardrails. Convey importance of guardrails; they must lead to an immediate stop when encountered, not a workaround.
- **Actionable directives**: apply STE100 (ASD Simplified Technical English) principles — one term per concept, active voice, short direct sentences — where ambiguity would cost the executing agent. Recommendation, not a gate: exact jargon or a denser precise term wins when STE100 phrasing would blur meaning. Use for steps, ordered instructions, warnings; skip for reference tables, frontmatter, and non-instructional prose.

### Inter-artifact coupling

- **Name coupling**: inter AI artifact reference by literal identifier/filename. Brittle: breaks silently if the target is renamed, replaced, or merged.
- **Behavioral reference**: reference by what the target does, not its name. Survives a swap to an equivalent artifact. Relies on runtime routing.

Default: behavioral reference only. Use name coupling only if the referenced artifact is in a declared same-family group with this one (e.g. `agent-*`, `minion-*`).

### Markdown style

- No hard-wrapping a logical instruction across physical lines; one instruction, one line, however long. Structural line breaks (blank line between sections, list items, table rows) stay.
- Agent-directed artifacts omit H1. Frontmatter and path identify artifact; start body with directive or `##` section. Exception: literal output template requiring H1.
- Paragraph, enumeration, bullet list: terminal punctuation `.`, `!`, `?`.
- Tables: compact, `---` columns, leading + trailing pipes.
- Maximum header depth: `##` preferred, `###` allowed for larger structures, `####` disallowed.

### YAML frontmatter

Primary routing surface, always in scope. During runtime, this is sole information given to AI-agent about available resources to decide if worthwhile loading. Core rules apply.

### File placement

| Artifact | Location |
|---|---|
| Skill (LLM-facing) | `skills/<name>/SKILL.md` |
| Skill README (human) | `skills/<name>/README.md` |
| Skill executable assets | `skills/<name>/scripts/` — create only when needed; never beside `SKILL.md` |
| Primary agent | `agents/<name>.md` |
| Subagent | `agents/<name>.md` |
| Nested subagent family | `agents/<family>/` |
| Slash command | `commands/<name>.md` |

## AI-agent artifact specialization

### `AGENTS.md`

- For files named `AGENTS.md` — rule policy, edits, audits, creation. Rules and instructions in `agent-agents-md` skill override this skill's rules in case of conflict. Load `agent-agents-md` immediately.

### Skill

**Template**: `templates/skill.md`.

**Frontmatter `description`**: Primary routing truth. Specificity governs load correctness. Design goal is to ensure consistent behavior:

- Capability statement + optional one-clause why.
- Explicit trigger conditions, e.g., "Load if A and B", "Load when C unless D". Broad conditions allowed only if accompanied by applicable context.
- Highest-signal trigger words verbatim (filenames, error strings, domain terms).
- Non-triggers when any credible and highly likely wrong-scope risk exists — i.e. accidental overlap the router could resolve incorrectly; skip when overlap is instead resolved by a declared same-family internal handoff (see Inter-artifact coupling). Only if risk exists, do not add non-triggers just to be exhaustive. When in doubt, sharpen the positive scope instead, prefer stating what artifact _is_ used for, not what it is _not_ used for.
- Minimize length, hard cap ≤100 words.
- Example: `"Discover existing repository knowledge cheaply before spending context on exploration. Load on non-trivial repo work: before a grep/glob/read sweep of an unfamiliar area, before answering how something works in this repo, when a past session may already have settled the question, when onboarding to a repo, or when a repo has an .agent/ directory."`

**Skill body text**:
- Body = post-load behavior (workflow, boundaries, decision rules, output contract). Never trigger text.
- Flat bullets for policy; numbered lists only for ordered workflow.
- ≤ ~500 lines total; bulky templates/examples → one-level-deep reference files, link from body.
- Subfolders: `scripts/` for owned executables; `templates/` for reference templates; `resources/` for all other owned files. No other subfolders.
- Links to own resources: bare relative only (`scripts/foo`), never `<skill-root>/scripts/foo`, never hardcoded absolute deploy path (`~/.config/opencode/skills/foo/scripts/bar`).
- Where a skill's own workflow has a step that a bounded worker could run standalone (locate, mechanical edit, isolated review): add a one-line delegation hint at that step, only when the split earns its place; do not invent a step just to hint delegation.

**Companion README**:
- Human-facing, readable, no AI slop.
- One-line what, design intent, trigger summary, maintainer constraints, see-also.

### Primary Agent and Subagent

**Frontmatter `description`**: Primary routing truth. Specificity governs delegation correctness. Design goal is to ensure consistent behavior:
- Exact task statement.
- Explicit trigger conditions, when to pick this agent.
- Highest-signal trigger words verbatim.
- Optimize description for correct delegation, not brevity.
- Sentences: ≤4 highly encouraged, ≤6 if necessary to ensure routing quality.

**Frontmatter `model`**: Pin model explicitly unless target runtime guarantees deliberate caller-model inheritance; then omit model field.

**Frontmatter permissions**:
- Minimize privileges: broad denial before specific grants when the target-client schema has ordered permission rules.
- Lead bash block `"*": deny`/`ask` — outranks global allows, forces full self-declared allowlist. Use when tight control required. Narrow allowlist; default-deny + explicit allows, never a wide bash grant.
- Tools: default-deny, enable only needed access.
- Command access: narrow. Check the target-client schema for how it matches compound-command allowlists (commonly per sub-command) — grant shell no-ops (`exit`, `true`, `continue`, `test`) explicitly if compound commands are allowed, don't assume they're implied.
- Nested subagents: subagents default cannot spawn other subagents by default. Enable named children only explicitly.
- Baseline grants belong in runtime harness-config, not copied into every primary agent or subagent definition; each artifact declares only its role deltas.

**Companion README**: One shared `agents/README.md`; use a dedicated `## <name>` section to contain relevant maintenance information. Do not create a per-agent README file.

#### Agent specific

**Template**: `templates/primary-agent.md`.

**Agent body**:
- State role, rules, workflow, boundaries, output contract, success condition; skip unneeded ones.

#### Subagent specific

**Template**: `templates/subagent.md`.

**Subagent body**:
- Start with a one-line role statement. Use `## Rules`, `## Workflow`, `## Boundaries`, and `## Output contract`; add `## Tools` only for a real tool-selection or safety protocol.
- Give one bounded role. Rules state included work, excluded work, and any evidence limit. Workflow ends with a compact receipt; caller owns integration and broader validation unless role explicitly includes it.
- Boundaries distinguish: out-of-scope request = `refused`; missing target, scope, input, or authority = `blocked`; unexpected valid-scope execution failure = `failed`. State whether files remain unchanged or identify unavoidable changes.

**Subagent output contract**: `templates/subagent.md` ships an `## Output contract` section — fill it with real payload shapes, not just the envelope.
- Lead with role evidence: path/line findings, changed paths, check results, or equivalent. Add fields such as `total`, `checks`, `verified`, or `coverage` only when the caller needs them. No exploration story.
- Every report ends with, in order:
    - `status`:
        - `done`: completed requested work.
        - `partial`: requested work remains incomplete. Provide completed-work evidence, state uncompleted prompt scope in `gap`, and explain cause in `issue`.
        - `none`: completed requested work; no requested result or action exists. Explain why in `gap`.
        - `refused`: out of scope.
        - `blocked`: missing input or authority.
        - `failed`: unexpected failure.
    - `gap`: List requested in-scope work not done; include why when relevant. Never list desired improvements.
    - `issue`: List blockers, errors, or other material problems encountered, including resolved problems the caller must know. Use `none` when absent.
- Token strings are fixed; field formatting follows the agent's style. `none` is distinct from `done`. Refusal or terminal tokens the agent defines map to a status value; bind them in one line, never restate their meaning. Envelope placement and order are load-bearing; it wraps the bespoke contract, never replaces it.

### Command

Slash commands are agent-directed instructions invoked by name. No model, no tools, no output contract — just behavior the agent must follow when the command fires.

**Template**: `templates/command.md`.

**Gate**: write a command only if:
- Behavior is invoked by explicit user trigger (slash name), not by autonomous routing (that's a skill's job).
- The steps are a fixed one-off sequence run by that trigger, not a reusable policy consulted across many unrelated tasks. A reusable decision framework, admission bar, or checklist meant to be loaded and applied repeatedly → that's a skill, not a command.
- Body fits one screen even with ordered steps included.
- Needs tools/model/permissions of its own → that's a subagent, not a command.

**Frontmatter `description`**: one sentence. What this command does. Shown in command picker; routing truth.

**Command body text**:
- Imperative dense prose or a numbered list when order matters. No headers.
- State what to do, in what order, under what conditions. No narration, no filler.
- Use `$ARGUMENTS` for user-supplied input. Handle missing gracefully (fallback or ask). If no need for user input, place `$ARGUMENTS` on the very last line.
- No output contract section — command body IS the contract.
- Target length: fits on one screen. Long commands signal over-scoping; split or trim.
- Multi-step command with real delegation tradeoffs: add a minimal per-step `Delegate: allow|encourage|prohibit — reason` line. Skip entirely on a short/simple command — do not force it.
- Command register is the terse end of the core dense-prose rule: no filler survives even at the cost of a slightly cryptic fragment, as long as it stays unambiguous.

**Companion README**: One shared README.md; use dedicated `## <name>` section to contain relevant maintenance information.

## Workflow

1. Classify request: create, edit, or read-only audit. Identify file form, target client, intended reader, and success evidence.
2. Assess if warranted: check if feature already covered by existing artifact, new artifact is justified, or feature could be added to an existing artifact. If not warranted, push back: present the match and grep evidence, and ask the user to choose — extend/replace the existing artifact, or confirm a new one is truly warranted — before proceeding. For edit/audit, read current artifact first; never replace it with a fresh template.
3. Create: choose location per file-placement table, copy that artifact type's template (see core rules: template-first). A new skill also copies `templates/skill-readme.md` to `README.md` alongside it. Edit: change smallest affected surface. Audit: make no mutations; collect `path:line` evidence, impact, and fix direction.
4. Write or revise body first. Use form rules; dense agent-facing language. Write routing frontmatter last. Configure runtime fields against target-client schema, not template defaults.
5. Trim: if body exceeds ~500 lines, extract reference file. Add `scripts/` only for owned executables. If replacing/obsoleting: grep inbound refs; update/remove same change.
6. Run verification (checklist below), starting with the cheap-model test from core rules.
7. Return artifact.

### Post-delivery deep-evaluation pass

After artifact shipped, do NOT run evaluator; propose deep-evaluation for next-step and wait for approval. If approved or requested:

1. Delegate clean-context final review to a read-only artifact evaluator. Give target, intent, scope, and applicable rules.
2. Incorporate justified findings (use normal workflow). Skip only trivial, mechanical edits; state skip reason.
3. Return final artifact and summary of changes made.
4. If substantial changes made: ask to re-run deep-evaluation again, state why.

## Verification

After creating or editing, ensure all pass.

- [ ] Everywhere: No placeholders, scaffold comments, under-specified runtime variables, or template-only examples remain; required values are concrete.
- [ ] Everywhere: No name coupling to other artifacts outside a declared same-family group; behavioral references only elsewhere (swap test passes).
- [ ] Everywhere: Any section stacking 3+ interacting technical facts a weak model must synthesize (e.g. permission/ordering/parsing rules) carries one worked example showing them combined; cheap-model test from core rules applies to that section specifically, not just the artifact as a whole.
- [ ] Artifact: If replacing an artifact: all inbound refs updated or removed.
- [ ] Artifact: No stubs, maintainer-facing residue, or roadmap items, or vestiges remain.
- [ ] Artifact: No dead refs to paths/skills/tools that don't exist.
- [ ] Frontmatter: YAML parses cleanly, each field is one physical line (no wrapped values), and all required fields present. No empty values.
- [ ] Frontmatter: `description` dense with correlated keywords. Routing truth; no trigger phrases duplicated in body.
- [ ] Skill: Owned resources referenced correctly (`scripts/foo`), no `<skill-root>` placeholder, no hardcoded absolute deploy path.
- [ ] Subagent: Report ends with `status:` (one of `done` `partial` `blocked` `refused` `none` `failed`), `gap:`, and `issue:`; every refusal or terminal token maps to a status and is payload, not a replacement.
- [ ] Subagent: Output contract has a real success payload and explicit empty-result, refusal, block, partial, and failure behavior.
- [ ] Command: Fits one screen, `$ARGUMENTS` handled, dense/compressed phrasing throughout.
- [ ] Command: `Delegate:` per-step delegation tags present only where a real tradeoff exists, never forced on a trivial command.
- [ ] README: created or updated alongside artifact. Human-facing, readable, no AI slop.
