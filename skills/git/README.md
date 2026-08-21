# git

Git safety constraints. Not Git tutorial.

## Design intent

Models know common Git syntax. This skill adds durable behavior where syntax is not enough:

- exact-path staging and dirty-tree stops, via deterministic scripts (`git-stage-group`, `git-commit-group`) — not hand-rolled `git add`/`git commit`
- explicit boundaries for destructive or shared-history operations
- per-commit staged secret scanning, with honest unavailable-tool handling
- recursive submodule decision gate; Gitlinks stage through exact native `git add`, never file-only staging helper
- deliberate push discovery instead of assumed `origin` and `main` (`git-repo-context`)
- bounded local maintenance, change-inspection, and change-digest helpers, each with a fixed structured-output contract and no extra noise beyond it
- bounded history-rewrite for re-signing a commit range with a new date (`git-resign-from`), dry-run first, clean-tree required, never pushes

`gitleaks`, `trufflehog`, and `detect-secrets` are independent scan gates. `scripts/git-secret-scan` defaults to `gitleaks`, selects a different scanner via `--scanner`, or runs all three with `--scanner all`; it fails closed when the selected command is missing, finds a secret, or errors. It also blocks staged local paths/usernames and warns on normalized full-name matches. Scanner output never replaces manual staged-diff inspection.

## Trigger

Load for Git mutations and risky Git-state inspection. Load for object-store space, connectivity checks, repacking, or merged-local-branch review. Skip conceptual questions and repo work without Git action.

## Maintainer rules

- Keep safety invariants, not generic command recipes.
- Keep multi-commit approval interface in slash command, not here.
- Keep scanner contract tied to the three supported executables and explicit staged-content commands; default single-scanner behavior stays in the script, not here.
- Keep rare maintenance detail beside its script.
- Keep submodule recursion and Gitlink staging constraints in `SKILL.md` and `/git-commit`; do not widen `git-stage-group` beyond files.
- Do not encode branch names, remotes, or organization policy.

## See also

- `SKILL.md`
- `scripts/README.md`
- `scripts/git-repo-context`
- `scripts/git-change-inspect`
- `scripts/git-change-digest`
- `scripts/git-lint-changed`
- `scripts/git-stage-group`
- `scripts/git-commit-group`
- `scripts/git-secret-scan`
- `scripts/git-resign-from`
- `../../deploy/AGENTS.md`
