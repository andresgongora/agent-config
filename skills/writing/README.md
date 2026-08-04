# writing

Reader-facing prose discipline for communication that must be understood and acted on.

## What it does

Shapes written communications around clear reader needs, including emails, official correspondence, public statements, blog posts, proposals, and articles. Main point comes first. Claims carry evidence. Causes, consequences, requests, and decisions remain visible.

It treats reader as capable equal. Tone stays friendly, polite, and confident without deference, dominance, or canned enthusiasm. It allows emotion when facts warrant it, then turns toward concrete action.

## What it does not do

It stays a discipline, not a persona or a growth tactic. It is not a named-person voice, a marketing framework, a clickbait generator, or a substitute for factual research. It will not invent precision, turn a routine message into suspense, or swap an exact technical term for vague plain language.

## When it triggers

Substantial reader-facing prose pulls it in: correspondence, public statements, blog posts, proposals, and articles. Quick messages, technical addenda, code comments, changelogs, commit messages, internal notes, and mechanical anti-pattern cleanup do not. `SKILL.md` frontmatter remains the routing authority; this section is a summary of it, not a second source.

## Design intent

Prose becomes useful before it becomes elegant. The reader gets the material fact, the reason, the consequence, and the next action without ceremony, clickbait, invented authority, or false reassurance. Everything else in the skill exists to protect that.

The paragraph model is the load-bearing part, and it comes from how people actually read. Almost nobody reads a page linearly: one reader scans down the left edge collecting first sentences to find the paragraph worth stopping at, another skips to the ends hunting conclusions and actions. A paragraph therefore needs three functions — an opening that states its core idea, a body that develops it, and a closing that gives the consequence or takeaway. Serve both skimming paths and the linear reader gets a well-formed paragraph for free.

The three-sentence minimum is a consequence of that structure, not a style preference. Three functions cannot fit in two sentences, so a two-sentence substantive paragraph is missing one of them — usually the closing, which is exactly what the takeaway skimmer was looking for. The rule is stated as a hard floor because earlier hedged phrasing ("often", "when the reader needs it") let the closing quietly disappear. Padding is still forbidden: material that cannot support development or a closing was never a paragraph, and should merge into its neighbour or become a list item.

The upper bound is atomicity rather than length. One paragraph carries one core idea, so a second idea forces a split and a fragment that cannot stand alone gets grouped with the paragraph it serves. Length then takes care of itself, which is why no maximum sentence count appears anywhere in the skill.

Asking questions is what makes the rest of it possible. Given "our deployment process is slow, we should improve it", no amount of rewriting produces a good paragraph, because the mechanism and the impact simply are not in the room — and the one thing the model must never do is supply them from imagination. Told instead that deployment takes 40 minutes because test and build run sequentially on one CI runner, that this blocks same-day releases, and that the team wants to parallelise, the same model writes a paragraph that actually informs. So the skill treats a vague claim as a signal to ask rather than a signal to polish, and the no-invented-facts rule is what forces that choice.

Curiosity has to come from a complete, relevant fact that deserves explanation. Withholding information or asking rhetorical questions buys attention the piece has not earned, and readers notice. The skill treats both as defects rather than techniques.

## Maintainer constraints

- Keep reader-facing, not a named-person voice profile.
- Preserve direct peer-level tone and evidence proportional to stakes.
- Add rules only when they change output behavior. Examples stay short and operational.
- Keep the three-part paragraph rule unhedged; hedging lets the closing sentence vanish.
- `SKILL.md` carries WHAT and HOW only. Rationale lives here, including the skimming model behind the paragraph rule. Move any WHY that leaks back into the skill.
- Keep the ask-for-mechanism-and-impact rule adjacent to the missing-fact rules. Removing it turns the skill into a polisher of vague claims, which is the failure it exists to prevent.
- The ask rule needs its non-ask exits kept intact. Constrained edits, explicitly requested placeholders, supplied-reason judgments, and non-material vagueness each have their own handling; delete those exits and the skill starts interrogating the user over grammar fixes.
- `references/asd-ste100.md` defaults to directive-only scope but defers to a caller that widens it. That deference is what lets the low-proficiency branch apply the rules piece-wide without the reference contradicting the skill.
- Shorter paragraphs are allowed only through the listed exempt structures, never through a length preference. Grow that list reluctantly.
- `SKILL.md` owns the one STE100 scope exception (low-proficiency readers get the rules piece-wide; everything else is directive-only). Keep the reference file and this README consistent with it rather than restating the rule.
- Examples must preserve stated facts. Demonstrate missing-fact handling with questions, omission, narrowed claim, judgment label, or explicitly requested draft markers; never add plausible detail.
- Keep priority order and missing-fact return behavior explicit enough for a lightweight model to follow.
- Avoid long enumerations unless exact scope needs every item. Use bullets only when each item adds distinct detail; reserve `(i)`, `(ii)`, and so on for required multi-part concepts in one paragraph.
- Keep `SKILL.md` dense. It serves AI agents, not human onboarding.
- Keep `references/patterns-to-minimize.md` a short conditional composition aid, not a ban list, exhaustive style guide, or duplicate anti-pattern catalog.
- Keep `references/asd-ste100.md` a scoped guide for directives, not formal ASD-STE100 compliance or a general-prose style.

## Structure

- `SKILL.md`: model-facing rules; frontmatter owns routing.
- `references/examples.md`: fact-preserving worked pairs for high-judgment composition decisions.
- `references/patterns-to-minimize.md`: final-pass patterns, costs, rewrites, and exceptions.
- `references/asd-ste100.md`: simplified ASD-STE100-inspired rules for directives only.
- `README.md`: human intent and maintainer constraints.

## Provenance

`references/asd-ste100.md` adapts selected instruction-writing principles from [woosal1337's STE writing skill](https://github.com/woosal1337/blog/blob/main/videos/ep01-the-cure-for-ai-slop/ste-writing-skill.md). It is intentionally less strict than ASD-STE100 and does not claim standard compliance.

## See also

- [`SKILL.md`](./SKILL.md)
- [`references/examples.md`](./references/examples.md)
- [`references/asd-ste100.md`](./references/asd-ste100.md)
