---
name: coding-bash
description: >
  Conventions and templates for authoring persistent bash script files to be saved at a
  named path and owned by the user. Load when the request produces a .sh file as a
  deliverable: "write me a script", "create a bash script at path X", "add a script that
  does Y". Do not load for agent-internal bash (commands an agent runs to accomplish a
  task), inline one-liners, shell debugging, NixOS config, or any bash that is not itself
  the deliverable.
---

# coding-bash

## File shape

- Shebang: `#!/usr/bin/env bash`
- Line 2: `set -Eeuo pipefail` — line 3: `IFS=$'\n\t'`
- Line width: 100 chars max
- Section separators: `##` + 98 `=` chars (100 total), followed by `##<TAB><ALL CAPS>` header
- Sub-section separators: `##` + 98 `-` chars (100 total), followed by `##<TAB>` title, closed by another `##` + 98 `-` chars line

## Names and scope

- **Locals** (inside functions): `snake_case`
- **Globals** (script-wide): `SNAKE_CASE` — both mutable and `declare -r` constants
- **Functions**: `camelCase`, always verb-first — `getData()`, `processInputFile()`, `isLedEnabled()`
- **Contextual functions**: `context_subcontext_verbCamelCase()` — e.g. `led_red_enable()`, `audio_stream_getLevel()`
- Verbose names over terse abbreviations: `processInputFile()` not `procFile()`; `input_file` not `f`
- Always `declare -r` for immutable globals; `local` for every function-local variable

## Functions

- Multi-line body: braces on own lines (standard)
- Single-expression body: one-liner permitted — `fn() { ...; }` — when entire body fits cleanly on one line without wrapping
- One function per logical operation. Split when a function grows past easy reading — not at a line count, but when holding the whole thing in head becomes work
- Core functions receive data via parameters — never read arg globals directly
- `main()` is the exception: it owns arg globals and wires core functions together; keep it short
- When `main` grows, extract the growing part into a named core function

## Shell safety

- `[[ ]]` not `[ ]`; `$(...)` not backticks; `printf` not `echo` for formatted output
- Expected nonzero statuses belong in `if`, `&&`, or `||`; `set -e` treats unguarded nonzero as fatal
- Avoid `((count++))`; use `((count += 1))`
- Always `die()` — never inline `echo ... >&2; exit 1`
- `requireCommand` defined inline in DEPENDENCY CHECKS — no `die`, no `SCRIPT_NAME`; bare error + exit
- Always `requireCommand` for every non-baseline external binary dependency
- `trash` instead of `rm`/`rmdir` for destructive file operations

## Strings, arrays, and input

- Preserve argument boundaries: `"$@"`, `"${array[@]}"`, `array+=("$value")`; never re-split with `for value in $string`
- `IFS=$'\n\t'` is global. For line reads use `IFS= read -r`; for deliberate splitting, set a command-local `IFS`: `IFS=, read -r -a values <<< "$csv"`
- Initialize arrays before use (`declare -a VALUES=()`). Under `set -u`, use `${VALUE:-}` for intentionally optional scalars

## Comments

- **Standalone comments** (prose, docs, section notes, function headers): `##`
- **Inline comments** (after a line of code): single `#` — e.g. `VERBOSE=false # mutable flag`
- Never bare `#` for standalone comments — indistinguishable from commented-out code

## Section order

1. Shebang + `set -Eeuo pipefail` + `IFS`
2. DEPENDENCY CHECKS (`requireCommand` definition inline + one call per binary)
3. GLOBALS (`declare -r` constants, necessary mutable globals)
4. UTILITIES (`die`, needed snippets)
5. CORE FUNCTIONS (one function per logical operation)
6. ARGUMENT PARSING (`printUsage`, `while [[ $# -gt 0 ]]; do case` when needed)
7. MAIN (`main()` glue function — reads parsed arg globals directly)
8. SCRIPT ENTRY POINT (bare `main` call, no arguments)

## Templates

| File | Purpose |
|---|---|
| `template/script.sh` | Canonical starter. Copy first for every persistent bash script. |
| `template/snippets.sh` | Opt-in helpers. Copy only blocks required by concrete script behavior. |
| `template/.shellcheckrc` | Optional project-root ShellCheck configuration. |
| `template/.editorconfig` | Optional project-root editor defaults. |

`TEMPLATE:` marks authoring instructions — never shipped documentation. Remove or replace every marked line and every example before validation. Do not copy speculative helpers into finished scripts.

## Workflow

1. Copy `template/script.sh`
2. Remove or replace every `TEMPLATE:` line, example dependency/global/function; fill usage text
3. Copy only needed blocks from `template/snippets.sh`; guard each non-baseline binary dependency
4. Optionally copy `.shellcheckrc` and `.editorconfig` to project root
5. Write CORE FUNCTIONS — one function per operation, verbose names, params not globals
6. Wire ARGUMENT PARSING and validate required args with `die`
7. Write `main()` — short, glue only
8. `bash -n script.sh` — syntax check
9. `shellcheck script.sh` — fix code; suppress only documented proven false positives

## Boundaries

- Not for: NixOS config, Python/other languages, debugging running processes, editor/LSP wiring
- Not for: installing shellcheck or shfmt
- Stop when: script needs a build system, compiled deps, or a package manager

## Verification

- [ ] Shebang `#!/usr/bin/env bash`; `set -Eeuo pipefail`; `IFS=$'\n\t'` on first 3 lines
- [ ] All globals `SNAKE_CASE`; all locals `snake_case`; all functions `camelCase` verb-first
- [ ] Verbose names — no single-letter vars, no abbreviated function names
- [ ] `die()` defined and used everywhere instead of inline `exit 1`
- [ ] `requireCommand` defined inline in DEPENDENCY CHECKS; every non-baseline external binary guarded
- [ ] Core functions take parameters, not arg globals
- [ ] `main()` is short — if it grew, the growing part is extracted into a named core function
- [ ] Finished script has no unused utility, global, or example
- [ ] All function-local vars declared with `local`; immutable globals with `declare -r`
- [ ] No unquoted `$variable` expansions
- [ ] `[[ ]]` conditionals; `$(...)` substitutions; `printf` for formatted output
- [ ] `trash` used instead of `rm`/`rmdir`
- [ ] `bash -n script.sh` exits 0; `shellcheck` clean
- [ ] Standalone comments use `##`; inline (after-code) comments use single `#`
