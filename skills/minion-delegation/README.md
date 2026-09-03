# minion-delegation

Decision guide. When to delegate to minion-\* subagents instead of doing the work inline.

## What it does

Tells the main thread when to spawn a minion-style subagent versus a general-purpose capability. Each worker has a narrow contract and a compact, structured output — spawning one keeps noisy exploration or review detail out of main context.

The Minion family and this workflow were inspired by CaveCrew in [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman).

Four subagents:

| Subagent | Job | Use when |
| --- | --- | --- |
| `minion-investigator` | Locate code (read-only) | "Where is X defined / what calls Y / list uses of Z" |
| `minion-builder` | Surgical edit, 1-2 files | Scope is obvious, ≤2 files. Refuses 3+ file scope. |
| `minion-reviewer` | Diff/file review | One-line findings with severity tier |
| `minion-vestige-hunter` | Post-rework cleanup | Stale comments, ghost steps, superseded wording |

Use a general exploration or review capability when you want prose, architecture commentary, or rationale. Use main thread directly for one-line answers and 3+ file refactors.

This skill is a decision guide, not a slash command. It activates for bounded code locating, surgical edits, diff review, and post-change cleanup.

## How to invoke

Triggers on phrases like "use minion", "spawn investigator/builder/reviewer/vestige-hunter", "find code usage", "surgical code edit", "review this diff", "find vestigial residue".

## Example chaining

Locate → fix → verify (most common):

1. `minion-investigator` returns site list (`path:line — symbol — note`).
2. Main thread picks 1-2 sites, hands paths to `minion-builder`.
3. Main thread inspects the diff and runs validation — no minion can run tests or builds.
4. `minion-reviewer` audits the validated diff when an independent defect check is worth its cost.

Cleanup after a change: hand the touched area to `minion-vestige-hunter` once the change lands.

Parallel scout: spawn 2-3 `minion-investigator` calls in one message with different angles (defs, callers, tests). Aggregate in main.

## Maintainer constraints

- `minion-fetcher` is documented in `agents/README.md` and the root `README.md` but `agents/minion-fetcher.md` does not currently exist on disk. This skill intentionally excludes it until the agent file is restored.
- Keep the worker list in sync with `agents/minion-*.md`; update this file and `SKILL.md` together when a worker is added, renamed, or retired.

## See also

- [`SKILL.md`](./SKILL.md) — full decision matrix and output contracts
- [`agents/minion-investigator.md`](../../agents/minion-investigator.md)
- [`agents/minion-builder.md`](../../agents/minion-builder.md)
- [`agents/minion-reviewer.md`](../../agents/minion-reviewer.md)
- [`agents/minion-vestige-hunter.md`](../../agents/minion-vestige-hunter.md)
