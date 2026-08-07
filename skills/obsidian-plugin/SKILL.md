---
name: obsidian-plugin
description: Covers creating, editing, testing, and releasing Obsidian plugins — TypeScript plugin class, manifest.json/versions.json, esbuild pipeline, local vault install for manual testing, community-plugin submission requirements, GitHub release flow. Triggers on "obsidian plugin", manifest.json, main.ts extending Plugin, BRAT beta testing, community plugin review. Not for generic TypeScript/npm work with no Obsidian API involved, not for Obsidian note-taking/vault content itself.
---

# obsidian-plugin

## Core rules

- Plugin root needs: `manifest.json` (id, name, version, minAppVersion, description, author, isDesktopOnly), `main.ts` entry exporting a class extending `Plugin`, `versions.json` (version → minAppVersion map), `styles.css` if plugin injects styling. Built `main.js` is the only file Obsidian loads at runtime — never hand-edit it, never treat it as source of truth.
- `manifest.json` `id` is permanent once submitted to community plugins — must match repo-registered id forever. Confirm before scaffolding a new plugin id.
- No dynamic `<style>` element injection — banned by `obsidianmd/no-forbidden-elements` lint rule. Use a class toggle + CSS custom property, base rules in `styles.css`.
- UI strings sentence case (`obsidianmd/ui/sentence-case`). Settings headings via `Setting(...).setHeading()`, never manual `<h1>`-`<h4>`.
- No network calls / telemetry unless plugin's stated purpose requires it — community review rejects undisclosed network access. Document any network use in README under a Privacy section.
- Desktop-only APIs (`require('fs')`, Node built-ins, Electron) require `isDesktopOnly: true` in manifest. Omitting this while using Node APIs breaks mobile users and fails review.
- Vault location varies per user/OS — never assume a path. Resolve per Workflow step 1 before any local-install action.
- Never wire raw `addEventListener`/`setInterval`/`setTimeout`/DOM-create by hand in a `Plugin`/`Component` — use `registerEvent`, `registerDomEvent`, `registerInterval` (and matching `register()` for arbitrary cleanup fns). Manual add without matching manual remove in `onunload` = leak, ghost listener survives plugin disable.
- `onload` stays lean — only registrations (commands, views, processors, event refs). No heavy compute, no data fetch, no vault scan inline. Heavy/startup work → wrap in `this.app.workspace.onLayoutReady(() => {...})`.
- `vault.on('create')` fires once per existing file during vault init — register inside `onLayoutReady`, or guard callback body with `if (!this.app.workspace.layoutReady) return;`. Skip guard = plugin reacts to every pre-existing file as if newly created.
- Ship minified production build only (`main.js` release artifact) — dev/unminified build slows disk read and app startup measurably.
- Custom `View` constructors run for every view Obsidian restores on launch — keep them cheap; expensive constructor work directly delays app load.
- Code examples for the above two rules: `resources/lifecycle-and-load-time.md`.

## Workflow

1. **Resolve vault path.** Check `.agent/notes/` or project `AGENTS.md` for a recorded vault path first (cheap, no interruption). Not found → ask the user directly for their vault's absolute path (use an interactive picker if the current client offers one; otherwise ask in plain prose). Persist the confirmed answer via the doc-writing behavior, so future sessions skip the question.
2. **New plugin scaffold.** Copy `templates/manifest.json`, `templates/versions.json`, `templates/esbuild.config.mjs`, `templates/version-bump.mjs`, `templates/release.sh` into the plugin root; fill bracketed placeholders (`<plugin-id>`, `<Plugin Display Name>`, description, author, `<minAppVersion>`) with real values in both `manifest.json` and `versions.json`. Add `src/main.ts` (class extends `Plugin`, `onload`/`onunload`), `styles.css` if needed. Wire `package.json` scripts: `dev` (esbuild watch), `build` (`tsc -noEmit` + esbuild production), `lint` (eslint with `eslint-plugin-obsidianmd` recommended config), `test` (jest, if tests requested), `version` (runs `version-bump.mjs`, stages `manifest.json`+`versions.json`) — do not run `npm version` manually here; `release.sh` owns the bump.
3. **Local test install.** Under resolved vault path: `<vault>/.obsidian/plugins/<manifest-id>/`. Prefer a symlink from that dir to the plugin repo root over copying — keeps rebuild-then-reload iteration fast, avoids stale copies. Only link to a `dist/`-style output dir if that dir is self-contained (holds its own `manifest.json`, `main.js`, `styles.css` — Obsidian reads all three from the linked dir, not from the repo root). Create the `.obsidian/plugins/` dir if absent. After linking: build once, then reload Obsidian or use the "Reload app without saving" command / a hot-reload plugin during dev.
4. **Verify before release.** Run lint, run tests if present, run production build. Confirm `CHANGELOG.md` is current and working tree is clean. Do not bump version here — `release.sh` owns that step.
5. **Release.** Run `release.sh`: bumps patch version via `npm version` (triggers `version-bump.mjs`, updating `manifest.json`+`versions.json` together), pushes branch+tags, creates a GitHub release attaching `manifest.json`, `main.js`, `styles.css` if present, body from `CHANGELOG.md`. For first-ever community-plugin submission, see `resources/first-submission-checklist.md` (bare minimum steps) and `resources/community-plugin-submission.md` (full requirements + rejection reasons) — separate PR-to-obsidian-releases-repo flow, one-time process, distinct from routine version releases.

## Boundaries

- Never commit `main.js`, `main.js.map`, or other build artifacts — gitignore them; they ship via GitHub releases only, not source control.
- Never invent a vault path or silently pick one when ambiguous — ask.
- Not for editing vault note content or vault configuration unrelated to plugin testing.
- Not for generic npm/TypeScript work absent the Obsidian API — route to general coding conventions instead.
- Community plugin store submission is a distinct, higher-friction one-time review process (see resource file) — do not conflate with routine GitHub releases.

## Verification

- [ ] `manifest.json` validates: `id`, `name`, `version`, `minAppVersion`, `description`, `author`, `isDesktopOnly` all present and correct
- [ ] `versions.json` has an entry for current version
- [ ] Build produces `main.js` with no TypeScript errors
- [ ] Lint passes (`eslint-plugin-obsidianmd` recommended rules, especially forbidden-elements and sentence-case)
- [ ] Local vault symlink resolves and Obsidian loads the plugin without console errors
- [ ] `main.js`/build artifacts absent from git tracked files
- [ ] Release script preconditions met before running: clean working tree, lint and tests green (version bump happens inside the script, not before)
