---
title: Design Principles
summary: Durable why-decisions behind this agent setup. Layer model, memory placement, testability stance, brutal-truth reminders. Read once to understand the shape; do not restate in AGENTS.md.
status: active
updated: 2026-08-02
---

# Design Principles

Why this setup exists in its current shape. Read once, do not restate elsewhere.

## Core Shape

Few sharp layers, each with one clear job.

| Layer                          | Purpose                                               | Loaded                      |
| ------------------------------ | ----------------------------------------------------- | --------------------------- |
| Home `AGENTS.md`               | Cross-project durable behavior                        | Every session               |
| Project `AGENTS.md`            | Repo-local rules, workflow, tooling                   | Every session in that repo  |
| Nested `AGENTS.md`             | Subdir-only overrides                                 | When working in that subdir |
| `.agent/`                      | Durable notes, project state, task handoffs, bug logs | On demand                   |
| Skills (`skills/<name>/`)      | Repeated specialized workflows                        | On trigger                  |
| Subagents (`agents/<name>.md`) | Isolatable delegated work                             | On invocation               |

Preferred over: giant all-in-one memory file, chat-log memory, or brittle local DB.

## Decisions (Durable)

### Communication

- Dense output default (currently via `caveman` skill, could be any equivalent compression).
- Honest pushback is a feature. Bad user idea → say plain.
- Agent optimizes for user's end goal, not literal wording.
- Better path clear + low-risk → take it, explain briefly.

### Planning

- Non-trivial work → real todo list.
- Sort by gain, risk, dependency, question cost.
- Ask early on ambiguity or rabbit-hole risk.
- Anti-drift rule: "since I'm here also fix X" → follow-up note, do NOT touch.

### Architecture

- Architecture-first when scope warrants: boxes, boundaries, APIs, invariants.
- Separate core flow from membrane/wrapper code.
- Prefer replaceable implementations behind stable boundaries.

### Docs

- Living docs, not graveyards. Delete stale.
- Cheap discovery via `docs` skill's `scripts/inventory`. If discovery is expensive, agents skip docs.
- Frontmatter + summary are routing layer. If an agent must read the whole doc just to decide relevance, the doc is too expensive.
- Read relevant docs before broad re-exploration.
- Stale docs → verify from source, then update.
- `.agent/**/*.md` require frontmatter: `title`, `summary`, `status`, `updated`. Discovery accepts third-party aliases without making them managed-doc schema.
- External-sourced content requires `source:` link. Undocumented sources become unverifiable.

### Skills

- Strong skill useful when workflow is repeated, concrete, and easy to misuse.
- Skills contain workflow / checklists / templates, NOT vague slogans.
- `SKILL.md` body should route to deeper assets when detail is large; do not turn the trigger-loaded file into a warehouse.
- Skill file on disk ≠ skill loaded at runtime. Respect that gap.
- Persistent skills need re-anchoring after long / tool-heavy turns.
- Every skill folder ships `SKILL.md` + `README.md` (LLM + human).

### Instruction Evaluation

- Static instruction review cannot see user intent, assembled runtime context, target-client behavior, or model execution. It finds source-evidenced severe misalignment, contradiction, unsound scope, and obvious ship blockers; it does not certify behavior.
- Minimal completeness: retain smallest rule set that makes critical boundaries, priorities, stop conditions, consumer contract, and exceptions executable. Add no ritual check, fixed syntax, or generic best practice without a concrete failure prevented.
- Multi-step workflow quality is semantic: state owner, transitions, completion evidence, and stop/replan behavior. Checkbox TODO syntax is optional, never a quality signal by itself.
- Deterministic validation and static judgment differ. Use parsers/tests/runtime exercise for facts they can establish; use read-only review for direction, coherence, and missing constraints.

### Subagents

- Delegate when: bounded scope, small output, isolatable, saves main-context tokens.
- Do NOT delegate when: subagent needs lots of context to even start, or output cost is trivial anyway.
- Framework-agnostic references. Skills mention subagents by name as examples, never as dependencies.
- Model routing per role: cheap for locators/reviewers, balanced for execution, strong for hard reasoning.

### Testing

- Design for testability always. Good boundary → easier test.
- Tests focus on contracts / invariants / behavior, NOT internals.
- Existing convention wins. If none: pick one sane default, stay consistent.
- `tests/` root is strong default when repo has no pattern.
- Test-first useful when boundary stable. Not religion.

## Memory Placement Rules

| Content                            | Home                                            |
| ---------------------------------- | ----------------------------------------------- |
| Durable + cross-project            | Home `AGENTS.md`                                |
| Durable + repo-specific            | Project `AGENTS.md`                             |
| Durable + subdir-specific          | Nested local `AGENTS.md`                        |
| Design / architecture / reference  | `.agent/notes/`                                 |
| Reusable workflow                  | Skill                                           |
| Current state of a project         | Repo-state snapshot workflow                     |
| Task-scoped handoff                | `.agent/progress/`                              |
| Bug attempts                       | `.agent/bugs/`                                  |
| Private / noisy / machine-specific | Local-only, do not commit                       |
| Secrets                            | Not in memory / not in docs / never             |

`.agent/progress/` also holds active task scratchpads. Task ends: delete; move reusable conclusion to `notes/`. Prompt/todo holds uncommitted thought.

**Portable memory rule:** git-tracked > local. High-value durable knowledge should survive machine loss.

## Brutal Truth

Too much memory makes the agent worse. Common failure modes:

- Global file absorbs repo quirks
- Local file restates parent
- Docs created but never used
- Skills overlap and fight
- Planning ritual slows tiny tasks
- Dead skill references waste tokens forever

Better less, sharper, maintained rules than many stale ones.

## Context Pollution: The Main Enemy

Long sessions die from context bloat, not bad ideas. Sources of pollution:

- Exploration transcripts (mitigate: delegate to subagents)
- Long fetched pages (mitigate: use `webfetch`/`websearch` tools; external CLI fetchers like trafilatura or crawl4ai if available; fetch few, scan snippets)
- Dead leads and retry loops (mitigate: stop after 2-3 failures, switch tools)
- "Since I'm here" tangents (mitigate: anti-drift rule, follow-up notes)
- Redundant re-reads (mitigate: read range you need, not the whole file)

Every rule in `AGENTS.md` that touches context should serve one of these mitigations.

## Skill Activation Reality

Skills do not always auto-activate when they should. Therefore:

- Important triggers must be explicit in `AGENTS.md`.
- Persistent skills need periodic re-anchoring.
- Skill should carry workflow, not just slogan.
- Do not assume a skill exists merely because a source file exists. Source may need install/reload before runtime exposes it.

## Guardrails (Repeated for Emphasis)

- Fewer sharp layers > many overlapping ones
- One strong skill > many similar
- Local/project rule > polluting global policy
- Delete stale > preserve every thought forever
- Small portable memory > clever local memory that vanishes on machine loss
