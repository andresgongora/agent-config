---
title: Bash Permission Asks — Path-Form Mismatch and Per-Sub-Command Matching
summary: >-
  Two distinct causes of spurious bash permission prompts. (1) Tilde/relative path forms never match absolute allow patterns, because patterns are `~`-expanded at load but command strings are not. (2) The bash tool emits one pattern per AST `command` node, so a single unlisted shell no-op (`exit`, `true`, `continue`) forces the whole compound command to prompt — and the dialog then lists every sub-command, allowed ones included. Both fixed in global config. RESOLVED.
status: resolved
updated: 2026-08-04
---

## Symptoms

**Symptom A** — command text literally `~/.config/opencode/skills/docs/scripts/inventory` prompts,
despite a verbatim `"~/.config/opencode/skills/*/scripts/*": "allow"` entry. CLI `run` auto-rejects
(no approver); TUI asks every time.

**Symptom B** — an approval dialog lists a long, seemingly-arbitrary set of patterns, most of which
are already allowlisted:

```
git status *, git log *, git diff *, git ls-files *, prettier *, python -m *,
exit *, true *, continue *, printf *, nix *, markdownlint-cli2 *,
/home/<user>/.config/opencode/skills/docs/scripts/inventory *
```

Symptom B is the one that looks like "permissions are completely broken". It is not.

## Root Cause

Verified against `v1.18.11`:
`packages/opencode/src/tool/shell.ts`, `packages/opencode/src/permission/index.ts`,
`packages/opencode/src/agent/agent.ts`, `packages/opencode/src/util/wildcard.ts`.

### 1. One pattern per sub-command; any `ask` prompts the whole call

`collect()` parses the command with tree-sitter, walks `descendantsOfType("command")`, and for each
node does:

```ts
scan.patterns.add(source(node))                              // raw sub-command text
scan.always.add(BashArity.prefix(tokens).join(" ") + " *")   // suggested pattern for the dialog
```

`Permission.ask()` then evaluates **every** pattern; `allow` continues, `deny` aborts immediately,
anything else sets `needsAsk = true`. So `a && b` where `b` is unlisted prompts for the whole call.
The dialog renders `scan.always` — i.e. every sub-command, including already-allowed ones.

**Consequence:** reading the dialog as "these all need approval" is wrong. Only the unlisted entries
matter. In the Symptom B case the actual blockers were `exit`, `true`, `continue`,
`markdownlint-cli2`, `nix`, and a relative-path skill script. Everything else was a passenger.

**Consequence:** shell no-ops are real `command` nodes. `exit`, `true`, `false`, `continue`,
`break`, `:`, `test`, `[` must be allowlisted or every script with error handling prompts.

`cd`/`pushd`/`popd` are the only exemption (`CWD` set, skipped by `collect`).

### 2. Ordered array, `findLast`, agent frontmatter last

```ts
rulesets.flat().findLast((r) => Wildcard.match(permission, r.permission) && Wildcard.match(pattern, r.pattern))
```

Not a map lookup — a flat ordered array, last match wins. `agent.ts` merges in this order:

```
builtin defaults  ->  builtin per-agent overrides  ->  global config (opencode.json)  ->  agent frontmatter
```

**Consequence:** an agent-file `bash: deny` or `bash: {"*": deny}` always beats a global allow. The
global baseline can therefore be widened freely; agents that declare their own deny stay tight.

**Consequence:** `builtins.toJSON` sorts Nix attrset keys alphabetically. `*` (0x2A) happens to sort
below `.`, `:`, `[`, and every letter, so `"*" = "ask"` lands first by accident, not by design.
Re-verify deny resolution after any batch edit to the global map.

### 3. Patterns are `~`-expanded; command strings are not

`Permission.fromConfig()` runs `expand()` on each pattern (leading `~/`, bare `~`, leading `$HOME`).
The bash tool submits `source(node).trim()` with **no** expansion. Pattern `/home/<user>/.config/...`
vs command `~/.config/...` never matches.

`Wildcard.match` compiles `*` to `.*` and `?` to `.`, anchored. **`*` crosses `/`**, unlike
minimatch/picomatch. One leading-`*` pattern therefore covers every absolute form
(`~/…`, `$HOME/…`, `/home/<user>/…`).

