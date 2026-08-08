---
name: artifact-markdown
description: "Minimal Markdown completion checks. Load whenever writing, editing, finishing, or reviewing Markdown files (`*.md`, `*.markdown`). Not for prose/content guidance or broader documentation workflow."
license: MIT
---

# Local Markdown

## Finish

1. Preserve nearest repository Markdown conventions and tool configuration.
2. Classify `file`: `AGENTS.md`, `agents/`, `commands/`, `skills/**/SKILL.md`, agent templates, `assets/`, and `.agent/` artifacts use Markdown lint only; human-facing Markdown uses both formatter and lint.
3. For human-facing Markdown, check:

   ```bash
   file="path/to/file.md"
   prettier --check "$file"
   markdownlint-cli2 -- "$file"
   ```

4. Writing, editing, or finishing: run `prettier --write "$file"` when human-facing format fails; fix lint findings, then rerun applicable checks. Read-only review: report findings; do not modify file.
5. Read final file. Check applicable frontmatter, headings, lists and code fences, link syntax, paths, and commands.

## Heading structure

- One `#` per file. Title only.
- `##` sections wrapped above and below, HTML-comment dash decorator, no new lines between decorator and heading. Omit decorator in AI-directed files.

  ```markdown
  <!------------------------------------------------------------------------------------------------->
  ## Section title
  <!------------------------------------------------------------------------------------------------->
  ```
- `###` deepest level by default. Past it needs concrete reason (deep reference material). Avoid `####`+.
- Skip decorators on Markdown-lint-only artifacts (Finish step 2 classification) unless that file already uses them.

## README template

New root README, no existing convention: start `templates/MAIN-README.md`. Self-contained — inline HTML comments mark required vs optional, cover License section rule, tell you to delete comments once filled. Minimalist, optional sections (config, contributing, license) drop clean. Apply heading rules above while filling it.

## Boundaries

- Format and lint checks do not prove factual accuracy, reachable external links, or good prose.
- Marksman supplies editor diagnostics; it is not this skill's shell validation step.
