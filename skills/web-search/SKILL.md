---
name: web-search
description: "Web research, online docs, current facts, source verification, error lookup, web pages, APIs, release notes, known bugs, papers, or \"look this up/search online\". Load for non-trivial external-information task needing more than one page, source, or query angle. Skip local-file answers or URL-only one-shot extraction."
---

## Role split

- Main agent: frame question; judge final result.
- `@web-search`: coordinator. Search directly or fan out; return `## Findings`.
- `@web-search-scout`: coordinator-only leaf. Search one branch; return `## Scout Report`.

Search noise dies below main context. Do not invoke scout from main thread.

## Route

Inline only if one obvious source or one trivial fact needs one lookup.

Otherwise call `@web-search` once per research question. Give:
- **Question:** exact thing to establish.
- **Context:** 1-3 lines; version, product, error, date, constraints.
- **Decision:** why answer matters; answer vs lead vs verification.
- **Mode:** `concise-answer` default | `lead-hunt` | `verify-claim` | `broad-scan`.

No raw pages, result dumps, or search diary in prompt.

## Parallelism

Main-thread sibling calls:
- use only for independent user questions or unrelated research tasks.
- one coordinator per question; wait for all before synthesis.

Coordinator fanout:
- same question; independent source families or genuinely distinct query angles.
- coordinator decides direct search vs scout fanout.
- do not prescribe scout mechanics from main thread.

Fanout only when distinct branches improve recall or isolate web slop; never for thoroughness alone.

## Read `## Findings`

- `Best answer`: supported answer, or `not established`.
- `Best sources`: evidence worth using now.
- `Useful leads`: promising targets, not established facts.
- `Confidence`: answer certainty, not source attractiveness.
- `Dead angles`: do not retry without new information.
- `Recommended next move`: coordinator advice; main agent still decides.
- `Status`/`Gap`: `none` means ran fully, found nothing — do not retry it; `partial` means `Gap` names an unanswered slice.

`high`: multiple authoritative or convergent strong sources.
`medium`: one authoritative source or convergent partial evidence.
`low`: weak, stale, single, or contradictory evidence. Do not state as fact.
`none`: no reliable answer. Reformulate only with a new angle; otherwise report failure.

## Boundaries

- Research only. No local-file inspection, implementation, or design work.
- Do not turn one uncertain claim into certainty.
- Use URLs, exact versions, dates, error strings, and caveats unchanged.
- Dense output. No filler. Fragments OK. Preserve exact technical text.
- If search target is ambiguous, ask user before delegation.
