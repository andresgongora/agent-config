# local-markdown

Small finish gate for Markdown files: scoped formatter check, lint, then a short source review.

## Intent

Markdown errors are cheap to prevent and easy to miss in agent-generated files. Keep this skill narrow: it checks file shape, not content quality, research claims, or documentation structure. Prettier applies to human-facing Markdown; agent-directed artifacts retain intentional dense layout and use Markdown lint only.

## Trigger summary

Load for Markdown writing, editing, completion, and review. It is most useful after agent-artifact work.

## Tools

- `prettier` checks and formats human-facing Markdown.
- `markdownlint-cli2` reports Markdown rule violations.
- `marksman` provides editor/LSP diagnostics. No shell check belongs here.

## Maintainer constraints

- Keep workflow short and file-scoped.
- Do not add prose, documentation, link-checking, or repository-wide linting policy.
- Use repository configuration when present.

## See also

Use existing prose and documentation workflows for content quality and document structure.
