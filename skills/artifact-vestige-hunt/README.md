# artifact-vestige-hunt

Finds residue that an author designing the current artifact from scratch would omit.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

Vestiges survive because maintainers edit around an inherited shape instead of deriving the shortest
current path. A rule, code path, or rationale can leave the route from A, rejoin it later, and
contribute nothing to reaching B. Removing that whole loop leaves the same endpoint and a clearer
route.

A bend is the same problem in a less obvious shape. One section pushes away from the intended
result, then another section compensates and points back. The pair is vestigial only when both can
disappear without changing behavior, output, purpose, or maintainability. If straightening the path
needs redesign, it is ordinary refactoring and outside this skill.

A detour is different. A current constraint blocks the direct route, so the deviation prevents a
concrete failure. Keep it, but state the obstacle and failure as a current constraint rather than an
edit-history story. If the obstacle might be gone but the target does not prove that, report the
detour as unresolved instead of guessing.

Two nearby shapes need no new vocabulary in reports. A dead end consumes attention but contributes
nothing; existing ghost-step and dead-scaffolding labels cover it. Parallel roads express the same
rule twice; superseded wording covers that case. More road terms would add classification work
without improving the zero-impact decision.

The core test remains stricter than the analogy: remove a candidate only when outcome is unchanged
and maintainability does not decline. Road direction must come from explicit artifact text, supplied
context, or supplied behavior evidence, never from guessed design intent. If the endpoint or state
equivalence is not established, the candidate remains unresolved. Path shapes help find candidates;
the taxonomy in `SKILL.md` labels what the residue looks like. This boundary keeps vestige hunting
separate from general simplification.

The `artifact-vestige-hunter` worker uses one finding per line, without praise or preamble.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

- Post-rework cleanup ("clean this up after the last change", "why is this still here")
- Suspected negative documentation: comments or prose describing what something no longer does
- Ghost steps in a numbered workflow whose entire content is their own obsolescence
- Meta commentary in agent-directed text explaining the file's own edit history instead of
  instructing the executing agent
- Rule or rationale paths that deviate, compensate, and return to the same outcome

<!------------------------------------------------------------------------------------------------->
## When it does NOT trigger
<!------------------------------------------------------------------------------------------------->

- General code review, correctness checking, or style critique
- Static dead-code or unused-import analysis. Linters and compiler tooling own reachability and
  data-flow proof; this skill targets prose, sequence, and intent.
- General refactor proposals with no vestige angle
- Auditing whether an agent-directed artifact is internally aligned with its stated intent.
  `agent-evaluator` handles that question. Vestige hunting asks whether a segment is deletable with
  zero impact; evaluation asks whether the artifact is correct and consistent.

<!------------------------------------------------------------------------------------------------->
## Maintainer constraints
<!------------------------------------------------------------------------------------------------->

- Never relocates cut material to a changelog or ADR. Git history is the archive. Relocation would
  be a separate behavior, not a silent extension.
- Survivor class stays narrow. Keep a detour only for a concrete current obstacle and failure mode.
  "Just in case" is not evidence.
- `scripts/prefilter` is a marker-word scan only. Recall applies only to lexical history markers in
  text selected by installed scanner defaults; it cannot detect structural excursions or bends. Hits
  require contextual admission before becoming candidates. Scoring, config, and ignore files would
  turn it into the pseudo-linter this skill rejects.
- Do not add bare `loop` triggers or prefilter markers. In code, that word usually means iteration,
  not an outcome-neutral excursion.

<!------------------------------------------------------------------------------------------------->
## See also
<!------------------------------------------------------------------------------------------------->

- `agents/artifact-vestige-hunter.md`: bounded worker applying this skill with compressed output
