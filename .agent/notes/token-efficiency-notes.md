---
title: Token Efficiency Notes
summary: Selective token-efficiency lessons retained in repo policy, plus what it explicitly does not adopt.
status: active
updated: 2026-08-04
---

# Token Efficiency Notes

## Keep

- Cheap routing surfaces matter. Frontmatter, short summaries, and trigger tables should help an agent decide whether deeper reads are worth paying for.
- Lazy-load detail. Put deep procedures in the right skill, doc, or asset; keep always-loaded memory files lean.
- Reusable workflows beat reinvention. If the same reference or helper gets recreated often, promote it into a durable artifact.
- Smaller, focused artifacts usually help more than monoliths, but this repo does not treat any fixed line count as policy.
- Context pollution is real. Discovery, delegation, and selective reading are worth designing for.

## Instruction Artifact Format

- No universal evidence that bullets beat clear prose. Use format by semantic job, not ritual.
- Independent executable constraints: one requirement per bullet. Mandatory sequence: numbered
  workflow. Fixed mappings: small table. Nuanced rationale/definitions: prose. Exact consumer
  contract: explicit schema/template. Provider guidance converges on clear sections, delimiters,
  examples, and separated stable instructions versus variable context
  ([OpenAI](https://developers.openai.com/api/docs/guides/prompt-engineering),
  [Google](https://ai.google.dev/gemini-api/docs/prompting-strategies)).
- Examples steer format and task pattern, but cost context and can overfit. Keep only examples with
  demonstrated marginal value. Empirical work finds demonstration format and input/label
  distribution materially affect in-context learning; it does not establish one universal prompt
  layout ([Min et al., 2022](https://arxiv.org/abs/2202.12837)).
- Critical instructions must not hide in large optional detail. Long-context performance often
  degrades when relevant information sits mid-context
  ([Liu et al., 2023](https://arxiv.org/abs/2307.03172)). Exact best placement remains model and
  assembled-prompt dependent.
- Support files are progressive disclosure, not automatic quality. Extract optional/reference-heavy
  detail only when primary artifact stays self-contained, routing stays explicit, and one consumer
  can load needed module without repository archaeology.
- Prompt-only output templates improve inspectability, not compliance guarantees. Constrained
  structured output can enforce schema when runtime supports it
  ([OpenAI Structured Outputs](https://developers.openai.com/api/docs/guides/structured-outputs)).
- Optimize requirement-per-token. Preserve priority, boundaries, names, stop conditions, and
  exceptions. Terseness that creates ambiguity is negative efficiency.

## Do Not Import

- Fixed thresholds like "150 lines per file" or "500 lines per memory file" as repo-wide law
- Claude-specific commands, MCP counts, model-pricing guidance, or API caching mechanics as general philosophy
- Numerical claims from that skill as permanent repo rules unless this repo reproduces and trusts the measurements
- Any advice that would bloat `AGENTS.md`, `README.md`, or trigger-loaded skills with implementation detail

## Repo Impact

- `docs` skill now leans harder on frontmatter-as-router and detail-on-demand.
- `agent-agents-md` now states explicitly that `AGENTS.md` is a router, not a warehouse.
- Repo philosophy states these rules once instead of copying details everywhere.
