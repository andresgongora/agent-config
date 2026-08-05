---
name: git
description: "Git safety constraints for state-mutating work: staging, committing, branching, merge, rebase, conflict resolution, push, undo, or risky Git-state inspection. Also load for object-store space, connectivity checks, repacking, or merged-local-branch review. Skip conceptual Git questions and repository work with no Git action."
---

# Git

## Mutation guardrails

1. Inspect repository state, current branch, recent history, and relevant diff before Git mutation.
2. Stage exact intended file paths only, via `scripts/git-stage-group`. No directories, globs, `git add .`, `git add -u`, or `git commit -a`.
3. Dirty tree before branch movement, merge, or rebase: stop and assess.
4. Pre-existing staged content is reversible input, not a blocker. Command-specific flow can unstage and restage it while forming groups. This skill only requires the partial-hunk guard below before any reset. Unrelated changes outside the task's own scope: stop and ask.
5. Prefer reversible operations. No shared-history rewrite, destructive cleanup, or branch deletion without explicit user approval.
6. Discover repository remote, base branch, and policy before any sync or push. Never assume `origin` or `main`; use `scripts/git-repo-context` to discover them.

## Commit integrity

- Inspect status and proposed diff. `.gitignore` neither untracks nor protects tracked/staged secrets.
- Suspected secret blocks commit. Do not expose secret value in output.
- Before each commit, inspect its staged diff.
- Preflight, before grouping: run `scripts/git-repo-context` and `scripts/git-change-inspect`; both NUL-safely report state and are silent beyond their structured output. `--staged` on `git-change-inspect` supports the per-commit staged integrity gate.
- Before grouping: run `scripts/git-lint-changed`. Failure blocks commit.
- Resetting the index (`scripts/git-stage-group --unstage-all` or any restage): if a path has both staged and unstaged changes for the same file, that is partial-hunk staging — the script blocks and lists it, no override flag exists. Stop and ask the user to fully stage or fully unstage each listed file outside this flow, then retry. Never silently reset a partial-hunk stage.
- Per-file change context for delegated extraction: `scripts/git-change-digest`; keeps raw diff bytes out of the caller's context.
- Before each commit: run `scripts/git-secret-scan` from repository root, then `scripts/git-commit-group`, which independently verifies the staged set matches the expected group before committing.
- Identity findings: staged `$HOME`/`/home/$USER` paths and username are hard blocks. Full-name-like text is warning severity, but stop transaction until user explicitly accepts identity exposure; then rerun scanner with `--accept-identity-exposure`. `--skip-identity-scan` also requires explicit user approval.
- Re-run detection and scan after any staged-content change.
- Commit message: concise, imperative, project-consistent. Use a message-only workflow when requested; it does not own staging or commit execution.

## Commit transaction boundary

- Explicit user request required before commit. A multi-group transaction also needs fresh interactive approval after exact-path plan presentation.
- Command-specific flow owns group review, approval, invalidation, and sequential commits. This skill owns reusable safety constraints and staged integrity gate.
- After every commit, inspect final status. Push only when user explicitly asks; use discovered remote/branch and normal push. Never force-push.

## Conflict and undo

- List unresolved paths with `git diff --name-only --diff-filter=U`. Resolve task-relevant conflicts only; unrelated conflicts: ask.
- Prefer `git revert`, `git restore --staged`, and `git reflog`. `reset --hard`, `clean -fd`, amend of pushed work, force-push, and branch deletion require explicit user intent plus impact review.

## Repository maintenance

- Object-store maintenance, connectivity verification, merged-local-branch review: read `scripts/README.md`, then run `scripts/git-housekeep`.
