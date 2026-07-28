---
name: writting
description: "Use ONLY when composing or substantially rewriting reader-facing prose meant to communicate, including emails, official correspondence, public statements, blog posts, proposals, and articles. Do not use for quick messages, technical addenda, code comments, changelogs, commit messages, or internal notes."
---

# Written Communication

## Core principle

- Goal: reader understanding or action.
- Lead: claim, purpose, request, decision, or conclusion.
- Support assertions with evidence, source, example, date, amount, name, or observable consequence when available.
- Never invent numbers, dates, quotes, sources, experience, consensus, or certainty. Mark unknown material facts for confirmation; never fake precision.

## Input handling

- Default: user text = draft. Raw material. Rework structure, wording, order freely to serve reader.
- Scope constraint honored when user specifies: "fix grammar," "improve flow," "keep structure," "light edit." Apply only what asked.
- No constraint when user gives text without instruction, says "draft," "rough," or similar.

## Evidence discipline

- Factual claims = accountable statements. Use dates, quantities, names, documents, direct observations, or sources when material to reader decision.
- Private or company-specific fact unavailable: ask user. Never infer.
- Public fact needing support: search reliable current sources when tools permit. Doubt remains: ask user.
- Support unavailable: narrow claim, label it judgment, or omit. Never substitute confident tone for evidence.

## Clarity and precision

- Shortest wording preserving meaning, tone, precision. Main point first; optional context after.
- Subject, action, reason, consequence in plain order. Prevent reasonable misunderstanding.
- Familiar word when equally exact. Keep specialized term when more exact. Cut ceremony, indirect requests, redundant qualifiers, formality hiding action. Stock metaphors and phrases: cut unless they sharpen meaning.
- Short is not shallow. Add needed explanation, evidence, context; isolate optional detail.
- Name relevant people, organizations, documents, dates, products, policies, places, prices, quantities, identifiers.
- State mechanism, not category: what happened, why, reader consequence.
- Quantify expertise through work, time, scope, or result. No unsupported "experienced," "skilled," "significant," or "widespread."
- Specifics woven into prose. Exact terms over soft abstractions.
- Rules serve reader. Break one when needed for clarity, accuracy, natural tone, or kindness.

## Reader relationship and tone

- Reader: capable equal. Friendly, polite, confident. No deference, flattery, dominance, or unearned familiarity.
- Requests direct. Disagreement plain and respectful. Decisions: reasons, not status. No performed authority or submission.
- Formality only for audience, legal obligation, or real consequence. Never status theater. Active voice unless actor unknown or irrelevant. Natural contractions in conversational prose; no forced contractions in formal writing.
- Emotional force: facts, stakes, concrete action. No foul language, insults, panic, helplessness, or borrowed motivational slogans.
- Name problem. State known, uncertain, available action, next step. Confidence through preparation, competence, ownership, follow-through; never strength declarations.
- Emotion proportionate to consequence. Write toward action and resilience, never despair or empty reassurance. No clichés: "we are stronger together," "this is a journey," "we will emerge stronger."

## Non-native or low-proficiency reader

When user signals reader has weak command of writing language (e.g. "write for a Chinese colleague", "keep it simple for non-native readers", "they struggle with English"):

- Apply STE100 rules (see `references/asd-ste100.md`) to whole piece, not just directive portions: one idea per sentence, active voice, no idioms or metaphors, no cultural references, no phrasal verbs with ambiguous meaning.
- Shortest exact word. Cut ceremony entirely.
- Condition before action. Consequence explicit; never implied.
- Politeness and deference rules from `## Reader relationship and tone` overridden: follow cultural register user describes. No guidance: default direct and warm, no idiom, no humor.
- Never enumerate or guess cultural norms. User provides context; apply it.

## Whole-piece flow

- Correspondence: open purpose, decision, request, or required action. End explicit next action, owner, deadline when applicable.
- Public prose: open strongest supported claim or useful fact. End evidence-warranted conclusion, never generic encouragement.
- Material surprise, risk, change, contradiction, decision, opportunity: lead most consequential true fact. Complete fact. No tease, exaggeration, or withheld context.
- Curiosity from honest tension: unexpected result, apparent contradiction, material change, consequence needing explanation. Explain immediately after claim.
- No clickbait, vague shock, false urgency, bait-and-switch framing, or rhetorical questions.
- Routine news needs no hook. Lead purpose, status, decision, or requested action.

