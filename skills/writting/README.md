# Writting

Reader-facing prose discipline for communication that must be understood and acted on.

## What it does

Shapes written communications around clear reader needs, including emails, official correspondence, public statements, blog posts, proposals, and articles. Main point comes first. Claims carry evidence. Causes, consequences, requests, and decisions remain visible.

It treats reader as capable equal. Tone stays friendly, polite, and confident without deference, dominance, or canned enthusiasm. It allows emotion when facts warrant it, then turns toward concrete action.

## What it does not do

It is not a named-person voice, marketing framework, clickbait generator, or substitute for factual research. It does not invent precision, turn routine messages into suspense, or replace technical terms with vague plain language.

Quick notes, code comments, changelogs, and technical addenda need less ceremony. Their routing stays outside this skill.

## Design intent

Makes prose useful before making it elegant. Reader gets material fact, reason, consequence, and next action without ceremony, clickbait, invented authority, or false reassurance.

Paragraph model stays load-bearing: substantive body paragraph orients, develops, and concludes one idea. Thin same-idea paragraphs merge; separate paragraphs must advance argument.

Curiosity comes from a complete, relevant fact that deserves explanation. Do not withhold information or write rhetorical questions to fish for attention.

## Routing

`SKILL.md` frontmatter is sole routing definition. Keep triggers and exclusions there; do not repeat them in skill body or this README.

## Maintainer constraints

- Keep reader-facing, not a named-person voice profile.
- Preserve direct peer-level tone and evidence proportional to stakes.
- Add rules only when they change output behavior. Examples stay short and operational.
- Do not weaken paragraph model into a sentence-count exercise.
- Avoid long enumerations unless exact scope needs every item. Use bullets only when each item adds distinct detail; reserve `(i)`, `(ii)`, and so on for required multi-part concepts in one paragraph.
- Keep `SKILL.md` dense. It serves AI agents, not human onboarding.

## Structure

- `SKILL.md`: model-facing rules; frontmatter owns routing.
- `README.md`: human intent and maintainer constraints.

## See also

- [`SKILL.md`](./SKILL.md)
- [`../no-ai-slop/SKILL.md`](../no-ai-slop/SKILL.md)
