# AI Agent Guidelines

Repo-local routing and boundaries for this agent ecosystem. Narrows `deploy/AGENTS.md`; do not restate it.

## Info

- **Purpose**: portable AI-agent rules, skills, subagents, commands, plugins, and durable knowledge; optimize quality against context cost.
- **Runtime entry**: `deploy/AGENTS.md` — deployed cross-project rules.
- **Layout**: `skills/<name>/SKILL.md` LLM workflows · `agents/` workers · `commands/` slash commands · `deploy/` runtime rules · `plugins/` JS/TS · `tools/` Bash · `.agent/` durable knowledge · `spikes/` gitignored disabled artifacts, never load.

## Directives

- Before authoring or auditing skills, agents, primary definitions, or commands: load owning artifact workflow.
- Before touching `AGENTS.md`: load AGENTS-maintenance workflow; reject first.
- Before writing or restructuring `.agent/` docs: load owning documentation workflow.
- Structural artifact change → check for dead refs before completion.

## Access Level

- Whole repo: read + write.
- Deploy wiring (whatever the maintainer uses to symlink / copy this repo into their AI-agent client's config dir) lives outside this repo: read only, ask before edit.
- Any protected paths in the parent repo (e.g. secrets): NO access (inherited from parent `AGENTS.md`).

## Rules

### Admission

- Persistent artifact or rule must be concrete, durable, non-overlapping, and reference only existing artifacts. Default no; bloat is failure.
- Replace or extend overlap; delete an obsolete replacement now.
- Skill: search `skills/`; routing lives in precise `SKILL.md` frontmatter description. Agent/command: check name collision. Doc: absorb into existing doc when possible.

### Decoupling (Skills / Subagents)

- Cross-family skills and agents specify behavior/trigger, never names; artifacts must survive equivalent replacement.
- `deploy/AGENTS.md` alone names direct runtime targets. Same-family artifacts may name each other.

### Style

- Agent-facing Markdown: dense fragments; preserve exact code, paths, commands, errors, and URLs. Keep structure where clarity needs it.
- `README.md` is maintainer context, never mandatory runtime context.

### Adding Artifacts

- Owning workflows hold procedure; these are repo-specific deltas only.
- `deploy/AGENTS.md` holds no worker table; add only routing precedence unavailable in worker descriptions.
- Command has no README or frontmatter beyond `description`; one screen maximum.

## Boundaries

- Keep `deploy/AGENTS.md` lean; do not repeat routing already expressed by skill frontmatter.
- Keep repo policy client-neutral; client/Nix deployment wiring is outside this repo.
- Parent `nixos/secrets/*`: read only.
