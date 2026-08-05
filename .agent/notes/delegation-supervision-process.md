---
title: Delegation Supervision — Process Record
summary: End-to-end record of the delegation-supervision effort — problem, plan, decisions, repo-wide envelope retrofit, live CLI validation, and the reviewer false-positive fix it uncovered. Read before touching the envelope, a subagent's output contract, or `cavecrew-reviewer`.
status: active
updated: 2026-08-05
---

# Delegation Supervision — Process Record

Design rationale in compressed form lives in `skills/agent-delegate/README.md`; that stays the load-bearing skill doc. This note is the narrative + evidence trail behind it — what was tried, what broke, what proved it works. Frontier (`.agent/frontier.md`) will eventually roll this detail off; this note is the durable record.

## 1. Problem

Delegation existed (`agent-delegate`, `cavecrew`) but had no supervision layer: no standard task-brief shape, no way for a supervisor to judge a returned report except by trusting its prose, and no retry/escalation discipline. Risk: runoff on under-specified briefs, unjudgeable claims, infinite cheap retries or premature expensive takeover.

## 2. Research (closed, do not repeat)

No canonical OSS solution exists for this. Surveyed and rejected/partially adopted:

- Anthropic's multi-agent research system — worker brief = objective + output format + boundaries; lead decomposes/synthesizes. Adopted the brief shape.
- LangGraph fault-tolerance docs — bounded retry then route-on-exhaustion, exhaustion is a routing event not an error. Adopted the framing.
- CrewAI tasks — `description` + `expected_output` + capped-retry guardrail. Confirmed the pattern, added nothing new.
- ECC (`affaan-m/ECC`) `multi-execute.md` — explicit task-block contract, patch-only return, mandatory audit phase; but shell-choreographed and has no retry/escalation engine. Took the contract idea, rejected the implementation.

Verdict: greenfield integration. Build from these fragments, do not expect a drop-in.

## 3. Design (locked decisions)

- **No generic delegation-coordinator subagent.** A coordinator at main's tier pays the expensive model twice (main still holds context) and can't ask the user. Only justified case: ≥3-way fanout needing consolidation, at MID tier — the existing `web-search` + `web-search-scout` pattern already does this. Document the pattern, do not build a new agent.
- **Retry requires materially changed input.** Identical re-spawn reproduces the failure at full price; forbidden.
- **Escalation ladder, fixed order:** retry-changed (≤2) → tier up one model level → main thread. Reused the repo's existing two-attempt number rather than inventing a second constant.
- **Report envelope mandatory on every subagent**, added to each agent's bespoke contract, not replacing it.
- **Owner artifact:** `skills/agent-delegate/` — decision gate, brief, evaluation, escalation all in one file, in that order, no cross-file lookup needed mid-task.

Envelope schema settled after auditing every existing subagent's output contract and refusal tokens (10 agents, no orphaned tokens):

| Status | Meaning |
|---|---|
| `done` | full scope covered |
| `partial` | some in-scope work uncovered; `gap` says what |
| `blocked` | cannot proceed; needs input, confirmation, or scope |
| `refused` | outside this worker's scope or capability |
| `none` | ran fully, found nothing — distinct from `done`, must not be retried |

## 4. Build

- `skills/agent-delegate/SKILL.md` rewritten: decision gate → brief → envelope → evaluate → escalate → domain-coordinator note.
- `skills/agent-delegate/templates/task-brief.md` authored: six-field mandatory core (goal, why, scope in/out, return shape, done-when, escalate-when), everything else optional and marked delete-if-empty.
- Envelope retrofitted into all 10 `mode: subagent` files in `agents/`, mapping each agent's existing refusal/terminal tokens onto a status value instead of restating them.
- `skills/cavecrew/SKILL.md`, `skills/web-search/SKILL.md` reconciled to match.
- `skills/agent-author/SKILL.md` + `templates/subagent.md` updated so future subagents inherit the envelope rule without reading `agent-delegate`.
- `deploy/AGENTS.md` edited net-zero-line: ladder summary added, one stale line removed.
- Clean-context audit (`agent-evaluator`) run before calling it done. Found 7 issues, fixed 6 (unmapped terminal tokens, a `web-search` lead-hunt miscategorized as `none`, a `build-fast` "one line only" refusal contradicting the two-line envelope, cavecrew terminal tokens read as *alternatives* to the envelope instead of preceding it, README hard-naming a sibling skill, `agent-author` verification narrower than its own rule). One audit suggestion declined — see §6.

## 5. Live validation — the envelope was wrong on paper, caught by testing

Textual retrofit was never executed before this. It was tested against real subagents via the OpenCode CLI, and the first pass failed completely.

**CLI constraint discovered:** `opencode run --agent <subagent>` fails — subagents cannot be invoked directly. Must invoke a primary that spawns the worker:

```sh
opencode run --agent build "<instruction>. Paste the subagent's final report VERBATIM, do not summarise or reformat it."
```

**Probe matrix** (reusable, re-run after any envelope wording change):

