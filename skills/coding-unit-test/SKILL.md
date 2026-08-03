---
name: coding-unit-test
description: "Workflow for writing, reviewing, and improving unit tests in any language. Load when user asks for unit tests, TDD, testability, coverage, or test framework choice. Skip when testing is explicitly out of scope, for tiny glue and unstable spikes that need no test-first ritual, or for test infrastructure and CI configuration."
---

# coding-unit-test

Discipline for useful, deterministic tests. No unnecessary tooling. No internal coupling.

## Outcome

Prove stable behavior. Follow repo idiom. Never bind to implementation internals.

## Inspect First

Before writing tests:

- test command and framework in use
- test locations and file naming convention
- fixtures, fakes, mocks, helpers in use
- assertion idiom and async/error handling
- nearby tests for the same boundary

Existing setup: do NOT add framework, runner, layout, or assertion library unless it genuinely cannot test the contract.

No setup exists:

- material, repo-wide framework choice: ask
- clear ecosystem default: choose it, state choice
- no clear default: choose one sane default, state choice; use root `tests/` unless language or tooling convention gives stronger evidence

## Design

1. Name stable module boundary.
2. State contract: inputs, outputs, effects, invariants, failures.
3. Choose honest test level:
   - pure unit
   - unit with fake at adapter seam
   - integration test
   - boundary too muddy: improve design before forcing test
4. Cover behavior branches, errors, and regressions with focused named cases.
5. Assert observable results only. Private calls, internal structure, incidental order: untested.

Prefer: pure functions, explicit dependencies, adapter-isolated effects, deterministic time/randomness, narrow fakes.

Painful setup signals bad boundary. Improve boundary before adding mock scaffolding.

Reject:

- booting half system for local logic
- mocks that restate implementation or lack contract
- timing/network/filesystem/randomness/shared-state flake sources
- snapshots/goldens where explicit assertions say more

## TDD and Coverage

- Stable, valuable seam: test before, with, or after change — favor early feedback
- Tiny glue, exploratory code, unstable interface: no ritual test-first
- Coverage measures gaps; never chase percentage with low-value tests
- Intentional contract change: update affected tests — do not preserve obsolete expectations

## Validate

Run narrow relevant tests first, then repo-standard test command when proportionate. Report exact command, result, and unrun scope. Report coverage metric only from coverage command; inspection may identify untested paths.

## Escalate

Ask before:

- competing framework conventions within the same repo
- large testability refactor
- unclear or conflicting test policy

## Boundaries

- Stable behavior deserves tests; every glue line does not
- Integration behavior stays labelled integration
- Repo forbids or limits tests: obey
- Not for test infrastructure or CI configuration
