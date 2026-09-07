---
name: local-opencode
description: Locate, change, and verify this machine's OpenCode. Load for local OpenCode paths, config fields, permissions, agents, commands, plugins, models, or deployment behavior. Skip for generic OpenCode questions not specific to this machine's configuration.
---

## Guardrails

- Never edit deployed paths (`~/.config/opencode/**`) — edit only the mapped source in Source map below.
- Never deploy or rebuild (Nix activation, config regeneration) without explicit user approval — affects the live agent runtime beyond this session.
- Never assert a config field, permission value, or model id from memory or this skill's illustrative snippets as current fact — verify against installed `opencode --version`, live schema, or docs first.
- Source and docs disagree on runtime behavior: stop, report version + conflict — do not guess a resolution.

## Source map

| Need | Editable source | Deployed path | Apply / verify |
|---|---|---|---|
| Server/runtime config | `~/.nix/home/modules/tools/ai/opencode.nix` | `~/.config/opencode/opencode.json` | Nix deployment required; `opencode debug config` |
| TUI config | `~/.nix/home/modules/tools/ai/opencode.nix` | `~/.config/opencode/tui.json` | Nix deployment required |
| Agents | `agents/` in this repo | `~/.config/opencode/agents/` | Out-of-store symlink; `opencode agent list` |
| Skills, commands, plugins | matching repo directory | matching `~/.config/opencode/` directory | Out-of-store symlink; restart/reload client if needed |
| Cross-project rules | `deploy/AGENTS.md` | `~/.config/opencode/AGENTS.md` | Out-of-store symlink |

`readlink -f ~/.config/opencode/<path>` proves deployed target. Generated JSON and TUI files differ from out-of-store artifact symlinks.

## Workflow

1. Run `opencode --version`. Version gates schema, CLI, defaults, and implementation facts.
2. Select scope: runtime/TUI config, agent, skill/command/plugin, or project-local override.
3. Check current field and value before editing. Use references below.
4. Edit source-map truth; see Guardrails for deploy/rebuild approval.
5. Verify resolved state: `opencode debug config` for config; `opencode agent list` for agents and effective permissions.

Project overrides live in project `opencode.json` and `.opencode/{agents,commands,plugins}/`. Check them before blaming global config.

## Config fields

### Runtime config (opencode.json)

Current local runtime config is Nix that generates JSON. Field names match OpenCode JSON; Nix uses `=` and semicolons. Shape example below; fields and values are illustrative, not a dump of the current file — read `opencode.nix` for actual values before claiming what is set.

```nix
{
  "$schema" = "https://opencode.ai/config.json";
  model = "openai/gpt-5.4";       # provider/model-id, illustrative only; may be unset locally
  default_agent = "chat";         # primary agent name
  subagent_depth = 2;              # per schema: default 1 blocks subagent-of-subagent; 0 blocks subagents entirely; 2 allows one child level (opencode.ai/config.json)
  permission.bash = {
    "*" = "ask";
    "git status *" = "allow";
  };
}
```

### TUI config (tui.json)

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

- installed version: `opencode --version`.
- current schema: `https://opencode.ai/config.json` and `https://opencode.ai/tui.json`.
- current config docs: `https://opencode.ai/docs/config/`.
- provider/model-specific values: provider documentation and `opencode models`.
- version-sensitive behavior: matching release-tag source under `https://github.com/anomalyco/opencode/tree/`.

Schema covers recognized config fields; agent provider options can pass through.

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

Optional fields: `temperature` (finite number), `variant` (model-specific variant), `steps` (positive integer), `hidden` (boolean), `top_p` (number), plus provider-specific options. See Canonical references for field docs; see Guardrails before assuming a value.

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

### Caring for bash permissions

Four facts decide whether a rule fires. Check them in this order before adding rules.

1. **One pattern per sub-command.** The bash tool parses the command into an AST and emits a pattern for every `command` node. `a && b`, pipelines, `if`/`for` bodies all contribute. If any one resolves to `ask`, the whole call prompts — the approval dialog then lists *every* sub-command, including already-allowed ones. Read the dialog as a haystack, not a list of blockers.
2. **Allowlist shell no-ops.** `exit`, `true`, `false`, `continue`, `break`, `:`, `test`, `[` are real AST command nodes. Unlisted, they drag otherwise-allowed pipelines and every skill script wrapped in error handling into a prompt.
3. **Order is real; agent wins.** Rules flatten to one ordered array resolved by `findLast`, merged `builtin defaults → global config → agent frontmatter`. So an agent `bash: deny` fully neutralises any global allow — safe to widen the global baseline for locked-down agents that declare their own deny. Nix `builtins.toJSON` sorts keys alphabetically, which happens to place `"*"` first; verify denies still resolve after any batch edit.
4. **Patterns expand `~`/`$HOME`; commands do not.** Match is `Wildcard.match`, where `*` compiles to `.*` and crosses `/`. One leading-`*` pattern therefore covers every absolute path form. Relative invocations (`skills/x/scripts/y`) match none of them and need their own rule.

Worked example applying all four: an agent runs `cd ~/.config/opencode/skills/foo && ~/.config/opencode/skills/foo/scripts/run.sh || exit 1` under a global baseline of `bash."*": ask` plus an allow for the absolute script path.

```yaml
permission:
  bash:
    "*": ask                      # global baseline; agent-frontmatter allows below win (fact 3)
    "cd *": allow
    "~/.config/opencode/skills/foo/scripts/run.sh": allow   # absolute only (fact 4); a relative "./scripts/run.sh" invocation would NOT match this rule
    "exit *": allow                # shell no-op, else it drags the whole && chain to ask (fact 2)
```

Without the `exit *` and `cd *` allows, the AST emits three command nodes (`cd`, `~/.config/opencode/skills/foo/scripts/run.sh`, `exit`) (fact 1); any one left on `ask` prompts for the entire line, listing all three nodes in the approval dialog even though `run.sh` itself is allowed.

Global baseline lives in `opencode.nix`; agent files should carry role deltas only. Duplicating a 40-entry read-only baseline across agent files is how gaps like the above go unnoticed.

## Debug order

- Wrong field/value: see Config fields checklist for check order.
- Wrong config source: `opencode debug config`; inspect project overrides.
- Wrong agent/permission: `opencode agent list`; read matching rules top-to-bottom, last match wins.
- Path ambiguity: `readlink -f ~/.config/opencode/<path>`.
- Unknown model id: `opencode models` lists available `provider/model-id` values.
- Undocumented runtime behavior: inspect matching-version source, especially `packages/opencode/src/permission/` and tool implementation. See Guardrails if source and docs disagree.

## Canonical references

- `https://opencode.ai/docs/config/`.
- `https://opencode.ai/docs/agents/`.
- `https://opencode.ai/docs/permissions/`.
- `https://opencode.ai/config.json`.
- `https://opencode.ai/tui.json`.
