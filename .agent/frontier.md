---
title: AI Tools Frontier
summary: Present-tense boundary — Shape / Done / In progress / Next / Boundary. Portable AI-agent rules, skills, subagents, and optional OpenCode integrations.
status: active
updated: 2026-07-27
---

# Frontier
## Shape

- `AGENTS.md` — repo-local maintainer rules for agents editing this repo
- `deploy/AGENTS.md` — deployed cross-project user-home rules (the "product")
- `README.md` — human introduction and deployment map
- `agents/` — primary (`build`, `chat`, `cli`, `files`, `planning`) + bounded workers (`build-fast`, `cavecrew-*`, `fast`, `web-search*`)
- `skills/` — skills loaded on trigger. Each is `SKILL.md` + `README.md` (+ optional flat assets). Includes `authoring-agents` (authoring workflow) and `coding` (parent router) + `coding-bash`, `coding-python` (children).
- `.agent/` — lean durable notes (design-principles only), this frontier, temporary plan/progress/bug lifecycle folders
- `plugins/` — client-specific plugins (e.g. JS for opencode)
- `commands/` — slash-commands
- `tools/` — ad-hoc scripts (incl. `check-ai-repo`)

## Done

- Cross-project rules, repo-maintainer rules, skills, agents, commands, plugins, and validation script are present and documented.
- Skills use paired runtime instructions and maintainer README files; agent definitions use explicit role, model strategy, temperature, tool, and permission boundaries.
- `skills/writting/` provides reader-facing prose rules: evidence-led directness, peer-level tone, attention without clickbait, three-part body paragraphs, conditional final-pass minimization patterns, and an ASD-STE100-inspired directive overlay.
- `skills/authoring-agents/` ships three self-informing templates (skill / subagent / primary-agent file form). Replaces `.agent/notes/authoring-skills-and-subagents.md` (dissolved).
- `coding` parent skill + `coding-bash` + `coding-python` children added. `coding-bash` ships canonical starter + opt-in snippets. `coding` holds language-agnostic Core rules (nesting, responsibility, naming, coupling, abstraction, comments, meta-rule). Source-attributed to CodeAesthetic. OOP notes parked in `coding/README.md` pending a future `coding-oop` child.
- `deploy/AGENTS.md` skill-trigger table has `coding` row as single coding entry point.
- `.agent/` retains only durable design/authoring notes and present state. Historical plans, refactor records, and machine-specific deployment notes are removed.

## In progress
- (none)

## Next

- Add `coding-oop` child skill to absorb OOP rules parked in `coding/README.md`.
- Test a fresh external clone with supported client wiring; correct onboarding gaps found there.
- Validate web-search topology in real sessions before changing model tiers or guardrails.

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
