# Git scripts

## git-repo-context

Run from any repository subdirectory. Prints one preflight block: a fixed 6-line header (branch, upstream, remote name/url, ahead/behind counts, toplevel path, short HEAD), then one `STAGED-HINT` line per currently-staged path (or a single `STAGED-HINT\tNONE` line when nothing is staged). Silent otherwise. Never assumes `origin`/`main` — discovers them from the actual upstream/remote config.

```bash
~/.config/opencode/skills/git/scripts/git-repo-context
```

Run once at the start of `/git-commit` alongside `git-change-inspect`. The `STAGED-HINT` lines are the grouping hint for pre-existing staged content — never a block.

## git-change-inspect

Run from any repository subdirectory. Prints one `CHANGE` line per deduplicated changed/untracked path: `CHANGE\t<state>\t<+adds>\t<-dels>\t<path>[\t<type>]`. `<state>` is `staged`, `unstaged`, `untracked`, or `both`. Path field is the raw literal path (tab-separated, not shell-quoted); a path containing a literal tab or newline fails closed (nonzero exit) rather than emitting an ambiguous line. Silent otherwise; `--context` prepends one `REPO` line (toplevel, branch, short HEAD). Does not lint and does not gate anything — pure state reporter.

```bash
~/.config/opencode/skills/git/scripts/git-change-inspect
~/.config/opencode/skills/git/scripts/git-change-inspect --worktree
~/.config/opencode/skills/git/scripts/git-change-inspect --staged
~/.config/opencode/skills/git/scripts/git-change-inspect --context
~/.config/opencode/skills/git/scripts/git-change-inspect --types
```

Default scope supports `/git-commit` preflight before grouping. `--staged` supports the per-commit staged integrity gate. `--types` is opt-in (shells out to `file --brief` per path); omit unless a type column is actually needed. It does not replace repository-specific test, typecheck, build, or formatter commands, and does not replace `git-lint-changed`.

## git-change-digest

Run from any repository subdirectory. Bounded per-file change digest for delegated extraction workers — keeps raw `git diff` bytes out of the caller's context. `git-change-digest [--staged|--worktree] [--max-lines N] -- <path> [<path> ...]`. Per path prints `DIGEST\t<path>\t<state>\t+<adds>\t-<dels>`, then `HUNK` lines (hunk headers), then capped `LINE` entries, then `TRUNCATED\t<path>\t<n-more>` if capped. Binary files print `BINARY\t<path>` instead of content. Unknown/unchanged path: `die`.

```bash
~/.config/opencode/skills/git/scripts/git-change-digest -- path/a path/b
~/.config/opencode/skills/git/scripts/git-change-digest --staged --max-lines 20 -- path/a
```

Feed exact paths from `git-change-inspect`; no globs, no "all files" mode.

## git-lint-changed

Run from any repository subdirectory. Lints changed `.md`/`.markdown` files with `markdownlint-cli2`. Silent on success (no output, exit 0); skips entirely, exit 0, when no changed Markdown files exist. Failure prints lint output and exits nonzero. Missing `markdownlint-cli2` exits nonzero with an install hint.

```bash
~/.config/opencode/skills/git/scripts/git-lint-changed
~/.config/opencode/skills/git/scripts/git-lint-changed --staged
~/.config/opencode/skills/git/scripts/git-lint-changed --worktree
```

Called once by `/git-commit` before grouping. Not part of `git-change-inspect`.

## git-stage-group

Run from any repository subdirectory. Deterministic index management for one commit group — replaces hand-rolled `git add`/`git reset`.

```bash
~/.config/opencode/skills/git/scripts/git-stage-group --unstage-all
printf 'path/a\0path/b\0' | ~/.config/opencode/skills/git/scripts/git-stage-group
~/.config/opencode/skills/git/scripts/git-stage-group --paths-file paths.bin
```

`--unstage-all` resets the index to HEAD. Before resetting (either mode), checks for partial-hunk staging: any path with BOTH staged and unstaged changes blocks with an explicit list and no override flag — that state means the user hand-staged specific hunks; they must fully stage or fully unstage the listed files outside this script, then retry. No globs; any path containing `*`/`?` or naming a directory is rejected. Stage mode verifies the resulting staged set exactly matches the requested set, or dies listing the mismatch and leaves the index clean. Structured success output only: one `OK:` line, nothing else. Never touches working-tree file content.

## git-commit-group

Run from repository root. Commits the currently-staged set after verifying it exactly matches an expected path list — a safety check against a stale or partial stage from an earlier step.

