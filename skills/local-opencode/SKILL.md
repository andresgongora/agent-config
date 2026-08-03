---
name: local-opencode
description: Locate, change, and verify this machine's OpenCode configuration, deployed agent artifacts, and Nix-backed settings. Use for local OpenCode paths, config fields, permissions, agents, commands, plugins, models, or deployment behavior. Not for generic OpenCode questions without this machine's configuration.
---

# Local OpenCode

## Source map

Never edit deployed paths. Edit source below; user deploys Nix changes.

| Need | Editable source | Deployed path | Apply / verify |
|---|---|---|---|
| Server/runtime config | `/home/andy/.nix/home/modules/tools/ai/opencode.nix` | `~/.config/opencode/opencode.json` | Nix deployment required; `opencode debug config` |
| TUI config | `/home/andy/.nix/home/modules/tools/ai/opencode.nix` | `~/.config/opencode/tui.json` | Nix deployment required |
| Agents | `agents/` in this repo | `~/.config/opencode/agents/` | Out-of-store symlink; `opencode agent list` |
| Skills, commands, plugins | matching repo directory | matching `~/.config/opencode/` directory | Out-of-store symlink; restart/reload client if needed |
| Cross-project rules | `deploy/AGENTS.md` | `~/.config/opencode/AGENTS.md` | Out-of-store symlink |

`readlink -f ~/.config/opencode/<path>` proves deployed target. Generated JSON and TUI files differ from out-of-store artifact symlinks.

## Workflow

1. Run `opencode --version`. Version gates schema, CLI, defaults, and implementation facts.
2. Select scope: runtime/TUI config, agent, skill/command/plugin, or project-local override.
3. Check current field and value before editing. Use references below; do not guess from this skill.
4. Edit source-map truth. Do not initiate deployment/rebuild.
5. Verify resolved state: `opencode debug config` for config; `opencode agent list` for agents and effective permissions.

Project overrides live in project `opencode.json` and `.opencode/{agents,commands,plugins}/`. Check them before blaming global config.

## Config fields

Current local runtime config is Nix that generates JSON. Field names match OpenCode JSON; Nix uses `=` and semicolons.

```nix
{
  "$schema" = "https://opencode.ai/config.json";
  model = "openai/gpt-5.4";       # provider/model-id
  default_agent = "chat";         # primary agent name
  subagent_depth = 2;              # 0 blocks; 1 default; 2 allows one child level
  permission.bash = {
    "*" = "ask";
    "git status *" = "allow";
  };
}
```

Use `tui.json` for UI fields, not `opencode.json`:

```nix
{
  "$schema" = "https://opencode.ai/tui.json";
  scroll_speed = 3;
  scroll_acceleration.enabled = true;
  keybinds.input_submit = "return";
}
```

Config field/value truth can change. Check, in order:

- installed version: `opencode --version`
- current schema: `https://opencode.ai/config.json` and `https://opencode.ai/tui.json`
- current config docs: `https://opencode.ai/docs/config/`
- provider/model-specific values: provider documentation and `opencode models`
- version-sensitive behavior: matching release-tag source under `https://github.com/anomalyco/opencode/tree/`

Schema covers recognized config fields. Agent provider options can pass through; never infer their names or values from schema alone.

## Agent fields

Agent Markdown lives in `agents/<name>.md`; filename is agent name. Small safe shape:

```yaml
---
description: Exact job and when to use it.
mode: subagent                 # primary | subagent | all
model: openai/gpt-5.4          # provider/model-id
permission:
  edit: deny                   # allow | ask | deny
  bash:
    "*": deny
    "git diff*": allow
---
```

Optional fields: `temperature` (finite number), `variant` (model-specific variant), `steps` (positive integer), `hidden` (boolean), `top_p` (number), plus provider-specific options. Confirm exact field/value against `https://opencode.ai/docs/agents/`, `https://opencode.ai/config.json`, and provider docs before use.

Leave `temperature` absent by default. OpenCode then chooses model-specific behavior. Set it only for deliberate, tested sampling policy; explicit agent value overrides that behavior where model supports temperature. Do not assume omitted means a universal `0`.

`tools` is deprecated. Legacy `tools.<tool>: true` grants broad `{"*": "allow"}` access. New or revised agents use `permission`.

## Permissions

Actions: `allow`, `ask`, `deny`. Pattern maps resolve last matching entry, so broad `"*"` first, specific exceptions after.

```yaml
permission:
  task:
    "*": deny
    "web-search-scout": allow
  bash:
    "*": ask
    "git diff*": allow
```

Agent permissions override global configuration. `ask` needs an approver; do not use it for required non-interactive subagent work. Use narrow `task` allowlists. `tools.task: true` is deprecated broad access, not a substitute for a narrow allowlist.

## Debug order

- Wrong field/value: version, schema, docs, provider docs.
- Wrong config source: `opencode debug config`; inspect project overrides.
- Wrong agent/permission: `opencode agent list`; read matching rules top-to-bottom, last match wins.
- Path ambiguity: `readlink -f ~/.config/opencode/<path>`.
- Unknown model id: `opencode models` lists available `provider/model-id` values.
- Undocumented runtime behavior: inspect matching-version source, especially `packages/opencode/src/permission/` and tool implementation. Stop if source and docs disagree; report version plus conflict.

## Canonical references

- `https://opencode.ai/docs/config/`
- `https://opencode.ai/docs/agents/`
- `https://opencode.ai/docs/permissions/`
- `https://opencode.ai/config.json`
- `https://opencode.ai/tui.json`
