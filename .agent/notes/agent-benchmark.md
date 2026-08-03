---
title: agent-benchmark — Snapshot Regression Harness
summary: Hermetic snapshot/regression benchmarking for skills and agents. Runs a skill against fixed prompts in an isolated opencode environment, captures N raw responses, and writes a self-contained Markdown report. Manual judgment; no automated scoring.
status: active
updated: 2026-07-29
---

# agent-benchmark — Snapshot Regression Harness

Run a skill (or multi-skill combo) against immutable prompts under a controlled, isolated opencode invocation. Capture N raw responses into a self-contained report. Compare before/after a skill tweak manually.

## Committed artifacts

| Path | Purpose |
|---|---|
| `skills/agent-benchmark/SKILL.md` | Loaded workflow for the orchestrating agent |
| `skills/agent-benchmark/scripts/run.py` | Run script — assembles isolation env, runs opencode, writes report |
| `skills/agent-benchmark/README.md` | Human/maintainer notes |
| `agents/agent-benchmark.md` | Subagent definition (model-pinned, narrow bash permission) |

## Data layout (gitignored)

```
agent-benchmark/
  prompts/             # immutable prompt .md files (hash-enforced)
  reports/
    skills/<skill-or-sorted+combo>/
    agents/<agent-name>/
    system/agent-<agent>+skill-<sorted+combo>/
      YYYY.MM.DD_<configuration-hash12>_<provider>_<model>.md
```

All under `agent-benchmark/` is gitignored. The harness itself is committed.

## Isolation strategy

**Host throwaway HOME** — proven on this host (NixOS, opencode 1.18.3).

opencode scans two dirs:
- `~/.agents/skills/` — HOME-keyed; vanishes with throwaway HOME
- `~/.config/opencode/skills/` — XDG_CONFIG_HOME-keyed; replaced by throwaway

`scripts/run.py` sets `HOME` + `XDG_CONFIG_HOME` to a mktemp dir containing only the target skill(s) and a `permission.skill: {"*": "deny", "<target>": "allow"}` config. Auth copied per-run from real `~/.local/share/opencode/auth.json`.

Isolation assertion: every run parses `--print-logs` stderr. Any skill name not in the target allowlist = hard failure, no report written. Witness skill: `caveman` (present in real HOME, absent in benchmark runs).

Container (Docker available, Podman not installed) was evaluated but not needed — host strategy sufficient and simpler.

## Report format

Markdown with embedded JSON metadata block. Contents per report:
- JSON metadata (skill hashes, prompt hash, model, opencode version, isolation strategy, run count)
- Markdown metadata table
- Reproduction command
- Verbatim skill body (fenced)
- Verbatim prompt (fenced)
- N raw responses, each with timestamp plus available OpenCode token and cost metrics

Append rule: identical conditions (artifact hashes + prompt hash + model + report schema version + opencode version + isolation strategy) append to existing report. Any changed condition, including schema change, creates a sibling report and preserves prior snapshot.

Filename starts with UTC date for chronological review, then a configuration fingerprint. Fingerprint covers artifact content, prompt, model, temp, report schema version, OpenCode version, and isolation strategy; this prevents same-day overwrite when a controlled condition changes. Provider/model remain readable in filename. Per-response timestamp is report data too. OpenCode `step_finish` events currently provide input/output/cache token counts plus USD cost; harness records only those fields.

## Usage

```bash
# Single skill, 3 runs
uv run skills/agent-benchmark/scripts/run.py \
  --skill skills/<name>/SKILL.md \
  --prompt agent-benchmark/prompts/<prompt>.md \
  --model github-copilot/claude-haiku-4.5 \
  --n 3

# Multi-skill combo
uv run skills/agent-benchmark/scripts/run.py \
  --skills skills/foo/SKILL.md skills/bar/SKILL.md \
  --prompt agent-benchmark/prompts/<prompt>.md \
  --model github-copilot/claude-haiku-4.5
```

## Non-goals (v1)

- No automated scoring, grading, pass/fail
- No experiment index or dashboard
- No model comparison matrix (provision only — model is a recorded field)
- No true A/B variant comparison (provision only)

## Known limitations

- `opencode run` has no `--temp` flag; temperature is model-default only. `temp` field recorded as `null` unless user sets it (not possible via CLI v1.18.3).
- Reports from concurrent runs to the same file will conflict — run sequentially.
- `append_to` match includes `opencode_version` — upgrading opencode forces new report files (intended: version is a controlled variable).
