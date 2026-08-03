# code-frontier

Repo-state snapshot. One artifact. Current continuity.

## What it does

Maintains `.agent/frontier.md`: current shape, done, in progress, near next, boundary facts. Not changelog. Not roadmap. Not handoff.

## Why separate from generic docs

Generic doc discipline handles discovery, lifecycle, handoffs, and bug logs.

This workflow handles one repo-state artifact with stricter rules:

- stable `Done` and accepted near `Next`, not chronology
- near next only
- current evidenced risks only
- update in place

Keep cross-reference. Avoid stronger coupling.

## Key maintainer rules

- Path lives in `SKILL.md`.
- Keep 5 top-level sections.
- Keep file lean; prune hard.
- Do not let `Next` become roadmap.
- Do not let `Known risks` become speculation graveyard.
- If real projects prove multi-file frontier needed, add later. Not before.

## See also

- `SKILL.md`
- `../../.agent/frontier.md`