| # | Instruction | Expects | Discriminates |
|---|---|---|---|
| 1 | spawn `cavecrew-investigator`, find definitions of `zzqxNonexistentHandler` (does not exist) | `status: none` | `none` vs `done` confusion |
| 2 | spawn `cavecrew-investigator`, find `safeWriteFlag` (`plugins/caveman/caveman-config.cjs:132`) | `status: done`, envelope **last** | envelope placement |
| 3 | spawn `cavecrew-investigator`, ask it to EDIT a file | `status: refused` | envelope on refusal path |
| 4 | spawn `cavecrew-reviewer` on a clean file | in-set token, envelope last | reviewer judgment, not envelope |

**Run 1: 0/4 pass.**
1. `No match.` then `status: done` — wrong token.
2. Envelope emitted *before* the report content — wrong placement.
3. No envelope at all on the refusal path.
4. `status: done` on a clean-file review, plus invented findings (separate defect, see §6).

**Root cause, two distinct mechanisms:**

- **Placement.** The envelope had been written as prose ("Always end with…") in 2 of 10 agents (`fast`, `cavecrew-investigator`) and inside the fenced output template in the other 8. Every placement/missing-envelope failure came from a prose agent; the in-fence agent placed it correctly from the start. **A field the agent must emit binds only when it sits inside the fenced template it copies. Prose above the fence does not bind.**
- **Semantics.** Every fenced example in every file — including the 8 correctly-placed ones — depicted a *successful* run. The only concrete instance of the field the model ever saw was `status: done`, so `none` collapsed to `done` even where placement was right. **A success-only example teaches `done` as the default**, regardless of an adjacent rule stating the mapping.

**Fix applied:**
- Moved the envelope into the fenced template for the 2 prose agents.
- Added a second fenced example to all 10 agents showing the empty-result/refusal path with a literal non-`done` token (`status: none` / `refused` / `blocked`).
- Codified both as mandatory in `skills/agent-author/SKILL.md` + `templates/subagent.md`, with matching verification checkboxes, so a future subagent can't reintroduce this.

**Run 2: 3/4 pass, probe 4 not a valid envelope test** (see §6). Probes 1–3 confirmed fixed: correct token, envelope last, present on the refusal path.

## 6. Reviewer false-positive — found by probe 4, fixed and closed

Probe 4 assumed a clean file yields `No issues.` / `status: none`. `cavecrew-reviewer`, reviewing `skills/agent-delegate/templates/task-brief.md` (a clean template), instead returned `2🔵 1❓` and `status: partial` with a populated `gap:` naming desired-but-absent content ("no validation example", "no template instance"). Given genuine findings, `partial` was the *correct* token — this was never an envelope defect, it was reviewer over-eagerness on non-code input, mis-classified as findings and then leaked into `gap:`.

**Root cause:** nothing required a finding to be a defect in content that is *present*. Missing-content wishes entered as 🔵/❓ severities. The 🔵-only-if-thorough gate existed but was buried in a severity table and easy to miss.

**Fix in `agents/cavecrew-reviewer.md`:**
- Finding = defect in present content. "Could also have X" is a feature request, not a finding.
- 🔵 nit off by default; on only when the request says thorough/exhaustive/nitpick.
- Non-code input (markdown, docs, templates) scoped to meaning-changing/self-contradicting/contract-breaking defects only.
- `gap:` redefined as unreviewed in-scope area, never desired improvements.

**Validation, both directions:**
- **False-positive closed.** Re-run on `task-brief.md`: `No issues.` + `status: none` + `gap: none`.
- **False-negative checked.** Planted two real bugs in a control file (`isExpired` using `<` instead of `<=`; connection pool not released on the error path, no try/finally) and re-reviewed. Both caught, correctly tagged (🔴 bug, 🟡 risk), `status: done`, `gap: none`. Suppression rules did not blunt real-defect detection.
- First control attempt (pre-redeploy) timed out twice at 240 s on both `/tmp` and repo-local paths; other reviewer probes in the same session completed normally, so treated as session-local, not systemic — did not force a third attempt. Re-run after the OpenCode config redeploy completed without incident; root cause of the original timeout was never identified and is not assumed to be permission-related without evidence.

## Gotchas / standing facts

- Token strings (`done`/`partial`/`blocked`/`refused`/`none`) are fixed and uniform. Field *formatting* deliberately varies by agent family — lowercase `status:` in caveman-style agents, bold `**Status:**` in the web-search family. That variance is intentional; grep on the token, not the formatting.
- The outer primary agent may append commentary after a verbatim subagent report in CLI output. That is the wrapper, not the worker violating its contract — check the quoted block.
- Adding a sixth status token means editing all 10 worker definitions plus both `agent-author` surfaces (`SKILL.md` + `templates/subagent.md`).
- Nothing automatically enforces the envelope on a *newly authored* subagent. Enforcement is the `agent-author` verification checklist plus a manual grep — there is no CI here, this repo ships prompts, not code.
- Declined one audit suggestion: removing the retry-ladder one-liner from `deploy/AGENTS.md` as "duplication owned by `agent-delegate`". Rejected because `deploy/AGENTS.md` loads every session and `agent-delegate` does not — a main thread needs the one-line summary before it ever hits the failure that would load the skill.
