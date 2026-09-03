---
name: writing
description: "Write or materially revise reader-facing prose, no AI slop. Load when drafting or substantially revising external emails, correspondence, announcements, proposals, articles, blog posts, public statements, READMEs, or similar human-facing text. Skip for quick messages, code comments, changelogs, commit messages, and internal notes."
---

## Core Rules

- Treat user text as raw draft unless they specify constraints; honor them exactly.
- Honor requested scope and limits, such as grammar-only, light edit, or keep structure; otherwise revise whole draft.
- Preserve supplied facts. Do not invent support, including numbers, dates, quotes, sources, experience, consensus, certainty, or unavailable private or company-specific details.
- Support material claims with supplied evidence or reliable sources; never ship a polished but materially vague claim.
- Verify public facts with reliable current sources when tools permit. Never infer unavailable private or company-specific facts.
- Keep wording required by quotations, titles, code, established terminology, genre, house style, or clearer prose. Do not let a stylistic remedy worsen accuracy, clarity, or fit.

## Writing guidelines

Meaning, factual accuracy, user constraints, and required form outrank these guidelines. Skip a lower-priority guideline only when it reduces clarity or reader value.

### Clarity and precision

- Use the shortest precise wording. State subject, action, reason, and consequence plainly. Keep needed explanation, evidence, and context; clarity beats brevity.
- Prefer familiar exact words. Cut ceremony, hedging, indirectness, stock phrases, and empty metaphors.
- Replace buried noun-verbs ("establishment of", "the removal of") with direct verbs; name the actor.
- Avoid passive voice when the actor is known and relevant.
- Name the actual person, organization, document, date, product, policy, place, price, quantity, or identifier.
- Show experience or scale through work, time, scope, or result; do not use unsupported "experienced," "skilled," "significant," or "widespread."

### Reader relationship and tone

- Write to the reader as an equal: direct, polite, confident; no flattery, insults, or slogans.
- Public or professional writing: keep precise and restrained.
- Use only needed formality. Make requests and disagreements explicit; include supplied reasons, owners, deadlines, and actions.
- Match certainty and emotional force to evidence and stakes. State what is known, unknown, and next action; do not convert uncertainty into confidence or helplessness.

### Message structure and presentation

- Lead with the reader’s most consequential supported fact—purpose, decision, request, change, risk, or claim—and state any needed action, owner, and deadline plainly. Use honest tension only when it clarifies; never use clickbait, false urgency, withheld context, or rhetorical bait.
- Use prose for the message; use lists only for distinct detail or quick scanning.
- Let sentence and paragraph length follow evidence and reader need; avoid repeated sentence shapes or paragraph structures for reasons unrelated to message content.

#### Paragraph construction

Substantive paragraphs normally include:
1. Opening: state the paragraph's core idea, in one sentence, before developing it.
2. Body: develop it with reason, evidence, mechanism, or example. Any length.
3. Closing: state conclusion, consequence, or resulting action. If needed, introduce next paragraph's idea.

- Substantive body paragraphs (main prose) have at least 3 sentences; Fewer sentences = missing function.
- Keep one idea per paragraph. A new paragraph must add distinct information or change reader need; merge together one that only restates or continues its predecessor.
- Headings, salutations, sign-offs, captions, list items, supplied quotations, standalone directives, transitions, and short correspondence may be shorter.

### Patterns

#### Directions addressed at reader

For messages with instructions, commands, warnings, or actionable items:
- Write according to STE100 derived rules (read `references/asd-ste100.md`).
- Apply STE100 derived rules only to directive portions (list, enumeration, applicable paragraphs).

#### Arguments

Use claim, mechanism, reality:
1. State position or relevant fact.
2. Explain documented mechanism or reason.
3. State practical impact.

- Disagreement: state strongest fair counterpoint before response. Attribute positions to real sources. Prefer primary documents, direct records, and firsthand evidence to vague secondhand claims.
- Put concrete evidence inside claim, reason, and impact; do not append vague praise.

### Style

- **Quotes**: use `"`, not `“` + `”`. Period goes outside quotes unless part of quoted material.
- Comply with `references/no-ai-slop.md`.

### Special cases

#### Non-native or low-proficiency reader

If user explicitly signals the message targets a reader with limited proficiency, accessibility, translation, or plain-language needs:
- Extend directive STE100 derived rules to the whole piece (read `references/asd-ste100.md`).
- Avoid idioms, metaphors, cultural references, and ambiguous phrasal verbs. State conditions and consequences explicitly.
- Follow the cultural register, politeness and deference rules described for reader. No guidance: direct and warm; no idiom or humor.

## Workflow

1. Determine scope. Rewrite supplied text freely unless user sets an editing limit; write from brief if no draft exists.
2. Collect context. Inventory purpose, audience, facts, decisions, constraints, sources, and material unknowns; ensure claims and figurative wording preserve literal meaning.
3. Settle unknowns. If material unknowns exist, ask one concise batch of questions. Update the inventory from the reply, or apply `## Boundaries` if the user cannot answer. If the reply creates material unknowns, repeat the question batch.
4. Write draft. Write or rework prose within the granted scope.
5. Delegate review: send current draft to the writing-reviewer subagent. Afterwards, revise the draft from returned text or findings.
6. Validation: Check the final draft against applicable rules, patterns, boundaries, and validation checklist.
7. Output: Return finished prose without process narration; warn only about retained `[confirm: ...]` placeholders.

## Boundaries

- Do not rewrite structured data or fixed template aspects. Preserve fields, order, required wording, and format; rewrite only reader-facing prose within the allowed scope.
- If a missing material fact changes reader action, legal meaning, safety, reputation, or the message's core conclusion: ask.
- If the user cannot answer, refuses, or reliable public information is unavailable: omit or narrow unsupported detail, or state a recommendation as judgment based on its supplied reason; never invent support.
- For an explicitly incomplete draft or requested placeholders, mark only missing material facts as `[confirm: ...]`. Notify user.

## Checklist

- [ ] Purpose, key action/decision, and conclusion are clear.
- [ ] Claims have support proportionate to stakes; facts, names, dates, links, quotations, and numbers are accurate.
- [ ] No unsupported material detail or unrequested placeholder remains.
- [ ] STE100-like compliance where applicable: directive text is precise and unambiguous.
- [ ] Each substantive body paragraph has at least 3 sentences, excluding exceptions; no paragraph padding or fragmented one-idea flow.
- [ ] Tone fits the audience and consequences.