```bash
~/.config/opencode/skills/git/scripts/git-commit-group --message-file msg.txt --paths-file paths.bin
```

Both `--message-file` and `--paths-file` are required (no stdin, to stay pipeline-composable without contention). Dies on: empty stage, empty/whitespace message, or any mismatch between staged paths and `--paths-file` (lists extras/missing). On success: `git commit -F <message-file>`, then one line `OK: <short-sha> <subject>`.

## git-secret-scan

Run from repository root before each commit. Default scanner: `gitleaks`. Before secret scanning, it checks added staged text for local identity: `$HOME`/`/home/$USER` paths and standalone username block; normalized full Git name matches warn and need explicit user acceptance. Silent on success beyond one `OK:` line; scanner output only surfaces on failure. Override secret scanner with `--scanner`:

```bash
~/.config/opencode/skills/git/scripts/git-secret-scan
~/.config/opencode/skills/git/scripts/git-secret-scan --scanner trufflehog
~/.config/opencode/skills/git/scripts/git-secret-scan --scanner detect-secrets
~/.config/opencode/skills/git/scripts/git-secret-scan --scanner all
~/.config/opencode/skills/git/scripts/git-secret-scan --skip-identity-scan
~/.config/opencode/skills/git/scripts/git-secret-scan --accept-identity-exposure
```

Only the selected scanner's command is required; the other two are not checked. Exact scanner arguments:

```bash
gitleaks git --pre-commit --staged --redact=100
git diff --cached --binary --no-ext-diff -- . | trufflehog stdin --fail --fail-on-scan-errors
git diff --cached --name-only -z | xargs -0 detect-secrets-hook [--baseline .secrets.baseline]
```

The baseline argument is included only when `.secrets.baseline` exists. `--scanner all` runs every scanner and fails closed if any is missing, finds a secret, or errors. Full-name findings use fuzzy normalized matching (`John West`, `johnwest.com`, `john-west`); warning severity still stops commit flow until user explicitly accepts, then scanner is rerun with `--accept-identity-exposure`. `--skip-identity-scan` is exceptional: only use after explicit user acceptance of identity exposure.

## git-resign-from

Run from repository root, clean working tree required. Rewrites `<COMMIT>^..HEAD`, re-signing every commit with a single new author/committer date (default: now). History-rewriting — new SHAs from `<COMMIT>` forward. Never pushes.

```bash
~/.config/opencode/skills/git/scripts/git-resign-from --from <COMMIT> --dry-run
~/.config/opencode/skills/git/scripts/git-resign-from --from <COMMIT>
~/.config/opencode/skills/git/scripts/git-resign-from --from <COMMIT> --date "2026-08-01 09:00:00"
```

`--dry-run` prints `REWRITE-RANGE` and one `COMMIT` line per affected commit (short hash, current signing key, subject) with no mutation. Live run resigns via `git rebase --exec 'GIT_COMMITTER_DATE=... git commit --amend --no-edit -S --date=...'`, then prints `OK:` plus the same `COMMIT` preview against the new SHAs. Dies on dirty tree, invalid/non-ancestor commit, or root-commit target (no parent to rebase onto). Rewritten commits already pushed need explicit user approval and normal (never force) push, per this skill's mutation guardrails.

## git-housekeep

Contract for `git-housekeep`.

- Accepts one folder tree. Finds Git repositories below it.
- Default: `git repack -d -l`. Retains objects. No fetch, prune, GC, reflog expiry, reset, clean, remote mutation, or worktree change.
- `--report`: object-size and merged-branch candidates only. No writes.
- `--verify`: read-only `git fsck --connectivity-only --no-dangling` before maintenance.
- `--base BRANCH`: required for merged-branch review and `--delete-merged`. Never inferred.
- `--delete-merged`: local branches only. Candidate needs selected-base merge, present upstream tracking ref, and no checkout. `git branch -d` repeats merge safety.
- Review report before `--delete-merged`; explicit user approval required. Protected-branch policy remains repository-specific.
- No `git gc`. It can expire reflogs or prune unreachable objects.

```bash
~/.config/opencode/skills/git/scripts/git-housekeep --report /path/to/repos
~/.config/opencode/skills/git/scripts/git-housekeep --verify /path/to/repos
~/.config/opencode/skills/git/scripts/git-housekeep /path/to/repos
~/.config/opencode/skills/git/scripts/git-housekeep --delete-merged --base BASE /path/to/repos
```
