---
name: git
description: "Guides safe Git state changes. Load before Git mutations or risky Git-state inspection, including staging, commits, branch changes, merges, rebases, pushes, undo, or maintenance. Skip conceptual Git questions."
---

## Rules

- Inspect before changing state.
- Preserve unrelated work and identify intended paths.
- Prefer narrow, reversible changes.
- Always run the Git safety and secret checks required by the commit transaction.
- Run project lint, format, tests, or builds only when the caller requests them or repository policy requires them.
- Do not make commit-only workers run unrelated project validation.
- Helpers are bundled: run `scripts/<name>` relative to this skill directory (the folder holding this `SKILL.md`).

### Changes

- Inspect status, branch, active operations, conflicts, upstream, and relevant diffs.
- Make the smallest scoped change with narrow path arguments.

### Commit transaction

Helpers: `git-repo-context`, `git-change-inspect`, `git-stage-group`, `git-secret-scan`, `git-commit-group`. Native read-only Git is allowed. Exact `git add -- <approved-clean-gitlink>` is allowed. `git-change-digest` is for delegated extraction only, never this flow. No ad-hoc scripts or inline code.

1. Preflight, one call: `git-repo-context`, `git-change-inspect`, `git submodule status --recursive`, active-operation checks (`git rev-parse --git-path` for `MERGE_HEAD`, `CHERRY_PICK_HEAD`, `REVERT_HEAD`, `rebase-merge`, `rebase-apply`; test each exists), and `git ls-files -u`. Active operation, unresolved path, or no changes: report, stop.
2. Submodules: skip when `git submodule status --recursive` lists none. Otherwise inspect each with native read-only Git. Uninitialized or conflicted: report, stop, ask user. Never initialize, update, fetch, reset, or discard a submodule.
   - Dirty submodule: ask *interactive question*: `Commit recursively`, `Leave submodule changes uncommitted`, `Cancel`.
   - `Commit recursively`: run this transaction in each dirty submodule, deepest first, each with its own approval. Form parent groups only after every submodule is clean.
   - `Leave submodule changes uncommitted`: exclude each dirty submodule and its parent gitlink; continue with unrelated parent changes.
3. `STAGED-HINT` paths are grouping hints. If any exist, run `git-stage-group --unstage-all`. Partial-hunk rejection: report listed paths, ask user to fully stage or unstage them, restart at step 1 after resolution.
4. Form independently valuable atomic groups from `git-change-inspect` paths and native diff content. Do not infer summaries from path names. Prefer one group when independence is unclear. Paths outside known task scope: ask include/exclude before planning.
5. Write one concise, imperative, project-consistent message per group. Print every group as plain assistant text, once, in one message with no tool call. Never print with a shell command (`echo`, `printf`, `true`, or any no-op) or separate groups with shell output. Print before step 6, using this heading template:

   ```markdown
   ### 1. `type: summary`
   - `path/a`
   - `path/b` (new)
   - `path/c` (deleted)
   ```

   Record each group's approval snapshot: its `git-change-inspect` lines (state, adds, dels, path).
6. Approval: after the step 5 message, ask one *interactive question*. Keep its text short; it refers to the printed groups (e.g. "Approve the 2 groups printed above?") and does not repeat them. Options: `Approve shown groups`, `Reject; revise`, `Cancel`. Approval covers only shown paths and messages. Skip the question only when the caller's mission stated the exact paths and message. Custom answer, stale approval, or unavailable question tool: stop, restart at step 1.
7. Per group:
   a. Re-run `git-change-inspect`; any line differing from the group's snapshot invalidates approval: stop, restart at step 1.
   b. Stage non-gitlinks with `git-stage-group` (NUL-delimited paths). Gitlinks: native `git add -- <submodule-path>` only after confirming the submodule is clean. Never pass gitlinks to `git-stage-group`.
   c. Run `git-change-inspect --staged`; staged set must match the approved group, else restart at step 1.
   d. Run `git-secret-scan`. Secret finding, identity finding, or helper failure: stop, report exact failure, do not continue. Full-name warning: ask explicit acceptance; only acceptance permits `git-secret-scan --accept-identity-exposure`, then repeat from c.
   e. Run `git-commit-group --message-file <file> --paths-file <file>` with the full path list including gitlinks. It refuses any mismatch with the staged set.
   - Any stop after a successful commit: report completed `OK` SHAs, approved uncommitted groups, and remaining changes. Do not roll back. A retry restarts at step 1 with fresh approval.
8. Report `OK: <sha> <subject>` per commit, remaining changes, and secret-scan result. Never push.

### Other operations

- Resolve only in-scope conflicts. Do not mutate submodule contents without explicit scope.
- Before branch movement or sync, verify branch and upstream. For history rewriting, require a clean tree and dry run; for maintenance, read the helper contract.
- Repository maintenance across a folder tree: `scripts/git-housekeep`; read its contract in `scripts/README.md` first.
- Re-signing or re-dating commits from `<COMMIT>`: `scripts/git-resign-from`; dry-run first, then explicit approval.
- Bounded per-path diff digests for delegated workers: `scripts/git-change-digest`; feed paths from `scripts/git-change-inspect`.

## Workflow

1. Define operation, scope, and authority. If authority is missing, inspect only.
2. Inspect repository state and relevant content.
3. Apply the applicable procedure with the smallest scoped change.
4. Verify the relevant result and report remaining work.

## Guardrails

- Unrequested commits, discards, history rewrites, remote changes, or shared-branch changes need explicit user approval; otherwise leave unchanged and ask.
- Unexpected changes, unresolved conflicts, partial staging, or failed safety checks: stop, leave state unchanged, and report.
- Dirty, conflicted, or uninitialized submodule: leave parent unchanged, report, and ask user what to do.
- Secret found: stop, leave state unchanged, do not expose its value, and report only path or context.
- Never push. If user requests, explain CLI command they must run. If request is force-push, perform impact review, then explain to use `--force-with-lease`.
