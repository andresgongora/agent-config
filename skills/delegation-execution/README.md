# Delegation Execution

Prepares one complex, self-contained mission for execution by an existing generic subagent, with
optional bounded child delegation.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

Nested delegation execution is a context firewall, not a default hierarchy. Main freezes intent and
authority; executor absorbs implementation detail, coordinates leaves only when useful, validates
local result, then returns evidence small enough for main to judge.

Mission package is stricter than an ordinary task brief. It must let a cold executor finish without
user dialogue or hidden main-session context. Stronger model cannot repair missing authority or
undefined success.

Template stays separate because this path is conditional and package is larger than ordinary
delegation brief. Skill gate prevents paying template-read cost for rejected missions.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

One complex implementation chunk is self-contained, needs general judgment, can run without
dialogue, and would flood main context with low-level work. Executor may work alone or use leaf
workers.

<!------------------------------------------------------------------------------------------------->
## When it does NOT trigger
<!------------------------------------------------------------------------------------------------->

Ordinary bounded delegation, one cheap leaf task, unclear requirements, architecture negotiation,
cross-mission integration, or work whose details main already needs.

<!------------------------------------------------------------------------------------------------->
## Maintainer constraints
<!------------------------------------------------------------------------------------------------->

- Keep executor generic. No dedicated-agent dependency or worker catalog.
- Keep mission package gate strict. No model-tier exception for missing input.
- One template only. Add fields only when repeated executor failure proves omission.

<!------------------------------------------------------------------------------------------------->
## Files
<!------------------------------------------------------------------------------------------------->

- `templates/executor-prompt.md`: copy-and-fill mission package for generic executor.

<!------------------------------------------------------------------------------------------------->
## See also
<!------------------------------------------------------------------------------------------------->

- `../delegation/README.md`: ordinary bounded delegation and report supervision.
- `../../.agent/notes/design-principles.md`: context-pollution rationale.
