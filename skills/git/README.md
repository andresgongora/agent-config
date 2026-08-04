# git

Git safety constraints. Not Git tutorial.

## Design intent

Models know common Git syntax. This skill adds durable behavior where syntax is not enough:

- exact-path staging and dirty-tree stops
- explicit boundaries for destructive or shared-history operations
- per-commit staged secret scanning, with honest unavailable-tool handling
- deliberate push discovery instead of assumed `origin` and `main`
- bounded local maintenance and change-inspection helpers

`gitleaks`, `trufflehog`, and `detect-secrets` are independent scan gates. `scripts/git-secret-scan` defaults to `gitleaks`, selects a different scanner via `--scanner`, or runs all three with `--scanner all`; it fails closed when the selected command is missing, finds a secret, or errors. It also blocks staged local paths/usernames and warns on normalized full-name matches. Scanner output never replaces manual staged-diff inspection.

## Trigger

Load for Git mutations and risky Git-state inspection. Load for object-store space, connectivity checks, repacking, or merged-local-branch review. Skip conceptual questions and repo work without Git action.

## Maintainer rules

- Keep safety invariants, not generic command recipes.
- Keep multi-commit approval interface in slash command, not here.
- Keep scanner contract tied to the three supported executables and explicit staged-content commands; default single-scanner behavior stays in the script, not here.
- Keep rare maintenance detail beside its script.
- Do not encode branch names, remotes, or organization policy.

## See also

- `SKILL.md`
- `scripts/README.md`
- `scripts/git-secret-scan`
- `scripts/git-change-inspect`
- `../../deploy/AGENTS.md`
