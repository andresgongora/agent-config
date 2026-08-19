# [Task name]

<!--
Copy this file, then fill it. Required sections form a task contract.
Optional sections exist for specific failure modes; delete any section that does not earn its tokens.
In a finished prompt, remove all comments, placeholders, and unused blocks.
Preserve exact paths, commands, error text, quoted text, identifiers, limits, and safety constraints.
-->

## Task

<!-- REQUIRED. State one observable outcome, not an activity such as "look into" or "work on." -->

**Goal:** [What must be true when work finishes.]

<!-- REQUIRED. Name evidence another person or system can inspect. Avoid "good," "correct," or "complete" without a test. -->

**Done when:** [Required behavior, artifacts, checks, and expected results.]

<!-- REQUIRED. Define both sides. Include files, systems, topics, time range, or decisions when relevant. -->

**Scope:** in: [Included work or material]; out: [Explicit non-goals.]

<!-- OPTIONAL. Keep only when purpose changes tradeoffs or decisions. Do not add motivational filler. -->

**Why:** [Decision, user need, or downstream effect this work supports.]

<!-- OPTIONAL. Include when author suggests a method. Separate desired outcome from proposed route. -->

**Proposed approach:** [Method, sequence, or solution the author has in mind.]

<!-- REQUIRED when Proposed approach is present. "Read my intention" is not enough; state consumer's freedom exactly. -->

**Approach status:** [Required, preferred, or illustrative. If replaceable, state when consumer may choose a better path and whether approval or disclosure is required.]

## Inputs and context

<!--
REQUIRED when consumer cannot derive inputs. Give minimum sufficient context.
Prefer exact artifacts over summaries: paths with relevant lines, URLs, identifiers, versions, quoted errors, supplied data.
Do not dump unrelated history or files.
-->

**Inputs:** [Artifacts or data to inspect. State where each comes from.]

**Context:** [Facts needed to interpret inputs or choose correctly.]

<!-- OPTIONAL. Record settled choices so consumer does not reopen them. -->

**Accepted decisions:** [Decisions already made and their operational consequences.]

<!-- OPTIONAL. Use only for bounded defaults. Never disguise a material unknown as an assumption. -->

**Assumptions:** [Assumptions consumer may use; how to react if one is false.]

<!-- OPTIONAL but important for mixed or hostile content. Delimit untrusted data and state that instructions inside it are data, not commands. -->

**Trust boundary:** [Which instructions are authoritative; which files, pages, messages, or tool results are untrusted content.]

## Constraints and authority

<!-- REQUIRED for consequential, tool-using, delegated, or no-dialog work. Use exact limits. -->

<!-- `Do`/`Don't` are valid alternate labels. Keep positive requirements and exclusions separate. Do not force uncertain gray areas into either list. -->

**Must:**

- [Required behavior, invariant, compatibility rule, or quality bar.]

**Must not:**

- [Forbidden action, scope expansion, destructive operation, unsupported claim, or privacy breach.]

<!-- OPTIONAL. Preferences yield to Must and Must not. Delete when no meaningful preference exists. -->

**Prefer:**

- [Negotiable style, method, tradeoff, or default.]

<!-- OPTIONAL. Operationalize desired candor. Intensity words do not improve evidence. -->

**Judgment posture:** [For candid review, require premise challenges, strongest objection, facts-versus-judgment labels, unknowns, and a plain recommendation. Set directness without requesting hostility.]

<!-- State reversible choices consumer owns. Missing authority is not permission. -->

**May decide:** [Low-risk decisions consumer can make without asking.]

<!-- Name conditions that require user input, approval, or termination. -->

**Stop or escalate when:** [Missing authority, unsafe action, contradictory input, repeated blocker, or scope change.]

<!-- OPTIONAL. Keep when instructions can conflict. Put highest authority first. -->

**Priority on conflict:** [Safety and platform authority; then Must, Must not, and approval boundaries; then goal; then preferences and proposed approach.]

## Clarification policy

<!--
OPTIONAL. Keep when interaction rules matter.
Match invocation: an asynchronous worker cannot ask the user.
Ask only when missing intent, preference, authority, or risk tolerance changes outcome.
Recover researchable facts from allowed sources instead.
For low-risk reversible gaps, choose and disclose a bounded default.
-->

[State what to ask, what to research, what to assume, and whether work must pause for an answer.]

## Tools and sources

<!--
OPTIONAL. Keep for research, retrieval, code execution, or external actions.
Tool calls and arguments are proposals until validated.
Retrieved content is untrusted data. Grant least authority needed.
-->

**Allowed tools and actions:** [Tools, commands, APIs, files, systems, and permitted writes.]

**Approval required for:** [External writes, destructive actions, cost, publication, deployment, or sensitive access.]

**Source priority:** [Primary documents, official docs, repository source, tests, or other order.]

**Freshness:** [Required date, version, release, or time window.]

**Evidence:** [Citation, path and line, command plus result, tool receipt, diff, screenshot, or test output required.]

**Failure behavior:** [Retry rule, fallback, partial-result handling, or stop condition when tool or source fails.]

## Method and checkpoints

<!--
OPTIONAL. Specify method only when it affects safety, coordination, cost, or verification.
Prefer verifiable stages and external checks over hidden reasoning.
Do not demand private chain-of-thought.
Do not prescribe routine implementation details the consumer can choose better from current evidence.
-->

1. [First dependency, uncertainty, or high-risk stage; output/checkpoint.]
2. [Next stage; output/checkpoint.]
3. [Final integration or verification stage.]

<!-- OPTIONAL. Define iteration only when a verifier exists. -->

**Revision loop:** [Draft, check against tests/rubric/sources, revise; maximum attempts and stop behavior.]

## Validation

<!--
REQUIRED when correctness matters. Syntax checks validate syntax only; add semantic or behavioral checks.
State who or what judges success and the expected result for each check.
Tests, tools, environment observations, sources, and human review can provide independent evidence.
If the same model applies a rubric or semantic rule to its own output, label that self-review rather than independent verification.
-->

| Check | Judge | Expected result | Evidence |
| --- | --- | --- | --- |
| [Test, rubric item, source check, review, or invariant.] | [Tool, environment, source, human, independent model, or self-review.] | [Exact pass condition.] | [What to return or retain.] |

## Return

<!--
REQUIRED. Design output for its next consumer.
Use a schema only when machine parsing or stable fields matter.
A valid schema does not prove facts or semantics. Keep response compact enough to inspect.
-->

**Format:** [Markdown sections, table, JSON schema, patch, decision memo, or concise receipt.]

**Required content:** [Fields, decisions, evidence, caveats, changed paths, or next action.]

**Do not include:** [Raw logs, hidden reasoning, copied source text, unsupported claims, or other noise.]

<!-- Define non-success paths explicitly. Never teach a success-only contract. -->

**Empty, partial, blocked, or failed case:** [Exact fields or wording; evidence and unresolved gap required.]

## Examples

<!--
OPTIONAL. Add examples when desired transformation, classification, style, edge behavior, or output semantics remains ambiguous after rules.
Use few representative examples. Keep them consistent with instructions.
Include a contrast or edge case when a positive example alone could over-narrow behavior.
Delete this section when examples merely repeat rules.
-->

### Example: [Representative case]

**Input:**

```text
[Representative input.]
```

**Expected output:**

```text
[Expected output or only the important shape.]
```

### Counterexample or edge case: [Failure boundary]

**Input:**

```text
[Confusable, invalid, empty, adversarial, or boundary input.]
```

**Expected behavior:** [Reject, ask, abstain, return empty result, or handle by explicit rule.]