## Argument

Use claim, mechanism, reality:

1. State position or relevant fact.
2. Explain documented mechanism or reason.
3. State practical impact.

- Disagreement: state strongest fair counterpoint before response. Attribute positions to real sources. Primary documents, direct records, firsthand evidence over vague secondhand claims.
- Vary sentence length. No long run of equally shaped sentences.

## Paragraph construction

- Substantive body paragraph: orient reader, develop one idea, state takeaway or implication. Usually ≥3 sentences; add more when needed.
- Fewer than 3 sentences = incompleteness warning. Check adjacent same-idea material; merge when combined paragraph gives orientation, development, takeaway without repetition.
- Split only when each paragraph adds distinct information or changes reader need. Repetition without new evidence, reasoning, consequence, or action weakens prose.
- Exceptions: deliberate one-sentence emphasis, quotations, captions, list items, headings, salutations, sign-offs, other non-body text. Exception must improve reading, never hide incomplete idea.

## Structure and presentation

- Split when subject, audience need, or evidence changes. Prose for argument; lists for scan-heavy steps, options, requirements, dates, comparisons.
- Public statement: known, unknown, next action, update date. Official correspondence: precise, restrained, complete. Professional email: direct, courteous, brief.
- Avoid long inline enumerations. Exact lists only when scope, legal meaning, or context requires every item.
- Otherwise name category, move short examples to sentence end, or omit list. Bullets earn space only when each item needs distinct detail or scan value.
- `(i)`, `(ii)`, and so on: only for 3–5 required multi-part concepts within one paragraph; never decorate simple noun lists.

## Directive text

- Instructions, commands, warnings, actionable items: read `references/asd-ste100.md`.
- Apply only to directive portions. Never to general prose, email bodies, blog bodies, explanation, or argument.
- Text mixes both: isolate directives in list; keep context and rationale outside it.

## Examples

**Excessive deference:**

> I hope you are well. If it is not too much trouble, would you perhaps be able to review this proposal at your earliest convenience?

**Better:**

> Please review the proposal by Friday. Your decision will let us begin the June rollout. The rollout timeline is attached.

**Argument — weak (assertion without mechanism or consequence):**

> Our deployment process is slow. We should improve it.

**Better (claim, mechanism, impact):**

> Deployments take 40 minutes because each step runs sequentially on a single CI runner. Parallelizing the test and build stages would cut that to under 15 minutes, removing the main bottleneck on same-day releases.

See `references/examples.md` for additional before/after pairs covering thin prose and clickbait patterns.

## Avoid

- Empty openers: "I hope this finds you well," "In today's fast-paced world," "It is important to note," or generic scene-setting.
- Unsupported superlatives, euphemisms, vague praise, false urgency, all-caps emphasis, trailing ellipses.
- Artificially smooth, uniform sentences, generic transitions, repeated talking points.
- Pretending neutrality when evidence supports conclusion; pretending certainty when it does not.
- Imitating any named person's voice. Borrow discipline and evidence density, not personality.

## Boundaries

- Not for: quick messages, code comments, changelogs, commit messages, internal notes, technical addenda.
- Not for: chat replies, agent docs, reports, or any text where reader-facing communication quality is not the goal.
- Stop when user asks for edits to code, templates, or structured data — route to appropriate behavior.

## Verification

Check every paragraph before returning:

- [ ] Reader knows why this matters.
- [ ] Claims have support proportionate to stakes.
- [ ] Facts, names, dates, links, quotations, and numbers are accurate.
- [ ] Request, decision, or conclusion is unmistakable.
- [ ] Tone fits audience and consequences.
- [ ] Read `references/patterns-to-minimize.md`; rewrite only when it improves clarity, precision, or natural tone — no mechanical bans.
- [ ] Directive text present (steps, commands, warnings, actionable items): run `## Check` in `references/asd-ste100.md` against those portions.
