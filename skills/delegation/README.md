# Delegation

Decision and supervision workflow for ordinary bounded delegation.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

Delegation pays only when worker starts from little context and returns less than main would consume
doing the work. This skill owns decision, brief, evidence judgment, retry, and escalation. Focused
workflows own worker selection and domain execution.

Ordinary worker prompt stays in one conditional template. Caller skill state does not transfer to
spawned workers; template carries scope, evidence, stopping, and report semantics. Gate runs first,
so rejected delegation pays no template-read cost.

Worker reports use fixed `status:` and `gap:` fields. `none` means worker ran full scope and found
nothing; retrying it repeats settled work. Retry must change input.

<!------------------------------------------------------------------------------------------------->
## Decision rationale
<!------------------------------------------------------------------------------------------------->

- **Existing main context:** transfer duplicates tokens; work inline.
- **User decision or risk authority:** worker cannot safely choose; resolve in main.
- **Brief plus report exceeds work:** handoff loses cost test.
- **Bounded, checkable, compact return:** worker can save context without hiding uncertainty.

Parallel work must have independent state. Shared writes or dependent evidence require sequencing or
main-thread integration.

<!------------------------------------------------------------------------------------------------->
## Nested delegation execution
<!------------------------------------------------------------------------------------------------->

This skill only routes the candidate. Use nested delegation execution when one complex mission is
self-contained, has no open authority or user questions, needs broad judgment, and would contaminate
main context with implementation detail. That workflow owns mission package admission, generic
executor selection, and optional executor-to-leaf delegation.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

Generic delegation decisions, ordinary briefs, parallel work, report judgment, retries, or worker
failure.

<!------------------------------------------------------------------------------------------------->
## When it does NOT trigger
<!------------------------------------------------------------------------------------------------->

Named-worker selection, worker-definition authoring, plan lifecycle, domain-specific routing, or
mission-package construction after nested delegation execution is selected.

<!------------------------------------------------------------------------------------------------->
## Maintainer constraints
<!------------------------------------------------------------------------------------------------->

- Keep generic. No worker catalog, permissions, model policy, or nested-execution procedure.
- Preserve fixed five-status report envelope unless every worker contract changes together.
- Keep one worker-prompt template. Add fields only after repeated worker failure proves omission.

## Files

- `templates/worker-prompt.md`: copy-and-fill ordinary worker brief plus execution and report
  contract.

<!------------------------------------------------------------------------------------------------->
## See also
<!------------------------------------------------------------------------------------------------->

- `../delegation-nesting/README.md`: nested delegation execution and mission package design.
- `../../.agent/notes/design-principles.md`: context-pollution rationale.
