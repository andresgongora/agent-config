---
name: web-search
description: "Research bounded external questions and return compact, source-backed findings. Load before delegating web-search agents, when task needs current external facts or source-grounded technical evidence, and research context is not material to main-thread work. Skip for trivial one-source lookups or URL-only extraction."
---

## Decision Gate

- Delegate when the answer can be framed as a bounded question and main thread needs only a compact, sourced result; this confines search noise to the researcher.
- Do not delegate when research findings, source selection, or the search path must inform main-thread exploration, synthesis, or decisions. Return to main-thread research.
- One obvious source expected or trivial fact: search inline without this skill.

## Rules

- Parallel `@web-search` delegation for independent questions or unrelated tasks. One subagent per separate question.
- Carry returned URLs, versions, dates, error strings, and `Caveats` into main-thread work unchanged.
- Keep returned uncertainty as uncertainty. Report a hedged or unestablished finding as such; never restate it as settled.

## Delegation prompt

Template for `@web-search` delegation prompt:

```md
Question: <exact fact, claim, or lead to establish>.
Task context: <larger task and why this answer is needed; 1-2 lines>.
Needed result: <direct answer | source-backed verification | qualified lead | comparison>; <required answer shape or decision it supports>.
Known constraints: <product/version/date/region/error/compatibility/cutoff, plus any evidence already established; `none`>.
Starting points: <known URLs, docs, search terms, maintainers, issue IDs, or hypotheses; `none`>.
Exclude or treat cautiously: <known wrong versions, source types, claims, dates, paywalls, or misleading terms; `none`>.
Additional context: <relevant helpful evidence or constraints, or `none`>.
```

- Subagent has no main-thread context. Supply every relevant detail inline.
- Fields set to `none` can be omitted.

## Delegation Workflow

1. Split the need into bounded questions. Keep a question in the main thread when its search path, not just its answer, must inform reasoning.
2. Write one delegation prompt per question.
3. Dispatch one `@web-search` per question, in parallel; wait for all before synthesis.
4. Read each `## Findings`. Retry once only when `gap` or `issue` names unfinished in-scope work that new evidence, a corrected constraint, or a fresh lead can address.

## Resources

`references/source-families/` contains optional search hints:
- `academic-papers.md`: original papers, citations, formal specs, benchmarks.
- `chinese-tech.md`: Chinese-market hardware, Chinese-only docs, Chinese-dominant communities.
- `github-debug.md`: known bugs, exact errors, version breakage, workarounds, maintainer trail.
- `stackoverflow.md`: programming Q&A, API usage, syntax, standard-library behavior.

## Boundaries

- Missing decision-critical scope or fact that would change the result: ask the user one question and block before dispatch.
- Harmless ambiguity: pick a reasonable reading, state it in the delegation prompt's `Known constraints`, and flag it when folding the answer back.
- Returned `## Findings` still insufficient after the one allowed retry: report the gap to the user; do not fill it with assumption.
