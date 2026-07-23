<!--
================================================================================
AGENTS.md TEMPLATE

Purpose: bootstrap a new `AGENTS.md` for a project (or subdirectory / nested
scope). Loaded by AI coding agents on every session inside that scope.

Reader: AI agent, not human. Dense compressed style. Bullets over prose.
Fragments OK. Preserve exact commands, paths, invariants.

Scope: works for any project that needs agent guidance — code repos, config
repos, prose / docs projects, knowledge bases, research notes, mixed content.
This template stays domain-agnostic at the core. Code-specific sections
(Tools & Commands, Commit / PR) are optional and clearly marked.

Guiding principles (from community + this repo's own experience):
- SHORT. Community target <200 lines. Fewer sharp rules beats many
  overlapping rules.
- ARTIFACT-FIRST. Exact paths, exact commands, exact invariants beat prose.
- LINK OUT. Deep design goes in a durable doc (e.g. `.agent/`), not here.
- DELETE UNUSED SECTIONS. Every heading below is optional. Only keep what
  the project actually needs. Empty section = worse than no section.
- NO REDUNDANCY WITH PARENT. Nested AGENTS.md must not restate the parent
  unless narrowing or overriding.
- ROUTING BY BEHAVIOR, NOT NAMES. When triggering a workflow, describe the
  behavior needed (e.g. "compressed style"), not the tool name (e.g. "load
  caveman"). One glue file per user is allowed to name skills directly.
- DEAD REFS ARE POISON. Every referenced skill / tool / path is verified
  or removed. Do not leave stale references.

PROJECT-SHAPE HINTS (pick sections accordingly):
- Code project → keep Info, Directives, Access Level, Rules (Workflow +
  Style + File Placement), Boundaries, Tools & Commands, maybe Commit / PR.
- Config / infra project → same as code, but Style may be minimal.
- Content project (docs, notes, prose, knowledge base) → keep Info,
  Directives, Access Level, Rules (Workflow + Style + File Placement),
  Boundaries. Drop Tools & Commands and Commit / PR unless meaningful.
- Meta project (rules, skills, agent scaffolding — like this repo) → same
  as content, plus a Rules subsection for the artifact-authoring workflow.

HOW TO USE THIS TEMPLATE:
1. Copy this whole file to the target location as `AGENTS.md`.
2. Delete this HTML comment block.
3. Delete sections you do NOT need for this project's shape.
4. Replace `<PLACEHOLDER>` markers with real content.
5. Prune examples and inline guidance comments once real content is in.
================================================================================
-->

# AI Agent Guidelines

<!--
Optional one-line preamble telling readers what this file is for and how
it relates to any parent AGENTS.md.
Example: "Repo-local rules for agents working on <project name>. Inherits
and narrows the cross-project rules loaded from <parent>."
-->

<!------------------------------------------------------------------------------------------------->
## Meta
<!------------------------------------------------------------------------------------------------->

<!--
Rules ABOUT this file: how it evolves, how it splits, who edits it.
Keep tiny. Cut if the parent AGENTS.md already covers this.
-->

- Living doc. Evolves from repeated signal, not one-off taste.
- Durable behavior only. Task logs → a progress-notes folder (e.g. `.agent/progress/`).
- Nested `AGENTS.md` may narrow / override. Top-level prevails on conflict.
- Style: dense, imperative, fragment OK. Reader is AI.
- Verify referenced skills / tools / paths exist before saving.

<!------------------------------------------------------------------------------------------------->
## Info
<!------------------------------------------------------------------------------------------------->

<!--
High-level project facts an agent needs before touching anything.
Keep to ~5-7 lines. Update on major changes only.

Field guidance (pick what applies, add code-specific rows only if relevant):
- Purpose        — one line, what this project produces or maintains
- Domain         — what kind of artifact this project deals with (code,
                   config, docs, research notes, rules, media, …)
- Consumers      — who / what uses the output (humans, agents, a tool, …)
- Format         — primary content format (Nix, markdown, TS, images, …)
- Entry points   — key files / dirs an agent should read first
- Language       — (code projects only) primary programming language
- Platforms      — (code projects only) targeted platforms
-->

- **Purpose**: <one line — what this project produces or maintains>
- **Domain**: <one line — what kind of artifact this project deals with>
- **Consumers**: <who / what uses the output>
- **Format**: <primary content format>
- **Entry points**: <key files / dirs to read first>

<!------------------------------------------------------------------------------------------------->
## Directives
<!------------------------------------------------------------------------------------------------->

<!--
Meta-guidance for agent BEHAVIOR while working here.
Only put things that are TRUE FOR THIS PROJECT and NOT already in parent.
Delete anything that just restates a global rule.
-->

- <e.g. "Single clear implementation → proceed. No permission theater.">
- <e.g. "Before non-trivial change: todo list. Sort by gain / risk / dep.">
- <e.g. "Load `<behavior>` skill when <trigger>.">
- <e.g. "Ask early on risk, ambiguity, or rabbit-hole path.">

<!------------------------------------------------------------------------------------------------->
## Access Level
<!------------------------------------------------------------------------------------------------->

<!--
Where the agent may read / write vs. must ask first.
Explicit access maps beat implicit assumptions.
Cut if the whole project is read + write and there are no protected paths.
-->

- `<path/1>`: read + write.
- `<path/2>`: read only. Ask before write.
- `<path/secrets>`: NO access. May reference paths, never touch content.
- All other: <default policy — e.g. "read-only, ask for write">.

<!------------------------------------------------------------------------------------------------->
## Rules
<!------------------------------------------------------------------------------------------------->

<!--
Durable project-specific rules. Group only when it aids scanning.
Keep each bullet self-contained and testable.
-->

### Workflow

- <e.g. "Read related files first. Preserve existing structure.">
- <e.g. "Match existing style over inventing new one.">
- <e.g. "Validate with <check command> before commit.">
- <e.g. "Minimal diff. Root-cause fix, not patch-on-patch.">

### Style & Conventions

<!--
Non-obvious style / naming / structure rules that a linter (if any) cannot
express. Works for code, config, prose, or any artifact type.
Cut if the linter / project idiom already covers everything.
-->

- <e.g. comment format, front-matter shape, section ordering>
- <e.g. naming convention for files / symbols / entities>
- <e.g. content-length or layout norm>

### File Placement

<!--
Where new artifacts of each kind belong. Cut if trivial.
-->

- <artifact type> → `<path>`
- <artifact type> → `<path>`

### Adding a New <Thing>

<!--
Optional. Include when adding an item of some category is a recurring
operation with several ordered steps. Otherwise cut.
-->

1. <step>
2. <step>
3. <validation>

<!------------------------------------------------------------------------------------------------->
## Boundaries
<!------------------------------------------------------------------------------------------------->

<!--
Hard "do not" rules. Security, destructive ops, protected paths, out-of-scope
changes. Explicit is safer than implied.
-->

- Never `<destructive action>`.
- Never commit secrets / tokens / private keys.
- <project-specific "do not touch">

<!------------------------------------------------------------------------------------------------->
## Tools & Commands
<!------------------------------------------------------------------------------------------------->

<!--
OPTIONAL. Exact runnable commands for setup, validation, build, deploy.
Skip entirely for projects with no such commands (prose, notes, rules).
Command-first, no prose. Maintainer only edits. Never invent commands.

Typical entries for code / config projects: setup, test, lint, format,
build, deploy. Add or drop rows to match the project.
-->

- **Setup:**
  ```sh
  <exact command>
  ```
- **Validate / Check:**
  ```sh
  <exact command>
  ```
- **Test:**
  ```sh
  <exact command>
  ```
- **Lint:**
  ```sh
  <exact command>
  ```
- **Format:**
  ```sh
  <exact command>
  ```
- **Build:**
  ```sh
  <exact command>
  ```
- **Deploy:**
  <policy — e.g. "Never deploy unless user runs `<cmd>` explicitly.">

<!------------------------------------------------------------------------------------------------->
## Commit / PR
<!------------------------------------------------------------------------------------------------->

<!--
OPTIONAL. Only if the project has non-default VCS conventions.
Cut if "conventional commits + normal PRs" (or no VCS workflow) is fine.
-->

- Commit style: <e.g. "Conventional Commits, subject ≤50 chars">
- PR template: <link or none>
- Required checks: <e.g. lint + tests + type-check>
