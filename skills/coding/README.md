# coding skill

Parent skill for cross-language coding conventions. Everything common to all or most programming languages lives here; language-specific rules live in child skills (`coding-*`).

## Design intent

- **Router pattern.** `coding` is the family parent. It loads for any coding task and its body points to matching children: `coding-bash`, `coding-python`, `coding-unit-test`, and `coding-oop`. This lets `deploy/AGENTS.md` name a single coding trigger while child routing stays local to family.
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
- Register every active child in `SKILL.md` with its precise task match.

## Sources

Principles in this skill are sourced from repeated real signal. External sources are listed here for traceability.

- **CodeAesthetic** (YouTube channel) — https://www.youtube.com/@CodeAesthetic
  Principles derived from: [Naming Things in Code](https://www.youtube.com/watch?v=-J3wNP6u5YU), [Abstraction Can Make Your Code Worse](https://www.youtube.com/watch?v=rQlMtztiAoA), [Don't Write Comments](https://www.youtube.com/watch?v=Bf7vDBBOBUA), [Why You Shouldn't Nest Your Code](https://www.youtube.com/watch?v=CFRhGnuXG-4).

## See also

- `coding-bash` — bash script authoring child skill.
- `coding-python` — Python tooling and CLI child skill.
- `coding-unit-test` — language-agnostic test discipline child skill.
- `coding-oop` — object-oriented design child skill.
