---
description: "Review and approve exact atomic groups, then create safe Git commits; never push"
---
Commit current repository changes. Apply trailing injected instructions when present unless they conflict with version-control safety constraints.

Use only these helpers: `git-repo-context`, `git-change-inspect`, `git-stage-group`, `git-lint-changed`, `git-secret-scan`, `git-commit-group`. No delegation, ad-hoc scripts, inline code, Python, or `git-change-digest`. Native read-only Git inspection, exact `git add -- <approved-clean-gitlink>`, and ordinary temporary files for helper inputs or approval snapshots allowed.

1. Run `git-repo-context`, `git-change-inspect`, and native Git checks for active operations and unresolved entries. Active operation or unresolved path: report, stop. No changes: report, stop.
2. Inspect all registered submodules recursively with native read-only Git, then inspect every initialized child. Uninitialized or conflicted submodule: report, stop, ask user what to do. Never initialize, update, fetch, reset, or discard a submodule.
   - Dirty submodule: stop and ask *interactive question*: `Commit recursively`, `Leave submodule changes uncommitted`, `Cancel`.
   - `Commit recursively`: run this complete flow in every dirty submodule, deepest first. Obtain separate exact-group approval per repository. Reinspect all submodules after each commit. Do not form parent groups until every submodule is clean.
   - `Leave submodule changes uncommitted`: exclude every dirty submodule and its parent gitlink from this transaction. Continue only with unrelated parent changes.
3. `STAGED-HINT` paths are grouping hints only. If any exist, run `git-stage-group --unstage-all` before grouping; it rejects partial-hunk staging. Failure: report listed paths; ask user to fully stage or fully unstage each outside this flow; restart at step 1 after resolution.
4. Inspect current diff and recent commit subjects with native read-only Git. Form independently valuable atomic groups from `git-change-inspect` paths and inspected content. Retain exact raw-diff content snapshot per group, not only paths or counts. Do not infer semantic summaries from path names. Prefer one group when independence is unclear. If paths outside known task scope exist, ask include/exclude before planning.
5. Run `git-lint-changed`. Failure blocks; report exact files and output. Later snapshot comparisons invalidate approval if content changes.
6. Write one concise, imperative, project-consistent message per group. Show every group and message before asking anything:

   ```markdown
   ### 1. `type: summary`
   - `path/a`
   - `path/b` (new)
   - `path/c` (deleted)
   ```

7. Stop. Ask *interactive question*: `Approve shown groups`, `Reject; revise`, `Cancel`. Approval covers only shown paths and messages. Custom answer, stale approval, unavailable question tool, or unexpected worktree change before staging: stop; restart at step 1 and show a new plan.
8. Before each group, use native Git checks for active operations and unresolved entries; compare every uncommitted approved group's raw diff with its retained snapshot. Any difference invalidates approval: stop, restart at step 1, show new plan. Then make exact NUL-delimited non-gitlink and gitlink path lists plus message file.
   - Stage non-gitlinks with `git-stage-group`. Gitlinks are submodule directory paths, so never pass them to that helper. Stage only approved gitlinks with native `git add -- <submodule-path>` after confirming each referenced submodule is clean. Gitlink-only group: use `git-stage-group --unstage-all` first, then native `git add`.
   - Run `git-change-inspect --staged` and inspect staged diff. Paths and content must match approved group; mismatch: stop, restart at step 1, show new plan. Run `git-secret-scan`, then `git-commit-group` with full path list including gitlinks; inspect committed diff against retained snapshot before next group. Mismatch: stop; report unexpected commit; do not continue.
   - Identity path or username finding, secret finding, or any helper failure: stop; report exact failure; do not continue.
   - Full-name warning: stop. Ask explicit acceptance. Only acceptance permits rerunning `git-secret-scan --accept-identity-exposure`, then repeating this step's pre-staging checks and staged-diff comparison. Rejection or any later failure stops transaction.
   - If any stop follows a successful commit: report completed `OK` SHAs, uncommitted approved groups, and remaining changes. Do not roll back. Any retry restarts at step 1 with fresh approval.
9. Run `git-change-inspect`. Report `OK: <sha> <subject>` per commit, remaining changes, lint result, and secret-scan result. Do not push.

$ARGUMENTS
