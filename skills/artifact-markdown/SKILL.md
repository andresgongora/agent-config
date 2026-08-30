---
name: artifact-markdown
description: "Validates Markdown formatting and frontmatter against nearest repository config. Load when creating or editing Markdown files `*.md`, including `README.md`, `SKILL.md`, or `AGENTS.md`."
---

## Rules

- One pass per finished file or batch, not per edit. Do not reload mid-session; run this once work is otherwise done.
- Preserve nearest repository Markdown config and style convention; never impose this skill's style on a repo that already picked its own.

## Workflow

1. Run linting. If a check fails, fix the issue and rerun until clean.
  ```bash
  file="path/to/file.md"
  markdownlint-cli2 --fix -- "$file"
  awk 'NR==1{if($0!="---")exit 2;next}/^---$/{exit 0}{print}' "$file" | yq -e 'type == "!!map"'  # Frontmatter check.
  ```
2. Perform structural check on the finished file: heading levels, list/code-fence syntax, link syntax, and referenced paths/commands exist.
3. Report: concise one-line success report, or list violations.

## README files

- Always treat as human-facing.
- New root README with no existing repo convention: start from self-contained template `templates/MAIN-README.md`. HTML comments mark required vs. optional sections, state the license-section rule, and instruct deleting the comments once filled. Drop unused optional sections cleanly (no placeholder/"N/A" text).

## AI-agent facing Markdown

- No maximum line width. Do not break lines.
- Optimize layout for AI-agent consumption. No decoration.

## Human-facing Markdown

- One `#` per file, title only.
- `##` sections wrapped above and below with an HTML-comment dash decorator, no blank line between decorator and heading:
  ```markdown
  <!------------------------------------------------------------------------------------------------->
  ## Section title
  <!------------------------------------------------------------------------------------------------->
  ```
- `###` is the deepest default level. Going past it needs a concrete reason (deep reference material). Avoid `####`+.
- Skip decorators entirely on agent-facing (lint-only) files unless the file already uses them.
- Never retrofit this style onto a repo whose Markdown already has an established heading convention.

## Boundaries

- Format/lint checks do not prove factual accuracy, reachable external links, or good prose quality.
- LSP diagnostics (marksman) run separately in the editor; this skill only runs shell-based lint/format commands.
- Do not run this skill repeatedly within one active edit session; one finish-time pass per file/batch.
- Missing tool (`markdownlint-cli2`, `prettier`, `yq`): do not fail or halt. Skip the check, continue as if it passed, log tool name once in final report.
