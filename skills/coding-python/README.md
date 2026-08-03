# coding-python skill

Python child skill. Prefers `uv` for new projects and structured `typer` CLIs.

## Design intent

The inspected project guides contained mostly project-specific boundaries and conventions. This skill retains only portable preferences: `uv` for new projects and nested `typer` command groups for new CLIs. Existing project tooling wins; migration and setup-documentation work need explicit scope.

## Trigger summary

Loads for Python code, packages, and project commands. Use with cross-language coding conventions.

## Maintainer constraints

- Keep this skill minimal until repeated Python work shows another durable rule.
- Add conventions only when broadly applicable across Python projects.

## See also

- `coding` — shared coding conventions and language-child routing.
