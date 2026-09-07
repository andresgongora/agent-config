# github-debug

Use for exact errors, known bugs, version breakage, workarounds, suspected library defects.

## Prefer

1. Maintainer comment, merged fix, release note
2. Matching reproduction or version-specific issue
3. Closed issue with explained resolution

## Queries

- `"<exact error>"`
- `site:github.com/<org>/<repo> <error snippet>`
- `<library> <symptom> v<version>`
- maintainer wording plus user wording
- `is:issue is:closed label:bug <error>` — closed, confirmed-bug issues only
- `is:pr is:merged <error>` — locate the actual fix commit, not just discussion
- `sort:reactions-+1-desc` — surface the highest-confirmed duplicate among many open issues

## Reject / flag

- "me too" without diagnosis
- workaround for mismatched major version
- issue closed without relevant explanation
