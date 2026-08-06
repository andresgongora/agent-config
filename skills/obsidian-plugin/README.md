# obsidian-plugin

Workflow for building, testing, and releasing Obsidian plugins.

## Design intent

Obsidian plugin dev has a few sharp edges an agent shouldn't rediscover each time: the manifest/versions.json coupling, the forbidden dynamic-`<style>` lint rule, desktop-only API flagging, and — the one that actually costs time — vaults live at an arbitrary user-chosen path with no standard location. This skill front-loads that knowledge and defines a repeatable local-test loop instead of the agent guessing or copying files by hand each session; see `SKILL.md` Workflow for the exact procedure.

Templates and requirements were distilled from two real plugin repos (`obsidian-hierarchical-toc`, `obsidian-colorful-note-background`) — their `release.sh`, `manifest.json`, `version-bump.mjs`, and lint/test setup are the working reference this skill's templates are based on.

## When it triggers

Creating, editing, testing, or releasing an Obsidian plugin. Manifest.json work, `main.ts extends Plugin`, BRAT beta distribution, community plugin submission/review requirements.

## When it does NOT trigger

Generic TypeScript/npm/esbuild work with no Obsidian API involved. Editing vault notes or vault settings unrelated to plugin testing. Obsidian usage/note-taking questions.

## Maintainer constraints

- Keep `resources/community-plugin-submission.md` current with Obsidian's actual submission requirements if they change (checklist, PR process to `obsidianmd/obsidian-releases`) — this is the piece most likely to drift.
- Templates in `templates/` should stay generic scaffolds, not tied to any specific plugin's business logic.
- If Obsidian's plugin API or manifest schema changes (new required field, deprecated field), update `SKILL.md` Core rules, not just the resource file.

## See also

- `templates/manifest.json`, `templates/versions.json`, `templates/esbuild.config.mjs`, `templates/version-bump.mjs`, `templates/release.sh` — scaffold files
- `resources/community-plugin-submission.md` — one-time community-store submission process
- coding conventions skill (cross-language) — general code quality still applies on top of this skill's Obsidian-specific rules
