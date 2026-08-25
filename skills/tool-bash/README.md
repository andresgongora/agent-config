# tool-bash skill

Guides safe, narrow use of a Bash command-execution tool.

## Design intent

Provide a tiny preflight for Bash execution without duplicating tool policy.

## When it triggers

Immediately before any Bash tool call, including development, validation, Git, or environment inspection.

## When it does NOT trigger

It does not cover persistent Bash-script deliverables, command examples in prose, or tasks with no planned Bash invocation.

## Maintainer constraints

Keep routing tied to tool invocation, not shell syntax. Add only durable rules absent from the tool contract.

## See also

- `skills/coding-bash/SKILL.md` — persistent Bash-script deliverables.
- `skills/local-opencode/SKILL.md` — local Bash permission configuration.
