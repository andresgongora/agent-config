# web-search

Layered online research. Main agent stays clean; researcher decides direct search vs bounded parallel branch fanout.

## Design

Three jobs, three context budgets:

| Layer | Job | Output |
|---|---|---|
| Main agent | frame need, judge evidence | user answer / next action |
| `@web-search` | direct research or parallel branch orchestration | `## Findings` |

Branches find direct evidence, valid leads, or nothing. Researcher aggregates lightly. Main agent resolves nuanced tradeoffs.

## Why bounded fanout

Direct research is the default. Fanout only when all four gate tests pass: context is disposable, 3+ branches known upfront, branches independent, each branch crawl-heavy. Many clean sources are cheaper as parallel searches inside the researcher than as separate top-level tasks.

Fanout is optional. More children can add latency, repeated queries, and report overhead. This stack caps workers per wave at 3-6 (6 hard max; 1-2 branches go inline), with 2 waves hard max.

## Contracts

- Researcher returns `## Findings`; `Confidence` rates final-answer support.
- A high-quality lead is not a high-confidence answer.
- Reports carry only compact evidence, URLs, caveats, and dead angles. Never child transcripts or page dumps.

## Files

| Path | Role |
|---|---|
| `SKILL.md` | Main-agent routing, invocation contract, result handling |
| `../../agents/web-search.md` | Researcher: direct search, optional fanout, aggregation |
| `references/source-families/` | Source-family hints. Bundled references; not agents. See README in that folder. |

## Runtime tools

Agents use available search/fetch tools. Present Opencode setup exposes `websearch`, `webfetch`, and `trafilatura`; prompts prefer clean extraction but do not depend on one provider.

## Maintainer rules

- Keep skill as main-thread routing layer. Do not move researcher internals into it.
- Keep researcher as policy/aggregation layer. Do not let it become final truth engine.
- Keep parallel branches scoped to one question. No broad synthesis or URL dumps.
- Update both templates and all callers when contract fields change.
- Keep source modules as hints. They live under `references/source-families/`; not agents, no frontmatter. Do not turn each module into another agent.
- Match frontmatter permissions to prompt: researcher may invoke only bounded branch fanout.
- Keep dense style without depending on any named compression skill.
- Researcher uses provisional alias `PERSONAL_MID`. Re-evaluate real cost, latency, and result quality before changing tier.
