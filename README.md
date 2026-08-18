# AI agent config

[![AGENTS.md](https://img.shields.io/badge/AGENTS.md-compatible-blue)](https://github.com/andresgongora/agent-config)
[![AI Agent Config](https://img.shields.io/badge/AI_Agent-Config-orange)](https://github.com/andresgongora/agent-config)
[![OpenCode](https://img.shields.io/badge/OpenCode-compatible-7c3aed)](https://opencode.ai)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-tip-yellow)](https://buymeacoffee.com/YOUR_USERNAME)

Personal AI-agent ecosystem: cross-project rules, skills, subagents, and docs. Designed for [OpenCode](https://opencode.ai) but structured to work with any AGENTS.md-aware client.

The goal is a sharp, lean agent, not a yes-man. It pushes back on weak requests, plans before executing, protects context by delegating isolatable work, and keeps state in durable git-tracked memory so a fresh session picks up cold.

<!------------------------------------------------------------------------------------------------->
## Setup
<!------------------------------------------------------------------------------------------------->

### OpenCode

Clone this repo, then run the installer:

```bash
./tools/install-opencode
```

Creates symlinks under `${XDG_CONFIG_HOME:-~/.config}/opencode/` for `AGENTS.md`, agents, skills, commands, and plugins. Existing files are never overwritten. Restart OpenCode after installation.

| Option            | What it does                              |
| ----------------- | ----------------------------------------- |
| `--dry-run`       | Print planned actions without writing     |
| `--force`         | Back up conflicting files before linking  |
| `--uninstall`     | Remove symlinks created by the installer  |
| `--only <target>` | Scope to one client (default: `opencode`) |

Custom files you've added to these directories are left untouched — the installer only manages files from this repo. Re-run after pulling updates.

**Manual setup**: symlink or copy these files instead:

- `deploy/AGENTS.md` → `~/.config/opencode/AGENTS.md`
- `agents/` → `~/.config/opencode/agents/`
- `skills/` → `~/.config/opencode/skills/`
- `commands/` → `~/.config/opencode/commands/` (optional)
- `plugins/` → `~/.config/opencode/plugins/` (optional)

Verify OpenCode picks up the skill list and subagents by checking the model selector and skill-load triggers.

### Other clients

- `deploy/AGENTS.md` is the single file to deploy. It references skills and subagents by name; those only matter if your client supports them.
- Skills are loaded on demand via a `skill` tool call. If your client does not have that, the `SKILL.md` files can be copy-pasted as system-prompt sections.
- Subagents need client support for spawning named agents. Without it, the main agent absorbs all work.

<!------------------------------------------------------------------------------------------------->
## Agent-directed instructions
<!------------------------------------------------------------------------------------------------->

### Agent instructions (`deploy/AGENTS.md`)

The main deployed file. Sets tone, workflow, guardrails, context-protection rules, parallelization rules, and the skill/subagent trigger table. Project-level `AGENTS.md` files narrow or override it.

Key rules it enforces:

| Rule                        | What it does                                                                     |
| --------------------------- | -------------------------------------------------------------------------------- |
| Caveman mode                | Session-default compressed output to cut token use                               |
| Plan before execute         | Todo list for non-trivial work; auto-continue only on expected steps             |
| Hard claim needs hard proof | No plausible-sounding invention; omit what can't be sourced                      |
| Delegate isolatable work    | Subagents handle search, code-locate, review; main context keeps only the result |
| Reject-first                | Every new rule / skill / doc / subagent must earn its place                      |
| Shell restrictions          | `trash` instead of `rm`/`rmdir`; banned tools have no fallback                   |

### Skills

Skills are instruction sets loaded on demand when a task matches their trigger. They do not run automatically — the agent loads them when needed, then follows the workflow inside.

| Skill                   | What it does                                                                                                                  | Load when                                                                                 | Source                                                                                                                       |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `agent-agents-md`       | Admission checklist and scope selection for `AGENTS.md` files                                                                 | Any add / change / trim / audit / create of an `AGENTS.md`                                |                                                                                                                              |
| `agent-author`          | File-form guidance and workflow for creating/editing skill files, subagent files, agent definitions, and slash commands       | Authoring or auditing any `SKILL.md`, `agents/*.md`, agent definition, or `commands/*.md` |                                                                                                                              |
| `delegation`            | Generic bounded-delegation decision and worker-contract workflow                                                              | Generic delegation considered/arranged, parallel waves, worker failure                    |                                                                                                                              |
| `delegation-execution`  | Admits nested delegation execution and builds a complete mission package for a generic executor                               | Complex self-contained mission would pollute main context                                 |                                                                                                                              |
| `cavecrew`              | Decides when to delegate to `@cavecrew-*` subagents                                                                           | Surgical repo-local code work                                                             | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT)                                                      |
| `caveman-commit`        | Conventional Commits messages, subject ≤50 chars, body only when the why isn't obvious                                        | Writing commit messages                                                                   | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT)                                                      |
| `caveman-review`        | Code review: one line per finding, severity-tagged, no praise                                                                 | Reviewing PRs or diffs                                                                    | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT)                                                      |
| `caveman`               | Compressed output style, ~65% fewer tokens. Multiple intensity levels.                                                        | Every session (default)                                                                   | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT)                                                      |
| `coding-bash`           | Conventions, templates, and workflow for writing bash scripts matching the maintainer's established style                     | Writing or extending any bash script                                                      |                                                                                                                              |
| `coding-oop`            | Object-oriented design conventions: inheritance, hierarchies, interfaces, composition                                         | Writing, editing, or reviewing OOP code                                                   |                                                                                                                              |
| `coding-python`         | Python development convention, used alongside cross-language coding conventions                                               | Writing, editing, or reviewing Python code                                                |                                                                                                                              |
| `coding-unit-test`      | Test framework and idiom discipline; child of `coding` ecosystem                                                              | Writing tests, TDD, coverage                                                              |                                                                                                                              |
| `coding`                | Cross-language coding conventions: structure, naming, function design, readability; parent router to language-specific skills | Writing, editing, or reviewing code in any language                                       |                                                                                                                              |
| `docs-write`            | Write side of repo knowledge: admit, shape, place, update, prune durable `.agent/` docs                                       | Persisting settled research, architecture facts, root causes, handoffs                    |                                                                                                                              |
| `docs`                  | Doc discovery and discipline; cheap frontmatter inventory scripts                                                             | Non-trivial repo work, `.agent/` work, architecture notes                                 |                                                                                                                              |
| `file-tidy`             | Metadata-only file inventory, duplicates, cleanup plans                                                                       | Messy downloads, media libraries, space reclaim                                           |                                                                                                                              |
| `git`                   | Git guardrails and fast workflows                                                                                             | Branch, commit, merge, rebase, push, undo                                                 |                                                                                                                              |
| `artifact-markdown`     | Minimal Markdown completion checks                                                                                            | Writing, editing, finishing, or reviewing `.md` files                                     |                                                                                                                              |
| `artifact-vestige-hunt` | Find vestigial residue: leftover comments, steps, or notes describing removed/superseded behavior                             | Post-rework cleanup, "why is this still here", ghost steps in workflows                   |                                                                                                                              |
| `local-opencode`        | Locate and edit this machine's deployed OpenCode config                                                                       | Local OpenCode config work                                                                |                                                                                                                              |
| `nixos`                 | NixOS / Home Manager workflows and pitfall guide                                                                              | Any NixOS or Home Manager config work                                                     |                                                                                                                              |
| `no-ai-slop`            | Rules for prose that does not read like AI output                                                                             | Writing human-facing docs, READMEs, copy                                                  | [realrossmanngroup/no_ai_slop_writing_rules](https://github.com/realrossmanngroup/no_ai_slop_writing_rules) (no license yet) |
| `obsidian-plugin`       | Creating, editing, testing, and releasing Obsidian plugins — TypeScript, manifest, esbuild, BRAT, community submission        | Obsidian plugin work, manifest.json, BRAT beta, community plugin review                   |                                                                                                                              |
| `planning`              | Plan-first session workflow: scope, live todos, coarse-to-fine execution                                                      | Multi-step tasks, ambiguous scope, risky forks                                            |                                                                                                                              |
| `teach`                 | Multi-session teaching workspace                                                                                              | Explicit request only                                                                     | [mattpocock/skills](https://github.com/mattpocock/skills) (MIT)                                                              |
| `web-search`            | Coordinates online research through a main agent and optional scout fanout                                                    | Multi-page online research                                                                |                                                                                                                              |
| `writing`               | Reader-facing prose: direct, evidence-led, peer-level, and structured for action                                              | Emails, official correspondence, blog posts, proposals, public statements                 |                                                                                                                              |

### Subagents

Named workers the main agent can delegate to. Each has a narrow tool set and a defined output shape, so their transcripts stay isolated from main context.

| Subagent                   | What it does                                                                                           | Use when                                                               | Source                                                                  |
| -------------------------- | ------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `@agent-evaluator`         | Read-only fuzzy-quality evaluator; returns a full evidence-cited report                                | Auditing agent-directed instructions during authoring or revision      |                                                                         |
| `@artifact-vestige-hunter` | Read-only; returns terse list of vestigial residue from file, diff, or directory                       | Post-rework audits, "find leftover cruft", "why is this still here"    |                                                                         |
| `@build-fast`              | Fast, cheap single-task runner: tests, lint, format, install deps, one script                          | Noisy terminal output that would pollute main context                  |                                                                         |
| `@build-medium`            | Mid-cost bounded multi-step runner: fix-and-verify loop, small feature slice, scoped few-file refactor | Task needs small in-task judgment/iteration, not a full planning cycle |                                                                         |
| `@build`                   | Development agent: edit code, run linters/formatters/builds/tests                                      | Repo-local code work needing judgment                                  |                                                                         |
| `@cavecrew-builder`        | Surgical 1-2 file edit; hard-refuses 3+ file scope                                                     | Bounded, obvious edits                                                 | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT) |
| `@cavecrew-investigator`   | Read-only code locator; returns `file:line` table                                                      | Finding where something is defined or used                             | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT) |
| `@cavecrew-reviewer`       | Diff/file review; one line per finding, severity-tagged                                                | Reviewing PRs or specific files                                        | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT) |
| `@chat`                    | Cloud-only conversational agent; no local files or shell                                               | Discussion, explanation, brainstorming without local context           |                                                                         |
| `@cli`                     | Broad Linux/CLI access for system, service, network diagnostics                                        | Commands outside the repo                                              |                                                                         |
| `@fast`                    | Cheap one-shot common-knowledge answer or quick web search                                             | Trivial facts, simple comparisons, definitions                         |                                                                         |
| `@files`                   | Filesystem navigation and metadata inspection; never reads file text                                   | Duplicates, renames, moves, space usage                                |                                                                         |
| `@planning`                | Dialogue and inspection; outputs one revisable plan in `.agent/plan/`; cannot implement                | Decision-grade pre-implementation plans                                |                                                                         |
| `@web-search-scout`        | Single-query leaf for `@web-search` only; returns `## Scout Report`                                    | One isolated query angle within a research task                        |                                                                         |
| `@web-search`              | Multi-page online research coordinator; returns `## Findings`                                          | Non-trivial research needing multiple sources                          |                                                                         |

### Commands

Slash-commands: user-invoked shortcuts that run a fixed prompt.

| Command            | What it does                                                                                            | Source                                                                  |
| ------------------ | ------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `/agent-repo-init` | One-time bootstrap of agent-naive or agent-stale repo: AGENTS.md, .agent/ ignore, stale-artifact triage |                                                                         |
| `/caveman-commit`  | Generate a terse caveman-style commit message for staged changes                                        | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT) |
| `/caveman-review`  | Caveman-style code review — one-line findings with severity                                             | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT) |
| `/caveman`         | Activate caveman compression mode (lite \| full \| ultra \| wenyan \| off)                              | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT) |
| `/checkpoint`      | Validate work and capture durable state before a separate commit request                                |                                                                         |
| `/git-commit`      | Plan, show, approve, then create safe atomic Git commits; does not push                                 |                                                                         |
| `/document`        | Update and prune durable repository documentation and current-state memory                              |                                                                         |
| `/fanout`          | Parallelize explicit work items through direct workers or admitted nested executors, then verify.       |                                                                         |
| `/plan-execute`    | Execute a durable plan document from `.agent/plan/`                                                     |                                                                         |

