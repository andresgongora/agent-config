---
name: agent-prompt
description: Designs, rewrites, critiques, and teaches machine-facing AI prompts using explicit task contracts, bounded context, decision authority, examples, tool and source rules, structured returns, and verifiable completion. Use for prompt creation, prompt review, reusable prompt templates, evaluator prompts, or tool-using prompts. Also helps an owning workflow identify missing prompt-contract decisions when a materially underspecified request prevents safe or correct action; it does not own live task state, delegation supervision, agent artifact files, policy files, or human-facing prose.
---

## Core rules

- Contract before wording. Define outcome, completion evidence, scope, inputs, constraints, authority, stop conditions, and return before polishing prose.
- Minimum sufficient prompt. Add only context or structure that changes a decision, prevents a likely failure, or makes completion observable.
- Separate positive requirements, exclusions, preferences, and unknowns. `Do` and `Don't` define known boundaries; they do not settle gray cases.
- Models cannot read intent hidden behind words. State goal, label proposed method as required, preferred, or illustrative, and grant bounded authority to replace it.
- Translate candor requests into behavior: challenge weak premises, state strongest objection, and distinguish evidence, judgment, and unknowns. Aggressive tone does not prove truth.
- Evidence over confidence. A format, rationale, self-review, or confidence score does not prove correctness.
- Separate instructions, trusted context, untrusted material, examples, and requested output. Delimiters organize content; they do not neutralize prompt injection.
- Request concise plans, decisions, evidence, or intermediate artifacts when useful. Never require hidden chain-of-thought.
- Verification claims need independent evidence: tests, tool or environment observations, cited sources, or human review. Schemas, semantic rules, rubrics, rationale, and self-review are acceptance criteria or internal checks unless an independent judge applies them. Bound revision attempts.
- Stronger model cannot repair missing intent, authority, or success criteria.

## Modes

- **Create:** Convert an idea or task into a finished prompt.
- **Rewrite:** Preserve intent and hard constraints; repair omissions, conflicts, and weak structure.
- **Critique:** Identify prompt defects by impact. Provide corrected text only when request includes improvement or rewrite.
- **Teach:** Guide user through prompt design; explain only patterns relevant to current prompt.
- **Clarify:** Local subroutine for a materially underspecified request that blocks correct or safe action. Identify missing task-contract decisions; ask one batch for known blockers; return resolved answers or exact remaining gap. Caller retains task state and resumes or stays blocked.

## Workflow

1. Identify mode, prompt consumer, invocation mode, desired outcome, downstream judge, and consequence of failure.
2. Target has a specialized worker, mission, agent, command, skill, or policy form: stop general template flow and apply owning artifact workflow.
3. Clarify mode:
   - Caller retains task state. Identify only missing intent, outcome, done evidence, scope, authority, or risk decision that blocks safe or correct action.
   - Ask one batched set for all known blockers. Explain choices only when needed for an informed answer.
   - Answers are sufficient when owning workflow can act without guessing a material outcome, boundary, authority, or success condition.
   - Return `resolved: <answers>` when sufficient; caller resumes current task. Return `blocked: <exact unresolved decision>` when partial, contradictory, or newly blocking; caller stays blocked or asks again under its normal workflow.
   - Do not choose a risky default or produce prompt text unless requested deliverable is prompt text. Stop this subroutine after one result.
4. Create, rewrite, or teach mode: extract task contract: goal, done evidence, scope, inputs, method status, positive and negative constraints, preferences, judgment posture, decision authority, stop or escalation conditions, and return.
5. Critique mode: compare existing prompt against task-contract fields and likely failure modes. Request includes improvement or rewrite: continue with corrected prompt; otherwise return findings and stop.
6. Classify missing information:
   - User intent, preference, authority, or risk tolerance changes result: ask.
   - Fact recoverable from allowed context, tools, or sources: instruct consumer to recover it.
   - Low-risk reversible detail: choose bounded default and disclose it.
   - No-dialog invocation: encode assumption or stop behavior; never write an impossible clarification instruction.
7. Select minimum patterns needed for likely failure modes. Do not fill every available section.
8. Copy `templates/prompt.md`. Fill required fields. Delete comments, placeholders, and unused optional sections from finished prompt.
9. Add examples only when rules alone leave style, classification, transformation, edge behavior, or output semantics ambiguous. Keep examples representative and consistent with instructions.
10. For tool or research work, define allowed actions, source priority and freshness, trust boundaries, evidence, permission limits, and failure behavior.
11. Tie output shape to downstream use. Add semantic checks beside schema requirements. Define empty, partial, blocked, and failure cases when relevant.
12. Add process constraints only when method affects safety, coordination, cost, or verification. Do not micromanage ordinary execution.
13. Run cold-reader check. Consumer must know what to do, what not to do, what it may decide, when to stop, what proves completion, and what to return without hidden context.

## Output

- Create or rewrite: finished prompt first. Follow with unresolved assumptions only when they remain material.
- Critique: findings ordered by impact; each names defect, consequence, and repair. Include revised prompt only when request includes improvement or rewrite.
- Teach: smallest useful question batch or choice set. After answers, return finished prompt rather than more theory.
- Clarify: return question batch, `resolved` answers, or `blocked` gap to caller. Do not return a general prompt unless requested deliverable is prompt text.
- User asks to fill template: preserve template structure only where useful; remove all instructional comments and unused sections in final prompt unless user requests an annotated draft.

## Boundaries

- Own prompt text. In Clarify mode, supply task-contract questions or result to caller; never take over live planning, worker selection, delegation retries, execution, or task state.
- Do not replace specialized worker, mission, agent, command, skill, or policy templates. Apply owning artifact workflow instead.
- Do not treat persona, verbosity, politeness, or magic phrases as substitutes for task requirements.
- Do not promise universal model behavior. Mark vendor, model, tool, and version assumptions when they matter.
- Harmful or unauthorized goal: refuse or narrow goal; prompt quality does not override safety or authority.

## Verification

- [ ] One unambiguous outcome and observable done condition.
- [ ] Scope, non-goals, authority, constraints, and stop conditions agree.
- [ ] Every referenced input exists or has explicit recovery behavior.
- [ ] Instructions distinguish trusted directions from untrusted content.
- [ ] Output supports downstream decision and covers empty or failure case.
- [ ] Examples match rules and do not silently narrow task.
- [ ] Validation checks correctness, not only syntax or self-confidence.
- [ ] No hidden context, conflicting priorities, unsupported guarantees, or unnecessary sections.
