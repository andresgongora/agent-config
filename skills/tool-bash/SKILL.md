---
name: tool-bash
description: "Bash command-execution preflight. Covers how to run a command safely. Load immediately before Bash tool use, shell command, terminal invocation or CLI call. Do not load for pre-existing skill-script execution."
---

## Rules

- Avoid `cd`. Run target by path; this preserves `PWD`. Set tool working directory only when target requires another directory.

## Forbidden commands

Forbidden commands: unavailable; never bypass. Use listed alternative; if unavailable: stop and ask for an allowed alternative.

| Forbidden | Use instead |
| --- | --- |
| `rm`, `rmdir` | `trash` |
| `timeout <cmd>` | Tool-native timeout parameter |

## Guardrails

- Missing command? Use approved on-demand environment or clear alternative. Neither works: stop, tell user. No workaround without approval.
