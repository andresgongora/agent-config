---
title: agent-benchmark Evaluation Layer
summary: >-
  Durable LLM-judge evaluation design: frozen-report rubric, mechanical/judgmental routing, evidence verdicts, interaction checks, and derived A/B assessment. Reports remain immutable; evaluation never gates.
status: active
updated: 2026-08-04
---

# agent-benchmark Evaluation Layer

## Goal

Make benchmark reports evaluable, repeatable, semi-automated. Answer two questions:
1. **Isolated** (first eval of skill): did skill produce what skill promises? Over N runs. Negative (rules violated?) + positive (point made? well presented?).
2. **A/B** (skill changed): does new report move output in skill's desired direction vs old?

Output = **measurement instrument, not pass/fail gate**. Unit of truth = aggregate over N runs. Cross-run variance = signal.

## Requirement rewrite

User asked "how evaluate output". Reframe (accepted): no 1-10 score on one run. Distribution measurement over N. LLM-judge bias fought two ways: **decomposition** (bounded binary question, little bias room) + **named techniques** for biases decomposition can't touch (see Locked decisions).

Rejected (keep out):
- **Golden-file / similarity for prose** — infinite valid surface forms; similarity ≠ quality; goldens rot per edit. Tight-shape skills (`caveman-commit`) maybe later; deferred.
- **Enforced judge≠generator** — per-rule judges already differ (cheap small models). Interaction/compound tier: small strong-model pool, judge may equal generator; enforcing difference deferred, self-preference recorded instead.

## Constraints

### Hard

- **Reports immutable.** Eval reads frozen responses; never mutates report. (Inherited from `agent-benchmark`.)
- **Harness isolation untouched.** Eval is downstream consumer; no change to `run.py` isolation.
- **Eval artifacts under `agent-benchmark/evaluation/`, mirror `reports/` 1:1**: `skills/<slug>/`, `agents/<name>/`, `system/agent-<a>+skill-<combo>/`; filename keyed to source report. Gitignored, local-only.
- **Report N≥1.** Aggregate when N>1; still produce result at N=1, flagged lower-trust.
- **Harness files committed; data not.** Committed: eval skill, eval script, judge subagent(s). Gitignored: all under `evaluation/`.
- **Repo authoring rules apply.** New skill = `SKILL.md`+`README.md`. New subagent = pinned `model`+`temperature`, narrow tools, `description`. Caveman style agent-facing. Decouple by behavior/trigger; `deploy/AGENTS.md` sole naming glue. Reject-first.

### Soft

- **Script does mechanics** (parse report, split `## Response N` blocks, assemble artifact skeleton, roll verdicts into rates). LLM does judgment only. Mirrors harness: `run.py` mechanics, model does task.
- **Two judge tiers.** Per-rule judgmental items: cheap/fast small model (side-benefit: ≠ generator, self-preference negligible). Interaction pass + compound assessment: stronger model; small pool, judge==generator tolerated + recorded.
- **Rubric auto-derived from skill body** in report. No central registry, no per-skill hand file. Each item cites skill line it came from; uncited dropped. Criteria track skill, cannot rot.

## Non-goals

- No pass/fail gate, CI blocker, blocking threshold.
- No fix proposals / advice / rewrites from judge — evidence only.
- No golden-file / embedding-similarity for prose.
- No change to `run.py` isolation or report format (reading OK; new format field = flagged sub-decision, not assumed).
- No model-comparison matrix, no eval-of-eval meta-benchmark.
- No committing eval data.

## Locked decisions

Invariants. Every phase stays consistent.

