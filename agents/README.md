---
hidden: true
---

# Agents

Agent definitions for OpenCode-compatible clients. Primary agents own a broad work mode; subagents handle bounded work and return compact results. Each Markdown file defines its role, model, tools, permissions, and operating rules.

Permission maps resolve last match. Agents place broad `bash: "*": deny` or `ask` before exceptions; hard denies follow broad rules. Frontmatter comments are maintenance notes, not runtime instructions.

## Agent Evaluator

`agent-evaluator.md` is a read-only subagent for static audits of agent-directed artifacts such as `AGENTS.md`, agent definitions, skills, and commands.

- Finds source-evidenced contradictions, scope problems, and visible execution gaps.
- Does not edit artifacts, run software, grade numerically, or review application code.

## Artifact Vestige

`artifact-vestige-hunter.md` is a read-only subagent that finds vestigial residue (leftover comments, steps, or notes describing removed/superseded behavior) in code, docs, or agent-directed text.

- Judges each candidate by a zero-impact-refactor test, not pattern match alone; emits a terse finding-per-line list.
- Does not edit, propose diffs, audit correctness/alignment of agent-directed artifacts, or perform static dead-code analysis.

## Build

`build.md` is the primary development agent for repository-local work.

- Edits code, manages dependencies, and runs validation such as tests, linters, formatters, and builds.
- Does not own broad system administration or deploy and publishing workflows.

## Build Fast

`build-fast.md` is a low-cost subagent for one mechanical development command.

- Runs one supplied test, lint, format, dependency, script, or type-check action.
- Returns command output, exit code, and pass or fail status.
- Refuses ambiguous, multi-step, or judgment-dependent work.

## Build Medium

`build-medium.md` is a mid-cost subagent for one bounded multi-step development task.

- Implements a small feature slice, fixes a failing test/bug with a known repro, or applies a
  scoped few-file refactor, iterating on verification failures within budget.
- Refuses undefined scope, cross-cutting architecture work, or multi-turn dialogue needs.

## Cavecrew Builder

`cavecrew-builder.md` makes one or two bounded edits to existing files.

- Suited to typo fixes, mechanical renames, small rewrites, and format-preserving changes.
- Refuses broader refactors, new features, and scopes of three or more files.

## Cavecrew Investigator

`cavecrew-investigator.md` is a read-only code locator.

- Finds definitions, call sites, usages, and directory structure.
- Returns compact `file:line` evidence without proposing fixes.

## Cavecrew Reviewer

`cavecrew-reviewer.md` reviews a bounded diff, branch, or file for defects and risks.

- Returns one terse, severity-tagged finding per line.
- Does not edit code or perform broad codebase exploration.

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
