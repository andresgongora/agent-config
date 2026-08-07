# First community submission — minimal checklist

Source: https://docs.obsidian.md/plugins/releasing/submit-plugin

Bare minimum to get the *initial* version accepted. Full requirements/rejection reasons: `resources/community-plugin-submission.md`.

- GitHub account + Obsidian account.
- Repo root has: `README.md` (purpose + usage, relative image links ok — rewritten on listing page), `LICENSE`, `manifest.json`.
- `manifest.json` `version` bumped to valid semver `x.y.z` (e.g. `1.0.0`) before tagging.
- GitHub release: tag name == `manifest.json` version exactly. Attach `main.js`, `manifest.json`, `styles.css` (if present) as binary assets — not source zip.
- Fork `obsidianmd/obsidian-releases`, add entry to `community-plugins.json`, open PR.
- After merge: only the initial submission needs a PR. Every later version = normal GitHub release; Obsidian polls it automatically.

Skip this whole file if the plugin already went through initial submission — route to `resources/community-plugin-submission.md` for ongoing rules and rejection causes instead.
