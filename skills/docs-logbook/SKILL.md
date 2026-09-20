---
name: docs-logbook
description: "Automatically log major repository work in `.agent/logbook/` for later reuse or analysis. Load before first material action, then update after material outcomes and before final response; skip minor one-step work and routine tool calls."
---

## Rules

- Major task: implementation, multi-file change, nontrivial diagnosis, material research, planning, migration, or work needing multiple decisions. Minor task: answer, one routine read/check, or trivial mechanical edit. Major gets one entry; minor gets none.
- Unless user or runtime denies `.agent/logbook/` writes, open one `active` entry before first material action. Keep branches in it; new task or objective gets a new entry. Link `parent` only when it continues an earlier entry.
- Create `.agent/logbook/YYYYMMDDTHHMMSSZ-<lowercase-hyphenated-brief>.md`; UTC ISO 8601 basic timestamp sorts records chronologically. Brief is specific, filesystem-safe, and at most 60 characters. If it exists, append `-2`, then increment until unique.
- Use managed-document frontmatter: `title`, `description`, `status`, `updated`. `status` is `active`, `done`, or `resolved`; `updated` is the substantive-update date. Add `source` only for an external source central to the attempt.
- Write compact facts. Include exact paths, commands, error text, outputs, scores, or artifacts when decision-relevant. Redact secrets, credentials, private data, and large raw output.
- On final response, set `done` only when requested work succeeded. Set `resolved` when work ends failed, blocked, refused, or inconclusive; state why in `Outcome` and `Next decision`.
- A logbook preserves observations. It does not prove replayability, correctness, or future applicability.

## Record shape

```md
---
title: <specific attempt title>
description: "<prompt/task, approach, and decision-relevant outcome>."
status: <active|done|resolved>
updated: YYYY-MM-DD
parent: <optional relative logbook path>
source: <optional canonical external URL>
---

# <specific attempt title>

## Prompt

<user request or bounded task, constraints, and success condition.>

## Starting state

<relevant paths, parent result, assumptions, and unknowns before work.>

## Approach

<hypothesis or strategy; branch/fork choice; why it was chosen.>

## Actions and evidence

<what was changed, queried, or run; compact decision-relevant results.>

## Outcome

<done, failed, blocked, refused, or inconclusive; exact result and what it establishes.>

## Next decision

<next action, stop condition, or why no further action is needed.>
```

## Workflow

1. Classify task. Minor: write nothing. No-write authority: report `logbook skipped: no write authority` at closeout.
2. Otherwise create the active entry before work; update it after material state change, approach branch, validation result, blocker, or final outcome.
3. Before final response, close it as `done` or `resolved`; check frontmatter, filename, outcome, and secret redaction.

## Boundaries

- This skill records work in the background. It does not execute the task, choose a strategy, create a plan, or replace other documentation.
- Never invent missing task context. Write only observed facts; mark unavailable context as unavailable.

## Verification

- Entry has unique filename; compatible frontmatter; prompt, approach, evidence, outcome, and next decision; accurate terminal status; and no sensitive data.
