---
name: minion-master
description: "Prepare and dispatch the `minion-master` subagent for one frozen, bounded repository mission. Load when a complete multi-step mission needs local planning, eligible leaf delegation, integration, and validation without user dialogue; not for unclear scope, open-ended discovery, or recursive coordination."
---

`minion-master` owns one frozen mission, its local integration, and proof. Caller owns user intent, cross-mission decisions, and final acceptance.

## Admission gate

- Dispatch only when preserving an already costly caller context outweighs handoff loss.
- Dispatch `minion-master` only for one self-contained, bounded planning milestone too large for one leaf worker.
- Freeze outcome, scope, authority, relevant context, validation, and completion evidence before dispatch.
- Resolve user decisions, architecture forks, destructive approval, deploy/publish authority, and missing material facts in caller context.
- If the executor needs user dialogue or the mission package is incomplete, do not dispatch it.

## Rules

- `minion-master` must not widen scope, coordinate another master, or infer missing authority.
- Parallel masters need frozen, independent missions with non-overlapping files and no shared decisions. Expect unrelated file changes from other masters.
- Keep commits, publishing, deployment, destructive actions, and unapproved dependency changes outside the mission unless explicitly authorized.

### Delegation prompt

Give `minion-master` a frozen mission package:

```md
Mission: <one frozen outcome>.
Success: <completion condition and required proof>.
Scope: <included work; explicit exclusions>.
Authority: <allowed edits, commands, dependencies, destructive actions, and state changes; silence means prohibited>.
Decisions: <settled choices the master must not revisit; `none` if none>.
Context: <settled decisions, facts, constraints, paths, supplied diffs, and prior evidence; `none` if none>.
Dependencies: <required order, external inputs, and parallel work; `none` if none>.
Workspace: <pre-existing changes, other active masters, and their exclusive paths; `none` if none>.
Validation: <commands, inspections, and acceptance criteria>.
Milestones: <ordered coarse plan; mark delegated milestone. Each milestone states outcome, dependencies, and completion evidence>.
Return: <required receipt focus, including changes, proof, validation, gaps, and issues>.
```

## Dispatch

1. Select one bounded milestone from the caller plan, or identify one self-contained mission.
2. Do not dispatch from a coarse milestone alone. Create a detailed executable subplan with its own milestones.
3. Include that subplan in the mission package.
4. Delegate.
5. Inspect receipt and judge evidence; do not treat completion claim as proof.
