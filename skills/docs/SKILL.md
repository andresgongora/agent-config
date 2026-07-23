---
name: docs
description: >
  Docs, documentation, .agent/ folder, architecture notes, repo maps, ADRs, work
  handoff, bug-attempt logs. Make them discoverable, useful, alive. For AI
  agents. Dense compressed style. Cheap discovery scripts (inventory,
  frontmatter). No subagent — doc work needs live parent context. For repo-state
  snapshots (code frontier), see the `code-frontier` skill.
---

# Skill: docs

## Audience

Primary reader: AI agents. Docs are agent infrastructure. Terse, exact, high-signal. Humans can read; optimize agents.

## Purpose

Docs cut long-term token cost. Avoid no docs, stale-doc graveyard.

## Trigger

Load for non-trivial repo work. Also:
- `.agent/` folder, documentation, architecture notes
- doc frontmatter/format
- stale-doc cleanup
- work handoff or bug-attempt logging

Repo-state snapshot, repo-level next/risk/deferred state, session continuity: also load `code-frontier`.

## On Load: Required Todos

Repo root, non-trivial task: add todos now:

1. **Scan inventory** — run `scripts/inventory` (see Tools). Reads frontmatter only.
2. **Assess** — note available high-level info. Flag gaps.
3. **Bootstrap if empty** — no useful docs: create minimal viable doc (see Bootstrap).

Skip: trivial task, not repo root, docs already scanned this session.

## Core Rules

1. Cheap discovery first.
2. Source beats docs.
3. Frontmatter routes; body details. Prefer pointers over large inline background.
4. Few sharp docs > many weak docs.
5. Delete stale.
6. Dense prose. Fragments OK.

## Discovery Workflow

1. Check `.agent/`/`README.md` exists.
2. Docs exist:
   - Run `scripts/inventory`.
   - Full-read only task-relevant doc.
   - Relevant missing frontmatter: add.
3. No docs:
   - Minimal doc saves future exploration: bootstrap.
   - Else proceed.

## Bootstrap Rules

Create minimal viable doc only when:
- At repo root
- No existing useful docs
- Task non-trivial
- Clear consumer (future agents, team)

Start with folder scaffold. Empty placeholders OK if titled clearly. Example:

```
.agent/
  frontier.md         # repo-state snapshot
  plan/               # durable pre-implementation plans
  progress/           # task-scoped handoff notes
  bugs/               # bug-attempt logs
  notes/              # design, authoring, research, conventions
```

Adapt project. Never force fit.

Minimal viable doc: title, purpose (1-2 sentences), key components/modules, entry points, non-obvious conventions.

Do NOT create: chat transcripts, raw logs, speculative structure with no content, code-comment duplicates, one-off task docs.

## Frontmatter

Enables cheap discovery via `scripts/inventory`.

Minimum:

```yaml
---
title: <clear title>
summary: <1-2 sentence description>
---
```

Recommended:

```yaml
---
title: <title>
summary: <summary>
status: draft|active|stale|archived
updated: YYYY-MM-DD
---
```

External-source doc info (web, manual, API, spec): add `source:` or `references:` URL. External info drifts; no source = unverifiable claim.

Frontmatter routes. `summary:` decides full-body value.

## Work Handoff

Cross-session/stopped mid-flight task: progress note.

Location: `.agent/progress/`. Dense compressed style. Fields:
- **Goal** — what task aims to do
- **Done** — finished
- **Remaining** — left, next concrete step
- **Blockers** — open questions, stuck points
- **Touch points** — files/modules touched or relevant

Task done: delete/archive.

## Code Frontier

Repo-state snapshot: use `code-frontier`. Docs does not own its format.

## Bug-Attempt Log

Non-trivial debugging: log attempts. Future agents skip dead ends.

Location: `.agent/bugs/`. Dense compressed style. Per attempt:
- **Symptom** — exact error quoted
- **Hypothesis** — suspected cause
- **Tried** — what changed
- **Result** — worked / failed / partial + why
- **Next** — untried ideas if unsolved

Log failed attempts; dead ends save tokens. Resolved bug: root cause + fix.

## Update Rules

Update when:
- Source drift makes doc misleading
- Architecture/design changes
- Repeated work exposes missing durable context

Never churn tiny non-durable local edits.

## Prune Rules

Delete or archive when:
- Duplicate
- Stale and not worth updating
- Scan noise exceeds value
- Content belonged in a durable rule (`AGENTS.md`) or in code, not a doc
- Handoff/bug log obsolete (task done, bug fixed)

## Split Rules

Large multi-domain doc: split at natural seams. Never split long single-topic doc.

## Tools

Runtime paths when installed:

```
~/.config/opencode/skills/docs/scripts/inventory
~/.config/opencode/skills/docs/scripts/frontmatter
```

Both allowlisted in `opencode.nix`; no permission prompt.

### `scripts/inventory` — cheap discovery

```bash
~/.config/opencode/skills/docs/scripts/inventory [dir]   # default: .agent/
```

Lists every `*.md`: `title`, `summary`, `status`, `updated:`. Sort: `updated` desc. One call replaces N reads. Use before full reads.

### `scripts/frontmatter` — single-file frontmatter

```bash
~/.config/opencode/skills/docs/scripts/frontmatter <file.md>
```

Prints just the YAML frontmatter of one file.

## Source Attribution

External-source content in a doc MUST include a reference link.

- Whole-doc source → frontmatter `source:` or `references:` field
- Section-specific → inline link near the relevant content

Example inline:

```markdown
Redis recommends max 10k connections per instance ([source](https://redis.io/docs/...)).
```

External info drifts. Links verify. Undocumented sources = unverifiable claims.

## Relationship to Other Memory

| Type | Purpose |
|---|---|
| `AGENTS.md` | Behavior rules, agent directives |
| `.agent/` | Durable reference, architecture, intent, handoff, bug logs |

Durable + high-value → prefer git-tracked doc.

## No Subagent

No `@document` subagent. Doc work needs live parent context: change, user request. Fresh subagent loses it. Discovery script; writing main-agent work. Full rationale: README.
