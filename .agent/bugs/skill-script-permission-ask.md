---
title: Skill Script Permission Ask — Tilde/Path-Form Mismatch
summary: Skill scripts (e.g. ~/.config/opencode/skills/docs/scripts/inventory) triggered permission ask despite allow patterns. Root cause: opencode expands ~/$HOME in PATTERNS at load but matches the bash COMMAND string raw. Fix: a leading-`*` allow pattern (opencode's `*` crosses `/`), matching every path form in one rule. RESOLVED + verified.
status: resolved
updated: 2026-07-27
---

## Symptom

Bash command whose text is literally `~/.config/opencode/skills/docs/scripts/inventory`
triggers:

```
! permission requested: bash (~/.config/opencode/skills/docs/scripts/inventory); auto-rejecting
```

Even though `opencode.json` contains verbatim `"~/.config/opencode/skills/*/scripts/*": "allow"`.
CLI `run` auto-rejects (no approver). TUI asks every time.

## Root Cause (verified against v1.18.3 source)

opencode config permission is a JSON **object/map** of `{pattern: action}`, not an ordered array.

1. **Patterns expanded at load.** `Permission.fromConfig()` expands leading `~/`, bare `~`, and
   leading `$HOME` via `os.homedir()`. So `~/.config/...` pattern becomes `/home/andy/.config/...`
   in memory.
   Source: `https://github.com/anomalyco/opencode/blob/v1.18.3/packages/opencode/src/permission/index.ts`
2. **Command string matched RAW.** The bash tool submits the parsed AST source text (`.trim()`),
   with NO `~`/`$HOME` expansion, as the permission input.
   Source: `https://github.com/anomalyco/opencode/blob/v1.18.3/packages/opencode/src/tool/shell.ts`
3. **Asymmetry = miss.** Runtime pattern `/home/andy/.config/...` vs runtime command
   `~/.config/...` → no match → falls to `"*": "ask"`.
4. **Matcher: custom `Wildcard.match`.** `*`→regex `.*`, `?`→`.`, anchored `^...$`. Therefore
   **`*` DOES cross `/`** (unlike minimatch/picomatch).
   Source: `https://github.com/anomalyco/opencode/blob/v1.18.3/packages/opencode/src/util/wildcard.ts`

Known upstream request: `https://github.com/anomalyco/opencode/issues/9806` (expand `~`/`$HOME`
in patterns; done for patterns, not for command strings).

## Fix (applied + verified)

Because `*` crosses `/`, ONE leading-`*` pattern matches every path form of the command
(`~/…`, `$HOME/…`, `/home/andy/…`) and any trailing args:

```
"*/.config/opencode/skills/*/scripts/*": "allow"
"*/.agents/skills/*/scripts/*": "allow"
"*/.nix/home/andy/dotfiles/tools/agent-config/skills/*/scripts/*": "allow"
```

Applied in two places:
- Global truth: `/home/andy/.nix/home/modules/tools/ai/opencode.nix` (needs `nixos-rebuild` to deploy).
- Live-tested now: `/home/andy/.nix/home/andy/dotfiles/tools/agent-config/agents/cli.md` (live symlink;
  effective immediately, no rebuild). Redundant with global once rebuilt — kept as tested guarantee.

Trade-off: leading `*` is broader than an absolute pattern (any prefix before `/.config/opencode/…`
matches). Acceptable for personal skill scripts. For least privilege, allowlist only the expanded
`$HOME`/absolute form and invoke scripts by canonical absolute path.

## What Was WRONG in the First Diagnosis

- **Wrong model**: assumed array + "last-match-wins" ordering. Config is a MAP; ordering as
  originally described does not apply. (`opencode agent list` renders it array-like — misleading.)
- **Wrong fix**: "force absolute paths in the system prompt." Works but treats the symptom, is
  fragile (depends on model obeying), and misses that a single leading-`*` pattern fixes it at
  the config layer for all agents and all path forms.
- **Redundant noise**: ~20 exact-literal + per-form patterns added to `cli.md`. All replaced by
  3 leading-`*` globs.

## Verification (all passed, 2026-07-27)

Run via `opencode run --agent cli --model github-copilot/claude-haiku-4.5`, cwd
`/home/andy/.nix/home/andy/dotfiles/tools/agent-config`:

| Case | Command form | Result |
|---|---|---|
| tilde, no arg | `~/.config/opencode/skills/docs/scripts/inventory` | runs, no prompt |
| tilde, with arg | `~/.config/opencode/skills/docs/scripts/inventory .agent/bugs` | runs, no prompt |
| $HOME, with arg | `$HOME/.config/opencode/skills/docs/scripts/frontmatter .agent/frontier.md` | runs, no prompt |
| absolute | `/home/andy/.config/opencode/skills/docs/scripts/inventory` | runs, no prompt |

Pre-fix baseline (for regression): literal tilde command → `auto-rejecting`. Re-run the tilde
no-arg case after any permission change; it must run silently.

## Experiments (replicate)

CLI non-interactive; no TUI needed. Run from a dir containing `.agent/` for meaningful output.

### Inspect deployed pattern map
```bash
grep -o '"[^"]*scripts[^"]*":"[^"]*"' ~/.config/opencode/opencode.json
```

### Exp 1 — baseline reproduce (expect ask, pre-fix only)
```bash
opencode run --agent cli --model github-copilot/claude-haiku-4.5 \
  "Run verbatim, keep the tilde, do not rewrite: ~/.config/opencode/skills/docs/scripts/inventory"
```
Pre-fix: `permission requested … auto-rejecting`. Post-fix: script runs.

### Exp 2 — --auto bypass (proves script works, permission is the blocker)
```bash
opencode run --auto --agent cli --model github-copilot/claude-haiku-4.5 \
  "run: bash ~/.config/opencode/skills/docs/scripts/inventory"
```
Always runs (--auto approves non-denied).

### Exp 3 — post-fix tilde (expect run, no prompt)
```bash
opencode run --agent cli --model github-copilot/claude-haiku-4.5 \
  "Run verbatim, keep tilde: ~/.config/opencode/skills/docs/scripts/inventory"
```

### Exp 4 — negative control (arbitrary absolute exe still asks)
```bash
opencode run --agent cli --model github-copilot/claude-haiku-4.5 "run: /usr/bin/env echo hi"
```
Expect `auto-rejecting` — not in allowlist. Confirms allow is scoped, not global.

### Notes
- `cli.md` / `opencode.json` symlinks are live: pattern edits to the source take effect for the
  next `opencode run` immediately. `opencode.nix` edits need `nixos-rebuild` to reach `opencode.json`.
- Model may silently rewrite `~`→absolute; force literal tilde with "keep the tilde, do not rewrite".
