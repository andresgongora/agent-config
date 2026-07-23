# web-search

Layered online research. Main agent stays clean; coordinator decides direct search vs bounded scout fanout.

## Design

Three jobs, three context budgets:

| Layer | Job | Output |
|---|---|---|
| Main agent | frame need, judge evidence | user answer / next action |
| `@web-search` | direct research or scout orchestration | `## Findings` |
| `@web-search-scout` | one query angle, source family, or URL lead | `## Scout Report` |

Scouts are not miniature experts. They find direct evidence, valid leads, or nothing. Coordinator aggregates lightly. Main agent resolves nuanced tradeoffs.

## Why nested fanout

Use direct coordinator search when one authoritative source likely answers. Fan out only when one question has independent branches: docs vs issues vs Q&A, uncertain phrasing, Chinese-only hardware sources, or high junk rate.

Fanout is optional. More children can add latency, repeated queries, and report overhead. This stack caps depth at coordinator plus scout, workers per wave at 3 default / 5 hard max, waves at 2 hard max.

## Contracts

- Scout reports `answer`, `lead`, or `none`; `Quality` rates source promise.
- Coordinator returns `## Findings`; `Confidence` rates final-answer support.
- A high-quality lead is not a high-confidence answer.
- Reports carry only compact evidence, URLs, caveats, and dead angles. Never child transcripts or page dumps.

## Files

| Path | Role |
|---|---|
| `SKILL.md` | Main-agent routing, invocation contract, result handling |
| `../../agents/web-search.md` | Coordinator: direct search, optional fanout, aggregation |
| `../../agents/web-search-scout.md` | Leaf scout: one bounded branch |
| `references/source-families/` | Source-family hints. Bundled references; not agents. See README in that folder. |

## Runtime tools

Agents use available search/fetch tools. Present Opencode setup exposes `websearch`, `webfetch`, and `trafilatura`; prompts prefer clean extraction but do not depend on one provider.

## Maintainer rules

- Keep skill as main-thread routing layer. Do not move scout internals into it.
- Keep coordinator as policy/aggregation layer. Do not let it become crawler or final truth engine.
- Keep scout branch-local. No nesting, broad synthesis, or URL dumps.
- Update both templates and all callers when contract fields change.
- Keep source modules as hints. They live under `references/source-families/`; not agents, no frontmatter. Do not turn each module into another agent.
- Match frontmatter permissions to prompt: coordinator may invoke only scout; scout invokes nobody.
- Keep dense style without depending on any named compression skill.
- Models use provisional aliases: coordinator `POOL_MID`, scout `POOL_LIGHT`. Re-evaluate real cost, latency, and result quality before changing tiers.
