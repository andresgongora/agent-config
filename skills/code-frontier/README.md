# code-frontier

Repo-state snapshot. One artifact. Present tense.

## What it does

Maintains `.agent/frontier.md`: current shape, done, in progress, near next, boundary facts. Not changelog. Not roadmap. Not handoff.

## Why separate from `docs`

`docs` handles generic doc discipline.

`code-frontier` handles one repo-state artifact with stricter rules:
- present tense only
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
- `../docs/SKILL.md`
- `../../.agent/frontier.md`
