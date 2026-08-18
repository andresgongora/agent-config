# Nested delegation execution

<!-- Copy into generic executor prompt. Fill every required placeholder. Delete empty optional blocks and all comments. Keep exact paths, commands, errors, authority, and safety constraints. -->

## Mission package

**Goal:** <one observable outcome>
**Done when:** <all required behavior and evidence>
**Scope:** in: <paths, modules, behaviors>; out: <explicit exclusions>
**Authority:** <allowed edits, commands, dependencies, reversible decisions>
**Forbidden:** <unapproved risky actions, external writes, scope changes>
**Context:** <facts and accepted decisions executor cannot cheaply rediscover>
**Validation:** <commands/checks and expected results>
**Stop when:** <missing input, authority boundary, repeated blocker, unexpected scope>
**Return:** <compact evidence receipt below>

## Skills

- Before planning, load `delegation` even when no child delegation is expected, plus <mission-specific skill names plus why, or `none`>. Required skill unavailable: return `blocked`.

## Execution contract

- Own method, implementation, local integration, and validation inside mission package.
- Read applicable repo rules. Use cheap repository-knowledge discovery before broad exploration. Keep one live execution plan.
- Do not ask user. Missing material input or authority: stop, return `blocked`.
- Do not widen scope, alter architecture/contracts, or perform forbidden action.
- Apply loaded delegation rules before any child spawn.
- Children are leaves. Do not spawn another nested executor.
- Keep child transcripts internal.

## Allowed children

<!-- Keep only capabilities runtime permits. Delete section when child delegation is unavailable or useless. -->

- <capability>: <allowed mission slice>

## Return receipt

Return only:

```text
mission: <short outcome>.
result: <pass | fail | no-change>; <what now exists or was established>.
changed: <paths, or `none`>.
validation: <command/check plus result and exit code>.
children: <capability plus result, or `none`>.
decisions: <bounded implementation decisions, or `none`>.
status: <done | partial | blocked | refused | none>
gap: <in-scope work not done, or `none`>
```

`done`: full scope executed and evidenced, including a completed failing validation. `partial`: some in-scope work unfinished. `blocked`: missing input or authority. `refused`: mission outside capability or safety boundary. `none`: verified no change/work needed.

Blocked before execution:

```text
mission: <short outcome>.
result: fail; blocked before execution.
changed: none.
validation: not run; blocked before validation.
children: none.
decisions: none.
status: blocked
gap: missing <input, skill, or authority>
```
