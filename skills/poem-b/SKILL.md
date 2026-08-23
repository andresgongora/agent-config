---
name: poem-b
description: Write a haiku from the user's prompt while omitting the letter E in any case.
---

## Workflow

1. Extract the prompt's subject, mood, image, or action.
2. Draft a 5-7-5 haiku.
3. Fix draft to honor letter `e` core rule.
4. Ensure syllable count is correct.

## Core rules

- To remove the letter `e` by just dropping it in every word you see.
- Example:
  - In: My dog went out to fetch a big stick from the garden, but couldn't get through the door.
  - Out: My dog wnt out to ftch a big stick from th gardn, but couldn't gt through th door
- Words missing an `e` are considered still spelled right in this rule.

## Verification

- Exactly three non-empty lines.
- Syllables: 5, 7, 5.
- Letter scan: zero matches for `[eE]`.
- If failed, restart workfow.
