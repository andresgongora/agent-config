# docs-logbook

Automatically writes compact, structured records of major repository work for future agents.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

Entries preserve starting state, approach, actions, evidence, outcome, and parent task. Dream-RSI
shows observed history can guide later exploration; it cannot predict untried branches.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

Repository instruction loads it before major work. It opens one entry before first material action,
updates it at material outcomes, and closes it before final response. Major means implementation,
multi-file change, nontrivial diagnosis, material research, planning, migration, or multiple decisions.

<!------------------------------------------------------------------------------------------------->
## When it does not trigger
<!------------------------------------------------------------------------------------------------->

Do not log answers, one routine read, one routine check, trivial mechanical edits, or each command.
Record passing checks when they materially establish task outcome. This skill records observed work;
it does not execute, plan, or validate that work.

<!------------------------------------------------------------------------------------------------->
## Maintainer constraints
<!------------------------------------------------------------------------------------------------->

- Keep frontmatter compatible with managed `.agent/` documents: `title`, `description`, `status`,
  `updated`, and optional `source`.
- Keep entry schema small and evidence-first. Do not promise simulator-grade replay without durable
  environment snapshots and deterministic tool contracts.
- Keep records local unless repository policy changes: `.agent/` is currently ignored.

<!------------------------------------------------------------------------------------------------->
## See also
<!------------------------------------------------------------------------------------------------->

- `../../.agent/references/dream-rsi-recursive-self-improvement.md`: paper summary and local adaptation limits.
