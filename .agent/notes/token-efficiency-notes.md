---
title: Token Efficiency Notes
summary: Selective token-efficiency lessons retained in repo policy, plus what it explicitly does not adopt.
status: active
updated: 2026-07-23
---

# Token Efficiency Notes

Former local source artifact removed. These retained lessons stand independently.

## Keep

- Cheap routing surfaces matter. Frontmatter, short summaries, and trigger tables should help an agent decide whether deeper reads are worth paying for.
- Lazy-load detail. Put deep procedures in the right skill, doc, or asset; keep always-loaded memory files lean.
- Reusable workflows beat reinvention. If the same reference or helper gets recreated often, promote it into a durable artifact.
- Smaller, focused artifacts usually help more than monoliths, but this repo does not treat any fixed line count as policy.
- Context pollution is real. Discovery, delegation, and selective reading are worth designing for.

## Do Not Import

- Fixed thresholds like "150 lines per file" or "500 lines per memory file" as repo-wide law
- Claude-specific commands, MCP counts, model-pricing guidance, or API caching mechanics as general philosophy
- Numerical claims from that skill as permanent repo rules unless this repo reproduces and trusts the measurements
- Any advice that would bloat `AGENTS.md`, `README.md`, or trigger-loaded skills with implementation detail

## Repo Impact

- `docs` skill now leans harder on frontmatter-as-router and detail-on-demand.
- `agents-md` now states explicitly that `AGENTS.md` is a router, not a warehouse.
- Repo philosophy states these rules once instead of copying details everywhere.
