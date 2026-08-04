# artifact-vestige-hunt

Finds vestigial residue — leftovers of removed behavior that a from-scratch author would never have written in the first place.

## Design intent

"Vestige" tracks the giraffe recurrent laryngeal nerve intuition the skill is built on — routing that made sense for an ancestor, kept because nobody re-derives the whole animal from scratch each generation. An AI agent reworking a file behaves the same way: it edits around the old shape instead of re-deriving it, so old shape survives as scar tissue.

The core mechanic is a single test, not a pattern list: _if this were refactored to the same output with ≥90% of its essence retained, what would you cut with guaranteed zero impact?_ Anything that passes is a vestige. The taxonomy in `SKILL.md` exists only to prime the scan; the test is the actual judge, so the skill stays useful on residue that doesn't match any known shape.

The `artifact-vestige-hunter` worker uses finding-per-line output: no praise, no preamble.

## When it triggers

- Post-rework cleanup ("clean this up after the last change", "why is this still here")
- Suspected negative documentation — comments/prose describing what something no longer does
- Ghost steps in a numbered workflow whose entire content is their own obsolescence
- Meta commentary in agent-directed text explaining the file's own edit history instead of instructing the executing agent

## When it does NOT trigger

- General code review, correctness checking, or style critique
- Static dead-code / unused-import analysis — that's a linter's job; this skill targets what linters can't parse (prose, sequence, intent)
- General refactor proposals with no vestige angle
- Auditing whether an agent-directed artifact is internally aligned with its stated intent — that's `agent-evaluator`'s job. Vestige-hunt asks "is this line deletable with zero impact"; evaluator asks "is this artifact correct and consistent." Both can run on the same file for different questions.

## Maintainer constraints

- Never relocates cut material to a changelog/ADR. Cut, don't relocate — git history is the archive. If a future variant needs relocation behavior, that's a new decision, not a silent addition here.
- Survivor class (inverse Chesterton's fence — a note preventing re-introduction of something that caused a real failure) stays narrow. If the worker or skill starts keeping things "just in case," that's scope creep against the plan; re-tighten the test, don't add exceptions.
- `scripts/prefilter` is a marker-word grep only. High recall, low precision, no verdict. Resist adding scoring, config, or an ignore-file — that turns it into a pseudo-linter, which is an explicit non-goal.

## See also

- `agents/artifact-vestige-hunter.md` — bounded worker applying this skill with compressed output
