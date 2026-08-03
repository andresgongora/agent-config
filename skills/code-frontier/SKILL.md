---
name: code-frontier
description: "Maintain a repo-state snapshot: current shape, done, in-flight, near next, and boundary facts. Load for repo state, session continuity, repo-level next steps, risks, limitations, or deferred/discarded decisions. Not for handoff, bug logs, or architecture docs."
---

# Skill: code-frontier

Repo-state snapshot. Current-state only.

## Use

Load:
- user asks where repo stands, what is done, what is next, what is risky
- non-trivial session where prior repo state likely matters
- milestone closes, new work starts, repo-level risk/limitation appears
- structural map changed enough that fresh agent would care

Do not load:
- task handoff, task progress.
- bug attempts
- architecture/reference docs
- trivial work in already-understood repo

## What the Frontier Is Not

- Not a changelog or commit log (past-tense, historical)
- Not a task log or bug log (task-scoped, different granularity)
- Not a wishlist or roadmap (aspirational, not present state)
- Not the README (framed for onboarding humans)
- Not the AGENTS.md (agent behavior, not repo state)
- Not the architecture doc (stable reference; frontier changes as work happens)
- Not a handoff note (task-scoped; frontier is repo-scoped)

Content belongs there: put it there.

## File

Default path: `.agent/frontier.md`.

Path changes require targeted reference scan.

## Shape

Keep fixed shape. Fill all sections. Empty: `- (none)`.

```markdown
---
title: <Repo> Frontier
summary: Current repo boundary — Shape / Done / In progress / Next / Boundary.
status: active
updated: YYYY-MM-DD
---

# Frontier

## Shape
- <path/> — <role>

## Done
- <stable capability> — <note>

## In progress
- <active work> — <owner/open question>

## Next
- <near next move> — <why next>

## Boundary

### Known risks
- <current evidenced risk> — <trigger/mitigation>

### Limitations
- <current constraint> — <impact/workaround>

### Deferred / discarded
- <item> — <deferred|discarded> — <why / revisit trigger>
```

## Rules

- Update in place. No history.
- `Next`: near, plausible, accepted move. Not roadmap.
- `Known risks`: current, evidenced, actionable. Speculation temporary.
- Tested risk/hypothesis: promote, move, delete.
- Verify source before writing.
- Keep lean. Aim ~60 lines.

**Stale frontier worse than none.** Misleading map costs more than missing map.

Update on:
- milestone close
- work start
- structural change
- repo-level risk/limitation/deferred decision

Do not update for:
- every commit
- trivial local edits
- task-scoped notes

## Prune Rules

To hit the ~60-line target:

- Background infrastructure: remove from `Done`; worthwhile structure gets one `Shape` line.
- Related done items: collapse.
- Discarded item no longer re-proposal risk: delete.
- Past ~60 lines: prune before add.

## Workflow

**Reading (session start, non-trivial work):**
1. Check if `.agent/frontier.md` exists.
2. Exists: read. Last session ends there.
3. Absent: explore. Bootstrap only if repo long-lived enough.

**Updating (milestone / structural change):**
1. Open `.agent/frontier.md`.
2. Move items as reality changed.
3. Update `updated:` date.
4. Prune if past ~60 lines.
5. Save. Commit only as part of larger documenting commit.

**Bootstrapping (new repo, long-lived):**
1. Create `.agent/frontier.md` with the format above.
2. Fill `Shape` from real folder inventory (one line per top-level dir).
3. Fill `Done` from stable capabilities.
4. Leave rest `- (none)` until real state exists.

## Boundaries

- Path changes: targeted reference scan and update.
- Keep current continuity only. `Done` = stable capability; `Next` = accepted near move. No chronology or distant roadmap.
- No subagent. Frontier update needs live parent context.
