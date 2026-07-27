---
name: coding-python
description: >
  Python development convention. Load when writing, editing, or reviewing Python code,
  Python packages, or Python project commands. Use alongside cross-language coding conventions.
  Not for agent-internal non-Python commands or non-Python deliverables.
---

# coding-python

## Core rules

- Use `uv` for every Python execution, environment, interpreter, dependency, lockfile, and package operation. Run code with `uv run`; never invoke `python`, `pip`, `poetry`, or virtual-environment tools directly.
- Ensure root `README.md` has a concise `## uv` section covering project-relevant `uv` commands, including `uv sync`, `uv run`, `uv add`, and `uv remove` where applicable.
- Prefer `typer` for Python CLI work. Structure nested command groups with `typer.Typer`; do not migrate an existing CLI framework unless asked.
