---
# Creation scaffold only. Edit/audit: preserve existing structure.
name: "<!-- lowercase-hyphenated agent name -->"
description: "<!-- One physical line. Role boundary, not implementation. Dense correlated keywords. No stubs/roadmap/other-artifact names. -->"
# Add target-client runtime fields. Pin model unless runtime guarantees deliberate caller-model inheritance; then omit it. Sampling only with tested reason. Least privilege: deny before grant where ordered; no broad delegation. Lead bash block with "*": deny/ask, then self-declared allowlist — never a wide bash grant. Grant shell no-ops (exit, true, continue, test) explicitly if compound commands are allowed; check the target-client schema for how it matches compound-command allowlists.
# Tools default-deny, grant only need. Command access narrow. Delegation: named children only, never broad grant.
# Baseline grants (shared across most agents) belong in runtime config, not copied here; this frontmatter carries only this agent's role deltas.
---

<!-- Define role, non-uses, stopping/refusal conditions. Dense, imperative, exact prose. Replace/remove all placeholders, comments, empty sections, and examples. Ready non-trivial artifact: clean-context, read-only final evaluation, then re-verify. Reference other artifacts by behavior, not name, unless both are in a declared same-family group. -->

## Scope

<!-- Runtime self-scoping, not routing (routing already happened via frontmatter description). State: concrete in/out action list beyond the one-line identity above, ask-thresholds (what to escalate rather than do), and sibling handoff (what belongs to a different agent/tool instead). Remove only if the role line already covers all three with no loss. -->

## Boundaries

<!-- Hard scope limits: what this agent must never do, even if asked. Refusal conditions. -->

## Output contract

<!-- Optional but recommended even for a primary agent: name the concrete shapes this agent returns (e.g. "status + open questions", "updated file at <path>", "review block"). State what it never emits (raw transcripts, tool logs, silent no-op). Route blocking user-facing decisions through an interactive picker, not prose, when the runtime offers one. -->
