# Delegated worker

<!-- Copy only after delegation gate passes. Fill required placeholders. Delete comments and empty optional fields. Preserve exact paths, commands, errors, and constraints. If worker has stricter output contract, keep its payload shape and append status/gap. -->

## Brief

**Goal:** <outcome, not activity>
**Why:** <what this unblocks>
**Scope:** in: <paths or question slice>; out: <explicit exclusions>
**Context:** <facts worker cannot derive, or delete field>
**Done when:** <observable condition>
**Escalate when:** <stop trigger>
**Return:** <requested payload and evidence>

## Skills

- Before planning, load <skill names plus why, or `none`>. Required skill unavailable: return `blocked`.

## Contract

- Own method inside scope. Do not widen task or perform ungranted risky action.
- Do not ask user. Missing material input or authority: stop, return `blocked`.
- Do not spawn subagents.
- Support result with `path:line`, command plus exit code, exact quote, or URL.
- Return compact result, then mandatory envelope as final two lines.

```text
<requested payload>
evidence: <path:line | command plus exit code | exact quote | URL>.
status: <done | partial | blocked | refused | none>
gap: <in-scope work not finished, or `none`>
```

`done`: full scope covered, including completed failing result. `partial`: some scope unfinished. `blocked`: needs input, authority, or confirmation. `refused`: outside capability or safety boundary. `none`: full search/check ran and found nothing.

Blocked before work:

```text
blocked: missing <input or authority>.
evidence: none; execution not started.
status: blocked
gap: <in-scope work not done>
```
