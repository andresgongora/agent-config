---
name: nixos
description: >
  NixOS / Home Manager workflow and pitfall guide. Load for NixOS config work,
  Home Manager work, package/option lookup, flakes/modules, rebuild/debug, or
  when CLI work hits NixOS-specific friction like missing commands, missing
  shared libraries, non-FHS binaries, one-off tool use, or Nix traces. Skip
  for generic Linux/app problems with no NixOS angle.
---

# NixOS

Fast NixOS-friction guide. Not full Nix handbook.

## Core playbook

### 1. Need one-off tool

Prefer ephemeral shell; do not mutate config.

```bash
nix shell nixpkgs#PKG -c CMD
```

Legacy fallback:

```bash
nix-shell -p PKG --run CMD
```

One-off missing CLI (`rg`, `fd`, `jq`, `node`, etc.): use this.

### 2. Need package / option lookup

```bash
nix search nixpkgs QUERY
nix-locate --whole-name --top-level bin/CMD   # if nix-index available
```

Web refs:
- Packages: https://search.nixos.org/packages
- NixOS options: https://search.nixos.org/options
- Home Manager options: https://home-manager-options.extranix.com

### 3. Prebuilt binary fails on NixOS

Symptoms:
- `error while loading shared libraries`
- `No such file or directory` for existing ELF binary
- missing dynamic linker / interpreter

First try:

```bash
fhs -c "CMD"
```

Fallback:

```bash
steam-run CMD
```

Never hunt random Ubuntu package names. NixOS often has FHS/runtime-env friction, not apt-style missing lib.

### 4. Nix config changed

Validate before apply.

```bash
sudo nixos-rebuild dry-run --flake .#$(hostname) --show-trace
```

If only build needed:

```bash
sudo nixos-rebuild build --flake .#$(hostname) --show-trace
```

Never run `switch`/`boot` without explicit request.

## Flakes / modules

Useful:

```bash
nix flake show
nix flake metadata
nix flake update INPUT
```

Module pattern:

```nix
{ config, lib, pkgs, ... }:
{
  options.myMod.enable = lib.mkEnableOption "feature";
  config = lib.mkIf config.myMod.enable { };
}
```

Override reminders:
- `mkDefault` = weak default
- plain assignment = normal
- `mkForce` = hard override

## Common traps

- Never assume FHS-like global shared libs.
- Never install one-off tool through config unless persistence wanted.
- Never run `nixos-rebuild switch` to "test".
- Never update `flake.lock` unless version change needed.
- Search cheap option names; never guess.

## Fast debug

```bash
nix repl
:lf .
```

```bash
nix why-depends .#TARGET /nix/store/PATH
```

Use `--show-trace` on failing eval/build commands.

## Agent rules

1. Search before guess.
2. Prefer ephemeral env (`nix shell`) for one-off tools.
3. Prefer `fhs`/`steam-run` quickly when binary looks non-FHS.
4. Dry-run before apply.
5. No `switch` without explicit user request.
6. If using unstable packages, say why.
7. Never touch secrets or secret material.
