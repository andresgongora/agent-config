---
title: Authoring Skills and Subagents
summary: Lessons for future agents adding skills, subagents, or agent-side capabilities to this repo. Covers context isolation, skill/subagent coupling patterns, README housekeeping, caveman writing rules, and clarifying-question checklist.
status: active
updated: 2026-07-23
---

# Authoring Skills and Subagents

## Purpose

Distilled checklist for agents adding skills, primary agents, subagents, or agent-side capabilities. Not a walk-through of any one change.

Treat this doc as "skill for building skills" — but keep it lightweight, not a bureaucracy.

## Core Premises

### 1. Context is the scarcest resource

Every token loaded into main context is a token that will be re-processed on every subsequent turn. Long sessions die from context bloat, not from bad ideas.

Design skills and subagents to protect main context:
- Skills: dense, information-rich, no filler. Load-once cost, many-turn benefit.
- Subagents: encapsulate work that would otherwise pollute main thread with exploration transcripts, tool logs, or long file reads.

Rule of thumb: if a task's *output* is small but the work to produce it is large, that is a subagent candidate. Main thread pays a small "invoke + result" cost instead of the full exploration.

### 2. Skills and subagents reinforce each other, do NOT couple

`caveman` is the model here. It is a writing-style skill. It is used by many skills and subagents (compressed commit messages, compressed review output, compressed docs like this one). None of them import caveman or require it. They just happen to be better when caveman is loaded.

Same pattern for a workflow skill and optional primary-agent entry point. Skill stays useful without agent selection. Agent may load skill for detailed workflow, but owns only its narrow boundary.

**When adding a new skill or subagent, ask:**
- Can I write this so it works with the other components loaded — but does not break if they are missing or replaced?
- If I name another skill/subagent, is it as an *example* or as a *dependency*?
- Would swapping the referenced component break this one? If yes, decouple.

### 3. Caveman for information density

All skills and durable docs written in caveman style (see `skills/caveman/SKILL.md`). Drop articles, filler, hedging. Fragments OK. Preserve exact technical terms, code, error strings, URLs.

Why: skills are read on every trigger. Docs are read at bootstrap. A skill 40% smaller means 40% cheaper each load — for the lifetime of the skill.

Structure survives (headings, tables, frontmatter, code blocks). Only prose compresses.

If unsure, look at `skills/caveman/SKILL.md`, `skills/caveman-commit/SKILL.md`, `skills/cavecrew/SKILL.md`, `skills/planning/SKILL.md` for the tone.

### 4. Hierarchical / recursive delegation

Nested subagents exist in opencode (default-deny, opt-in via `permission.task`). Depth cap 5. Use nesting when:
- Sub-question would eat many turns in the parent's context
- Sub-work is independent and would benefit from isolation
- A different model tier makes sense at the inner level

Do NOT nest just because it is possible. Each nested call has invocation overhead and its own token cost. Two flat calls are often cheaper than a nest.

### 5. Model routing per role

Two sides of the same principle.

**When pinning a model for a subagent:** cheap models for locators/reviewers (haiku-class), balanced for regular execution (sonnet-class), strong for hard reasoning or planning (opus-class). Match model to task complexity, not to convenience.

**When authoring a skill or subagent prompt:** write it so a *cheaper* model than you assume can still succeed. The prompt + skill + template does the shape-work; the model just fills in the answers. If a prompt only works with a strong model, that is a prompt-design smell — usually means the boundaries are too loose, the template is missing, or too many decisions are left to the model. Tighten the prompt before reaching for a bigger model.

Concrete tests when authoring:
- Would a small model know what to output? (Fixed template + examples help.)
- Would a small model know when to stop? (Explicit stopping rules help.)
- Would a small model know when to refuse? (Explicit refusal triggers help.)

Treat model tier choices as provisional. Validate cost, latency, and output quality before changing them.

### 6. Session-to-session continuity

