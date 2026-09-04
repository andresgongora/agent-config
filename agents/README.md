---
hidden: true
---

# Agents

Agent definitions for OpenCode-compatible clients. Primary agents own a broad work mode; subagents handle bounded work and return compact results. Each Markdown file defines its role, model, tools, permissions, and operating rules.

Permission maps resolve last match. Agents place broad `bash: "*": deny` or `ask` before exceptions; hard denies follow broad rules. Frontmatter comments are maintenance notes, not runtime instructions.

The `minion-*` family uses only `done`, `partial`, `blocked`, `refused`, and `none`. Every report ends with `status`, then `gap`; an optional preceding `issue` explains a block, refusal, or partial result.

The Minion family was inspired by CaveCrew in [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman).

## Minion Master

`minion-master.md` is the high-capability executor for one frozen, bounded multi-step repository mission.

- Builds or follows an internal subplan, dispatches eligible leaf minions, integrates their work, and validates the outcome.
- Cannot talk to the user; incomplete scope, authority, or proof requirements stop with a structured receipt.
- Exists because planning milestones need one integration owner while leaf minions retain small, reusable contracts.

## Agent Evaluator

`agent-evaluator.md` is a read-only subagent for static audits of agent-directed artifacts such as `AGENTS.md`, agent definitions, skills, and commands.

- Finds source-evidenced contradictions, scope problems, and visible execution gaps.
- Does not edit artifacts, run software, grade numerically, or review application code.

## Minion Vestige Hunter

`minion-vestige-hunter.md` is a read-only vestige hunter for a supplied file, directory, or repository area.

- Uses broader current context and a zero-impact test to find vestigial residue, ghost steps, and superseded wording.
- Returns vestige, survivor, or unresolved evidence; does not edit, review correctness, or perform general style analysis.

## Build

`build.md` is the primary development agent for repository-local work.

- Edits code, manages dependencies, and runs validation such as tests, linters, formatters, and builds.
- Does not own broad system administration or deploy and publishing workflows.

## Minion Builder

`minion-builder.md` makes one or two surgical edits to existing repository files.

- Suited to obvious typo fixes, mechanical renames, single-function rewrites, comment removal, and format-preserving tweaks.
- Caller owns tests, builds, formatters, and other validation.

## Minion Linter

`minion-linter.md` runs applicable formatting and linting tools on supplied repository files or directories.

- Applies only presentation-preserving automatic fixes and reports unresolved diagnostics.
- Does not change code or content, install dependencies, review correctness, or perform feature work.

## Minion Investigator

`minion-investigator.md` is a read-only repository locator for focused evidence collection.

- Finds definitions, call sites, usages, tests, imports, and directory structure.
- Returns compact, verified path-based evidence without proposing changes.

## Minion Reviewer

`minion-reviewer.md` reviews a supplied diff or one bounded file for verified defects and risks.

- Returns compact severity-tagged findings with emoji tiers.
- Does not edit code, design refactors, or perform broad architecture review.

## Chat

`chat.md` is the primary cloud-only conversational agent.

- Handles discussion, explanation, brainstorming, and web research without local context.
- Has web access but cannot read local files or run shell commands.

## CLI

`cli.md` is the primary terminal agent for work outside a repository.

- Investigates system state, services, networks, packages, and complex shell workflows.
- Does not own ordinary repository code editing.

## Fast

`fast.md` is a cheap subagent for one-shot answers.

- Handles stable common knowledge, simple comparisons, definitions, or one quick web search.
- Returns only the answer, uncertainty, or no information.
- Refuses implementation, multi-step reasoning, source verification, and local-context work.

## Files

`files.md` is the primary filesystem-maintenance agent.

- Organizes folders, inspects metadata, finds duplicates, and renames or moves files.
- Uses paths, sizes, timestamps, hashes, and media metadata only; never reads file text.

## Planning

`planning.md` is the primary durable-planning agent.

- Inspects available context and writes one revisable execution plan under `.agent/plan/`.
- Cannot implement changes or write outside the plan directory.

## QA Tester

`qa-tester.md` runs one supplied skill against one supplied prompt.

- Returns the skill's raw answer in a status envelope.
- Runs independently; callers can start one instance per skill in parallel.

## QA Judge

`qa-judge.md` compares two completed tester outputs against their shared prompt.

- Judges visible results only, not skill definitions or authors.
- Returns which result appears better, or no clear winner.

## Web

`web.md` is a low-cost executor for platform/service extraction and transformation.

- Loads matching `web-*` skills for compact answers or transformed content.
- Does not return verbatim large artifacts, perform multi-source research, access local files, or delegate.

## Web Search

`web-search.md` coordinates non-trivial online research.

- Searches and fetches multiple sources, using bounded scout fanout when useful.
- Returns a compact `## Findings` report.
- Does not perform local-file work or implementation.

## Web Search Scout

`web-search-scout.md` is a leaf subagent for one isolated research angle.

- Searches or fetches a specific source family, query angle, or URL lead.
- Returns a compact `## Scout Report` for the web-research coordinator.

## Writing

`writing.md` is a chat-first primary agent for drafting and revising human-directed prose.

- Uses supplied facts, asks for missing material context, and applies writing rules plus references.
- Does not research, inspect local files, or handle code, configuration, structured data, or AI-directed text.

## Writing Reviewer

`writing-reviewer.md` is a read-only subagent for final review of supplied reader-facing prose.

- Returns corrections or a revised text with reasons, or reports a bounded limitation.
- Does not ask questions, research, edit files, or delegate.
