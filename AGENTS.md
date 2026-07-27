# AI Agent Guidelines

Repo-local rules for agents authoring / editing skills, subagents, and docs in this repo. Inherits and NARROWS the personal cross-project rules defined in `deploy/AGENTS.md` (which the maintainer deploys to their AI-agent client of choice). Do not restate those global rules here.

<!------------------------------------------------------------------------------------------------->
## Meta
<!------------------------------------------------------------------------------------------------->

- Living doc. Evolves from repeated signal, not one-off taste.
- Durable behavior only. Task logs → `.agent/progress/`.
- Reader is AI. Dense, imperative, fragment OK.
- Every referenced skill / subagent / doc / path is verified or removed. Dead refs are the failure mode this repo actively fights.
- If you must add a rule: load the `agents-md` skill first. Reject-first is the default.

<!------------------------------------------------------------------------------------------------->
## Info
<!------------------------------------------------------------------------------------------------->

- **Purpose**: personal AI-agent ecosystem — rules, skills, subagents, docs. Optimizes output quality vs token/context cost. Framework-agnostic — deployable to any AGENTS.md-aware AI-agent client.
- **Consumers**: AI coding agents. No specific client assumed.
- **Language**: markdown (skills, docs, subagents) + YAML frontmatter. JS in `plugins/`. Bash in `tools/`. Deploy wiring is client-specific and lives outside this repo.
- **Product entry point**: `deploy/AGENTS.md` — the deployed cross-project user-home rules.
- **Repo entry points** (read first): `README.md`, `.agent/notes/design-principles.md`, `.agent/frontier.md`.

<!------------------------------------------------------------------------------------------------->
## Directives
<!------------------------------------------------------------------------------------------------->

- Before adding / changing a skill or subagent: load the `authoring-agents` skill. Non-negotiable.
- Before adding a rule to any `AGENTS.md`: load the `agents-md` skill. Reject-first.
- Before adding / restructuring docs under `.agent/`: load the `docs` skill.
- Before broad code scan: use cheap doc discovery (see `docs` skill) and check `.agent/frontier.md` for current repo state.
- Update `.agent/frontier.md` when the shape / done / in-progress / next / boundary of the repo shifts. Use the `code-frontier` skill.
- After any structural change (new skill / subagent / doc, moved template, deleted artifact): run `tools/check-ai-repo` before reporting done.

<!------------------------------------------------------------------------------------------------->
## Access Level
<!------------------------------------------------------------------------------------------------->