<!------------------------------------------------------------------------------------------------->
## Details about this repo
<!------------------------------------------------------------------------------------------------->

### Layout

```
deploy/AGENTS.md        Cross-project user-level rules (the main deployed file).
AGENTS.md               Repo-local rules for agents maintaining this repo.
agents/                 Subagent definitions, one file each.
skills/                 Skills loadable on demand.
  <name>/SKILL.md       LLM-facing instructions.
  <name>/README.md      Human maintainer notes.
.agent/                 AI working memory: plans, frontier, progress, bugs, notes.
plugins/                Client-specific plugins (e.g. JS).
commands/               Slash-commands.
tools/                  Ad-hoc scripts.
```

<!------------------------------------------------------------------------------------------------->
## Donations
<!------------------------------------------------------------------------------------------------->

If you like this project and want to show your support,
[buy me a coffee](https://buymeacoffee.com/andresgongora). Caffeine goes in, code comes out.

<!------------------------------------------------------------------------------------------------->
## License
<!------------------------------------------------------------------------------------------------->

Original files in this repo are [MIT licensed](./LICENSE).

Third-party files, clearly indicated in the above tables, retain their upstream licenses. The source column in the tables above identifies which skills and subagents came from other repos; check those repos for their license terms before redistributing. Some upstream repos have not published a license yet or can not be shared; those files are not redistributed in this repo.