- **L1** Eval = derived downstream artifact from frozen responses; never mutates report.
- **L2** Eval artifacts mirror `reports/` 1:1 under `agent-benchmark/evaluation/`, keyed to source report.
- **L3** Unit of truth = aggregate over N responses. N=1 allowed, marked lower-trust.
- **L4** Eval = **rubric of items**, each derived from skill's own promises. Each item **routed** `mechanical` (deterministic script/regex, zero-variance) or `judgmental` (focused judge subagent). "Desired direction" defined by skill under test.
- **L5** Judgmental items decomposed into isolated per-item sub-questions, fanned out to focused judges. Min scopes: **negative** (rules violated?) + **positive** (point made? well presented?). One judge, one bounded question.
- **L6** **Interaction pass** runs downstream of per-item checks. ONLY judge allowed to read full response. One question: given per-item verdicts, is there **emergent failure** (all items pass, output still fails) or **inter-rule contradiction** isolated checks missed? Must cite colliding items/rules. Surfaces interaction only; never re-scores items.
- **L7** **Contradiction, two granularities**: *skill-internal* (two rules of one skill fight) surfaced in the artifact as a property of that skill's eval; *skill-composition* (skill A vs B) surfaced only in multi-skill combo-report artifacts. **Cadence**: skill-internal recomputed every eval, deduped within that artifact (no cross-file cache). Accepts repeat strong-model tokens + cross-artifact duplication for simpler code.
- **L8** Verdicts **binary + evidence-quoted**, never holistic numeric score. A/B **pairwise**, never absolute-score delta.
- **L9** **De-bias committed, not optional**:
  - (a) **forced-negative-evidence-first** — judgmental item must quote strongest reason it FAILS before verdict.
  - (b) **self-consistency, adaptive + append-based** — default K=1 first sense. Re-run eval **appends** to prior result (never replaces). New verdict differs from prior in the binary value → trigger **3rd** tie-break run. Majority wins; split (e.g. 2/3) reported as confidence, never hidden.
  - (c) **swap-and-rerun** for A/B — judge A-then-B and B-then-A. Flip on swap = tie/low-confidence, not winner.
