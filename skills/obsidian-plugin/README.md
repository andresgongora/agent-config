# obsidian-plugin

Workflow for building, testing, and releasing Obsidian plugins.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

The skill records four Obsidian-specific constraints an agent otherwise rediscovers per session: the
`manifest.json`/`versions.json` version coupling, the forbidden dynamic-`<style>` lint rule,
desktop-only API flagging, and the absence of any standard vault path. It also fixes one repeatable
local-test loop (symlink into `<vault>/.obsidian/plugins/`) so files are not hand-copied each time.
See `SKILL.md` Workflow for the procedure.

Templates come from two working plugin repos, `obsidian-hierarchical-toc` and
`obsidian-colorful-note-background`: their `release.sh`, `manifest.json`, `version-bump.mjs`, and
lint/test setup are the reference implementation.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

Creating, editing, testing, or releasing an Obsidian plugin. Manifest.json work, `main.ts extends
Plugin`, BRAT beta distribution, community plugin submission/review requirements.

<!------------------------------------------------------------------------------------------------->
## When it does NOT trigger
<!------------------------------------------------------------------------------------------------->

Generic TypeScript/npm/esbuild work with no Obsidian API involved. Editing vault notes or vault
settings unrelated to plugin testing. Obsidian usage/note-taking questions.

<!------------------------------------------------------------------------------------------------->
## Maintainer constraints
<!------------------------------------------------------------------------------------------------->

- Keep `resources/community-plugin-submission.md` current with Obsidian's actual submission
  requirements if they change (checklist, PR process to `obsidianmd/obsidian-releases`). This file
  drifts fastest.
- Templates in `templates/` should stay generic scaffolds, not tied to any specific plugin's
  business logic.
- If Obsidian's plugin API or manifest schema changes (new required field, deprecated field), update
  `SKILL.md` Core rules, not just the resource file.
- `SKILL.md` Core rules are grouped as structure/manifest, lifecycle and load time, and review
  compliance. Add new rules to the matching group rather than a flat list, and keep each group's
  verification item in sync.

<!------------------------------------------------------------------------------------------------->
## See also
<!------------------------------------------------------------------------------------------------->

- `templates/manifest.json`, `templates/versions.json`, `templates/esbuild.config.mjs`,
  `templates/version-bump.mjs`, `templates/release.sh`: scaffold files.
- `resources/community-plugin-submission.md`: one-time community-store submission process.
- `resources/first-submission-checklist.md`: minimal step list for the initial submission only.
- `resources/lifecycle-and-load-time.md`: cleanup and startup-cost code examples.
- Cross-language coding-conventions behavior: general code quality still applies on top of these
  Obsidian-specific rules.
