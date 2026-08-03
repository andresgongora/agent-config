# Git scripts

## git-secret-scan

Run from repository root before each commit. Requires all three commands:

```bash
~/.config/opencode/skills/git/scripts/git-secret-scan
```

Exact scanner arguments:

```bash
gitleaks git --pre-commit --staged --redact=100
git diff --cached --binary --no-ext-diff -- . | trufflehog stdin --fail --fail-on-scan-errors
git diff --cached --name-only -z | xargs -0 detect-secrets-hook [--baseline .secrets.baseline]
```

The baseline argument is included only when `.secrets.baseline` exists. The script uses `set -o pipefail`; any scanner failure blocks commit.

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
