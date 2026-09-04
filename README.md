# AI agent config

![AGENTS.md](https://img.shields.io/badge/AGENTS.md-compatible-blue)![AI Agent Config](https://img.shields.io/badge/AI_Agent-Config-orange)![OpenCode](https://img.shields.io/badge/OpenCode-compatible-7c3aed)![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)![Buy Me A Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-tip-yellow)

Personal AI-agent ecosystem: cross-project rules, skills, subagents, and docs. Designed for
[OpenCode](https://opencode.ai) but structured to work with any AGENTS.md-aware client.

The goal is a sharp, lean agent, not a yes-man. It pushes back on weak requests, plans before
executing, protects context by delegating isolatable work, and records reusable context in project
memory.

<!------------------------------------------------------------------------------------------------->
## Setup
<!------------------------------------------------------------------------------------------------->

### OpenCode

Clone this repo, then preview and run installer:

```bash
./install/install-for-opencode --dry-run
./install/install-for-opencode
```

Creates symlinks under `${XDG_CONFIG_HOME:-$HOME/.config}/opencode/` for `AGENTS.md`, agent
definitions, skill directories, command definitions, and plugin directories. It requires standard
Unix tools plus `trash`. Restart OpenCode after installation.

| Option        | What it does                             |
|---------------|------------------------------------------|
| `--dry-run`   | Print planned actions without writing    |
| `--force`     | Back up conflicting files before linking |
| `--uninstall` | Remove symlinks created by the installer |

Existing destinations stop installation unless `--force` backs them up. `--uninstall` removes only
installed links that still match installer manifest.

**Manual setup**: symlink or copy these files instead:

- `deploy/AGENTS.md` → `~/.config/opencode/AGENTS.md`
- `agents/` → `~/.config/opencode/agents/`
- `skills/` → `~/.config/opencode/skills/`
- `commands/` → `~/.config/opencode/commands/` (optional)
- `plugins/` → `~/.config/opencode/plugins/` (optional)

Restart OpenCode, then verify installed agents, skills, commands, and plugins load.

### Model aliases

Agent definitions use model aliases and require bundled `opencode-model-alias` plugin. Without it, OpenCode receives aliases instead of provider/model IDs.

The plugin reads `~/.config/opencode/model-aliases.json`; create aliases for available models. These deliberately fictitious examples show tiered alias naming only; replace every value with a provider/model ID from `opencode models`.

```json
{
  "TEAM_FAST": "provider-alpha/fast-1",
  "TEAM_LIGHT": "northstar-ai/light-2",
  "TEAM_MID": "horizon-cloud/mid-3",
  "TEAM_HEAVY": "nebula-router/heavy-4",
  "LOCAL_LIGHT": "workbench-lab/compact-5"
}
```

### Other clients

- `deploy/AGENTS.md` is the portable user-level instruction file. Deploy skill, agent, command, and plugin artifacts only when your client supports them.
- Skills load on demand through a `skill` tool call. Clients without that tool can use relevant `SKILL.md` content as instruction context.
- Subagents need client support for spawning named agents. Without it, the main agent absorbs all work.

<!------------------------------------------------------------------------------------------------->
## Agent-directed instructions
<!------------------------------------------------------------------------------------------------->

### Agent instructions (`deploy/AGENTS.md`)

The main deployed file. Sets tone, skill-routing rules, planning and delegation boundaries,
guardrails, and completion expectations. Project-level `AGENTS.md` files narrow or override it.

Key rules it enforces:

| Rule                        | What it does                                                            |
|-----------------------------|-------------------------------------------------------------------------|
| Concise output              | Direct, evidence-backed output without filler                           |
| Skill routing               | Load every matching workflow before acting                              |
| Architecture first          | Set boundaries, APIs, and invariants before cross-module implementation |
| Hard claim needs hard proof | Do not invent support or bridge uncertainty                             |
| Bounded delegation          | Delegate only isolatable work with checkable evidence                   |
| Stop and ask                | Ask on material uncertainty; stop after repeated blockers               |

### Skills

Skills are instruction sets loaded on demand when a task matches their trigger. They do not run
automatically — the agent loads them when needed, then follows the workflow inside.

| Skill                   | What it does                                                                                                                  | Load when                                                                                 | Source                                                                                                                       |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| `agent-agents-md`       | Admission checklist and scope selection for `AGENTS.md` files                                                                 | Any add / change / trim / audit / create of an `AGENTS.md`                                |                                                                                                                              |
| `agent-author`          | File-form guidance and workflow for creating/editing skill files, subagent files, agent definitions, and slash commands       | Authoring or auditing any `SKILL.md`, `agents/*.md`, agent definition, or `commands/*.md` |                                                                                                                              |
| `delegation`            | Generic bounded-delegation decision and worker-contract workflow                                                              | Generic delegation considered/arranged, parallel waves, worker failure                    |                                                                                                                              |
| `delegation-nesting`    | Admits nested delegation execution and builds a complete mission package for a generic executor                               | Complex self-contained mission would pollute main context                                 |                                                                                                                              |
| `minion-delegation`     | Decides when to delegate bounded locating, editing, linting, review, cleanup, or frozen-mission execution to `@minion-*`     | Before summoning a minion or coordinating bounded repo-local delegation                    |                                                                                                                              |
| `minion-master`         | Executes one frozen mission with optional leaf delegation, local integration, and validation                                  | Running `@minion-master` on a complete multi-step repository mission                      |                                                                                                                              |
| `caveman-commit`        | Conventional Commits messages with terse subjects and context-bearing bodies                                                  | Writing commit messages                                                                   | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT)                                                      |
| `caveman-review`        | Code review: one line per finding, severity-tagged, no praise                                                                 | Reviewing PRs or diffs                                                                    | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT)                                                      |
| `caveman`               | Compressed output style with multiple intensity levels.                                                                       | Every session (default)                                                                   | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT)                                                      |
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
| `local-opencode`        | Locate mapped OpenCode sources; inspect and verify deployed state                                                             | Local OpenCode config work                                                                |                                                                                                                              |
| `nixos`                 | NixOS / Home Manager workflows and pitfall guide                                                                              | Any NixOS or Home Manager config work                                                     |                                                                                                                              |
| `obsidian-plugin`       | Creating, editing, testing, and releasing Obsidian plugins — TypeScript, manifest, esbuild, BRAT, community submission        | Obsidian plugin work, manifest.json, BRAT beta, community plugin review                   |                                                                                                                              |
| `planning`              | Plan-first session workflow: scope, live todos, coarse-to-fine execution                                                      | Multi-step tasks, ambiguous scope, risky forks                                            |                                                                                                                              |
| `qa-skill`              | Static comparison and matched subagent QA for two agent skills                                                                | Comparing exactly two agent skills                                                        |                                                                                                                              |
| `tool-bash`             | Bash command-execution preflight                                                                                              | Before any shell command or script execution                                              |                                                                                                                              |
| `web-search`            | Coordinates online research through a main agent and optional scout fanout                                                    | Multi-page online research                                                                |                                                                                                                              |
| `web-youtube`           | Fetches YouTube metadata and caption-backed transcripts through `yt-dlp`                                                      | YouTube URLs, caption availability, transcripts, or summaries                             |                                                                                                                              |
| `writing`               | Reader-facing prose: direct, evidence-led, peer-level, and structured for action                                              | Emails, official correspondence, blog posts, proposals, public statements                 |                                                                                                                              |

