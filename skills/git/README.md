# git

Git guardrails for agents. Not Git tutorial.

## What it does

Adds repo-wide safety defaults and a few durable workflows:
- inspect state first
- stage narrow
- prefer reversible undo
- avoid history rewrite by default
- stop when unrelated files get entangled
- compact object stores without pruning objects
- report merged local branches; delete only by explicit option

Goal: reduce bad autonomous Git moves, not teach `git commit` from scratch.

## Design intent

Git knowledge already exists in most models. Value here is not syntax. Value is:
- your preferred safety posture
- anti-sloppiness defaults
- faster branch/commit/push routine
- stronger hesitation around destructive ops

Brutal truth: old version was too big and too cookbook-heavy. Many commands were low-frequency, risky, or context-specific. Bad skill shape.

## Script

`scripts/git-housekeep` walks repository roots below selected directory. Default runs `git repack -d -l`: packs loose objects and drops redundant packfiles without pruning objects, expiring reflogs, changing refs, fetching, or touching worktrees. `--report` skips repacking. `--verify` checks object connectivity without writing. `--delete-merged` deletes only reviewed local branches that Git confirms merged into chosen base and still have a present local upstream-tracking ref.

Never turn this into a fetch/prune wrapper or GC shortcut. Fetch changes remote-tracking references; normal GC can expire reflogs or prune unreachable objects. Keep full command contract in `SKILL.md`.

## Trigger

Load for branch / commit / merge / rebase / conflict / push / undo / git-state inspection work.

Do not load for generic repo work with no git action.

## Maintainer rules

- Keep only durable guardrails, common flows, and this bounded maintenance helper.
- Prefer safety defaults over clever recovery tricks.
- Avoid destructive command recipes unless framed as explicit danger.
- Do not encode company-specific branch naming here.
- Do not duplicate repo-specific git policy; local `AGENTS.md` should narrow when needed.
- If this grows again, move rare rescue tricks to docs, not skill.

## See also

- `SKILL.md`
- `../caveman-commit/SKILL.md`
- `../../AGENTS.md`
