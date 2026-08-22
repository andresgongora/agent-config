# coding-bash skill

Distills the maintainer's bash scripting conventions into one starter template and opt-in reusable snippets.

## Why this exists

Scripts in `~/Software/scripts/bash-scripts/` share a consistent structure — same shebang, same separator style, same section order, same `requireCommand` pattern. Without this skill, agents write bash that looks right but diverges in small ways that accumulate: unquoted expansions, missing `set -Eeuo pipefail`, wrong separator width, functions without verb prefixes, globals where params should be.

The skill gives agents one authoritative reference for persistent Bash script deliverables.

## Design intent

Structure is deliberate:

- **DEPENDENCY CHECKS first** — reader sees what's required before anything else
- **ARGUMENT PARSING before MAIN** — `main()` reads parsed globals directly, no parameter threading
- **`main()` is glue, not logic** — short by convention; when it grows, extract a core function
- **Core functions take parameters** — never reach into arg globals; keeps them testable and reusable
- **One-liners permitted** — when the body fits clean on one line; reduces noise for trivial helpers

## Triggers

Load when writing or extending a bash script as a deliverable. Not for debugging a running script, NixOS config, or one-off shell commands.

## Templates

`template/script.sh` is the canonical starter. Every `TEMPLATE:` marker is an authoring instruction: remove or replace it, and every example, before validation. It contains exactly one example core function and one placeholder dependency — enough to show the pattern, not enough to clutter.

`template/snippets.sh` is opt-in. Copy only required blocks: `basename`/`dirname` path helpers, root checks, timestamps, logging. Not standalone. `logVerbose` stays silent and returns success until `VERBOSE=true`.

## Linting configs

`template/.shellcheckrc` and `template/.editorconfig` are optional starters for a new dedicated script project. Never replace or merge existing root configuration without explicit scope.

`.shellcheckrc` sets `shell=bash` and disables SC1091 (not following sourced files). Does not suppress SC2086 or SC2155 — fix those, don't hide them.

`.editorconfig` sets 4-space indent, LF endings, and final newline for `.sh` files.

## Conventions reference

| Convention           | Value                                                                              |
| -------------------- | ---------------------------------------------------------------------------------- |
| Shebang              | `#!/usr/bin/env bash`                                                              |
| Error flags          | `set -Eeuo pipefail`                                                               |
| Separator width      | 100 characters total (`##` + 98 `=` or `-` chars)                                  |
| Decorator layout     | Blank line → separator → header → identical separator → blank line; never trailing |
| Section header style | `##<TAB><ALL CAPS>`; sub-sections use `##<TAB><TITLE>`                             |
| Variable naming      | Globals `SNAKE_CASE`; locals `snake_case`                                          |
| Function naming      | `camelCase` verb-first; contextual: `context_sub_camelCase()`                      |
| Dependency guard     | `requireCommand()` inline one-liner in DEPENDENCY CHECKS                           |
| Destructive file ops | `trash`, never `rm` or `rmdir`                                                     |
| `main()`             | Short glue; reads arg globals; called bare from SCRIPT ENTRY POINT                 |
| Core functions       | Take parameters, not arg globals                                                   |
| Arg parsing          | Positional or `while case`; no `getopts`                                           |

## How to update this skill

When conventions in the source scripts drift, re-read 3-4 of the most recently edited scripts and update `SKILL.md` — section order, separator format, `requireCommand` pattern. Keep `script.sh` minimal; add reusable optional helpers only to `snippets.sh`.

The `.shellcheckrc` rules list is intentionally short. Add only when a rule causes repeated false positives across multiple scripts — not to avoid fixing real issues.

## See also

- `coding` — shared coding conventions and child routing.
