# Deployed agent rules

`AGENTS.md` in this directory is meant to be installed as the user-level `AGENTS.md`, so every
session in every project loads it. Project and nested `AGENTS.md` files narrow or override it.
Deployment wiring lives outside this repo; see the root [`README.md`](../README.md).

<!------------------------------------------------------------------------------------------------->
## Maintainer notes
<!------------------------------------------------------------------------------------------------->

- Every line is paid for on every session. A rule that fires rarely, or a slogan with no testable
  action, costs more than it returns.
- Before saving, confirm each named skill exists under `skills/` and each named worker under
  `agents/`.
