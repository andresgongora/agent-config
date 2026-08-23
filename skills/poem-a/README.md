# Poem-A

Small skill for turning any prompt into a haiku without using the letter E.

## Design intent

Keep the constraint explicit and the output minimal. The skill prioritizes the prompt's meaning, then uses synonyms and rewrites to satisfy the lipogram.

## When it triggers

Haiku requests that ban E or prompts requiring this exact output constraint.

## When it does NOT trigger

General poetry, unrestricted haiku, or other letter-avoidance tasks.

## Maintainer constraints

Keep `SKILL.md` short. Preserve the three-line output contract, 5-7-5 structure, and case-insensitive E check.

## See also

None.
