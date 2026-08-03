# Local OpenCode

Maps this machine's generated OpenCode configuration to editable Nix and dotfile sources.

## Design

Keep local deployment facts, source paths, and verified local traps here. Keep changing OpenCode field catalogs in official docs and schema links. This prevents a pinned local package from turning old claims into rules.

## Use

Load for local OpenCode configuration, deployed artifact paths, permission resolution, or Nix-backed settings. Do not load for generic OpenCode questions with no local configuration angle.

## Maintainer constraints

- Never edit deployed files; edit mapped source.
- Nix-generated JSON needs user deployment. Repo artifacts are out-of-store symlinks.
- Check `opencode --version` before relying on defaults or implementation behavior.
- Re-check fields and values in schema, current docs, and provider docs before adding them.
- Keep snippets short and representative; do not copy generic documentation into runtime instructions.

## See also

- [OpenCode config docs](https://opencode.ai/docs/config/)
- [OpenCode agent docs](https://opencode.ai/docs/agents/)
- [OpenCode permission docs](https://opencode.ai/docs/permissions/)
- [OpenCode config schema](https://opencode.ai/config.json)
