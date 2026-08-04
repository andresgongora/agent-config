---
title: Nested Skill Folder Layout
summary: >-
  Decide whether to nest opencode skill source folders (vs current flat one-skill-per-folder). Verdict recorded: stay flat. Doc holds loader facts + safe-nesting path if reversed later.
status: active
updated: 2026-08-02
---

# Nested Skill Folder Layout

## Goal

Decide the source-tree layout for skills under `tools/agent-config/skills/` (deploy target `~/.config/opencode/skills`), knowing the same skills must also flatten to `~/.agents/skills/<name>/SKILL.md` for other clients.

## Requirement rewrite

User wants visual grouping (e.g. `coding-*` children under a `coding/` parent) without breaking opencode load. Real need: grouping ergonomics vs loader-safety + cross-client portability. Better framing: grouping via `name` prefix (`coding-*`) is already available at zero loader risk — nesting is cosmetic.

## Loader facts (verified, opencode v1.18.3 binary)

Source: installed OpenCode binary. Re-verify after an OpenCode upgrade.

- Discovery glob = `**/SKILL.md` — **recursive**. Nesting depth irrelevant. `coding/coding-bash/SKILL.md` AND `coding/bash/SKILL.md` both found.
- Skill identity = **frontmatter `name`** (code: `j.skills[z.data.name]={...}`). Folder path NOT parsed for identity. Docs' "matches the folder name" = convention, not enforcement.
- `description` frontmatter effectively required — skills lacking it filtered out (`if(!mA(z.data))return`).
- Duplicate `name` → `logWarning("duplicate skill name")`, last-writer-wins in map → silent shadow.
- Skill base dir = `dirname(SKILL.md)`; relative asset paths resolve there. Nesting does NOT break bundled assets.
- Non-default locations registered via `skills.paths` (also scanned recursively).

## Verdict (locked)

- **Stay flat.** One skill per folder, folder name == frontmatter `name`, as today.
- Nesting is structurally allowed but buys near-nothing and adds a real failure mode.
- Rationale:
  1. `name` must stay globally unique regardless of tree. Nesting does NOT free `bash`/`python` to be bare names — collision risk stands, and bare names weaken routing keywords. Frontmatter namespace stays flat either way; folder prettiness is cosmetic.
  2. Nesting desyncs the `name`↔folder convention that every other client (`~/.agents/`) and the opencode docs assume. Source tree and deployed tree already differ under the flatten plan; a second structural mismatch raises debugging cost.
  3. Portability goal argues AGAINST nesting: flat `~/.agents/skills/<name>/SKILL.md` is the lowest common denominator you must emit anyway. Authoring flat skips a transform that could only ever reproduce flat.
- Grouping without risk: rely on existing `name` prefix (`coding-*`). That IS the grouping, loader-cost-free.

## If reversed later (nesting path)

- **Prefer Option A** (`coding/coding-bash/SKILL.md`): folder still == `name`; convention + docs + other-client assumptions survive; only an outer grouping dir is new. Low risk.
- **Avoid Option B** (`coding/bash/SKILL.md`): folder `bash` ≠ `name: coding-bash`; breaks every "folder = name" assumption in docs, other clients, future memory. Aesthetic only; higher debugging cost.
- Either option: keep `name` values exactly as today (`coding-bash`, `coding-python`). Never shorten to `bash`/`python` (see Verdict rationale 1).
- Flatten-on-install rule (makes A and B safe to deploy elsewhere):
  - `find skills -name SKILL.md`
  - For each, read frontmatter `name`, deploy to `~/.agents/skills/<name>/SKILL.md` (+ copy sibling assets).
  - Derive target dir from frontmatter `name`, NEVER from source path.

## Success criteria

- Layout decision recorded with loader evidence. (met — this doc)
- If nesting adopted: `opencode agent list` / skill load shows every skill once, no `duplicate skill name` warning; flattened `~/.agents/` tree has one dir per unique `name`.

## Open questions

- Adopt the flatten-on-install rule now (keeps nesting a *safe* future option) or defer? Current lean: **defer** — do not implement the rule yet; flat needs no transform. The rule stays documented above for whenever nesting is actually wanted.
