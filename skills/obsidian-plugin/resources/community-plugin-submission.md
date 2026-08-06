# Obsidian community plugin submission

One-time process, distinct from routine GitHub releases. Only relevant when a plugin is submitted to Obsidian's official community plugin store for the first time.

## Requirements before submitting

- `manifest.json` valid: unique `id` (lowercase, hyphenated, matches repo name convention), `name`, `version` (semver), `minAppVersion`, `description`, `author`, `authorUrl` (optional), `isDesktopOnly`.
- Repo has a GitHub release matching the manifest version, tag name = version (no `v` prefix), with `manifest.json`, `main.js`, and `styles.css` (if present) attached as release assets — not just source zip.
- `README.md` explains what the plugin does and how to use it.
- `LICENSE` file present.
- No bundled `node_modules`, no build artifacts committed to source (only shipped via release assets).
- Passes Obsidian's plugin review bot checks: no forbidden APIs, no eval, no remote code execution, no obfuscated code, styles scoped (no global CSS pollution), settings use `Setting` API not raw DOM where avoidable.
- Any network calls disclosed in README (what, why, to where).

## Submission process

1. Fork `obsidianmd/obsidian-releases`.
2. Add an entry to `community-plugins.json` (id, name, author, description, repo `owner/reponame`) — alphabetically sorted by id.
3. Open a PR against `obsidianmd/obsidian-releases`. A bot runs automated validation against the manifest and release assets.
4. Address reviewer feedback — Obsidian maintainers review manually; can take weeks. Common rejection reasons: forbidden dynamic style elements, missing `isDesktopOnly` correctness, sentence-case UI violations, unscoped/global CSS, unnecessary permissions or network calls.
5. Once merged, the plugin appears in Community Plugins browse/search after the next catalog sync.

## After acceptance

Every subsequent version: normal release flow (bump version, tag, GitHub release with manifest/main.js/styles.css assets). Obsidian's plugin catalog polls releases automatically — no repeat PR needed unless changing `id` or `author` (which should essentially never happen).

## BRAT (beta testing) as an alternative

For pre-release or private testing without going through community review: users install the [BRAT](https://github.com/TfTHacker/obsidian42-brat) plugin, then add the plugin repo URL directly. BRAT installs from the latest GitHub release (or a specific branch/commit) without requiring `obsidian-releases` inclusion. Useful for beta feedback loops before or alongside submission.
