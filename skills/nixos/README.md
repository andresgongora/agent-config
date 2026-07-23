# nixos

NixOS / Home Manager pitfall guide for agents working on this machine.

## What it does

Teaches the agent fast responses to common NixOS-specific friction:
- one-off missing tools
- package / option lookup
- non-FHS binary failures
- rebuild validation
- flake / module basics

Goal: stop wasted reasoning on distro assumptions that do not hold on NixOS.

## Design intent

This skill exists because many agents burn time on wrong defaults:
- assume `apt`/`dnf` style fixes
- assume global shared libs
- assume "install tool permanently" when `nix shell` enough
- assume `switch` acceptable as test step

Skill should be short, operational, and biased toward safe unblocking.

Brutal truth: old version tried to be mini Nix handbook. Too broad. Wrong shape. Most of that detail was dead weight for the real goal.

## Trigger

Load when task hits NixOS / Home Manager / flakes / modules / package lookup / rebuild / missing command / missing shared library / FHS friction.

Do not load for generic Linux work with no NixOS angle.

## Maintainer rules

- Keep focus on fast NixOS-specific unblocking.
- Prefer commands agent can use immediately.
- Keep dangerous ops explicit: no `switch` without user ask.
- Prefer `nix shell` for one-off tooling. Mention `nix-shell` only as fallback.
- Keep `fhs` note. It is machine-specific but high-value here.
- Do not bloat with advanced Nix lore unless it prevents common agent failure.
- If this grows again, split rare/debug-heavy material to docs instead of fattening skill.

## See also

- `SKILL.md`
- `../../AGENTS.md`
- `../../.agent/frontier.md`