### Subagents

Named workers the main agent can delegate to. Most have narrow tool sets; `@minion-master` has full repository capability for a frozen mission. All return defined output shapes, so transcripts stay isolated from main context.

| Subagent                   | What it does                                                                                           | Use when                                                               |
|----------------------------|--------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|
| `@agent-evaluator`         | Read-only static evaluator of agent-directed artifacts; returns evidence-cited findings                | Auditing agent-directed instructions during authoring or revision      |
| `@build`                   | Development agent: edit code, run linters/formatters/builds/tests                                      | Repo-local code work needing judgment                                  |
| `@minion-master`           | Frozen multi-step mission executor; plans packages, directs leaves, integrates, and verifies           | Complete planning milestone too large for one leaf                     |
| `@minion-builder`          | Surgical 1-2 file edit; hard-refuses 3+ file scope                                                     | Bounded, obvious edits                                                 |
| `@minion-linter`           | Runs formatters and linters; applies presentation-only automatic fixes                                  | Bounded formatting or linting needs                                    |
| `@minion-investigator`     | Read-only repository locator; returns compact path-based evidence                                      | Finding definitions, callers, uses, tests, imports, or structure       |
| `@minion-reviewer`         | Supplied diff/file review; returns verified severity-tagged findings                                   | Reviewing a bounded diff or file                                       |
| `@minion-vestige-hunter`   | Read-only post-rework vestige hunter; returns removable residue candidates                             | Removing stale steps, comments, or superseded wording                  |
| `@chat`                    | Cloud-only conversational agent; no local files or shell                                               | Discussion, explanation, brainstorming without local context           |
| `@cli`                     | Broad Linux/CLI access for system, service, network diagnostics                                        | Commands outside the repo                                              |
| `@fast`                    | Cheap one-shot common-knowledge answer or quick web search                                             | Trivial facts, simple comparisons, definitions                         |
| `@files`                   | Filesystem navigation and metadata inspection; never reads file text                                   | Duplicates, renames, moves, space usage                                |
| `@planning`                | Dialogue and inspection; outputs one revisable plan in `.agent/plan/`; cannot implement                | Decision-grade pre-implementation plans                                |
| `@qa-tester`               | Runs one supplied skill against one supplied prompt and returns raw output in a status envelope        | Parallel behavior tests for two agent skills                           |
| `@qa-judge`                | Judges two tester outputs against their shared prompt                                                  | Selecting the better result after parallel skill tests                 |
| `@web`                     | Low-cost executor for platform/service extraction and transformation                                   | Compact answer; captioned-video ideas persist source resource          |
| `@web-search-scout`        | Single-query leaf for `@web-search` only; returns `## Scout Report`                                    | One isolated query angle within a research task                        |
| `@web-search`              | Multi-page online research coordinator; returns `## Findings`                                          | Non-trivial research needing multiple sources                          |
| `@writing`                 | Chat-first drafting and revision of human-directed prose                                               | Emails, correspondence, announcements, articles, reports, and copy     |
| `@writing-reviewer`        | Read-only final prose review; returns corrections or revised text with reasons                         | Review a completed reader-facing draft                                 |

