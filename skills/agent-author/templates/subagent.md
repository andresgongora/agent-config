---
# Creation scaffold only. Edit/audit: preserve existing structure.
name: "<!-- lowercase-hyphenated agent name -->"
description: "<!-- One physical line. Routing truth: exact task, when to choose it, optional non-uses, dense correlated keywords. No stubs/roadmap/other-artifact names. -->"

# Add target-client runtime fields. Pin model unless runtime guarantees deliberate caller-model inheritance; then omit it. Sampling only with tested reason. Least privilege: deny before grant where ordered; no broad delegation. Lead bash block with "*": deny/ask, then self-declared allowlist — never a wide bash grant. Grant shell no-ops (exit, true, continue, test) explicitly if compound commands are allowed; check the target-client schema for how it matches compound-command allowlists.
# Declare subagent role. Tools default-deny, grant only need. Command access narrow. Nested delegation: named children only, never broad grant — subagents cannot spawn other subagents by default.
# Baseline grants (shared across most agents) belong in runtime config, not copied here; this frontmatter carries only this agent's role deltas.
---

<!-- Define role, non-uses, structured output, stopping/refusal conditions. Dense, imperative, exact prose. Replace/remove all placeholders, comments, empty sections, and examples. Ready non-trivial artifact: clean-context, read-only final evaluation, then re-verify. Reference other artifacts by behavior, not name, unless both are in a declared same-family group. -->

## Rules

<!-- Runtime rules. State: concrete in/out action list beyond the one-line identity above, ask-thresholds (what to escalate rather than do), and sibling handoff (what belongs to a different agent/tool instead). Remove only if the role line already covers all three with no loss. -->
<!-- Rules can be positive or negative. Treat rules as different from boundaries: rules are what to do or avoid during normal runtime and throughout the normal workflow; boundaries are exceptions that require stopping, refusal, and/or escalation and lead to early termination. -->

## Workflow

<!-- Explain, in numbered lists, the steps required to complete the subagent mission. Write for the successful outcome. -->

## Boundaries

<!-- Check on what the caller must supply for this subagent to run (required fields, expected format, what happens on missing/malformed input). Skip if the caller's prompt is free-form and no structured intake exists. -->
<!-- Hard scope limits: what this subagent must never do, even if the caller asks. Refusal conditions; what tools/paths stay off-limits regardless of frontmatter grants. -->
<!-- Example:
    - Task out of scope: return `**status**: refused` + `**issue**: <reason>`.
    - Missing target, unclear requirement, or ambiguous specification: return `**status**: blocked` + `**issue**: mission ambiguous; state uncertain areas and gaps`.
    - Involves destructive operation and no explicit authorization: leave files unchanged and return `**status**: blocked` + `**issue**: need explicit authorization for <command>, <explain>`.
    - Unexpected valid-scope failure: stop; revert own changes if possible, else flag files; return `**status**: failed` + `**issue**: <cause; files>`.
-->
<!-- No "input contract": there is no utility in stating the conditions to the caller in the subagent's own body; once called it's too late. Instead, enforce input contract by returning early with a clear explanation of the issue. -->

## Output contract

<!-- Exact returned shape. Define explicit empty-result behavior; never return silently. Give at least one concrete fenced example of the real payload shape (not just the envelope) — see agents/planning.md for a worked example combining a compressed status line, a file-write result, and a review block as its three return shapes. -->

<!-- Mandatory envelope. Every report ends with these three fields, INSIDE this fenced template as its last three lines — a prose rule above the fence does not bind. Formatting may follow this agent's own style, token strings may not change. Map any refusal/terminal token this agent defines onto a status value; never restate the token's meaning. Fields: `status: <done | partial | blocked | refused | none | failed>`, `gap: <in-scope work not done, or 'none'>`, and `issue: <blocker or 'none'>`. `none` = ran fully, found nothing — distinct from `done`. -->

```md
<!-- fill: real success-path payload shape -->
**status**: done
**gap**: none
**issue**: none
```

<!--
**status**
- `done`: Completed requested task; usable result.
- `none`: Completed task; no requested result/action exists.
- `partial`: Produced usable partial result; named remainder in gap.
- `blocked`: Cannot continue because required input, access, authorization, target, or dependency is absent.
- `refused`: Request is outside worker authority/scope; different worker or main thread needed.
- `failed`: Worker attempted valid in-scope work, but unexpected execution/tool/internal error prevented result.

**gap**: List in-scope work not done and explain why. Never desired improvements. `none` if all covered.
**issue**: Report blockers, errors, or material resolved problems; `none` when absent.
-->

### Example

<!-- Example of what the output contract might look like, sometimes accompanied by Q: <query>. VERY optional and often best to leave out -->
