# git

Git safety constraints. Not Git tutorial.

## Design intent

Models know common Git syntax. This skill adds durable behavior where syntax is not enough:

- exact-path staging and dirty-tree stops
- explicit boundaries for destructive or shared-history operations
- per-commit staged secret scanning, with honest unavailable-tool handling
- deliberate push discovery instead of assumed `origin` and `main`
- bounded local maintenance helper

`gitleaks`, `trufflehog`, and `detect-secrets` are independent scan gates. `scripts/git-secret-scan` runs all three and fails closed when any command is missing, finds a secret, or errors. Scanner output never replaces manual staged-diff inspection.

## Trigger

Load for Git mutations and risky Git-state inspection. Load for object-store space, connectivity checks, repacking, or merged-local-branch review. Skip conceptual questions and repo work without Git action.

## Maintainer rules

- Keep safety invariants, not generic command recipes.
- Keep multi-commit approval interface in slash command, not here.
- Keep scanner contract tied to all three supported executables and explicit staged-content commands.
- Keep rare maintenance detail beside its script.
- Do not encode branch names, remotes, or organization policy.

## See also

- `SKILL.md`
- `scripts/README.md`
- `scripts/git-secret-scan`
- `../../deploy/AGENTS.md`
