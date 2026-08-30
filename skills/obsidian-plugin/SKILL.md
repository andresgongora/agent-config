---
name: obsidian-plugin
description: "Create, edit, test, and release Obsidian plugins. Load on work related to Obsidian Plugins."
---

## Core rules

### Structure and manifest

- Plugin needs `manifest.json` (`id`, `name`, `version`, `minAppVersion`, `description`, `author`, `isDesktopOnly`), `src/main.ts` exporting a class extending `Plugin`, `versions.json` (version → minAppVersion map), and `styles.css` when styling is needed.
- Obsidian loads `manifest.json`, built `main.js`, and optional `styles.css` from one directory. Never hand-edit `main.js` or treat it as source.
- `manifest.json` `id` is permanent once submitted to the community store. Confirm the id with the user before scaffolding a new plugin.
- Node built-ins, `require('fs')`, or Electron APIs require `isDesktopOnly: true`. Skipping the flag breaks mobile users and fails review.
- Vault location varies per user and OS. Resolve it per Workflow step 1 only for local-install or vault-test tasks; never assume a path.
- These rules are defaults; if one clearly hurts the plugin at hand, say so and ask for an override. The Boundaries section is not overridable.

### Lifecycle and load time

- Register through the `Component` API: `registerEvent`, `registerDomEvent`, `registerInterval`, and `register()` for arbitrary cleanup. Raw `addEventListener`/`setInterval`/`setTimeout` without matching removal in `onunload` leaks a ghost listener past plugin disable.
- Keep `onload` to registrations only (commands, views, processors, event refs). Move heavy compute, data fetch, or vault scans into `this.app.workspace.onLayoutReady(() => {...})`.
- `vault.on('create')` fires once per existing file during vault init. Register it inside `onLayoutReady`, or guard the callback with `if (!this.app.workspace.layoutReady) return;`.
- Custom `View` constructors run for every view Obsidian restores on launch; expensive constructor work directly delays app start.
- Ship a minified production build as the released `main.js`.
- Code examples for this section: `resources/lifecycle-and-load-time.md`.

### Review compliance

- No dynamic `<style>` element injection — banned by `obsidianmd/no-forbidden-elements`. Use a class toggle plus a CSS custom property, with base rules in `styles.css`.
- UI strings use sentence case (`obsidianmd/ui/sentence-case`). Build settings headings with `Setting(...).setHeading()`, never manual `<h1>`-`<h4>`.
- No network calls or telemetry unless the plugin's stated purpose requires it. Disclose any network use in a README Privacy section; undisclosed access is rejected in review.

## Workflow

1. **Resolve vault path (local install or vault testing only; skip otherwise).** Check durable repo notes or project agent rules for a recorded vault path first. Not found: ask the user for the absolute vault path (interactive picker if the client offers one, plain prose otherwise). Persist the confirmed answer through the durable-knowledge writing behavior so later sessions skip the question.
2. **Scaffold a new plugin.** Copy `templates/manifest.json`, `templates/versions.json`, `templates/esbuild.config.mjs`, `templates/version-bump.mjs`, and `templates/release.sh` into the plugin root. Replace every bracketed placeholder (`<plugin-id>`, `<Plugin Display Name>`, description, author, `<minAppVersion>`) in both `manifest.json` and `versions.json`. Add `src/main.ts` (class extends `Plugin` with `onload`/`onunload`), `styles.css` if needed, a `CHANGELOG.md` (required by the release script), `README.md`, `LICENSE`, and a `.gitignore` covering `main.js`, `main.js.map`, and `node_modules`. Initialize `package.json` and install dev dependencies: `typescript`, `esbuild`, `obsidian`, `@types/node`, `eslint`, `eslint-plugin-obsidianmd`. Wire `package.json` scripts: `dev` (esbuild watch), `build` (`tsc -noEmit` + esbuild production), `lint` (eslint with `eslint-plugin-obsidianmd` recommended config), `test` (only if tests are requested), `version` (runs `version-bump.mjs` and stages `manifest.json` + `versions.json`).
3. **Install locally for testing.** Target `<vault>/.obsidian/plugins/<manifest-id>/`, creating `.obsidian/plugins/` if absent. Prefer a symlink to the plugin repo root over copying, so rebuild-then-reload stays fast and no stale copy survives. Link a `dist/`-style directory only when it is self-contained (`manifest.json`, `main.js`, `styles.css` all inside it). Build once, then reload Obsidian.
4. **Verify before release.** Run lint, run tests if present, run the production build, confirm `CHANGELOG.md` is current, and confirm the working tree is clean. Do not bump the version here.
5. **Release.** Only after explicit user approval, run the plugin root's copy of `release.sh` (never the skill template path, which resolves `manifest.json` and `CHANGELOG.md` next to itself): it bumps the patch version via `npm version` (which triggers `version-bump.mjs` to update `manifest.json` and `versions.json` together), pushes branch and tags, and creates a GitHub release attaching `manifest.json`, `main.js`, and `styles.css` if present, with body from `CHANGELOG.md`.
6. **First community submission only.** Follow `resources/first-submission-checklist.md` for the minimal steps and `resources/community-plugin-submission.md` for full requirements and rejection reasons. This is a one-time PR to Obsidian's releases repo, separate from routine version releases.

## Boundaries

- Never commit `main.js`, `main.js.map`, or other build artifacts. Gitignore them; they ship as release assets only.
- Never invent or silently pick a vault path when it is ambiguous — ask, then stop until answered.
- Never run the release script without explicit user approval in the current session.
- Do not edit vault note content or vault configuration unrelated to plugin testing.

## Verification

- [ ] `manifest.json` has `id`, `name`, `version`, `minAppVersion`, `description`, `author`, `isDesktopOnly`, all present, correct, and with no bracketed placeholders left.
- [ ] `isDesktopOnly: true` whenever Node, `fs`, or Electron APIs are used.
- [ ] `versions.json` has an entry for the current version.
- [ ] Production build produces `main.js` with no TypeScript errors.
- [ ] Lint passes, including forbidden-elements and sentence-case rules.
- [ ] Every listener, interval, and timer goes through a `register*` call or is removed in `onunload`.
- [ ] Local vault symlink resolves and Obsidian loads the plugin without console errors.
- [ ] Build artifacts are absent from git-tracked files.
- [ ] Before the release script runs: clean working tree, lint and tests green, user approval given.