Relative invocations (`skills/docs/scripts/tests/test`, run from the repo root) match none of the
absolute patterns and need their own rule.

Upstream: `https://github.com/anomalyco/opencode/issues/9806`.

## Fix

All in `/home/<user>/.nix/home/modules/tools/ai/opencode.nix` under `permission.bash`.
Requires `nixos-rebuild` to reach `~/.config/opencode/opencode.json`.

```
"*/.config/opencode/skills/*/scripts/*"                            = allow
"*/.agents/skills/*/scripts/*"                                     = allow
"*/.nix/home/<user>/dotfiles/tools/agent-config/skills/*/scripts/*"  = allow
"skills/*/scripts/*"                                               = allow   # relative form
"./skills/*/scripts/*"                                             = allow   # relative form
```

Plus a global baseline covering: shell no-ops and control flow; read-only inspection
(`cat`/`stat`/`jq`/`diff`/`sed`/`awk`/…); read-only git; formatters and linters
(`prettier`, `markdownlint-cli2`, `nixfmt`, `shfmt`, `statix`, `deadnix`, …); read-only `nix`
subcommands only.

Deliberately left at `ask`: `xargs`, `env`, `bash`, `sh`, `eval`, `nix build`/`run`/`shell` — all
generic execution escapes.

Deliberately accepted risk: the two relative skill-script patterns cannot be anchored to a trusted
root, so a checked-out repo containing `skills/<x>/scripts/<y>` would also match. Drop those two
lines to require absolute invocation.

## What Was Wrong in Earlier Diagnoses

- **First pass**: assumed last-match-wins ordering, then "fixed" it by forcing absolute paths in the
  system prompt — symptom treatment, model-dependent, fragile.
- **Second pass**: corrected to "config is a MAP, ordering does not apply". Also wrong. Ordering is
  real (`findLast` over a flat array); the map is only the authoring surface.
- **Both passes** missed per-sub-command matching entirely, which is why Symptom B kept recurring
  after Symptom A was fixed.
- **Structural cause**: a ~43-entry read-only baseline was duplicated into `build.md`,
  `build-fast.md`, `build-medium.md`, and `cli.md` instead of living in global config. Gaps in one
  copy were invisible. Baseline now global; agent files should carry role deltas only.

## Verification

`opencode.nix` edits need `nixos-rebuild`. Agent-file and skill symlinks are live — effective on the
next `opencode run`.

### Inspect deployed pattern map

```bash
python3 -c "import json;print(json.dumps(json.load(open('$HOME/.config/opencode/opencode.json'))['permission']['bash'],indent=1))"
```

### Static resolution check (no rebuild needed)

Sort the rule keys the way Nix will, then take the last match per command. Confirms `"*" = "ask"`
sorts first and no allow shadows a deny.

### Exp 1 — tilde form (expect run, no prompt)

```bash
opencode run --agent cli --model github-copilot/claude-haiku-4.5 \
  "Run verbatim, keep the tilde, do not rewrite: ~/.config/opencode/skills/docs/scripts/inventory"
```

Model may silently rewrite `~` to absolute; the "keep the tilde" wording is load-bearing.

### Exp 2 — compound command with shell no-op (regression test for Symptom B)

```bash
opencode run --agent build --model github-copilot/claude-haiku-4.5 \
  "Run exactly: git status --short && test -d .agent && echo ok || exit 1"
```

Pre-fix: prompts on `exit`/`test`. Post-fix: runs silently.

### Exp 3 — relative skill script

```bash
cd ~/.nix/home/<user>/dotfiles/tools/agent-config
opencode run --agent build --model github-copilot/claude-haiku-4.5 \
  "Run exactly, do not make it absolute: skills/docs/scripts/inventory .agent"
```

### Exp 4 — negative controls (expect prompt/reject; proves scoping held)

```bash
opencode run --agent cli --model github-copilot/claude-haiku-4.5 "run: /usr/bin/env echo hi"
opencode run --agent cli --model github-copilot/claude-haiku-4.5 "run: nix build .#nothing"
```

### Exp 5 — `--auto` bypass (isolates permission from script bugs)

```bash
opencode run --auto --agent cli --model github-copilot/claude-haiku-4.5 \
  "run: bash ~/.config/opencode/skills/docs/scripts/inventory"
```

Always runs; `--auto` approves everything not explicitly denied.
