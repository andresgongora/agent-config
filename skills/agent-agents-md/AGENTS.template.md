<!--
AGENTS.md TEMPLATE — bootstrap a new `AGENTS.md` for a project or nested scope.

Use:
1. Copy to target location as `AGENTS.md`.
2. Delete this comment block.
3. Delete every section this project does not need. Empty section is worse than none.
4. Replace `<PLACEHOLDER>` markers with real content. Delete inline guidance comments.

Section picking:
- Code / config project → all sections.
- Content project (docs, notes, prose) → drop Tools & Commands and Commit / PR.
- Meta project (rules, skills, agent scaffolding) → as content, plus a Rules subsection for the agent-artifact authoring workflow.
-->

# AI Agent Guidelines

<!-- Optional one-line preamble telling readers what this file is for and how it relates to any parent AGENTS.md. Example: "Repo-local rules for agents working on <project name>. Inherits and narrows the cross-project rules loaded from <parent>." -->

## Meta

<!-- Rules ABOUT this file: how it evolves, how it splits, who edits it. Keep tiny. Cut if the parent AGENTS.md already covers this. -->

- Living doc. Evolves from repeated signal, not one-off taste.
- Durable behavior only. Task logs → a progress-notes folder (e.g. `.agent/progress/`).
- Nearest applicable `AGENTS.md` wins. Child narrows / overrides parent; never restates it.
- Style: dense, imperative, fragment OK. Reader is AI.
- Verify referenced skills / tools / paths exist before saving.

## Info

<!--
Repo orientation facts. Must save a cold session the probe round. Keep to ~5-12 lines. Admit a fact only if high-signal, stable for months, and not self-evident from the path name alone. Update on shape shifts only.

Field guidance (pick what applies, add code-specific rows only if relevant):
- Purpose — one line, what this project produces or maintains
- Domain — what kind of artifact this project deals with (code, config, docs, research notes, rules, media, …)
- Consumers — who / what uses the output (humans, agents, a tool, …)
- Format — primary content format (Nix, markdown, TS, images, …)
- Layout — top-level dirs, one clause of role each
- Entry points — key files / dirs an agent should read first
- Not source of truth — generated / vendored / mirrored paths
- Language — (code projects only) primary programming language
- Platforms — (code projects only) targeted platforms
-->

- **Purpose**: <one line — what this project produces or maintains>
- **Domain**: <one line — what kind of artifact this project deals with>
- **Consumers**: <who / what uses the output>
- **Format**: <primary content format>
- **Layout**: `<dir>/` <role> · `<dir>/` <role> · `<dir>/` <role>
- **Entry points**: <key files / dirs to read first>
- **Not source of truth**: <generated / vendored / mirrored paths, or delete this line>

## Directives

<!-- Meta-guidance for agent BEHAVIOR while working here. Only put things that are TRUE FOR THIS PROJECT and NOT already in parent. Delete anything that just restates a global rule. -->

- <e.g. "Single clear implementation → proceed. No permission theater.">
- <e.g. "Before non-trivial change: todo list. Sort by gain / risk / dep.">
- <e.g. "Load `<behavior>` skill when <trigger>.">
- <e.g. "Ask early on risk, ambiguity, or rabbit-hole path.">

## Access Level

<!-- Where the agent may read / write vs. must ask first. Explicit access maps beat implicit assumptions. Cut if the whole project is read + write and there are no protected paths. -->

- `<path/1>`: read + write.
- `<path/2>`: read only. Ask before write.
- `<path/secrets>`: NO access. May reference paths, never touch content.
- All other: <default policy — e.g. "read-only, ask for write">.

## Rules

<!-- Durable project-specific rules. Group only when it aids scanning. Keep each bullet self-contained and testable. -->

### Workflow

- <e.g. "Read related files first. Preserve existing structure.">
- <e.g. "Match existing style over inventing new one.">
- <e.g. "Validate with <check command> before commit.">
- <e.g. "Minimal diff. Root-cause fix, not patch-on-patch.">

### Style & Conventions

<!-- Non-obvious style / naming / structure rules that a linter (if any) cannot express. Works for code, config, prose, or any artifact type. Cut if the linter / project idiom already covers everything. -->

- <e.g. comment format, front-matter shape, section ordering>
- <e.g. naming convention for files / symbols / entities>
- <e.g. content-length or layout norm>

### File Placement

<!-- Where new artifacts of each kind belong. Cut if trivial. -->

- <artifact type> → `<path>`
- <artifact type> → `<path>`

### Adding a New <Thing>

<!-- Optional. Include when adding an item of some category is a recurring operation with several ordered steps. Otherwise cut. -->

1. <step>
2. <step>
3. <validation>

## Boundaries

<!-- Hard "do not" rules. Security, destructive ops, protected paths, out-of-scope changes. Explicit is safer than implied. -->

- Never `<destructive action>`.
- Never commit secrets / tokens / private keys.
- <project-specific "do not touch">

## Tools & Commands

<!--
OPTIONAL. Exact runnable commands for setup, validation, build, deploy. Skip entirely for projects with no such commands (prose, notes, rules). Command-first, no prose. Maintainer only edits. Never invent commands.

Typical entries for code / config projects: setup, test, lint, format, build, deploy. Add or drop rows to match the project.
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
- **Deploy:**
  <policy — e.g. "Never deploy unless user runs `<cmd>` explicitly.">

## Commit / PR

<!-- OPTIONAL. Only if the project has non-default VCS conventions. Cut if "conventional commits + normal PRs" (or no VCS workflow) is fine. -->

- Commit style: <e.g. "Conventional Commits, subject ≤50 chars">
- PR template: <link or none>
- Required checks: <e.g. lint + tests + type-check>
