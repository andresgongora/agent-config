# minion-delegation

Decision guide. Load before summoning a `minion-*` subagent; bounded work defaults to delegation.

## What it does

Tells the main thread when to spawn a minion-style subagent versus a general-purpose capability. Each leaf worker has a narrow contract and compact structured output. `minion-master` owns a frozen multi-step mission, its leaf dispatch, local integration, and proof.

The Minion family and this workflow were inspired by CaveCrew in [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman).

Six subagents:

| Subagent | Job | Summon when |
| --- | --- | --- |
| `minion-master` | Frozen mission executor | Complete planning milestone needs subplan, leaf work, integration, and verification without user dialogue. |
| `minion-investigator` | Locate code (read-only) | "Where is X defined / what calls Y / list uses of Z" |
| `minion-builder` | Surgical edit, 1-2 files | Scope is obvious, ≤2 files. Refuses 3+ file scope. |
| `minion-linter` | Formatting and linting | Supplied targets need tool selection or safe automatic fixes. |
| `minion-reviewer` | Diff/file review | One-line findings with severity tier |
| `minion-vestige-hunter` | Post-rework cleanup | Stale comments, ghost steps, superseded wording |

Use a general exploration or review capability when you want prose, architecture commentary, or rationale. Use main thread directly for one-line answers, user decisions, scope discovery, tests, builds, installs, external research, or unclear/risky work; delegate other standalone bounded work by default. Summon `minion-master` after a planning milestone becomes a complete mission package.

This skill is a decision guide, not a slash command. It activates before summoning any minion: bounded code locating, editing, linting, diff review, cleanup, and frozen-mission execution.

## How to invoke

Triggers on phrases like "use minion", "spawn minion-master", "spawn investigator/builder/linter/reviewer/vestige-hunter", "find code usage", "surgical code edit", "review this diff", "find vestigial residue".

## Example chaining

Locate → fix → verify (most common):

1. `minion-investigator` returns site list (`path:line — symbol — note`).
2. Main thread picks 1-2 sites, hands paths to `minion-builder`.
3. Main thread inspects the diff and runs validation; `minion-master` performs this only inside its frozen mission package.
4. `minion-reviewer` audits the validated diff when an independent defect check is worth its cost.

Cleanup after a change: hand the touched area to `minion-vestige-hunter` once the change lands.

Parallel scout: spawn 2-3 `minion-investigator` calls in one message with different angles (defs, callers, tests). Aggregate in main.

## Maintainer constraints

- Keep this worker list, `SKILL.md`, every `minion-*` description, `agents/README.md`, and root agent catalog in sync when a minion is added, renamed, or retired.

## See also

- [`SKILL.md`](./SKILL.md) — full decision matrix and output contracts
- [`agents/minion-master.md`](../../agents/minion-master.md)
- [`agents/minion-investigator.md`](../../agents/minion-investigator.md)
- [`agents/minion-builder.md`](../../agents/minion-builder.md)
- [`agents/minion-linter.md`](../../agents/minion-linter.md)
- [`agents/minion-reviewer.md`](../../agents/minion-reviewer.md)
- [`agents/minion-vestige-hunter.md`](../../agents/minion-vestige-hunter.md)