### Commands

Slash-commands: user-invoked shortcuts that run a fixed prompt.

| Command            | What it does                                                                                              | Source                                                                  |
|--------------------|-----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| `/agent-repo-init` | One-time bootstrap of agent-naive or agent-stale repo: `AGENTS.md`, durable memory, stale-artifact triage |                                                                         |
| `/caveman-commit`  | Generate a terse caveman-style commit message for staged changes                                          | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT) |
| `/caveman-review`  | Caveman-style code review — one-line findings with severity                                               | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT) |
| `/caveman`         | Activate caveman compression mode (lite \| full \| ultra \| wenyan-lite \| wenyan-full \| wenyan-ultra \| off) | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT) |
| `/checkpoint`      | Validate work and capture durable state before a separate commit request                                  |                                                                         |
| `/git-commit`      | Plan, show, approve, then create safe atomic Git commits; does not push                                   |                                                                         |
| `/document`        | Update and prune durable repository documentation and current-state memory                                |                                                                         |
| `/fanout`          | Parallelize explicit work items through direct workers or admitted nested executors, then verify.         |                                                                         |
| `/plan-execute`    | Execute a durable plan document from `.agent/plan/`                                                       |                                                                         |

<!------------------------------------------------------------------------------------------------->
## Details about this repo
<!------------------------------------------------------------------------------------------------->

### Layout

```
deploy/AGENTS.md        Cross-project user-level rules (the main deployed file).
AGENTS.md               Repo-local rules for agents maintaining this repo.
agents/                 Primary and subagent definitions, one file each.
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

Third-party files, clearly indicated in the above tables, retain their upstream licenses. The source
column in the tables above identifies which skills and subagents came from other repos; check those
repos for their license terms before redistributing. Some upstream repos have not published a
license yet or can not be shared; those files are not redistributed in this repo.
