# coding-unit-test

Unit test discipline for any language. Child of `coding` ecosystem.

## What it does

Inspect-first workflow: follow existing test idiom, choose honest test level, prove contract not internals.

## Design intent

- **Consistency over taste.** Existing test idiom wins unless it cannot test the contract. No second framework, renamed folders, or new assertion style by preference.
- **Contracts, not internals.** Tests describe behavior, invariants, and error cases — never private function detail.
- **Design-for-testability signal.** Painful setup signals bad boundary. Improve it before adding mock scaffolding.
- **TDD where it earns its keep.** Stable seams benefit from early feedback. Tiny glue and unstable exploration need no test-first ritual.

## Trigger summary

unit tests / TDD / testability / coverage / test framework choice / stable module boundary

## Maintainer constraints

- **Stay language/framework agnostic.** Language-specific test advice belongs in an owning language-specific child skill when one exists.
- **Keep "inspect existing setup first".** Primary value. Losing it means agents invent frameworks.
- **Keep escalation honest.** Ask when framework default is unclear, conventions conflict, policy is unclear, or refactor is material.
- **Do not turn this into a TDD manifesto.** Some tasks need tests after implementation; tiny or unstable work may need none.

## Relationship to `coding`

This skill is a child of `coding`. Load `coding` as the parent for language-agnostic conventions; load this skill when test-specific work is in scope. The routing table in `coding/SKILL.md` lists this as a child.

## See also

- `SKILL.md` — LLM-facing workflow
