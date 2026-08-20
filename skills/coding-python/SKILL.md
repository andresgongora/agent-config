---
name: coding-python
description: "Python development convention. Load when writing, editing, or reviewing Python code, Python packages, or Python project commands. Use alongside cross-language coding conventions. Not for agent-internal non-Python commands, non-Python deliverables, or Python test policy."
---

# coding-python

## Core rules

- Inspect project instructions, `pyproject.toml`, lockfiles, and existing commands before selecting tooling. Existing project tooling wins.
- New project without an established toolchain: prefer `uv`; run project code with `uv run`.
- Do not migrate package tooling, change lockfiles, or add README setup text unless user asks.
- Prefer `typer` for Python CLI work. Structure nested command groups with `typer.Typer`; do not migrate an existing CLI framework unless asked.
