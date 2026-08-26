# Deployed agent rules

`AGENTS.md` in this directory is meant to be installed as the user-level `AGENTS.md`, so every
session in every project loads it. Project and nested `AGENTS.md` files narrow or override it.
Deployment wiring lives outside this repo; see the root [`README.md`](../README.md).

<!------------------------------------------------------------------------------------------------->
## Why this file names skills directly
<!------------------------------------------------------------------------------------------------->

Everywhere else in the repo, artifacts refer to each other by behavior rather than by name, so any
one of them can be swapped for an equivalent. This file is the exception, and the only one. Because
it is the single glue point, replacing one skill with another means editing here and nowhere else.

<!------------------------------------------------------------------------------------------------->
## Description-driven routing
<!------------------------------------------------------------------------------------------------->

Step 4 of `## Workflow` tells agents when to inspect available skill descriptions: throughout
non-trivial work, before acting in a matching domain, and again when the task changes. Each skill's
frontmatter remains the routing truth, without a second domain-to-skill index that can drift.

<!------------------------------------------------------------------------------------------------->
## Maintainer notes
<!------------------------------------------------------------------------------------------------->

- Workers get no descriptions here. `## Delegated Workers` carries only the precedence a subagent's
  own `description` cannot state, such as choosing between an inline fetch, a cheap one-shot worker,
  and full research.
- Every line is paid for on every session. A rule that fires rarely, or a slogan with no testable
  action, costs more than it returns.
- Before saving, confirm each named skill exists under `skills/` and each named worker under
  `agents/`.
