---
name: coding
description: "Cross-language coding conventions shared by all or most programming languages: structure, naming discipline, function design, readability. Load whenever writing, editing, or reviewing code in any language, or when a language-specific coding skill would apply. Acts as parent router to language-specific skills (e.g. bash script authoring). Not for prose, docs, config files, or non-code deliverables."
---

# coding

## Child skills (routing)

Load every matching child skill for language, test, or design rules.

| Language / target | Child skill |
|---|---|
| Persistent Bash script file deliverable | `coding-bash` |
| Python code, packages, or project commands | `coding-python` |
| Unit tests, TDD, testability, coverage, framework choice | `coding-unit-test` |
| Object-oriented design, inheritance, interfaces, composition | `coding-oop` |

When no child matches, apply this skill alone.

## Core rules

- Ignore a rule that produces worse code.
- **Avoid wrong abstraction.** Prefer simplest clear design; premature/forced abstraction adds indirection without leverage.
- **Minimize coupling.** Shared state and internal deps impede change; design for independence.
- **Name abstractions by concrete role.** Avoid generic buckets (`Base`, `Abstract`, `Utils`, `Manager`). Generic names conceal purpose and attract unrelated responsibilities.
- **Single responsibility.** Each function does one thing. If a name needs "and" to describe it, split it.
- **Shallow nesting.** When nesting forces the reader to track multiple simultaneous conditions, extract. Depth is a proxy → extract when readability demands it, not on a fixed count.
- **Guard early, return early.** Prefer early exit over nested conditionals.
- **Prefer intent-revealing names** over terse abbreviations.
- **Comments explain rationale code cannot.** Delete restatement.

## Boundaries

- Defer language-specific rules (syntax, idiom, tooling) to the matching child skill.

## Verification

- [ ] Nesting: reader must track multiple conditions simultaneously? Extract.
- [ ] Function responsibility: split only when one name needs "and" or extraction improves clarity.
- [ ] Matching child skill loaded when task needs language, test, or design-specific rules.
