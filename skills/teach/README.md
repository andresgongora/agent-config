# teach

Long-lived teaching workspace skill.

## What it does

Turns the current directory into a structured teaching environment: mission, lessons, references, learning records, and reusable assets.

## Why it is unusual here

Most skills in this repo optimize coding-agent workflows. `teach` is different: it optimizes multi-session learning. That makes it broader, more stateful, and less likely to be a first-class default trigger.

## Maintainer note

Keep the distinction clear:

- `AGENTS.md`, `.agent/`, and most skills here store engineering memory
- `teach` stores learner progress and teaching artifacts

If future trimming happens, this skill should justify itself on actual use, not novelty.
