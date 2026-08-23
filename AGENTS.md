# AI Agent Guidelines

Repo-local rules for agents authoring / editing skills, subagents, and docs in this repo. Inherits and NARROWS `deploy/AGENTS.md`; do not restate global rules here.

## Meta

- Living doc. Evolves from repeated signal, not one-off taste.
- Durable behavior only. Task logs → `.agent/progress/`.
- Reader is AI. Dense, imperative, fragment OK.

## Info

- **Purpose**: personal AI-agent ecosystem — rules, skills, subagents, docs. Optimizes output quality vs token/context cost. Framework-agnostic — deployable to any AGENTS.md-aware AI-agent client.
- **Consumers**: AI coding agents. No specific client assumed.
- **Language**: Markdown + YAML frontmatter; JavaScript/TypeScript in `plugins/`; Bash in `tools/`. External client/Nix deployment wiring lives outside this repo.
- **Product entry point**: `deploy/AGENTS.md` — the deployed cross-project user-home rules.
- **Repo entry points** (read first): `README.md`, `.agent/notes/design-principles.md`, `.agent/frontier.md`.
- **Layout**: `deploy/` deployed user-global rules · `skills/<name>/SKILL.md` LLM-facing skills · `agents/` subagents · `commands/` slash-commands · `plugins/` client-specific JS/TypeScript · `tools/` ad-hoc scripts · `.agent/` durable repo knowledge · `spikes/` gitignored disabled experiments.
- **Not source of truth**: `spikes/` (disabled artifacts, never loaded), `.agent/frontier.md` and `.agent/plan*` (gitignored machine-local state).

## Directives

- Before adding / changing a skill, subagent, primary agent definition, or command: load agent-artifact authoring workflow.
- Before touching any `AGENTS.md` (add / change / trim / audit / create): load AGENTS-maintenance workflow. Reject-first.
- Before adding / restructuring docs under `.agent/`: load owning documentation workflow; discovery-only workflow does not own writes.
- Before broad scan: check `.agent/frontier.md` for current repo state.
- Update `.agent/frontier.md` when shape / done / in-progress / next / boundary shifts. Shape / entry-point / boundary moves also update the `## Info` block above.
- After any structural change (new skill / subagent / doc, moved template, deleted artifact): grep for dead refs before reporting done.

## Access Level

- Whole repo: read + write.
- Deploy wiring (whatever the maintainer uses to symlink / copy this repo into their AI-agent client's config dir) lives outside this repo: read only, ask before edit.
- Any protected paths in the parent repo (e.g. secrets): NO access (inherited from parent `AGENTS.md`).

## Rules

### Reject-first (Core Discipline)

Every new skill / subagent / doc / rule / trigger must earn its place. Default answer is "no". Bloat is the failure mode this repo actively fights.

Reject when:
- Duplicates or overlaps an existing artifact — extend or replace instead.
- Vague slogan without workflow / checklist / template.
- Would need updating soon (moving target, not durable).
- References an artifact that does not yet exist ("dead ref").

### Decoupling (Skills / Subagents)

- Skills and subagents REINFORCE each other. They MUST NOT depend on each other by name.
- When one artifact needs behavior from another: reference by BEHAVIOR / TRIGGER (e.g. "dense compressed style", "delegate isolatable research"), not by name.
- Exception: `deploy/AGENTS.md` is the single glue point. Name skills directly only there. Swapping one skill for another requires editing there and nowhere else.
- Same-family exception: artifacts of one family (e.g. `caveman*`, `web-search*`, `planning` skill + `planning` agent) belong to one toolset and MAY name each other. Family membership is the license to hard-couple; cross-family references stay behavior/trigger-only.
- Reference other artifacts as EXAMPLES, never as DEPENDENCIES. Swap-test rule: if artifact B were replaced by an equivalent, would A still work? If no, decouple.

### Style

- **`SKILL.md`, subagent files, `.agent/**/*.md`, `AGENTS.md`**: maximum compression by default. Bullets over prose. Fragments OK. Preserve exact code, paths, commands, error strings, URLs. Relax one notch only for complex multi-step sequences where compression creates ambiguity. Caveman style.
- **`README.md` (skill, repo root)**: human-facing maintainer context. Holds rationale, origins, rejected alternatives, maintenance constraints. Runtime agents never rely on READMEs; maintainers use them as optional context.
- Structure survives compression (headings, tables, frontmatter, code blocks). Only prose compresses.
- Em dash for aside/appositive only; still avoid. Consequence, sequence, or state transition (condition → action, before → after, step → step): use `→`, not em dash.

### Adding Artifacts

Owning workflow first: agent-artifact authoring for skills / subagents / commands, documentation workflow for `.agent/` docs, AGENTS-maintenance for any `AGENTS.md`. Those own the procedure. Repo-specific deltas only:

- **Skill**: grep `skills/` for overlap before creating. Routing truth is `SKILL.md` frontmatter `description`; keep it precise enough for description-driven loading. Obsoletes an existing skill → delete the old one now, not later.
- **Subagent**: grep `agents/` for name collision. `deploy/AGENTS.md` carries no worker table; add a line there only for delegation precedence the subagent's own `description` cannot express.
- **Command**: grep `commands/` for name collision. No README, no frontmatter beyond `description`. Fits one screen or it is over-scoped.
- **Doc**: check whether an existing `.agent/` doc can absorb the content instead of creating a file.

## Boundaries

- Never add a rule / skill / subagent / doc that references an artifact that does not exist.
- Never grow `deploy/AGENTS.md` with anything a skill's own frontmatter already routes. It loads every session; each line is paid for on every task.
- Never couple this repo's rules to a specific tool ("opencode does X"). Describe behavior. Tool-specific detail lives in deploy wiring, not here.
- Never edit `nixos/secrets/*` in the parent repo. Read paths only.

## Tools

- **Deploy**: external client/Nix wiring is out of scope; ask before editing it. Repo-owned `tools/install-opencode` manages OpenCode links.
- **No repository-wide build/test workflow** — Markdown lint config lives in `.markdownlint.json`; plugin packages may have local tooling; formatter scope in `.prettierignore`.
