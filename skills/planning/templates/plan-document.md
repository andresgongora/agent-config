---
title: <work item> Plan
description: <goal, boundary, why this plan exists>
status: draft
updated: YYYY-MM-DD
---

# <work item> Plan

<!-- Fill dense, low-token: fragments, bullets, no filler. Preserve exact paths/commands/code verbatim. Adapt headings; delete unused, never leave empty. -->

## Goal

<outcome, not activity>

## Requirement rewrite

<real need; better path or rejected framing if any>

## Constraints

### Hard

- <must hold>

### Soft

- <prefer if cost/risk stays acceptable>

## Non-goals

- <explicit exclusion>

## Locked decisions

<omit if none. Standing invariants the whole plan must stay consistent with; the final-pass review verifies each holds everywhere with no leftover superseded wording. Not a changelog — that is Decisions / revisions.>

- <decision, stated exactly as it must appear everywhere>

## Assumptions to validate

- <premise> — <validation method / decision impact>

## Success criteria

- <observable acceptance check — no "good", "complete", or "works well" without a check>

## Risks and guardrails

- <risk> — <trigger> — <mitigation or stop/replan action>

## Top-level AI execution plan

1. <milestone> — <outcome / dependency>.
   - Use: <named discovered capability — trigger / expected output; omit if none>
   - Delegate: <role/capability — bounded task / expected return / trigger / fallback; omit if main-thread work is cheaper or needs live synthesis>

## Execution capability notes

- Runtime assumption: <shared capability or permission expected during execution — validation / fallback>
- Setup: <one-time capability setup needed before affected milestones, or omit>
- Research: <decision-blocking question — direct inspection | web research | review — why>
- Lead: <current promising source/path and why, or omit>
- Avoid: <capability/approach that wastes tokens, risks damage, or cannot answer question>

Name capability role only when use changes execution. Milestone-specific use/delegation goes beside milestone; this section holds only shared assumptions, setup, fallback. Favour bounded workers for independent read-only mapping, focused review, known 1-2 file surgical edits; not for trivial work, broad refactors, or live-synthesis work.

## Open questions

- <decision needed from user>

## Recommended final deliverable format

- <format and acceptance shape>

## Decisions / revisions

- YYYY-MM-DD — <decision/change; why>
