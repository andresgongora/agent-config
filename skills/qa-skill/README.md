# QA-skill

QA harness for comparing two agent skills through static analysis and matched subagent runs.

## Design intent

Static comparison alone cannot show runtime behavior. This skill turns the meaningful difference into one shared prompt, runs both skills independently, preserves raw outputs, and sends them to a separate judge.

## When it triggers

Requests to compare, QA-test, or behavior-test exactly two agent skills using a static diff and matched prompts.

## When it does NOT trigger

Ordinary code QA, single-skill review, general prompt testing, or tests that require more than two skills.

## Maintainer constraints

Keep the comparison, prompt, tester, judge, storage, and presentation contracts stable. Testers run in parallel; judging starts only after both complete.

## See also

`skills/agent-prompt/SKILL.md` for prompt-contract principles. `skills/delegation/SKILL.md` for bounded worker execution.