Long-lived projects need session-to-session continuity. When authoring a skill/subagent that touches project workflow, do not invent a parallel tracking mechanism — check whether existing conventions (e.g. repo-state snapshot, `.agent/progress/` handoff notes) already cover the need.

## Companion README Rule

**Every skill folder should have both `SKILL.md` and `README.md`.**

- `SKILL.md` — LLM-facing. Caveman style. Instructions the model reads when the skill loads.
- `README.md` — human-facing. Explains intent, design tenets, maintainer constraints. Enables future revisions without re-deriving the design from source.

README must include:
- One-line what-it-does
- Design intent (why this skill exists at all)
- How to invoke / when it triggers
- Structural warnings for future edits ("do not couple to X", "keep the phase model", etc.)
- See-also links to related skills/agents

Reference examples: `skills/cavecrew/README.md`, `skills/caveman/README.md`, `skills/planning/README.md`.

Subagent files do NOT need a companion README (frontmatter description is enough for humans and agents).

## Where Things Live

| Artifact | Location | Notes |
|---|---|---|
| Skill (LLM-facing) | `skills/<name>/SKILL.md` | Caveman, frontmatter with `name` + `description`. |
| Skill README (human) | `skills/<name>/README.md` | Design intent, maintainer notes. |
| Subagent | `agents/<name>.md` | opencode-native frontmatter (see below). |
| Cross-cutting doc | `.agent/notes/<topic>.md` | With frontmatter, caveman. |
| System-level config | NixOS `opencode.nix` file | Nix. Only when config truly belongs in Nix (permissions, MCP servers, top-level agents defined inline). |

**Prefer standalone agent files under `agents/` over inline `agent = { ... }` blocks in `opencode.nix`.** File is the single source of truth. Nix config for cross-agent policy and MCP wiring only.

## Subagent Frontmatter (opencode)

Two styles co-exist in this repo. Use the opencode-native map style for anything new:

```yaml
---
description: >
  <clear when-to-use description. First sentence should tell an agent whether
  this is the right subagent for the task at hand.>
mode: subagent
model: <provider>/<model-id>
temperature: 0.2
tools:
  read: true
  write: false
  edit: false
  bash: true
  glob: true
  grep: true
  webfetch: true
  websearch: true
  task: true    # only if this subagent should nest further subagents
permission:
  edit: deny
  bash:
    "*": deny
    "git log*": allow
    # ... narrow allowlist
  task:
    "<specific-subagent>": allow
    "*": ask
---
```

Rules:
- `description` field is what the routing agent sees. Optimize it for correct routing, not brevity for humans.
- Pin `model` explicitly. Do not inherit unless truly generic.
- `permission.task` is default-deny in opencode. Only enable when subagent legitimately needs to delegate.
- Prefer allowlist over `"*": "allow"` for `bash` and `task`. Wildcards leak.

## Skill Frontmatter

```yaml
---
name: <skill-name>
description: >
  Compact but complete description of when to load. Include trigger phrases the
  agent should recognize. Loaded when this description matches user intent.
---
```

### Trigger placement rule

Frontmatter `description` owns routing truth.

- Put load / skip cues in `description`.
- Keep it sharp enough that matcher can fire without reading body.
- Do NOT repeat raw trigger text in body (`## Trigger`, `## Load when`, `Load when:`). Duplication drifts.
- Body is for post-load behavior: workflow, boundaries, decision rules, misuse cases, output contract.

Bad:
- frontmatter says when to load
- body repeats same trigger list

Good:
- frontmatter = routing
- body = `## Boundaries`, `## Use after load`, `## Do not use for`, `## Decision rules`

## Nested Subagents: What Works in Opencode

- Default: subagents can NOT spawn other subagents.
- Enable per-subagent via `permission.task` in that subagent's frontmatter.
- Depth cap: 5 (config knob `experimental.subagent_max_depth`).
- Ask-for-permission routes to root session (main thread).
- Global `permission.task: "allow"` in `opencode.json` propagates to ALL subagents and enables unbounded recursion — don't do it.

## Risks and Anti-Patterns

