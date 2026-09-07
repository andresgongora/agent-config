---
name: web-search
description: "Web research, online docs, current facts, source verification, error lookup, web pages, APIs, release notes, known bugs, papers, or \"look this up/search online\". Load for non-trivial external-information task needing more than one page, source, or query angle. Skip local-file answers or URL-only one-shot extraction."
---

## Decision Gate

- Main agent: frame question; judge final result. Inline only if one obvious source or one trivial fact needs one lookup.
- `@web-search`: coordinator. Search directly or fan out; return `## Findings`.
- `@web-search-scout`: coordinator-only leaf. Search one branch; return `## Scout Report`. Search noise dies below main context. Do not invoke scout from main thread.

## Rules

- One `@web-search` coordinator per question; wait for all before synthesis.
- Run multiple parallel delegations only for independent user questions or unrelated research tasks.

### Delegation prompt

```md
Question: <exact thing to establish>.
Context: <1-3 lines; version, product, error, date, constraints>.
Decision: <why answer matters; answer vs lead vs verification>.
Mode: <concise-answer | lead-hunt | verify-claim | broad-scan>.

Additional evidence:
- <exact URL, version, date, or error>.
- <exact URL, version, date, or error>.
- <exact URL, version, date, or error>.
```

- `mode`:
    - `concise-answer`: enough supported answer; stop.
    - `lead-hunt`: authoritative or promising leads acceptable.
    - `verify-claim`: support, refute, or leave unestablished.
    - `broad-scan`: survey distinct source families; depth still capped.

### Reacting to `## Findings`

When `@web-search` returns `## Findings`, it includes:

- `Question`, `Mode`, `Strategy`: coordinator interpretation and route used.
- `Branches run`: each researched angle and whether it produced an answer, lead, or none.
- `Best answer`: supported answer, or `not established`.
- `Best sources`: evidence worth using now.
- `Useful leads`: promising targets, not established facts.
- `Confidence`: answer certainty, not source attractiveness.
- `Why this confidence`: compact supporting evidence and caveats.
- `Dead angles`: do not retry without new information.
- `Caveats`: ambiguity, contradiction, or staleness affecting the result.
- `Recommended next move`: coordinator advice; main agent still decides.
- `status`: `done` found an answer or useful lead; `partial` leaves in-scope work; `none` found neither answer nor useful lead.
- `gap`: in-scope work not done, or `none`.
- `issue`: blocker, error, or material resolved problem, or `none`.

## Workflow

Search loop for each separate `@web-search` delegation:
1. Construct search prompt.
2. Call `@web-search` with constructed prompt.
3. Inspect `## Findings`. Retry if valid `gap` remains, or if `status` is `partial` and `issue` is resolvable. Otherwise, stop. Max 1 retry.

## Boundaries

- Research only. No local-file inspection, implementation, or design work.
- Do not turn one uncertain claim into certainty.
- Use URLs, exact versions, dates, error strings, and caveats unchanged.
- Dense output. No filler. Fragments OK. Preserve exact technical text.
- If ambiguity is harmless, choose a reasonable interpretation and state it in `Caveats`. If missing decision-critical scope or fact would change the result, ask one question and block before delegation.
