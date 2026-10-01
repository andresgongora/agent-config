---
name: artifact-markdown
description: "Validates Markdown formatting and frontmatter against nearest repository config. Load when creating or editing Markdown files `*.md`, including `README.md`, `SKILL.md`, or `AGENTS.md`."
---

## Rules

- One pass per finished file or batch, not per edit. Do not reload mid-session; run this once work is otherwise done.
- Preserve nearest repository Markdown config and style convention; never impose this skill's style on a repo that already picked its own.

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

## Linting

- `skills/artifact-markdown/scripts/lint.sh <file>.md`.
- `skills/artifact-markdown/scripts/lint.sh --recursive <directory>`.

## Boundaries

- Format/lint checks do not prove factual accuracy, reachable external links, or good prose quality.
