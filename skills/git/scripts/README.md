# Git scripts

## git-change-inspect

Run from any repository subdirectory. Reports status, unstaged/staged numstats, deduplicated changed and untracked paths, existing-file types, deleted paths, and lint results for changed `.md`/`.markdown` files. Paths use NUL-delimited Git output internally, so whitespace and newlines remain safe.

```bash
~/.config/opencode/skills/git/scripts/git-change-inspect
~/.config/opencode/skills/git/scripts/git-change-inspect --worktree
~/.config/opencode/skills/git/scripts/git-change-inspect --staged
```

Default scope supports `/commit` preflight before grouping. `--staged` supports the per-commit staged integrity gate. Missing `file`/`markdownlint-cli2` or Markdown lint failure exits nonzero and blocks commit. It does not replace repository-specific test, typecheck, build, or formatter commands.

## git-secret-scan

Run from repository root before each commit. Default scanner: `gitleaks`. Before secret scanning, it checks added staged text for local identity: `$HOME`/`/home/$USER` paths and standalone username block; normalized full Git name matches warn and need explicit user acceptance. Override secret scanner with `--scanner`:

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
