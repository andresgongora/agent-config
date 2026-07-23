# unit-test

Discipline for useful, deterministic tests without unnecessary tooling or internal coupling.

## What it does

Gives agent an inspect-first workflow: follow existing test idiom, choose honest test level, prove contract.

Design intent:

- **Consistency over taste.** Existing test idiom wins unless it cannot test contract. No second framework, renamed folders, or new assertion style by preference.
- **Contracts, not internals.** Tests describe behavior, invariants, and error cases, never private function detail.
- **Design-for-testability signal.** Painful setup signals bad boundary. Improve it before adding mock scaffolding.
- **No TDD religion.** Stable seams need early feedback. Tiny glue and unstable exploration need no test-first ritual.

## How to invoke

Loads when the request mentions unit tests, TDD, testability, coverage, framework choice, folder layout, or when implementing a stable module.

## Structure

- `SKILL.md` - LLM-facing. Routing, inspection, design, validation, escalation.
- `README.md` - Human maintainer notes.

## Revising this skill

- **Stay language/framework agnostic.** Project rules own language-specific test advice.
- **Keep the "inspect existing setup first" rule.** It is the primary value of the skill. Losing it means agents will invent frameworks.
- **Keep escalation honest.** Ask when framework default is unclear, conventions conflict, policy is unclear, or refactor is material.
- **Do not turn this into a TDD manifesto.** Some tasks need tests after implementation; tiny or unstable work may need none.

## See also

- `SKILL.md` — the workflow
- `../../.agent/notes/design-principles.md` — testability stance in context of the broader agent philosophy