- **L10** **Self-preference tier-dependent.** Per-rule judges: cheap small model ≠ generator, negligible. Interaction/compound: strong model, small pool, judge may equal generator → record both `judge_model`+`generator_model` in verdict record (S3) for audit; artifact displays primary judge model. Enforced judge≠generator deferred.
- **L11** **Judge never proposes fixes.** Finding schema = `item` + `verdict` + `evidence_quote` + `location` + `skill_line_citation`. No recommendation field; nowhere to put "should"/rewrite. Surface enough for human fix; do not fix.
- **L12** Script does parse/split/assemble/**numeric roll-up**. LLM judgment only. **Compound assessment** = distinct LLM step reading ONLY per-item verdicts + aggregate rates + interaction findings. Composes overall read; never re-judges items; never reads raw responses.
- **L13** Output = **measurement**, never gate.

## Staged growth architecture

Brutal honest: full design above is the *target*, not the first commit. Build minimal spine, prove it, grow. Each phase ships working + testable. Later phases bolt onto stable seams; do not front-load complexity.

**Seams that make growth cheap (build these right in Phase 1, even while feature set is minimal):**
- **S1 Report reader** — one module: report path → structured object (`meta`, `skill_bodies`, `prompt`, `responses[]`). All phases consume this. Isolate format coupling here.
- **S2 Rubric object** — list of items, each `{id, source_skill, skill_line, text, routing: mechanical|judgmental, scope}`. **Shape locked Phase 1**; Phase 2+ populates the `routing` tag but never changes the shape. Phase 1 may hand-seed items or derive crude.
- **S3 Verdict record** — `{item_id, response_index, verdict, evidence_quote, location, judge_model, generator_model, run_k}`. Append-only. `judge_model`+`generator_model` recorded here for self-preference audit (L10). Self-consistency, A/B, aggregation all read this shape. Lock it Phase 1.
- **S4 Artifact writer** — verdict records + rates → mirrored `evaluation/` markdown. Append-aware (matches harness append-on-matching-conditions).

Get S1–S4 shapes right and every later capability (more scopes, interaction pass, A/B, self-consistency, contradiction) is additive, not a rewrite.

### Phase 1 — Minimal spine (MVP)

Prove the pipe end-to-end, cheapest useful thing.
- S1 report reader + S3 verdict shape + S4 artifact writer.
- **One judgmental scope only: negative** (rules violated?). One judge subagent.
- Rubric: step 1 validates auto-derive feasibility. Feasible → Phase 1 uses auto-derive (few negative items, skill-line citation). Not feasible → hand-seed fallback. Routing field present; Phase 1 may mark all `judgmental`.
- K=1, no self-consistency loop yet (but verdict record already carries `run_k`).
- Aggregate over N = simple violation-rate per item. N=1 flagged.
- No A/B, no interaction pass, no positive scope, no mechanical checker.
- **Done when**: run on existing `no-ai-slop+writting` report → artifact at mirrored path, per-item violation-rate + evidence, report hash unchanged.

### Phase 2 — Second scope + mechanical routing

- Add **positive** scope judge (point made? well presented?).
- Implement **mechanical** checker (script/regex) for regex-able items (emdash, banned verbs). Router sends item to script or judge per `routing`.
- Rubric auto-derivation tags routing per item; validate on `no-ai-slop`.
- **Done when**: mixed rubric runs; mechanical items zero-variance, judgmental items evidence-quoted; both in one artifact.

### Phase 3 — Robustness (de-bias)

- **forced-negative-evidence-first** in judge contract.
- **adaptive append-based self-consistency** (L9b): append on re-run, tie-break 3rd, report split.
- **Done when**: re-running eval appends + shows confidence split; disagreement triggers 3rd run.

### Phase 4 — A/B

- Pairwise mode: two paired reports (same prompt+model, differing skill hash).
- **swap-and-rerun** (L9c). Per-item deltas + evidence.
- **Done when**: two paired reports → pairwise verdict, direction stated, flips flagged tie.

### Phase 5 — Interaction + contradiction

- **Interaction pass** (L6): strong model, reads full response, cites collisions.
- **Contradiction** (L7): skill-internal (recompute+dedupe), skill-composition (combo reports).
- **Compound assessment** (L12): compose from verdicts + rates + interaction findings.
- **Done when**: artifact carries interaction findings + compound read, both traceable to inputs, neither re-judges items.

### Phase 6 — A/B result persistence + human readout

- Persist pairwise judge input/result after `compare`; final verdict must not live only in chat.
- Validate both orderings, source hashes, changed skill, verdict vocabulary, evidence, final confidence.
- Render Markdown with final verdict, confidence, source paths/hashes, both orderings, evidence, rationale.
- **Done when**: `writting` old/new result reopens from one Markdown file; stale/malformed judge result rejects; source reports unchanged.

**Deferred beyond phases** (revisit only if value proven): extra bespoke scopes (e.g. tone judge), interaction-pass N-sampling cost knob, enforced judge≠generator at strong tier, golden-file for tight-shape skills.

## Assumptions to validate (Phase 1 / step 1)

- **Responses cleanly splittable.** Anchors: `## Response N` heading + fenced ``` body + `<!--BENCHMARK_META …-->` JSON. Risk: skill body contains ```. Fallback: use `BENCHMARK_META` + heading offsets, or add machine-readable delimiter to `run.py` (flagged harness change, needs approval).
- **Eval agent can nest judge subagents** under `permission.task` allowlist (specific children, never `"*": allow`). Fallback: sequential single-agent eval (higher context cost).
- **Rubric auto-derive feasible.** Decided: auto-derive + mandatory skill-line citation. Validate: sane well-attributed items on real skill body? Correct mechanical-vs-judgmental tag? Fallback: hybrid (auto-derive + optional override) — flagged.
- **Routing machine-decidable.** Validate on `no-ai-slop` (regex-able emdash/banned-verbs vs judgment-only structural-slop/reads-like-marketing). Auto-deriver marks uncertain items `judgmental` (safe); executor validates the tagging in step 1.
- **A/B pairing contract.** Which meta fields must match (same prompt hash + model; differing skill hash). Reuse `conditions_match` logic.
- **Judge stability at K.** Trial: run judgmental item K times on same frozen response; measure split. Near-random on clear-cut item → narrow sub-question or mark manual-only.

## Success criteria

Per phase "Done when" above is the gate. Global acceptance at plan completion:
- Existing N-response report → artifact under `evaluation/<mirrored-path>/`; per item: violation-rate (negative) + hit-rate (positive) aggregated over N, each with quoted evidence tied to specific response.
- Artifact names source report by path + hash (traceable, reproducible).
- Eval never modifies report (verify: report hash unchanged before/after).
- Two reports differing only in skill hash → pairwise A/B verdict + per-item deltas + evidence.
- N=1 produces artifact, flagged low-trust.
- Compound assessment present, visibly derived from verdicts + rates + interaction findings (not fresh guess).
- Committed artifacts pass repo rules (no dead refs; skill has SKILL.md+README; subagent frontmatter complete).

## Risks and guardrails

- **Judge variance stacks on output variance** — same input, swinging verdicts — binary/evidence items, forced-negative-first, self-consistency split, low temp; still unstable → narrow sub-question or mark "manual-only".
- **Interaction pass → holistic slop** — free-forms quality verdict / re-scores — question is interaction-only; findings must name colliding items with evidence; uncited dropped; feeds compound, never overwrites items.
- **Compound → holistic slop** — invents new judgment — consumes ONLY verdicts + rates + interaction findings; forbidden to read raw responses.
- **A/B position bias** — verdict depends on order — swap-and-rerun; flip = tie.
- **Self-preference** — judge==generator family — negligible per-rule (small model ≠ generator); interaction/compound tier records both models; enforced difference deferred.
- **Routing misclassification** — judgment rule tagged mechanical (regex false verdict) or scriptable wasted on judge — step-1 validation on `no-ai-slop`; uncertain → judgmental.
- **Rubric hallucination / mis-attribution** — invents rule or wrong skill line — mandatory citation, uncited dropped; step-1 attribution check; hybrid-override fallback.
- **Splitter couples to report format** — schema change breaks split — anchor on versioned `BENCHMARK_META` + headings; harness delimiter = flagged change, no silent `run.py` edit.
- **Scope creep to gate / to fixes** — blocking threshold request, or judge emitting advice — Non-goals + Locked forbid; schema has no recommendation field.
- **Subagent bloat** — one judge per micro-rule explodes count — reject-first; few parameterized scopes (negative/positive/interaction) driven by rubric, not bespoke judges.

## Top-level AI execution plan

Phases above define scope. Milestones:

1. **Step 1 — validate cheap unknowns.** Inspect existing reports + `run.py`. Confirm: (a) splitter anchors; (b) A/B pairing meta fields; (c) rubric auto-derive + routing feasibility on `no-ai-slop`; (d) `permission.task` nesting for judge children. Output: four decided answers. No new files.
   - Use: direct inspection of reports + `run.py` (`conditions_match`, `make_report_name`) + repo `permission.task` rules.
2. **Step 2 — design lock (seams S1–S4 + artifact schema).** Fix: verdict record shape, rubric object shape, report-reader interface, artifact markdown schema, judge scope count, model tiers/temps. Output: written architecture the executor builds from. Rubric source per step-1 finding.
   - Delegate: none — core design, live judgment.
3. **Phase 1 build — spine + negative judge.** S1 reader, S3 verdict, S4 writer, one negative judge subagent, crude rubric, K=1, violation-rate aggregate. Verify Phase-1 "Done when".
   - Use: `uv`-run single-file script, PEP-723 header, stdlib-only, mirror `scripts/run.py`.
   - Delegate: bounded builder for parse/assemble script once S1–S4 locked.
4. **Phase 2 — positive scope + mechanical routing.** Second judge, script/regex checker, router. Verify Phase-2 gate.
   - Use: repo subagent authoring rules (frontmatter, default-deny tools).
5. **Phase 3 — de-bias.** forced-negative-first, adaptive append self-consistency. Verify Phase-3 gate.
6. **Phase 4 — A/B.** pairwise + swap-and-rerun. Verify Phase-4 gate.
7. **Phase 5 — interaction + contradiction + compound.** Verify Phase-5 gate.
8. **Close.** Grep dead refs. Update `.agent/frontier.md` if repo shape shifts. `@build-fast` for noisy runs; main thread interprets.

Orchestrating eval flow ships `SKILL.md` (caveman) + `README.md`; allowlist judge children in `permission.task`. Nesting disallowed (step 1) → sequential single-agent, same verdict contract.

## Execution capability notes

- Runtime: eval agent nests judge children via `permission.task` allowlist — fallback sequential single-agent.
- Runtime: benchmark model/auth available for judge (harness copies `auth.json`) — fallback judge model = plan-time param.
- Setup: none before step 1; script + subagents built in-plan.
- Research: all unknowns local (report format, meta fields, nesting) — direct inspection, no web.
- Lead: `agent-benchmark/reports/skills/no-ai-slop+writting/2026.07.30_9c468e7a9c73_openai_gpt-5.6-luna.md` = concrete N=1 specimen. `run.py` `conditions_match` / `make_report_name` define meta + pairing.
- Avoid: golden-file/similarity; editing `run.py` isolation; absolute-score judge; committing eval data.

## Execution design lock

- Local source until maintainer de-ignores it: extend `skills/agent-benchmark/` with `scripts/evaluate.py`, extend `agents/agent-benchmark.md`, add parameterized judge agents. Data stays under gitignored `agent-benchmark/evaluation/`.
- `evaluate.py` uses PEP-723 + stdlib. Commands: parse/derive frozen report + rubric; validate/roll verdict JSON; write append-aware Markdown artifact. Script never calls model. Existing `run.py` unchanged unless current anchors fail.
- S1 reader: report bytes → `{meta, source_hash, skills, prompt, responses}`. Parse metadata block, named section offsets, then response-heading offsets. Strip only outer fence at known section end; never split arbitrary triple-backtick blocks.
- S2 item: `{id, source_skill, skill_line, text, routing, scope}`. One item has one scope. Phase 1 derives bounded negative items from frozen `## Rule` headings/directive bullets, cited as `<skill>:<frozen line>`; derive failure stops with evidence, not invented rules. Phase 2 adds sibling positive items and deterministic negative items only where token pattern is explicit; uncertain remains judgmental.
- S3 verdict: `{item_id, response_index, verdict, evidence_quote, location, judge_model, generator_model, run_k}`. Scope stays in `item_id`/rubric, preserving locked record shape. `verdict` is `pass|fail`; verdicts append, never replace.
- S4 artifact: source report’s relative path under `agent-benchmark/reports/` mapped unchanged under `agent-benchmark/evaluation/`; source SHA-256 + metadata make it traceable. Markdown embeds append-only verdict JSON for later roll-up; N=1 carries lower-trust flag.
- Test-only before real judgment: evaluator + rule judge use `POOL_FAST`, `0.1`; test prompt runs use `github-copilot/claude-haiku-4.5` unless user selects another model. Phase-quality model tiers stay deferred. Runtime depth currently blocks nested judges, so evaluator uses sequential one-item/one-response prompts with same verdict contract. Judge agent stays available if nesting becomes enabled.
- A/B command accepts older/newer paths in chronological order, verifies all controlled fields plus skill-key set, requires exactly one changed skill hash. Desired direction comes from changed skill body; user supplies it only when body cannot decide. Equal/ambiguous chronology stops.
- Scope policy: negative/positive/interaction only. Bespoke scope requires explicit maintainer approval. Delimiter fallback, if needed, updates `run.py`, benchmark skill, and benchmark agent together; current anchors avoid it.

## Decisions / revisions

- 2026-07-30 — Initial plan. LLM-judge core, fan-out judges (negative+positive), compound assessment, pairwise A/B, aggregate-over-N (N=1 tolerated), script-assisted split, 1:1 `evaluation/` mirror. Rejected golden-file for prose.
- 2026-07-30 — Clean-context review applied. Assigned rubric-source + nesting validation to step 1; clarified script-rollup vs LLM-compound; wired nesting fallback; de-hedged wording.
- 2026-07-30 — Judge architecture deepened. Added per-rule routing; interaction pass (overrides "compound never reads raw"); two-granularity contradiction (skill-internal recompute+dedupe, composition combo-only); de-bias set (forced-negative-first, adaptive append self-consistency K=1→3, swap-and-rerun); evidence-not-advice schema. Rubric locked auto-derive+citation. Self-preference tier-dependent. Interaction cost knob deferred.
- 2026-07-30 — Rewrote ultra-dense. Added staged growth architecture: seams S1–S4 + Phases 1–5 (minimal spine first, additive growth). Full design = target not first commit. Skill-internal contradiction cadence locked recompute+dedupe-per-eval.
- 2026-07-30 — Clean-context review: no stubs/contradictions/forward-deps; staging sound. Fixed 6 ambiguities — S2 schema lock timing, S3 records both models, L7 contradiction surfacing location, L9b disagreement = binary-value difference, L10 audit location = S3 record, routing uncertain-item ownership + Phase-1 rubric feasibility branch.
- 2026-07-31 — Execution started. Step 1 validates current metadata + response-heading anchors, A/B controlled fields, no-ai-slop attribution/routing, named-child task allowlists. Current splitter works; no delimiter change. Benchmark source remains local/ignored until maintainer manually de-ignores and commits. Fixed judge scopes; A/B order chronological, desired direction inferred from skill body unless user supplies it.
- 2026-07-31 — Test-only model policy: cheapest available tier until execution mechanics prove out; defer judgment-quality model selection.
- 2026-07-31 — Runtime test: named task allowlist parses, but `subagent_depth=1` blocks evaluator nesting. Adopt locked sequential single-agent fallback; no external configuration change.
- 2026-07-31 — Phase 1 passes: mirrored N=1 artifact, six negative verdicts, source SHA-256 unchanged. Phase 2 parser/router/unit tests pass; integration artifact reveals evaluator ignored deterministic `check` output, so Phase 2 remains unaccepted pending a rerun with `judge_model: mechanical` records.
- 2026-07-31 — Phase 2 accepted on clean report mirror: three deterministic mechanical records, five negative plus two positive judgmental records; source SHA-256 unchanged. Fixed parser boundary for reports carrying `## Agent Under Test`.
- 2026-07-31 — Phase 3 accepted: `status` schedules K=2 then K=3 only on split; writer blocks duplicate/settled judgmental records; artifact reports consensus/confidence. Cheap run settled 21 judgmental item/response pairs at 2/2; unit test forces K=1/K=2 split and asserts K=3 pending.
- 2026-08-01 — Phase 4 mechanics added: `evaluate.py compare <older> <newer>` requires strict chronological order, matching controlled fields, identical skill-key sets, and exactly one changed skill hash; outputs frozen changed-skill bodies and context for pairwise judging. Available reports fail contract: same two skill hashes and bodies. No pairwise verdict or swap rerun; need valid old/new reports.
- 2026-08-01 — Phase 4 retest: valid `writting` pair is `fa37082c1e8c` (old, `f79777cc193c`) and `7dacf90bf4a5` (new, `4f54b34bd004`); each N=3 evaluation mirrors under `evaluation/skills/writting/`. Pairwise old-first = `worsened`; swapped order = `tie`; flip wins, so result is `tie`, low confidence. Direction inferred from frozen diff: harder paragraph and directive checks. No winner claim.
- 2026-08-01 — Phase 5 accepted: `phase5-context` validates settled records; `write-phase5` atomically replaces derived Phase-5 sections while preserving source and S3 records. New `writting` N=3 artifact: zero interaction findings, zero internal contradictions; compound restates settled negative 1–4 failures, negative 5 and positive 1 passes. Strong nested judges remain unavailable; execution uses standalone sequential fallback.