- Whole repo: read + write.
- Deploy wiring (whatever the maintainer uses to symlink / copy this repo into their AI-agent client's config dir) lives outside this repo: read only, ask before edit.
- Any protected paths in the parent repo (e.g. secrets): NO access (inherited from parent `AGENTS.md`).

<!------------------------------------------------------------------------------------------------->
## Rules
<!------------------------------------------------------------------------------------------------->

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
- Exception: `deploy/AGENTS.md` is the single glue point where any skill may be named directly. Swapping one skill for another requires editing there and nowhere else.
- Same-family exception: artifacts of one family (e.g. `caveman*`, `web-search*`, `planning` skill + `planning` agent) belong to one toolset and MAY name each other. Family membership is the license to hard-couple; cross-family references stay behavior/trigger-only.
- Reference other artifacts as EXAMPLES, never as DEPENDENCIES. Swap-test rule: if artifact B were replaced by an equivalent, would A still work? If no, decouple.

### Style

- **`SKILL.md`, subagent files, `.agent/**/*.md`, `AGENTS.md`**: caveman-ultra by default. Bullets over prose. Fragments OK. Preserve exact code, paths, commands, error strings, URLs. Soften to caveman-full only when adapting skills/agents with complex multi-step sequences where ultra creates ambiguity.
- **`README.md` (skill, repo root)**: human-facing. Metaphors, design intent, maintainer notes. Brief. An agent USING the repo should NOT rely on READMEs; an agent MAINTAINING may still read them.
- Structure survives compression (headings, tables, frontmatter, code blocks). Only prose compresses.
- Do not couple this rule to a specific compression skill. Style is the outcome.

### Skill Authoring

- Every skill folder ships `SKILL.md` + `README.md`. Enforced by `tools/check-ai-repo`.
- Content placement is strict: skill-load triggers + `description` live in `SKILL.md` frontmatter (routing truth); rules / workflow / boundaries live in the `SKILL.md` body; explanations, rationale, design intent, and maintainer notes live in `README.md`. READMEs serve both humans and maintaining agents; a skill-USING agent must not need the README.
- `SKILL.md` frontmatter (`name`, `description`) owns routing truth. Do NOT repeat trigger phrases in the body.
- Body is for post-load behavior: workflow, boundaries, decision rules, output contract.
- Prompt design: write for a smaller model. Explicit templates, stop conditions, refusal triggers. If it only works with a strong model, tighten the prompt before reaching for a bigger one.
- Skill file on disk ≠ skill loaded at runtime. Respect the gap.

### Subagent Authoring

- Standalone file under `agents/<name>.md` beats inline agent definitions.
- Pin `model` explicitly. Cheap for locators / reviewers, balanced for execution, strong only when justified.
- Set `temperature` explicitly. Choose for task need: lower for exact bounded work; higher when useful diversity outweighs variance.
- Tools: default-deny. Only what the subagent truly needs.
- `permission.task` (nesting): allowlist specific children only. Never `"*": "allow"`.
- `bash` allowlist: narrow. Wildcards leak.
- Permission profile follows role: `cli` broad terminal; `build` broad workspace-dev; `files` paths/metadata/hashes only; `chat` cloud-only. Narrow workers explicit deny. Rule order: broad `*` first, specific overrides last.
- Subagents do NOT need a companion README — frontmatter `description` is enough.
- Output contract: define the shape (e.g. `## Findings`, `## Plan`, one-line-per-finding). Structured output is what protects main context.

### Docs (`.agent/`)

- Frontmatter required: `title`, `summary`. Optional: `status`, `updated`. Enforced by `tools/check-ai-repo`.
- Living docs. Stale doc → verify from source, then update.
- If a doc grows past ~2 screens: split.
- Do not create docs nobody will use.
- External-sourced content requires `source:` link.

### File Placement

- Skill (LLM-facing) → `skills/<name>/SKILL.md`.
- Skill (human maintainer) → `skills/<name>/README.md`.
- Skill assets (templates, scripts) → `skills/<name>/<asset>` (flat where possible).
- Subagent → `agents/<name>.md`.
- Nested subagent family → `agents/<family>/`.
- Cross-cutting design doc → `.agent/notes/<topic>.md`.
- Task-scoped handoff → `.agent/progress/`.
- Bug attempts → `.agent/bugs/`.
- Slash-command → `commands/<name>.md`.
- Plugin (client-specific, e.g. JS) → `plugins/<name>/`.
- Ad-hoc script → `tools/<name>`.

### Adding a New Skill

1. Load `agents-md` skill (skills-authoring reuses the reject-first discipline).
2. Load `authoring-agents` skill (file-form guidance, templates, workflow).
3. Check for duplicates — grep `skills/` first.
4. Create `skills/<name>/SKILL.md` (caveman, frontmatter routing) + `README.md` (design intent).
5. Optionally register in `deploy/AGENTS.md` skill-triggers table if it's a first-class trigger.
6. Run `tools/check-ai-repo`.
7. If it obsoletes an existing skill: delete the old one in the same change.

### Adding a New Subagent

1. Load `authoring-agents` skill (subagent frontmatter section, templates).
2. Grep `agents/` for name collisions.
3. Create `agents/<name>.md` with pinned model, narrow tool set, explicit `description`.
4. If it should appear in the delegation table: register in `deploy/AGENTS.md`.
5. Run `tools/check-ai-repo`.

### Adding a New Doc

1. Load `docs` skill.
2. Check whether an existing doc should absorb this content instead.
3. Add frontmatter (`title`, `summary`; `status`, `updated` when useful).
4. Keep to ~2 screens. Split if it grows.
5. Run `tools/check-ai-repo`.

<!------------------------------------------------------------------------------------------------->
## Boundaries
<!------------------------------------------------------------------------------------------------->

- Never add a rule / skill / subagent / doc that references an artifact that does not exist.
- Never grow `deploy/AGENTS.md` past what its readers can hold in head. If it hurts to read: split or trim.
- Never introduce a second glue point that names skills directly. `deploy/AGENTS.md` is the only one.
- Never couple this repo's rules to a specific tool ("opencode does X"). Describe behavior. Tool-specific detail lives in deploy wiring, not here.
- Never delete a skill / subagent / doc without grepping for references first.
- Never edit `nixos/secrets/*` in the parent repo. Read paths only.

<!------------------------------------------------------------------------------------------------->
## Tools
<!------------------------------------------------------------------------------------------------->

- **Repo health check** (frontmatter, skill/README pairing, dead refs, frontier length):
  ```sh
  tools/check-ai-repo
  ```
- **Deploy**: client-specific and out of scope for this repo. The maintainer symlinks / copies these files into their AI-agent client's config dir (see the outer dotfiles / infrastructure repo). Never agent-initiated.
- **No build / test / lint / format at repo level** — content is markdown + YAML. Structural validation lives in `check-ai-repo`.
