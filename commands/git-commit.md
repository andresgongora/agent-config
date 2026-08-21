---
description: "Review and approve exact atomic groups, then create safe Git commits; never push"
---
Commit current repository changes. Apply loaded version-control safety constraints. `$ARGUMENTS` must be empty; otherwise stop and ask user to invoke without arguments.

Use only these helpers: `git-repo-context`, `git-change-inspect`, `git-stage-group`, `git-lint-changed`, `git-secret-scan`, `git-commit-group`. No delegation, ad-hoc scripts, inline code, Python, or `git-change-digest`. Native read-only Git inspection and ordinary temporary files for helper inputs or approval snapshots allowed.

1. Run `git-repo-context`, `git-change-inspect`, and native Git checks for active operations and unresolved entries. Active operation or unresolved path: report, stop. No changes: report, stop.
2. `STAGED-HINT` paths are grouping hints only. If any exist, run `git-stage-group --unstage-all` before grouping; it rejects partial-hunk staging. Failure: report listed paths; ask user to fully stage or fully unstage each outside this flow; restart at step 1 after resolution.
3. Inspect current diff and recent commit subjects with native read-only Git. Form independently valuable atomic groups from `git-change-inspect` paths and inspected content. Retain exact raw-diff content snapshot per group, not only paths or counts. Do not infer semantic summaries from path names. Prefer one group when independence is unclear. If paths outside known task scope exist, ask include/exclude before planning.
4. Run `git-lint-changed`. Failure blocks; report exact files and output. Later snapshot comparisons invalidate approval if content changes.
5. Write one concise, imperative, project-consistent message per group. Show every group and message before asking anything:

   ```markdown
   ### 1. `type: summary`
   - `path/a`
   - `path/b` (new)
   - `path/c` (deleted)
   ```

6. Stop. Ask *interactive question*: `Approve shown groups`, `Reject; revise`, `Cancel`. Approval covers only shown paths and messages. Custom answer, stale approval, unavailable question tool, or unexpected worktree change before staging: stop; restart at step 1 and show a new plan.
7. Before each group, use native Git checks for active operations and unresolved entries; compare every uncommitted approved group's raw diff with its retained snapshot. Any difference invalidates approval: stop, restart at step 1, show new plan. Then make exact NUL-delimited path list and message file; run `git-stage-group`; run `git-change-inspect --staged` and inspect staged diff. Paths and content must match approved group; mismatch: stop, restart at step 1, show new plan. Run `git-secret-scan`, then `git-commit-group`; inspect committed diff against retained snapshot before next group. Mismatch: stop; report unexpected commit; do not continue.
   - Identity path or username finding, secret finding, or any helper failure: stop; report exact failure; do not continue.
   - Full-name warning: stop. Ask explicit acceptance. Only acceptance permits rerunning `git-secret-scan --accept-identity-exposure`, then repeating this step's pre-staging checks and staged-diff comparison. Rejection or any later failure stops transaction.
   - If any stop follows a successful commit: report completed `OK` SHAs, uncommitted approved groups, and remaining changes. Do not roll back. Any retry restarts at step 1 with fresh approval.
8. Run `git-change-inspect`. Report `OK: <sha> <subject>` per commit, remaining changes, lint result, and secret-scan result. Do not push.

Re-read final file. No other edits.
