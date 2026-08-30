---
name: coding-python
description: "Provides Python development conventions. Load when writing, editing, or reviewing Python code, packages, or project commands."
---

## Core rules

- Inspect project instructions, `pyproject.toml`, lockfiles, and existing commands before selecting tooling. Existing project tooling wins.
- New project without an established toolchain: prefer `uv`; run project code with `uv run`.
- Do not migrate package tooling, change lockfiles, or add README setup text unless user asks.
- Prefer `typer` for Python CLI work. Structure nested command groups with `typer.Typer`; do not migrate an existing CLI framework unless asked.
