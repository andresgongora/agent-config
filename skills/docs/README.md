# docs

Living documentation for AI agents. Cheap to discover, cheap to trust, cheap to maintain.

## What it does

Guides the agent on when to consult repo docs, when to bootstrap missing docs, when to update, when to prune. Also provides two cheap discovery scripts (`inventory`, `frontmatter`) that let the agent scan a whole `.agent/` folder in one bash call instead of reading files individually.

Design intent:

- **Docs are agent infrastructure.** Written for machines, not humans. Terse, high-signal, caveman style. Humans can read too, but optimize for agent token cost.
- **Cheap discovery first.** One `inventory` call replaces N file reads. If discovery is expensive, agents skip docs. If agents skip docs, docs rot.
- **Route, don't dump.** Frontmatter and top summaries help the agent decide whether to read deeper. Big background belongs in the right doc, not repeated inline everywhere.
- **Living docs, not graveyard.** Delete stale docs. Better fewer sharp docs than many weak ones.
- **Handoff and bug-log support.** `.agent/progress/` for work handoff between sessions. `.agent/bugs/` for failed-attempt logs so future agents skip dead ends.
- **Not a subagent.** Doc updates need live parent context (what just changed, what user asked). Handing that to a fresh subagent means re-carrying context — negates the isolation benefit. Discovery is a script, writing/editing is a normal main-agent task. Considered and rejected.

## How to invoke

Loads automatically for non-trivial repo work, or when the request mentions docs / `.agent/` folder / architecture notes / doc frontmatter / stale cleanup / handoff / bug logs.

## Structure

- `SKILL.md` — LLM-facing. Rules for doc discovery, bootstrap, update, prune, handoff, bug logs.
- `README.md` — this file. Human-facing. Design intent, conventions, maintainer notes.
- `scripts/inventory` — bash script. Lists all Markdown docs in a tree with their frontmatter. Sorted by `updated:` desc.
- `scripts/frontmatter` — bash script. Prints YAML frontmatter of one Markdown file.

## Docs Conventions (What Goes Where)

### Frontmatter

Docs under `.agent/` should start with frontmatter when practical. Enables the `inventory` script to give a useful summary in one call.

**Minimum:**

```yaml
---
title: Short human title
summary: One-line summary of why this doc exists
---
```

**Recommended:**

```yaml
---
title: Short human title
summary: One-line summary of why this doc exists
status: active
updated: 2026-05-09
---
```

Useful `status` values:

- `draft`
- `active`
- `stale`
- `archived`

If the doc contains info from external sources (web pages, manuals, APIs, specs), add a `source:` or `references:` field with the URL. Undocumented sources become unverifiable claims.

### File types worth keeping

- Architecture overview
- Repo map
- Module responsibilities
- ADR / decision notes
- Process notes that save repeated exploration
- Small high-value project memory notes
- Work handoff notes (`.agent/progress/`)
- Bug-attempt logs (`.agent/bugs/`)

### File types to avoid

- Task logs
- Chat transcripts
- Duplicated README content with no new value
- Speculative notes nobody will consult
- Docs that exist only because "maybe useful someday"

### Update rules

Update a doc when:

- Source drift makes it misleading
- Architecture / design decision changes
- Repeated exploration reveals missing durable info

Do NOT update for:

- Tiny local code churn with no architectural meaning
- One-off debugging trivia
- Temporary task state (that belongs in the current prompt or a task-scoped handoff note under `.agent/progress/`)

### Delete / prune rules

Delete or archive when:

- Duplicates another doc
- Nobody uses it and it adds scan noise
- Content stale and not worth maintaining
- Value was one-shot (belonged in the prompt or a task-scoped handoff)

Prefer fewer sharper docs over many weak docs.

### Trust model

- Recent `updated:` date helps but is not proof
- If doc conflicts with source, source wins
- Stale doc → verify from source, then update doc

### Relationship to `AGENTS.md`

| Type | Purpose |
|---|---|
| `AGENTS.md` | Behavior rules, agent directives |
| `.agent/` | Durable reference, architecture, intent, handoff, bug logs |

Prefer git-tracked docs over local-only memory for durable, high-value knowledge.

## Scripts

### `scripts/inventory`

```bash
~/.config/opencode/skills/docs/scripts/inventory [dir]
```

- Default dir: `.agent/`
- Lists every `*.md` file in the tree
- Extracts `title`, `summary`, `status`, `updated` from frontmatter
- Sorted by `updated:` desc (recent first)
- One call replaces N reads

Deps: `bash`, `awk`, `find`, `sort`. All GNU coreutils / POSIX — should run anywhere.

### `scripts/frontmatter`

```bash
~/.config/opencode/skills/docs/scripts/frontmatter <file.md>
```

- Prints YAML frontmatter of one file
- Deps: `bash`, `awk`

## Revising this skill

- **Keep it caveman.** SKILL.md is read on every trigger. Verbose prose = permanent token tax.
- **Do not add a subagent.** This was considered and rejected. Doc work needs live parent context. If you think a subagent will help, re-read the "Not a subagent" note above.
- **Keep scripts portable.** POSIX / GNU coreutils only. No jq, no python, no yq. Discovery must work anywhere.
- **Frontmatter fields are a contract.** `title`, `summary`, `status`, `updated` are read by the `inventory` script. Renaming or removing them breaks discovery. If you change the schema, update `inventory` accordingly.
- **Do not couple to `caveman`.** Skill mentions it as a style hint, not a dependency. Docs skill works in normal prose mode too.
- **Do not couple to research skills.** Docs discipline is orthogonal to search/fetch workflows.
- **When adding a new script**: add it to `scripts/`, mark executable, add allowlist entries in `opencode.nix`, document in this README.

## Why no `@document` subagent

You may notice the opencode config has a comment where a `@document` subagent used to live. It was removed on purpose.

Doc work has this shape:

1. Live parent context knows what just changed / what user asked / what the current design is.
2. Deciding what to write requires all of that context.
3. A subagent starts fresh — the parent would have to hand-carry every relevant fact.
4. Hand-carrying = negates the isolation benefit that justifies a subagent in the first place.

Compare to search: search subagent input is "here is a question, find the answer". Small, precise, isolatable. That is why `@web-search` exists as a subagent and `@document` does not.

If a future doc-related workflow does fit the subagent shape (e.g. "audit every doc in `.agent/` for staleness against source, report findings"), that specific workflow could get its own narrow subagent. General "update the docs" cannot.

## See also

- `SKILL.md` — full LLM-facing instructions
- `scripts/inventory`, `scripts/frontmatter` — discovery tools
- `../caveman/SKILL.md` — writing style used by this skill's text
- `../plan/SKILL.md` — planning workflow; document mode follows doc conventions
- `../../.agent/notes/design-principles.md` — cross-cutting agent philosophy, memory model, brutal-truth reminders
- `../code-frontier/SKILL.md` — sister skill for repo-state snapshots (frontier concept + workflow)
- `../authoring-agents/SKILL.md` — how to add new skills/subagents
