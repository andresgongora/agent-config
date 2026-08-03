---
name: git
description: "Git safety constraints for state-mutating work: staging, committing, branching, merge, rebase, conflict resolution, push, undo, or risky Git-state inspection. Also load for object-store space, connectivity checks, repacking, or merged-local-branch review. Skip conceptual Git questions and repository work with no Git action."
---

# Git

## Mutation guardrails

1. Inspect repository state, current branch, recent history, and relevant diff before Git mutation.
2. Stage exact intended file paths only. No directories, globs, `git add .`, `git add -u`, or `git commit -a`.
3. Dirty tree before branch movement, merge, or rebase: stop and assess.
4. Unrelated or entangled changes: stop and ask.
5. Prefer reversible operations. No shared-history rewrite, destructive cleanup, or branch deletion without explicit user approval.
6. Discover repository remote, base branch, and policy before any sync or push. Never assume `origin` or `main`.

## Commit integrity

- Inspect status and proposed diff. `.gitignore` neither untracks nor protects tracked/staged secrets.
- Suspected secret blocks commit. Do not expose secret value in output.
- Before each commit, inspect its staged diff.
- Before each commit: run `scripts/git-secret-scan` from repository root.
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
