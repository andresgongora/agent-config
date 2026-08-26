---
name: nixos
description: "Ready-to-run commands for NixOS: missing CLI tool, prebuilt binary failing with missing shared library or dynamic linker, package/option lookup, non-activating rebuild validation. Load when a command fails for NixOS reasons, a config change needs validating, work touches a NixOS/Nix flake repo (flake.nix, nixos/ dir present), or the environment is known to be NixOS (e.g. /etc/os-release ID=nixos)."
---

Symptom → command. No Nix theory. Unblock, do not mutate system state.

<nix-repo> defaults to `~/.nix` unless otherwise specified.

## Core rules

- Missing tool: run ephemerally (see Boundaries for the no-config-edit rule).
- Prefer an already-installed alternative first (`rg`/`grep`, `fd`/`find`, `jq`). Only fetch a package when it is the clean tool for the job.
- Binary fails on library/linker: assume non-FHS layout, not a missing distro package. Never hunt apt/dnf package names.
- Config change: validate by building. `switch`/`boot`/`test` only on explicit user request.
- Search option and package names; never guess them.
- Append `--show-trace` to any failing Nix eval/build.
- Dry-run (`--dry-run`) is costly (time, disk); never run speculatively or "just to check." Run it only when no other way verifies correctness (e.g. distinguishing between candidate fixes). Otherwise propose it as a next step and let the user decide.

## Troubleshooting

### Tool missing or not installed

Run without installing:

- Preferred solution: `nix shell nixpkgs#PKG -c CMD ARGS`
- Legacy fallback: `nix-shell -p PKG --run 'CMD ARGS'` (quote whole command).
- Multiple tools: `nix shell nixpkgs#PKG1 nixpkgs#PKG2 -c CMD`.

### Binary fails

Load FHS environment if: `error while loading shared libraries`, missing interpreter/dynamic linker, or `No such file or directory` on an ELF that exists.

- Preferred solution: `fhs -c "CMD ARGS"`
- Fallback if `fhs` fails: `nix run nixpkgs#steam-run -- CMD ARGS`.
- Still failing on one specific library: add it to that module's `targetPkgs` only if the need is persistent.

### Need package or option name

- Run: `nix search nixpkgs QUERY`.
- Sources:
  - Packages: https://search.nixos.org/packages
  - NixOS options: https://search.nixos.org/options
  - Home Manager options: https://home-manager-options.extranix.com

### Eval error hard to read

1. Run: `nix repl && :lf <nix-repo>`.
2. Then inspect attributes directly.

### Don't know HOST name

- Run: `nix flake show --json 2>/dev/null | jq -r '.nixosConfigurations | keys[]'`.
- Alternative: list `<nix-repo>/nixos/hosts/*.nix`, then inspect `config.system.hostName` attribute in each file.

### Deployment wants unexpected local builds

1. List exact derivations before activation.
2. Run: `nix build .#nixosConfigurations.HOST.config.system.build.toplevel --dry-run --print-build-logs`

### Trace one listed derivation to its owner

- Run:
  ```bash
  TOP_DRV=$(nix eval --raw .#nixosConfigurations.HOST.config.system.build.toplevel.drvPath)
  nix why-depends "$TOP_DRV" /nix/store/HASH-PACKAGE.drv
  ```
- Never type a `.drv` hash from memory or guesswork.
- Separately evaluated package attributes may differ after overrides.

### AppImages

AppImage won't run, complains about FUSE, or fails inside `fhs` with a library missing from its baseline set:

- Extract instead of running the AppImage directly — avoids the FUSE dependency NixOS doesn't provide by default: `fhs -c "'/path/to.appimage' --appimage-extract"`, then run the extracted `AppRun` inside `fhs`.
- Missing library not in `fhs`'s baseline `targetPkgs`: get its store path with `nix eval --raw nixpkgs#PKG.outPath` and prepend `<path>/lib` to `LD_LIBRARY_PATH` when launching `AppRun` inside `fhs`.
- Bundled script does both steps and caches the extraction: `scripts/run-appimage.sh <path-to-appimage> [nixpkgs#lib-attr ...]`.

## Boundaries

- No activation: no `switch`, `boot`, `test`, `--install-bootloader` without explicit user request.
- No config edit to satisfy a one-off tool need.
- No `flake.lock` mutation outside a task whose stated goal is a version change.
- Generic Linux/app failure with no NixOS cause: drop this playbook, debug normally.
- Unpredicted behavior: stop, tell user. Do not silently keep retrying.

## Verification

- [ ] Command run matches an instruction above verbatim, with only placeholders (`PKG`, `CMD`, `HOST`) substituted with real, sourced values.
- [ ] Any `.drv` or store path used was copied from actual command output, never typed from memory.
- [ ] Config change: validated by a rebuild that exited 0, when the user asked for validation.
- [ ] No `--dry-run` executed unless required by the task's own correctness check or explicitly requested; otherwise propose as a next step instead.
- [ ] No `switch`/`boot`/`test`/`--install-bootloader` ran without explicit user request.
