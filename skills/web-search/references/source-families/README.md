# Source-Family Reference Modules

Optional search hints bundled with the `web-search` skill. **Not agents. Not skills.** No OpenCode frontmatter.

## Purpose

Each module contains source-specific query patterns, preference order, and reject/flag rules for one well-defined source family. They supplement the generic source hygiene already in the coordinator and scout prompts. Use when a branch clearly targets a known source family.

## Index

| File | Use when |
|---|---|
| `academic-papers.md` | original papers, citations, formal specs, benchmarks |
| `chinese-tech.md` | Chinese-market hardware, Chinese-only docs, Chinese-dominant communities |
| `github-debug.md` | known bugs, exact errors, version breakage, workarounds, maintainer trail |
| `stackoverflow.md` | programming Q&A, API usage, syntax, standard-library behavior |

## Selection rules

- Coordinator selects at most one module per branch when the branch brief maps cleanly to a source family.
- Scout may read the named module when the branch brief names a source family.
- If no module matches or matches weakly, use core source hygiene from the coordinator/scout prompts. Generic rules are always sufficient.
- Never preload all modules. Load on selection.
- Modules never override coordinator or scout caps, stop rules, or output contracts.

## Authoring rules

Keep modules:
- branch-local hints only
- source-family query patterns + preference + reject/flag
- NO routing frontmatter, agent permissions, fanout caps, output templates, or generic source-hygiene rules (those live in the agent prompts)
- strip the trailing "use as hint only" footer — this README covers it

Add a new module when a real search task exposes a recurring source family with distinct query mechanics not covered by existing modules. Do not add speculatively.
