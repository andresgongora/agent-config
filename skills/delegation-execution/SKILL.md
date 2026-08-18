---
name: delegation-execution
description: "Prepares nested delegation execution: decides whether one self-contained complex mission should move from main context into an existing generic subagent, closes material questions, builds a complete mission package, and selects that executor. Load for main-middle-subsub execution, context-firewall handoffs, or complex implementation chunks that need broad judgment plus optional leaf delegation. Not for ordinary bounded delegation, standalone focused-worker selection, unclear work, or missions needing user dialogue during execution."
license: MIT
---

# Delegation Execution

Nested delegation execution: main hands one frozen mission package to a generic executor. Executor owns implementation and local integration; may delegate bounded leaves when useful. Main keeps user intent, cross-mission decisions, and final acceptance.

## Admission gate

First apply ordinary delegation gate. If it permits delegation, admit nested delegation execution only when every condition holds:

- One outcome. Scope self-contained; local decisions do not change outside contracts.
- Main can freeze goal, authority, constraints, non-goals, done condition, validation, and return shape.
- No unresolved user preference, architecture fork, destructive approval, deploy/publish authority, or secret access.
- Executor can finish without main history or dialogue.
- Work needs broad implementation judgment beyond a cheap focused worker.
- Implementation detail or child transcripts would materially pollute main context.
- Runtime supplies suitable generic subagent, required tools, `delegation` skill access, and one safe child depth when nested delegation may help.

Any failure: do not spawn nested executor. Close package gap, use ordinary delegation, or keep work in main.

## Close questions

Classify every unknown before packaging:

| Unknown | Main action |
| --- | --- |
| User intent, risk acceptance, irreversible choice | Ask user. |
| Architecture or cross-mission contract | Decide in main; record decision. |
| Repo fact | Inspect directly or delegate one bounded investigation. |
| Low-risk implementation choice inside frozen boundary | Grant executor decision authority. |
| Validation unavailable | Define review evidence or reject mission. |

Never tell executor to "figure out requirements." Authority to choose is explicit, bounded, and recorded.

## Mission package gate

Mission package complete only when a cold executor can answer all without inference:

- What exact outcome must exist?
- What observable evidence proves done?
- Which files, modules, systems, and behaviors are in and out?
- Which edits, commands, dependencies, and child workers are allowed?
- Which actions require authority executor does not have?
- Which repo facts and prior decisions cannot be cheaply rediscovered?
- Which mission-specific skills must executor load?
- Which validation must run, with expected result?
- When must executor stop instead of widening scope or grinding?
- Which compact fields must return so main can judge without replaying work?

One missing material answer: package incomplete. Do not compensate with a stronger model.

## Executor selection

- Pick existing generic subagent with enough judgment, repo-local execution tools, skill loading, validation access, and bounded child delegation when needed.
- Prefer caller-model inheritance or deliberate stronger tier only when mission reasoning warrants cost.
- Do not use focused leaf worker as executor. Do not create dedicated executor merely to carry prompt.
- Executor must accept non-interactive work. Prompt forbids user questions; missing package input returns `blocked`.
- Children are leaves. No nested executor below executor. Zero child calls is valid.

## Dispatch

1. Pass admission and mission package gates.
2. Read `templates/executor-prompt.md`; fill every placeholder, delete empty optional blocks.
3. Name allowed child capabilities and depth. Never grant broad recursion in prose or runtime permissions.
4. Send one mission package to one generic executor. Main does not micromanage method.
5. Hand receipt to ordinary delegation supervision for evidence judgment, status handling, retry, and escalation.
6. Integrate conclusion only. Never import executor or child transcript into main context.

## Boundaries

- One executor owns one mission. Unrelated work stays separate.
- Main owns user dialogue, mission authority, cross-mission conflicts, and final acceptance.
- Executor owns implementation method, local child coordination, local conflict resolution, and mission validation.
- Mission package is immutable during run. New scope returns `blocked`; executor never silently expands it.
- No commit, push, deploy, publish, destructive action, or external write unless mission package grants exact authority and runtime permits it.
