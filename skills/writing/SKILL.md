---
name: writing
description: "Use ONLY when composing or substantially rewriting reader-facing prose meant to communicate, including emails, official correspondence, public statements, blog posts, proposals, and articles. Do not use for quick messages, technical addenda, code comments, changelogs, commit messages, internal notes, or mechanical anti-pattern cleanup alone."
license: MIT
metadata:
  author: andresgongora
---

# Written Communication

Goal: reader understanding or action.

## Priority and completion

Apply rules in this order:
1. Truth: preserve supplied facts; never invent or imply support absent from source.
2. User scope: honor stated limits such as grammar-only, light edit, or keep structure.
3. Reader need: make purpose, action, decision, consequence, and material uncertainty clear.
4. Clarity and tone: use shortest natural wording that preserves meaning and relationship.
5. Style guidance: structure, paragraph shape, and pattern minimization serve higher rules.

- Return finished prose when supplied facts support it. Do not expose brackets, research notes, or process narration in a finished piece.
- Never invent numbers, dates, quotes, sources, experience, consensus, or certainty. Never substitute confident tone for evidence.
- Support material claims with dates, quantities, names, documents, direct observations, or sources.
- Missing material fact: ask one concise question when omission would change reader action, legal meaning, safety, reputation, or core conclusion.
- Draft asserts a problem, judgment, or recommendation without its mechanism or its impact ("the process is slow", "we should improve it"): ask for the missing mechanism and impact before rewriting. Never fill either from inference, and never ship the vague version polished.
- Do not ask when any of these holds: user constrained scope to grammar, flow, structure, or light edit; user explicitly requested an incomplete draft or placeholders; the claim's reason is supplied and only outcome proof is missing; the vague claim is non-material to reader action. Handle each by the matching rule below instead.
- One round of questions, batched. Answers supplied: rewrite using them and nothing more. Answers refused or unavailable: narrow the claim to what is supplied, or label it judgment.
- Unsupported non-material detail: omit it. Do not ask merely to add color.
- Overbroad factual claim with partial support: narrow it to supported scope.
- Requested conclusion or recommendation with supplied reason but no outcome proof: label it judgment and give the reason. Do not ask for proof the user does not have.
- User requests a draft with gaps, or explicitly requests placeholders: mark only missing material fact as `[confirm: ...]`.
- Public fact needing support: verify with reliable current source when tools permit. Verification fails or doubt remains: apply the materiality rules above.
- Private or company-specific fact unavailable: never infer.

## Input handling

- Default: user text = draft. Raw material. Rework structure, wording, order freely to serve reader.
- Scope constraint honored when user specifies: "fix grammar," "improve flow," "keep structure," "light edit." Apply only what asked.
- No constraint when user gives text without instruction, says "draft," "rough," or similar.

## Clarity and precision

- Shortest wording preserving meaning, tone, precision. Main point first; optional context after.
- Subject, action, reason, consequence in plain order. Prevent reasonable misunderstanding.
- Vary sentence length. No long run of equally shaped sentences.
- Familiar word when equally exact. Keep specialized term when more exact. Cut ceremony, indirect requests, redundant qualifiers, formality hiding action. Stock metaphors and phrases: cut unless they sharpen meaning.
- Find the buried verb inside a noun (`establishment of`, `the removal of`) and use it directly, naming the actor. See `references/examples.md`.
- Brevity never removes needed explanation, evidence, or context. Isolate optional detail instead.
- Name the actual person, organization, document, date, product, policy, place, price, quantity, or identifier. Never a soft abstraction standing in for one.
- Quantify expertise through work, time, scope, or result. No unsupported "experienced," "skilled," "significant," or "widespread."

## Reader relationship and tone

- Reader: capable equal. Friendly, polite, confident. No deference, flattery, dominance, or unearned familiarity.
- Requests direct. Disagreement plain and respectful. Decisions: reasons, not status. No performed authority or submission.
- Formality only for audience, legal obligation, or real consequence. Never status theater. Active voice unless actor unknown or irrelevant. Natural contractions in conversational prose; no forced contractions in formal writing.
- Emotional force: facts, stakes, concrete action. No foul language, insults, panic, helplessness, or borrowed motivational slogans.
- Name problem. Confidence through preparation, competence, ownership, follow-through; never strength declarations.
- Emotion proportionate to consequence. Write toward action and resilience, never despair or empty reassurance. No clichés: "we are stronger together," "this is a journey," "we will emerge stronger."
- Peer-level request: name requested action, owner, reason, and deadline only when supplied or required.
- Calibrated uncertainty: state what is known, unknown, and next action. Do not convert uncertainty into confidence or helplessness. See `references/examples.md`.

## Non-native or low-proficiency reader

