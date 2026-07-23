---
title: AI Tools Frontier
summary: Present-tense boundary — Shape / Done / In progress / Next / Boundary. Portable AI-agent rules, skills, subagents, and optional OpenCode integrations.
status: active
updated: 2026-07-23
---

# Frontier
## Shape

- `AGENTS.md` — repo-local maintainer rules for agents editing this repo
- `deploy/AGENTS.md` — deployed cross-project user-home rules (the "product")
- `README.md` — human introduction and deployment map
- `agents/` — primary (`build`, `chat`, `cli`, `files`, `planning`) + bounded workers (`build-fast`, `cavecrew-*`, `fast`, `web-search*`)
- `skills/` — skills loaded on trigger. Each is `SKILL.md` + `README.md` (+ optional flat assets)
- `.agent/` — lean durable notes, this frontier, temporary plan/progress/bug lifecycle folders
- `plugins/` — client-specific plugins (e.g. JS for opencode)
- `commands/` — slash-commands
- `tools/` — ad-hoc scripts (incl. `check-ai-repo`)

## Done

- Cross-project rules, repo-maintainer rules, skills, agents, commands, plugins, and validation script are present and documented.
- Skills use paired runtime instructions and maintainer README files; agent definitions use explicit role, model strategy, temperature, tool, and permission boundaries.
- Web research uses coordinator plus bounded scout topology; compact evidence contracts separate source quality from answer confidence.
- `.agent/` retains only durable design/authoring notes and present state. Historical plans, refactor records, and machine-specific deployment notes are removed.

## In progress
- (none)

## Next

- Test a fresh external clone with supported client wiring; correct onboarding gaps found there.
- Validate web-search topology in real sessions before changing model tiers or guardrails.
- Rework `rossmann-voice` before broadening its trigger.

## Boundary

### Known risks

- Skill-routing miss: subtle cues may not load `code-frontier`. Mitigate with real-session testing and stronger routing only if evidence warrants it.
- Documentation drift: runtime prompts, README guidance, and durable notes can diverge. Mitigate by treating runtime files as operational source and pruning duplicate history.

### Limitations

- Repository health checks are local scripts, not automatic enforcement.
- Permission maps are approval UX, not an OS sandbox; shell patterns cannot prove command semantics.
- Client schemas and model availability vary; verify deployment boundaries in target client.

### Deferred / discarded

- Permanent plan archive — discarded — completed/abandoned plans create noise; preserve only durable decisions.
- Dedicated document subagent — discarded — documentation needs parent context.
