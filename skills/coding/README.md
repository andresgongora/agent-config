# coding skill

Parent skill for cross-language coding conventions. Everything common to all or most programming languages lives here; language-specific rules live in child skills (`coding-*`).

## Design intent

- **Router pattern.** `coding` is the family parent. It loads for any coding task and its body points to language-specific children (currently only `coding-bash`). This lets `deploy/AGENTS.md` name a single `coding` trigger instead of one row per language — new languages register as children without touching the glue point.
- **Same-family coupling is intentional.** The repo's decoupling rule forbids cross-family hard-naming, but `coding` and `coding-*` are one family (shared `coding` prefix). The parent MAY name its children directly. That naming is the router mechanism.
- **Rules are heuristics, not laws.** Every rule in this skill is a readability signal, not an invariant. If applying a rule makes the code worse than the problem it was solving, drop it for that case. The "rules are not laws" meta-rule exists to prevent mechanical compliance from defeating the point.

## How loading works

Skill frontmatter does not auto-chain-load sibling skills. Loading is trigger-based: the routing agent reads `description` and decides. `coding` has a broad "any language" trigger, so it loads for general coding work. When the task is language-specific, the `coding` body's child-skill table tells the agent to ALSO load the matching child. Effect: any coding-skill activity pulls in the shared parent conventions.

## Trigger summary

Loads for: writing/editing/reviewing code in any language, or when a language-specific coding skill applies. Not for: prose, docs, config-only files, non-code deliverables.

## Maintainer constraints

- Keep language-specific rules OUT of this skill — they belong in the child.
- Add cross-language rules only from repeated real signal, not taste.
- Rules grow from signal: sourced from repeated real-world patterns or trusted external sources (see Sources). New rules land only when signal justifies them, not speculatively.
- Register new languages by adding a child `coding-<lang>` skill and a row in the SKILL.md child table.

## OOP holding notes

Not the right home for these — no `coding-oop` child exists yet. Parked here until it does.

- **Prefer composition over inheritance.** Inheritance creates tight coupling across the hierarchy; composition assembles behavior from independent parts. Use inheritance only when a true IS-A relationship exists and the hierarchy is shallow.
- **Prefer abstraction through interfaces over class hierarchies.** Interfaces decouple the contract from the implementation; deep hierarchies make both hard to change independently.

Source: CodeAesthetic — [The Flaws of Inheritance](https://www.youtube.com/watch?v=hxGOiiR9ZKg).

## Sources

Principles in this skill are sourced from repeated real signal. External sources are listed here for traceability.

- **CodeAesthetic** (YouTube channel) — https://www.youtube.com/@CodeAesthetic
  Principles derived from: [Naming Things in Code](https://www.youtube.com/watch?v=-J3wNP6u5YU), [Abstraction Can Make Your Code Worse](https://www.youtube.com/watch?v=rQlMtztiAoA), [The Flaws of Inheritance](https://www.youtube.com/watch?v=hxGOiiR9ZKg), [Don't Write Comments](https://www.youtube.com/watch?v=Bf7vDBBOBUA), [Why You Shouldn't Nest Your Code](https://www.youtube.com/watch?v=CFRhGnuXG-4).

## See also

- `coding-bash` — bash script authoring child skill.
