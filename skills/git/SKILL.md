---
name: git
description: "Guides safe Git state changes. Load before Git mutations or risky Git-state inspection, including staging, commits, branch changes, merges, rebases, pushes, undo, or maintenance. Skip conceptual Git questions."
---

## Rules

- Inspect before changing state.
- Preserve unrelated work and identify intended paths.
- Prefer narrow, reversible changes.
- Always run the Git safety and secret checks required by the commit flow.
- Run project lint, format, tests, or builds only when the caller requests them or repository policy requires them.
- Do not make commit-only workers run unrelated project validation.

## Body

### Changes

- Inspect status, branch, active operations, conflicts, upstream, and relevant diffs.
- Make the smallest scoped change with narrow path arguments.

### Commits

- Commit flow: run `scripts/git-repo-context` and `scripts/git-change-inspect`; stage exact paths with `scripts/git-stage-group`; inspect, scan with `scripts/git-secret-scan`, then use `scripts/git-commit-group`.
- Stage clean, intended gitlinks with native `git add -- <submodule-path>`. Before unstage or restage, if a path is both staged and unstaged, leave it and ask the user to fully stage or unstage it.
- After staged content changes, repeat inspection and scanning. Use a concise, imperative, terse message.

### Other operations

- Resolve only in-scope conflicts. Do not mutate submodule contents without explicit scope.
- Before branch movement or sync, verify branch and upstream. For history rewriting, require a clean tree and dry run; for maintenance, read the helper contract.

## Workflow

1. Define operation, scope, and authority. If authority is missing, inspect only.
2. Inspect repository state and relevant content.
3. Apply the applicable Body procedure with the smallest scoped change.
4. Verify the relevant result and report remaining work.

## Guardrails

- Commit, discard, rewrite history, change remotes, or modify shared branches only after explicit user approval; otherwise leave unchanged and ask.
- Unexpected changes, unresolved conflicts, partial staging, or failed safety checks: stop, leave state unchanged, and report.
- Dirty, conflicted, or uninitialized submodule: leave parent unchanged, report, and ask user what to do.
- Secret found: stop, leave state unchanged, do not expose its value, and report only path or context.
- Never push. If user requests, explain CLI command they must run. If request is force-push, perform impact review, then explain to use `--force-with-lease`.
