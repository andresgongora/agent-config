---
title: <work item> Plan
summary: <goal, boundary, why this plan exists>
status: draft
updated: YYYY-MM-DD
---

# <work item> Plan

## Goal

<outcome, not activity>

## Requirement rewrite

<real user need; better path or rejected framing if relevant>

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
   - Delegate: <named worker — bounded task / expected return / trigger; omit if main-thread work is cheaper or needs live synthesis>

## Execution capability notes

- Runtime assumption: <shared skill, MCP/tool, worker, or permission expected during execution — validation / fallback>
- Setup: <one-time capability setup needed before affected milestones, or omit>
- Research: <decision-blocking question — direct inspection | web research | review — why>
- Lead: <current promising source/path and why, or omit>
- Avoid: <capability/approach that wastes tokens, risks damage, or cannot answer question>

Name a capability only when its use changes execution. Milestone-specific use/delegation goes beside that milestone; this section holds only shared assumptions, setup, fallback. Favour workers for independent read-only mapping, focused review, known 1-2 file surgical edits; not for trivial work, broad refactors, or live-synthesis work.

## Open questions

- <decision needed from user>

## Recommended final deliverable format

- <format and acceptance shape>

## Decisions / revisions

- YYYY-MM-DD — <decision/change; why>
