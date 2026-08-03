---
name: local-markdown
description: "Minimal Markdown completion checks. Load whenever writing, editing, finishing, or reviewing Markdown files (`*.md`, `*.markdown`). Not for prose/content guidance or broader documentation workflow."
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

## Boundaries

- Format and lint checks do not prove factual accuracy, reachable external links, or good prose.
- Marksman supplies editor diagnostics; it is not this skill's shell validation step.
