---
name: git
description: >
  Git guardrails and fast workflows. Load for branch create/switch, staging,
  commit, merge, rebase, conflict resolution, push, undo, or git-state
  inspection before risky action. Skip for pure conceptual git explanation or
  work with no git-state change. Use to avoid risky history rewrites,
  dirty-tree mistakes, and broad staging.
---

# Git

## Core rules

1. Inspect state first.
2. Stage only intended files.
3. Dirty tree before checkout/merge/rebase = stop and assess.
4. Do not rewrite shared history.
5. Do not use destructive commands unless user explicitly asked.
6. If non-task files are entangled, stop and ask.

## Repository maintenance

- Use `scripts/git-housekeep` for Git object-store space, connectivity check, repacking, or merged-branch review across one folder tree.
- Default: `git repack -d -l`. Repack retains every Git object. No fetch, prune, GC, reflog expiry, reset, clean, or remote mutation.
- `--report`: inspect object sizes and merged branch candidates only.
- `--verify`: run read-only `git fsck --connectivity-only --no-dangling` before maintenance.
- `--delete-merged`: explicit local-branch deletion only. Candidate must be merged into local `main`/`master` (or `--base`), have a present upstream tracking ref, and not be checked out. `git branch -d` rechecks merge safety.
- Review candidates before `--delete-merged`. Never infer a protected-branch policy beyond selected base.
- No `git gc`: normal GC may expire reflogs or prune unreachable objects. Outside non-destructive contract.

```bash
~/.config/opencode/skills/git/scripts/git-housekeep --report /path/to/repos
~/.config/opencode/skills/git/scripts/git-housekeep --verify /path/to/repos
~/.config/opencode/skills/git/scripts/git-housekeep /path/to/repos
~/.config/opencode/skills/git/scripts/git-housekeep --delete-merged --base main /path/to/repos
```

## Fast state

```bash
git status --porcelain=v2 --branch
git rev-parse --abbrev-ref HEAD
git log --oneline -10
git diff --stat
```

Use before commit, merge, rebase, push, or undo.

## Safe default workflows

### Branch

```bash
git fetch origin --prune
git checkout -b BRANCH
```

If repo uses submodules and branch movement matters:

```bash
git submodule update --init --recursive
```

### Commit

```bash
git status --porcelain=v2 --branch
git add -- FILE1 FILE2
git diff --staged
git commit -m "msg"
```

Prefer small atomic commits. Commit message concise, imperative. Use `caveman-commit` if available.

### Push

```bash
git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
```

### Sync with main

```bash
git fetch origin --prune
git merge origin/main
```

Rebase only when repo/user expects it.

### Conflicts

```bash
git diff --name-only --diff-filter=U
```

Resolve only task-relevant conflicts. Non-task conflicts = ask user.

### Undo safe-first

Prefer non-destructive undo:

```bash
git revert HASH
git restore --staged FILE
git reflog
```

Use `reset --hard`, `clean -fd`, force-push, or branch deletion only with explicit user intent.

## Common traps

- `git add .` stages too much. Prefer explicit paths.
- `commit --amend` on pushed commit rewrites history. Usually wrong.
- `reset --hard` fixes mess by deleting evidence. Dangerous.
- force-push on shared branch can burn others. Avoid.
- conflict in unrelated files usually means stop, not improvise.

## Agent rules

1. Review state before mutating history.
2. Prefer reversible ops.
3. Ask before destructive cleanup or history rewrite.
4. Never assume branch policy; if repo conventions unclear, inspect first.
5. If user asked to commit, still inspect diff/status first.
