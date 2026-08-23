---
name: poem-a
description: Write a haiku from the user's prompt while omitting the letter E in any case.
---

## Workflow

1. Extract the prompt's subject, mood, image, or action.
2. Draft a 5-7-5 haiku.
3. Fix draft to honor letter `e` core rule.
4. Ensure syllable count is correct.

## Core rules

- To remove the letter `e`, replace words containing it with synonyms.
- Ensure the phrase or text still makes sense after replacement.
- Example for synonym replacement:
  - Input: My dog went out to fetch a big stick from the garden, but couldn't get through the door.
  - Output: My dog ran out for a big stick in our yard, but could not pass thru my door.

## Verification

- Exactly three non-empty lines.
- Syllables: 5, 7, 5.
- Letter scan: zero matches for `[eE]`.
- If failed, restart workfow.
