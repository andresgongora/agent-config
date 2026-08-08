---
description: Plan, show, approve, then create safe atomic Git commits; does not push
license: MIT
---
Create reviewed commits for current repository changes. Apply loaded version-control safety constraints.

Run no helper scripts except `git-repo-context`, `git-change-inspect`, `git-stage-group`, `git-lint-changed`, `git-secret-scan`, and `git-commit-group`. Do not delegate. Do not run ad-hoc scripts, inline code, Python, or `git-change-digest`. Native read-only Git inspection and ordinary temporary-file creation needed by the approved helpers are allowed.

1. Run `git-repo-context` and `git-change-inspect`. No changes: report, stop.
2. Capture `STAGED-HINT` paths as a grouping hint only. Before any reset, run `git-stage-group --unstage-all` to apply its partial-hunk guard. If it fails, report exact paths; ask user to fully stage or fully unstage each outside this flow. Rerun from step 1 after resolution.
3. Run `git-lint-changed`. Failure blocks; report exact failing files and output.
4. Inspect current changes and recent commit subjects with native read-only Git commands. Group `git-change-inspect` paths into independently valuable atomic commits. Use inspected diff content and `STAGED-HINT`; do not invent per-file semantic summaries. Prefer one group when independence is unclear. Task-scope-external paths: ask include/exclude before forming a plan.
5. Generate one concise, imperative, project-consistent message per group. Present every group and message before asking anything:

   ```markdown
   ### 1. `type: summary`
   - `path/a`
   - `path/b` (new)
   - `path/c` (deleted)
   ```

6. Stop. Ask interactive question tool: `Approve shown groups`, `Reject; revise`, `Cancel`. Approval authorizes only exactly shown paths and messages. Custom answer, old approval, unavailable question tool, or any change discovered before execution: stop; rerun from step 1 and show a new plan.
7. Per approved group, in order: build exact NUL-delimited path list and message file; run `git-stage-group` → `git-change-inspect --staged` and inspect the staged diff with native read-only Git → `git-secret-scan` → `git-commit-group`. The staged paths and content must match the approved group; otherwise stop, rerun from step 1, and show a new plan. Any nonzero exit: stop; report exact failure; do not continue.
   - Secret, local-path, or username finding blocks.
   - Full-name warning: stop; ask explicit acceptance; rerun `git-secret-scan --accept-identity-exposure` only after acceptance.
8. Run `git-change-inspect`. Report commits made (`OK: <sha> <subject>` per group), remaining changes, scanner availability, and lint status. Do not push.
