---
name: unit-test
description: >
  Unit test workflow for code projects. Use when user asks for unit tests, TDD,
  testability, coverage, test framework choice, or when implementing stable module boundaries.
  Inspects existing test setup first, keeps test idiom consistent, and designs tests around contracts.
  Skip when testing is explicitly out of scope. Tiny glue and unstable spikes need no forced TDD.
---

# Unit Tests

## Outcome

Useful, deterministic tests. Follow repo idiom. Prove stable behavior without binding implementation.

## Inspect First

Before writing tests, inspect:

- test command and framework,
- test locations and file names,
- fixtures, fakes, mocks, helpers,
- assertion idiom and async/error handling,
- nearby tests for same boundary.

Existing setup: do not add framework, runner, layout, or assertion library unless it cannot test contract.

No setup:

- material, repo-wide framework choice: ask;
- clear ecosystem default: choose it, state choice;
- no clear default: ask. Prefer language/tooling convention over generic `tests/` layout.

## Design

1. Name stable module boundary.
2. State contract: inputs, outputs, effects, invariants, failures.
3. Choose honest level:
   - pure unit;
   - unit with fake at adapter seam;
   - integration test;
   - boundary too muddy: improve design before forcing test.
4. Cover behavior branches, errors, and regressions with focused named cases.
5. Assert observable results. Private calls, structure, and incidental order stay untested.

Prefer pure functions, explicit dependencies, adapter-isolated effects, deterministic time/randomness, narrow fakes.

Painful setup signals bad boundary. Improve it before adding mock scaffolding.

Reject:

- booting half system for local logic,
- mocks that restate implementation or lack contract,
- timing, network, filesystem, randomness, shared-state flake,
- snapshots/goldens where explicit assertions say more.

## TDD And Coverage

- Stable, valuable seam: test before, with, or after change. Favor early feedback.
- Tiny glue, exploratory code, unstable interface: no ritual test-first.
- Coverage measures gaps; never chase percentage with low-value tests.
- Intentional contract change: update affected tests. Do not preserve obsolete expectations.

## Validate

Run narrow relevant tests first, then repo-standard test command when proportionate. Report exact command, result, and unrun scope. Report coverage metric only from coverage command; inspection may identify untested paths.

## Escalate

Ask before competing conventions, large testability refactor, or unclear test policy.

## Boundaries

- Stable behavior deserves tests; every glue line does not.
- Integration behavior stays labelled integration.
- Repo forbids or limits tests: obey.
