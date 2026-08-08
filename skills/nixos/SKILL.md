---
name: nixos
description: "Ready-to-run commands for NixOS: missing CLI tool, prebuilt binary failing with missing shared library or dynamic linker, package/option lookup, non-activating rebuild validation. Load when a command fails for NixOS reasons, a config change needs validating, or work touches NixOS repo. Not a Nix tutorial and not the repo's own conventions; skip for generic Linux failures with no NixOS angle."
license: MIT
---

# NixOS

Symptom → command. No Nix theory. Unblock, do not mutate system state.

<nix-repo> defaults to `~/.nix` unless otherwise specified.

## Core rules

- Missing tool: run ephemerally. Never add to config for one-off use.
- Prefer an already-installed alternative first (`rg`/`grep`, `fd`/`find`, `jq`). Only fetch a package when it is the clean tool for the job.
- Binary fails on library/linker: assume non-FHS layout, not a missing distro package. Never hunt apt/dnf package names.
- Config change: validate by building. `switch`/`boot`/`test` only on explicit user request.
- Search option and package names; never guess them.
- Append `--show-trace` to any failing Nix eval/build.

## Friction playbook

**Tool not installed** — run it without installing:

```bash
nix shell nixpkgs#PKG -c CMD ARGS      # preferred
nix-shell -p PKG --run 'CMD ARGS'      # legacy fallback; quote whole command
```

Multiple tools: `nix shell nixpkgs#PKG1 nixpkgs#PKG2 -c CMD`.

**Binary fails: `error while loading shared libraries`, missing interpreter/dynamic linker, or `No such file or directory` on an ELF that exists** — give it a traditional FHS environment:

```bash
fhs -c "CMD ARGS"
```

`fhs` is a local wrapper. If absent (other machine):

```bash
nix run nixpkgs#steam-run -- CMD ARGS
```

Still failing on one specific library: add it to that module's `targetPkgs` only if the need is persistent.

**Need package or option name**:

```bash
nix search nixpkgs QUERY
```

- Packages: https://search.nixos.org/packages
- NixOS options: https://search.nixos.org/options
- Home Manager options: https://home-manager-options.extranix.com

**Eval error hard to read**:

```bash
nix repl
:lf <nix-repo>
```

Then inspect attributes directly. `nix why-depends .#TARGET /nix/store/PATH` for unexpected closure entries.

## Boundaries

- No activation: no `switch`, `boot`, `test`, `--install-bootloader` without explicit user request.
- No config edit to satisfy a one-off tool need.
- No `flake.lock` mutation outside a task whose stated goal is a version change.
- Generic Linux/app failure with no NixOS cause: drop this playbook, debug normally.

## Verification

- Command run was copied from a block above, with real package/command substituted.
- Config change validated by a rebuild that exited 0, when the user asked for validation.

## Growth

New recurring NixOS friction: append one `**symptom**` entry with the exact command. No prose expansion, no Nix explanation, no duplicate rule.
