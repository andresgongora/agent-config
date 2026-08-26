# artifact-markdown

Finish-time lint gate for Markdown files, plus a README starter template.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

The skill runs a scoped lint and structural check after a Markdown edit or creation session. It
checks frontmatter, headings, lists, code fences, links, and referenced paths or commands. It does
not establish factual accuracy, reachable external links, or prose quality. Missing tools skip their
checks and are logged once in the final report.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

Once, at the end of creating or editing Markdown or a README, before calling the work done.

<!------------------------------------------------------------------------------------------------->
## When it does NOT trigger
<!------------------------------------------------------------------------------------------------->

- Mid-session, on every individual edit within an active editing loop (batch it to the end).
- Prose quality, factual accuracy, or reachable-link validation.
- Editor LSP diagnostics; marksman runs separately in the editor.

<!------------------------------------------------------------------------------------------------->
## Maintainer constraints
<!------------------------------------------------------------------------------------------------->

- Run one completion pass per finished file or batch; do not reload or rerun mid-session.
- Preserve nearest repository Markdown config and established style; do not impose this skill's
  style on a repository with its own convention.
- Lint with `markdownlint-cli2 --fix -- "$file"`; fix reported issues, then rerun until clean.
- Report one concise success line, or violations only.
- Missing `markdownlint-cli2`, `prettier`, or `yq` never blocks work; skip its check and log the
  tool once in the final report.
- README files are human-facing. A new root README without an existing repo convention starts from
  `templates/MAIN-README.md`; remove unused optional sections without placeholder text.
- Human-facing Markdown uses one title-only `#`; `##` headings use the template's HTML-comment
  decorators; `###` is the deepest default level. Do not retrofit this style onto an established
  repository convention.
- AI-agent-facing Markdown has no maximum line width; do not break lines. Skip decorators unless
  the file already uses them.

<!------------------------------------------------------------------------------------------------->
## See also
<!------------------------------------------------------------------------------------------------->

- `templates/MAIN-README.md` — root README starter. Its comments distinguish required and optional
  sections, state the license-section rule, and must be deleted once filled.
