# nixos

A lookup table of NixOS unblocking commands, plus a map of the flake repo at `~/.nix`.

## Design intent

Models already know Nix. What they lose time on is the gap between "this command failed" and
"on NixOS the fix is X" — reaching for apt, installing a tool into the system config to run it
once, or treating a non-FHS binary as a broken dependency. So the skill carries commands, not
explanation.

Everything is symptom-first: the agent arrives with a failure, finds it in the playbook, and
copies the line. That shape is also why the skill stays cheap to grow — a new pitfall is one
more entry, not a new section of theory.

The repo section is deliberately thin. `~/.nix/AGENTS.md` already owns placement, style, lint,
format and deploy rules, and it loads automatically when working there; repeating any of it here
would only create two sources that drift apart. What the skill contributes instead is
navigation — which file holds what, and the fact that `doc/` answers most structural questions
faster than a glob does.

Three facts here are specific to this setup and were verified rather than assumed: `fhs` is a
local wrapper from `nixos/modules/system/fhs.nix`, Home Manager runs as a NixOS module so one
rebuild validates both layers, and `steam-run` is not installed, hence the `nix run` form.

Earlier versions drifted into a mini Nix handbook — module templates, override glossary, a
trailing rule summary that repeated the body. All dead weight against the real goal, all
removed.

## When it triggers

A command fails for a NixOS reason (missing tool, missing shared library, missing interpreter),
a package or option name is needed, a config change needs validating, or work touches `~/.nix`.

## When it does NOT trigger

Generic Linux or application failures, language and build tooling errors, and NixOS questions
that are conceptual rather than blocking.

## Maintainer constraints

- Commands only. If an entry needs a paragraph of Nix explanation to be usable, it does not belong.
- Never copy a rule out of `~/.nix/AGENTS.md` or `~/.nix/doc/` into this skill. Point at them.
- One rule in one place. Resist adding a summary list at the bottom.
- Keep dangerous operations gated inline, next to the command, not in a distant caveat.
- Verify machine-specific claims (`fhs`, flake output names, installed helpers, repo layout) before writing them in.
- If it grows past a screen or two, push rare debugging material into `.agent/notes/` instead of fattening the skill.

## See also

- `SKILL.md`
- `../../AGENTS.md`
- `../../.agent/frontier.md`
