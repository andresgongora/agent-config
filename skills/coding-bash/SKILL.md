---
name: coding-bash
description: "Conventions and templates for authoring persistent Bash script files saved at a named path and owned by the user. Load when request produces a Bash script deliverable, extensionless executable included. Do not load for agent-internal Bash, inline one-liners, shell debugging, NixOS config, or Bash that is not itself the deliverable."
---

# coding-bash

New scripts follow these conventions. Existing scripts retain established local conventions; edit only requested surface unless migration is requested.

## File shape

- Shebang: `#!/usr/bin/env bash`.
- Line 2: `set -Eeuo pipefail` — line 3: `IFS=$'\n\t'`.
- Indent: 4 spaces (never tabs).
- Line width: 100 chars max.
- Section separators: `##` + 98 `=` chars (100 total), followed by `##<TAB><ALL CAPS>` header.
- Sub-section separators: `##` + 98 `-` chars (100 total), followed by `##<TAB>` title, closed by another `##` + 98 `-` chars line.

## Names and scope

- **Locals** (inside functions): `snake_case`.
- **Globals** (script-wide): `SNAKE_CASE` — both mutable and `declare -r` constants.
- **Functions**: `camelCase`, always verb-first — `getData()`, `processInputFile()`, `isLedEnabled()`.
- **Contextual functions**: `context_subcontext_verbCamelCase()` — e.g. `led_red_enable()`, `audio_stream_getLevel()`.
- Verbose names over terse abbreviations: `processInputFile()` not `procFile()`; `input_file` not `f`.
- Always `declare -r` for immutable globals; `local` for every function-local variable.

## Functions

- Multi-line body: opening brace on declaration line, closing brace on own line.
- Single-expression body: one-liner permitted — `fn() { ...; }` — when entire body fits cleanly on one line without wrapping.
- One function per logical operation. Split when a function grows past easy reading — not at a line count, but when holding the whole thing in head becomes work.
- Core functions receive data via parameters — never read arg globals directly.
- `main()` is the exception: it owns arg globals and wires core functions together; keep it short.
- When `main` grows, extract the growing part into a named core function.

## Shell safety

- `[[ ]]` not `[ ]`; `$(...)` not backticks; `printf` not `echo` for formatted output.
- Expected nonzero statuses belong in `if`, `&&`, or `||`; `set -e` treats unguarded nonzero as fatal.
- Avoid `((count++))`; use `((count += 1))`.
- Always `die()` — never inline `echo ... >&2; exit 1`.
- When runtime external dependencies exist, define `requireCommand` inline in DEPENDENCY CHECKS — no `die`, no `SCRIPT_NAME`; bare error + exit.
- Classify each external binary as guaranteed by explicit target contract or runtime dependency. Guard every runtime dependency with `requireCommand`; shell builtins need no guard. No runtime dependencies: omit DEPENDENCY CHECKS and `requireCommand`.
- `trash` instead of `rm`/`rmdir` for destructive file operations.

## Strings, arrays, and input

- Preserve argument boundaries: `"$@"`, `"${array[@]}"`, `array+=("$value")`; never re-split with `for value in $string`.
- `IFS=$'\n\t'` is global. For line reads use `IFS= read -r`; for deliberate splitting, set a command-local `IFS`: `IFS=, read -r -a values <<< "$csv"`.
- Initialize arrays before use (`declare -a VALUES=()`). Under `set -u`, use `${VALUE:-}` for intentionally optional scalars.

## Comments

- **Standalone comments** (prose, docs, section notes, function headers): `##`.
- **Inline comments** (after a line of code): single `#` — e.g. `VERBOSE=false # mutable flag`.
- Never bare `#` for standalone comments — indistinguishable from commented-out code.

## Section order

1. Shebang + `set -Eeuo pipefail` + `IFS`.
2. DEPENDENCY CHECKS when runtime dependencies exist (`requireCommand` definition inline + one call per dependency).
3. GLOBALS (`declare -r` constants, necessary mutable globals).
4. UTILITIES (`die`, needed snippets).
5. CORE FUNCTIONS (one function per logical operation).
6. ARGUMENT PARSING (`printUsage`, `while [[ $# -gt 0 ]]; do case` when needed).
7. MAIN (`main()` glue function — reads parsed arg globals directly).
8. SCRIPT ENTRY POINT (bare `main` call, no arguments).

## Templates

| File | Purpose |
|---|---|
| `template/script.sh` | Canonical starter for new persistent Bash scripts. |
| `template/snippets.sh` | Opt-in helpers. Copy only blocks required by concrete script behavior. |
| `template/.shellcheckrc` | Optional configuration for a new dedicated script project. |
| `template/.editorconfig` | Optional editor defaults for a new dedicated script project. |

`TEMPLATE:` marks authoring instructions — never shipped documentation. Remove or replace every marked line and every example before validation. Do not copy speculative helpers into finished scripts.

## Workflow

1. New script: copy `template/script.sh`. Existing script: inspect its conventions and edit in place; do not rebuild or restyle it from template.
2. New script: remove or replace every `TEMPLATE:` line, example dependency/global/function; fill usage text.
3. Copy only needed blocks from `template/snippets.sh`; classify and guard runtime dependencies.
4. For a new dedicated script project, offer `.shellcheckrc` and `.editorconfig`; never replace or merge existing root configuration without explicit scope.
5. Write CORE FUNCTIONS — one function per operation, verbose names, params not globals.
6. Wire ARGUMENT PARSING and validate required args with `die`.
7. Write `main()` — short, glue only.
8. `bash -n "$script_path"` — syntax check.
9. If available, `shellcheck "$script_path"` — fix code; suppress only documented proven false positives. If unavailable, report validation gap; do not install it unasked.

## Boundaries

- Not for: NixOS config, Python/other languages, debugging running processes, editor/LSP wiring.
- Not for: installing shellcheck or shfmt.
- Stop and ask when requested deliverable is no longer a Bash script (for example, it requires compiled application code or project-wide build-system design).

## Verification

- New script:
  - [ ] Shebang `#!/usr/bin/env bash`; `set -Eeuo pipefail`; `IFS=$'\n\t'` on first 3 lines.
  - [ ] All globals `SNAKE_CASE`; all locals `snake_case`; all functions `camelCase` verb-first.
  - [ ] Verbose names — no single-letter vars, no abbreviated function names.
  - [ ] `die()` defined and used for error exits outside documented `requireCommand` exception.
  - [ ] Runtime dependencies: `requireCommand` defined inline in DEPENDENCY CHECKS; every dependency guarded unless target contract guarantees it.
  - [ ] No runtime dependencies: no DEPENDENCY CHECKS or unused `requireCommand`.
  - [ ] Core functions take parameters, not arg globals; `main()` is short.
  - [ ] No unused utility, global, or example; locals use `local`; immutable globals use `declare -r`.
  - [ ] No unquoted `$variable` expansions; `[[ ]]`; `$(...)`; `printf`; `trash` instead of `rm`/`rmdir`.
  - [ ] Standalone comments use `##`; inline comments use single `#`.
- Existing script:
  - [ ] Touched surface preserves established local naming, structure, and comment conventions.
  - [ ] No unrelated style migration or template boilerplate.
- All scripts: `bash -n "$script_path"` exits 0; `shellcheck` clean when available, otherwise gap reported.
