---
# Creation scaffold only. Edit/audit: preserve existing structure.
name: "<!-- lowercase-hyphenated agent name -->"
description: "<!-- One physical line. Routing truth: exact task, when to choose it, optional non-uses, dense correlated keywords. No stubs/roadmap/other-artifact names. -->"

# Add target-client runtime fields. Pin model unless runtime guarantees deliberate caller-model inheritance; then omit it. Sampling only with tested reason. Least privilege: deny before grant where ordered; no broad delegation. Lead bash block with "*": deny/ask, then self-declared allowlist — never a wide bash grant. Grant shell no-ops (exit, true, continue, test) explicitly if compound commands are allowed; check the target-client schema for how it matches compound-command allowlists.
# Declare subagent role. Tools default-deny, grant only need. Command access narrow. Nested delegation: named children only, never broad grant — subagents cannot spawn other subagents by default.
# Baseline grants (shared across most agents) belong in runtime config, not copied here; this frontmatter carries only this agent's role deltas.
---

<!-- Define role, non-uses, structured output, stopping/refusal conditions. Dense, imperative, exact prose. Replace/remove all placeholders, comments, empty sections, and examples. Ready non-trivial artifact: clean-context, read-only final evaluation, then re-verify. Reference other artifacts by behavior, not name, unless both are in a declared same-family group. -->

## Scope

<!-- Runtime self-scoping, not routing (routing already happened via frontmatter description). State: concrete in/out action list beyond the one-line identity above, ask-thresholds (what to escalate rather than do), and sibling handoff (what belongs to a different agent/tool instead). Remove only if the role line already covers all three with no loss. -->

## Input

<!-- Optional: what the caller must supply for this subagent to run (required fields, expected format, what happens on missing/malformed input). Skip if the caller's prompt is free-form and no structured intake exists. -->

## Boundaries

<!-- Hard scope limits: what this subagent must never do, even if the caller asks. Refusal conditions; what tools/paths stay off-limits regardless of frontmatter grants. -->

## Output contract

<!-- Exact returned shape. Define explicit empty-result behavior; never return silently. Give at least one concrete fenced example of the real payload shape (not just the envelope) — see agents/planning.md for a worked example combining a compressed status line, a file-write result, and a review block as its three return shapes. -->

<!-- Mandatory envelope. Every report ends with these two fields, INSIDE this fenced template as its last two lines — a prose rule above the fence does not bind. Formatting may follow this agent's own style, token strings may not change. Map any refusal/terminal token this agent defines onto a status value; never restate the token's meaning. Fields: `status: <done | partial | blocked | refused | none>` and `gap: <in-scope work not done, or 'none'>`. `none` = ran fully, found nothing — distinct from `done`. -->

```
<!-- fill: real success-path payload shape -->
status: done
gap: none
```

<!-- Also ship a second fenced example for the empty-result or refusal path showing the literal non-done token. A success-only example teaches `done` as the default. -->

```
<!-- fill: empty-result or refusal payload shape -->
status: none
gap: <what was not covered, or none>
```
