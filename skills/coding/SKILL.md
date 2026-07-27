---
name: coding
description: >
  Cross-language coding conventions shared by all or most programming languages: structure,
  naming discipline, function design, readability. Load whenever writing, editing, or reviewing
  code in any language, or when a language-specific coding skill would apply. Acts as parent
  router to language-specific skills (e.g. bash script authoring). Not for prose, docs, config
  files, or non-code deliverables.
---

# coding

Language-agnostic conventions. Routes to language-specific child skills.

## Child skills (routing)

Load the matching child skill IN ADDITION to this one when the task targets a specific language.

| Language / target | Child skill |
|---|---|
| Bash script file as deliverable | `coding-bash` |

When no child matches, apply this skill alone.

## Core rules

- **Rules are not laws.** If following a rule produces worse code than ignoring it, ignore it. The remedy must not become the disease.
- **Avoid wrong abstraction.** Prefer the simplest design that preserves clarity. Premature or forced abstraction adds indirection without leverage — wrong abstraction is worse than none.
- **Minimize coupling.** Shared state and internal deps between components make change harder. Design for independence; coupling erases abstraction's benefit.
- **Name abstractions by concrete role.** Avoid generic buckets (`Base`, `Abstract`, `Utils`, `Manager`). Generic names conceal purpose and attract unrelated responsibilities.
- **Single responsibility.** Each function does one thing. If a name needs "and" to describe it, split it.
- **Shallow nesting.** When nesting forces the reader to track multiple simultaneous conditions, extract. Depth is a proxy — extract when readability demands it, not on a fixed count.
- **Guard early, return early.** Prefer early exit over nested conditionals.
- **Verbose intent-revealing names** over terse abbreviations. Reader decodes nothing.
- **Comments explain why, not what.** Restatement is noise — delete it. Reserve comments for reasoning code can't express.

## Boundaries

- Not for: prose, docs, config-only files, non-code deliverables.
- Defer language-specific rules (syntax, idiom, tooling) to the matching child skill.
- New language-agnostic rules added only when durable patterns emerge — not speculatively.

## Verification

- [ ] Nesting: reader must track multiple conditions simultaneously? Extract.
- [ ] Every function has one responsibility
- [ ] Matching child skill loaded when task is language-specific
