---
# Creation scaffold only. Edit/audit: preserve existing structure.
name: "<!-- lowercase-hyphenated agent name -->"
description: "<!-- One physical line. Primary agent: role boundary, not implementation. Subagent: routing truth — exact task, when to choose it, optional non-uses, dense correlated keywords. No stubs/roadmap/other-artifact names. -->"

# Add target-client runtime fields. Pin model explicitly with target field; sampling
# only with tested reason. Least privilege: deny before grant where ordered; no broad
# delegation.
# Subagent only: declare subagent role. Tools default-deny, grant only need. Command
# access narrow. Delegation: named children only, never broad grant.
---

# <!-- Agent Name -->

<!-- Define role, non-uses, structured output if needed, stopping/refusal conditions.
     Dense, imperative, exact prose. Replace/remove all placeholders, comments, empty
     sections, and examples. Ready non-trivial artifact: clean-context, read-only final
     evaluation, then re-verify. -->

<!-- Subagent only — delete this whole block for a primary agent. -->

## Output contract

<!-- Exact returned shape. Define explicit empty-result behavior; never return silently. -->

<!-- Mandatory envelope. Every report ends with these two fields, INSIDE this fenced
     template as its last two lines — a prose rule above the fence does not bind.
     Formatting may follow this agent's own style, token strings may not change. Map
     any refusal/terminal token this agent defines onto a status value; never restate
     the token's meaning.
       status: <done | partial | blocked | refused | none>
       gap: <in-scope work not done, or `none`>
     `none` = ran fully, found nothing — distinct from `done`.
     Also ship a second fenced example for the empty-result or refusal path showing the
     literal token (`status: none` / `status: refused`). A success-only example teaches
     `done` as default. -->