When user explicitly signals limited proficiency, accessibility need, translation need, or plain-language need (e.g. "keep it simple for non-native readers", "they struggle with English"):
- Apply the STE100 rules (see `references/asd-ste100.md`) to the whole piece, not only its directive portions. This is the single exception to the directive-only scope below.
- One idea per sentence.
- Active voice.
- No idioms, metaphors, or cultural references.
- No phrasal verb with ambiguous meaning.
- Shortest exact word. Cut ceremony entirely.
- Condition before action. Consequence explicit; never implied.
- Paragraph three-part form still holds. Vocabulary and sentence shape simplify; structure does not.
- Politeness and deference rules from `## Reader relationship and tone` overridden: follow cultural register user describes. No guidance: default direct and warm, no idiom, no humor.
- Never enumerate or guess cultural norms. User provides context; apply it.

## Whole-piece flow

- Correspondence: open purpose, decision, request, or required action. End explicit next action, owner, deadline when applicable.
- Public prose: open strongest supported claim or useful fact. End evidence-warranted conclusion, never generic encouragement.
- Material surprise, risk, change, contradiction, decision, opportunity: lead the most consequential true fact, complete.
- Curiosity from honest tension: unexpected result, apparent contradiction, material change, consequence needing explanation. Explain immediately after claim.
- No clickbait, tease, vague shock, exaggeration, false urgency, withheld context, bait-and-switch framing, or rhetorical questions.
- Routine news needs no hook. Lead purpose, status, decision, or requested action.

## Argument

Use claim, mechanism, reality:
1. State position or relevant fact.
2. Explain documented mechanism or reason.
3. State practical impact.

- Disagreement: state strongest fair counterpoint before response. Attribute positions to real sources. Primary documents, direct records, firsthand evidence over vague secondhand claims.
- Put concrete details inside claim, reason, and impact; do not append vague praise after them. See `references/examples.md`.

## Paragraph construction

Every substantive paragraph carries three functions, in order:
1. Opening: state the paragraph's core idea, in one sentence, before developing it.
2. Body: develop that idea with reason, evidence, mechanism, or example. Any length.
3. Closing: state the conclusion, consequence, or resulting action. When needed, introduce the idea developed in the next paragraph.

- Three functions means three sentences minimum. Fewer sentences means a missing function; supply it or merge the paragraph into its neighbour.
- Never pad to reach the count. Nothing supports development or closing: the material is not a substantive paragraph.
- Upper bound is atomicity, not length: one core idea per paragraph. Second core idea appears, split. Fragment cannot stand alone, group it with the paragraph it serves. See `references/examples.md`.
- Do not split one idea across paragraphs. A new paragraph must add distinct information or change reader need; a paragraph that only restates or continues its predecessor merges back.
- Exempt structures, where the three-part form does not apply: headings, salutations, sign-offs, captions, list items, supplied quotations, standalone directives, transitions between sections, and a correspondence body that is only a decision, request, recommendation, or acknowledgment plus its supplied reason or required action.
- Classify by function, not length: a paragraph that argues, explains, reports, or supports a claim is substantive. Unlisted structure, or genuine doubt: treat as substantive and give it the three functions.

## Structure and presentation

- Prose for argument; lists for scan-heavy steps, options, requirements, dates, comparisons.
- Public statement: known, unknown, next action, update date. Official correspondence: precise, restrained, complete. Professional email: direct, courteous, brief.
- Avoid long inline enumerations. Give the exact list only when scope, legal meaning, or context requires every item; otherwise name the category or move short examples to sentence end.
- Bullets earn space only when each item needs distinct detail or scan value. `(i)`, `(ii)`, and so on: only for 3–5 required multi-part concepts within one paragraph; never decorate simple noun lists.

## Directive text

- Instructions, commands, warnings, actionable items: read `references/asd-ste100.md` and run its `## Check`.
- Apply only to directive portions. Never to general prose, email bodies, blog bodies, explanation, or argument. Sole exception: the low-proficiency reader branch above, which applies the rules piece-wide.
- Text mixes both: isolate directives in list; keep context and rationale outside it.

## Avoid

- Do not imitate any named person's voice. Borrow discipline and evidence density, not personality.
- For recurring composition failures that obscure meaning, use `references/patterns-to-minimize.md`. Do not turn that final pass into mechanical word banning.

## Boundaries

- Stop when user asks for edits to code, structured data, or a template whose form is fixed by a system rather than a reader — route to appropriate behavior. Reader-facing templates (email, letter, announcement, proposal) stay in scope.

## Verification

Check before returning:
Whole piece:
- [ ] Reader knows why this matters.
- [ ] Claims have support proportionate to stakes.
- [ ] Facts, names, dates, links, quotations, and numbers are accurate.
- [ ] Request, decision, or conclusion is unmistakable.
- [ ] Tone fits audience and consequences.

Each substantive body paragraph:
- [ ] Opens with its core idea, develops it, and closes with conclusion or consequence.
- [ ] Carries one core idea; a second idea has been split out, a dependent fragment merged in.
- [ ] Any paragraph under three sentences matches a listed exempt structure.

When relevant:
- [ ] Recurring composition pattern that obscured meaning was rewritten only where the rewrite improved clarity, precision, or natural tone.
- [ ] Delegate a fresh-context check against `references/examples.md` patterns, bounded diff-review-style output.