| Risk | How it bites | Mitigation |
|---|---|---|
| Skill A hard-imports skill B | Replacing B breaks A | Reference as example only, never as dependency. |
| Skill duplicates existing skill | Confusion at load, agent picks wrong one | Grep existing skills first. Extend or replace, do not duplicate. |
| Subagent duplicates one in `opencode.nix` | Two agents with overlapping names/purpose | Grep opencode.nix for existing agent defs before adding. Consolidate. |
| Verbose skill (marketing prose) | Every load costs extra tokens forever | Enforce caveman. Reject own draft if it reads like a blog. |
| Subagent with wide bash allowlist | Silent damage during runs | Narrow allowlist. Default-deny with explicit allows. |
| Subagent that spawns further subagents by default | Runaway cost | `permission.task` scoped to specific children only. |
| Skill without README | Future maintainer must re-derive intent | Always ship both. |
| Skill invoked when not needed | Wastes context | Sharp `description` field with clear triggers and non-triggers. |
| No lint / no validate | Broken agent silently fails at first invoke | Parse frontmatter YAML. Run `statix` + `deadnix` + `nixfmt` on any Nix edits. |

## Clarifying Questions Checklist

Before writing a new skill or subagent, ask the user (or answer yourself with high confidence):

**Scope and identity**
- Does an equivalent skill/subagent already exist? If yes, extend it or replace it — do not add a competitor.
- What triggers this? What must NOT trigger it? Both matter for description field.
- Who consumes the output — main thread, human, or another subagent?

**Style and coupling**
- Which existing skills should this reinforce? (name them, but do not depend on them)
- Which existing skills must this NOT couple to? (usually caveman, docs — they are style, not contract)
- Where does this live: `skills/`, `agents/`, `.agent/notes/`, `opencode.nix`?

**Subagent-specific**
- Which model tier? Cheap for narrow-scope, balanced for general, strong only when justified.
- Which tools does it truly need? Everything else = deny.
- Should it nest further subagents? If yes, which ones exactly (`task` allowlist)?
- What is the shape of its output? (structured template, prose, one-liner)

**Housekeeping**
- README planned? (yes if skill, usually no if subagent)
- Does this obsolete an existing artifact? Remove the old one in the same change to avoid drift.
- Any tests/lints available? Run them.

## Verification Steps After Adding

1. Nix syntax parses: `nix-instantiate --parse <file.nix>`
2. Nix formatted: `nixfmt -w 360 <file.nix>`
3. Nix lint: `statix check .` and `deadnix -lL --exclude secrets.nix .`
4. Frontmatter YAML parses: cheap script or `python -c "import yaml; yaml.safe_load(...)"`
5. New subagent's `description` reads correctly when scanning agent list.
6. If replacing an existing artifact: grep repo for stale references to the old one.
7. Do NOT run `nixos-rebuild` unless user asks — per `AGENTS.md` rule. Suggest the user deploys.

## Meta-Rule

If the number of skills / subagents grows past what a human can hold in head, that itself is a sign to consolidate, not to keep adding. Better fewer sharp tools than many overlapping ones.

Same applies to this doc: keep it terse. If it grows past 2-3 screens, split it.

## See Also

- `../../skills/planning/SKILL.md` + `README.md` — dual-mode planning workflow and its README pattern.
- `../../skills/caveman/SKILL.md` + `README.md` — writing style used everywhere.
- `../../skills/cavecrew/SKILL.md` + `README.md` — subagent-family pattern with output contracts.
- `../../skills/docs/SKILL.md` — docs discipline (this doc follows it).
- `../../agents/planning.md` — primary plan-document agent with scoped writes.
- `design-principles.md` — durable cross-cutting decisions (layer model, memory rules, context-pollution mitigations).
- `../../skills/code-frontier/SKILL.md` — repo-state snapshot skill (concept + workflow + format).
- `../../skills/docs/README.md` — doc conventions, frontmatter schema, and how the discovery scripts fit in.
