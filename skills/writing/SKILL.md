---
name: writing
description: "Load when composing or substantially rewriting reader-facing prose—emails, official correspondence, public statements, blog posts, proposals, or articles. Establish purpose, audience, structure, argument, then wording. Skip quick messages, code comments, changelogs, commit messages, and internal notes."
---

## Priority and completion

Apply rules in this order:
1. Truth: preserve supplied facts; never invent or imply support absent from source.
2. User scope: honor stated limits such as grammar-only, light edit, or keep structure.
3. Reader need: make purpose, action, decision, consequence, and material uncertainty clear.
4. Clarity and tone: use shortest natural wording that preserves meaning and relationship.
5. Style guidance: structure, paragraph shape, and pattern minimization serve higher rules.

Do not invent unsupported facts, including numbers, dates, quotes, sources, experience, consensus, certainty, or unavailable private/company-specific details. 
Support material claims with supplied evidence or reliable current sources. If a material claim lacks its mechanism or impact, ask one concise batch of questions unless the user requested a light edit, placeholders, or a judgment based on a supplied reason. Use answers only; if answers are refused or unavailable, narrow the claim or label it judgment. 
Never ship a polished but materially vague claim.

## Input handling

Treat user text as raw material unless they specify editing constraints; honor those constraints exactly.

## Drafting method

Organize supplied material for the reader, draft only from it, expose or resolve missing support, and ensure semantic relationships remain coherent.

## Clarity and precision

- Use the shortest precise wording. Lead with the main point; state subject, action, reason, and consequence plainly.
- Vary sentence length and structure.
- Prefer familiar exact words. Cut ceremony, hedging, indirectness, stock phrases, and metaphors that add no meaning.
- Find the buried verb inside a noun (`establishment of`, `the removal of`) and use it directly, naming the actor. See `references/examples.md`.
- Brevity never removes needed explanation, evidence, or context. Isolate optional detail instead.
- Name the actual person, organization, document, date, product, policy, place, price, quantity, or identifier. Never a soft abstraction standing in for one.
- Quantify expertise through work, time, scope, or result. No unsupported "experienced," "skilled," "significant," or "widespread."

## Reader relationship and tone

- Write to the reader as an equal: direct, polite, confident, and free of flattery, insults, or slogans.
- Use only necessary formality. Make requests and disagreements explicit, with reasons and supplied ownership, deadlines, and actions.
- Match emotional force and certainty to the facts and stakes. State what is known, unknown, and next; emphasize concrete action and follow-through.
- Calibrated uncertainty: state what is known, unknown, and next action. Do not convert uncertainty into confidence or helplessness. See `references/examples.md`.

## Non-native or low-proficiency reader

When user explicitly signals limited proficiency, accessibility need, translation need, or plain-language need (e.g. "keep it simple for non-native readers", "they struggle with English"):
- Apply the STE100 rules (see `references/asd-ste100.md`) to the whole piece, not only its directive portions. This is the single exception to the directive-only scope below.
- Paragraph three-part form still holds. Vocabulary and sentence shape simplify; structure does not.
- Politeness and deference rules from `## Reader relationship and tone` overridden: follow cultural register user describes. No guidance: default direct and warm, no idiom, no humor.

## Whole-piece flow

- Lead with the reader’s most consequential supported fact—purpose, decision, request, change, risk, or claim—and state any needed action, owner, and deadline plainly. Use honest tension only when it clarifies; never use clickbait, false urgency, withheld context, or rhetorical bait.

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
- Do not split one idea across paragraphs. A new paragraph must add distinct information or change reader need; a paragraph that only restates or continues its predecessor merges back.

## Structure and presentation

- Use prose for argument; use lists only when items need distinct detail or quick scanning. Keep public and professional writing direct, precise, restrained, and complete.

## Directive text

- Instructions, commands, warnings, actionable items: read `references/asd-ste100.md` and run its `## Check`.

## Avoid

- Do not imitate any named person's voice. Borrow discipline and evidence density, not personality.
- For recurring composition failures that obscure meaning, use `references/patterns-to-minimize.md`. Do not turn that final pass into mechanical word banning.

## Boundaries

- Stop when user asks for edits to code, structured data, or a template whose form is fixed by a system rather than a reader — route to appropriate behavior. Reader-facing templates (email, letter, announcement, proposal) stay in scope.

## Verification

Check before returning:
- [ ] Purpose, key action/decision, and conclusion are clear.
- [ ] Claims have support proportionate to stakes; facts, names, dates, links, quotations, and numbers are accurate.
- [ ] Tone fits the audience and consequences.
- [ ] Each substantive paragraph develops one idea from point to consequence; split or merge where needed.
- [ ] When relevant, rewrite recurring patterns only if clarity, precision, or natural tone improves; use a fresh-context diff review against `references/examples.md`.
