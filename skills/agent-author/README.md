# agent-author skill

Workflow skill for creating, editing, or auditing agent ecosystem artifacts: `SKILL.md` files, subagent files (`agents/*.md`), primary agent definitions, and slash commands.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

These four file forms have repeatable patterns. Cheaper models need explicit forms and checks.

- File-form guidance from Anthropic agent-skills best practices and OpenAI prompt-engineering guidance (vendor-neutral framing)
- Durable authoring rules for repeatable artifact maintenance
- Five portable self-informing templates: paired skill/runtime README, split primary-agent/subagent scaffolds, and a command scaffold

Context is scarce. Write dense agent-facing instructions: imperative, exact, low-token; fragments when clear. Templates shape artifacts; models fill intent. Ready non-trivial artifacts get clean-context read-only evaluation before ship, then re-verification.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

- Writing or editing a new `SKILL.md`
- Writing or editing a subagent file (`agents/*.md`)
- Writing or editing a primary agent definition
- Writing or editing a slash command (`commands/*.md`)
- Auditing any of the above for correctness, coupling, or bloat

<!------------------------------------------------------------------------------------------------->
## When it does NOT trigger
<!------------------------------------------------------------------------------------------------->

- anything in a file named `AGENTS.md`: `agent-agents-md` owns that file, rule policy and edits alike
- Prose / reader-facing writing: reader-facing writing behavior
- General `.agent/` docs or architecture notes: docs discipline behavior

<!------------------------------------------------------------------------------------------------->
## Maintainer constraints
<!------------------------------------------------------------------------------------------------->

- **Frontmatter is the routing surface.** `description` (and any routing field) loads into every session's scope and decides whether the artifact loads at all. Keep it one line per field, dense, current-state only, decoupled from other artifact names. Rationale: loose wording over-loads and burns context; narrow wording misses real triggers; stubs/roadmap/name-coupling rot silently because the frontmatter is always live. Maintainer meta and WHY live here in the README, never in frontmatter.
- **Non-triggers are a last resort, and the bar is behavioural, not theoretical.** List a neighbouring artifact as a non-trigger only when it is a genuine alternative and the mistake would recur — a frequent near-miss, or a needless double-load. Rationale: an earlier phrasing keyed only on "credible overlap" and produced false exclusions in practice; artifacts that legitimately co-load (completion gates, checklists, parent routers) got named as non-triggers, which suppresses correct behaviour, and boundaries already declared by the other artifact got restated, giving two copies to drift apart. Sharper positive scope usually beats a negative clause for the same words.
- **Simplicity over specificity.** A rule should be plain enough to read correctly on first pass, not pre-loaded with every edge case. An edge case earns its own bullet only once it actually arises. Does not license vagueness where exactness is required: schema fields, literal tokens, routing keywords, ordered steps stay exact regardless. Rationale: an over-qualified rule is harder to audit and drifts out of sync; a rule a smaller model misreads is one to simplify, not lengthen; this pairs with the cheap-model test.
- **No cross-family name-coupling in SKILL.md body.** Reference other skills/subagents by behavior keyword; a hard name breaks on rename. Two exceptions: `deploy/AGENTS.md`, and same-family siblings. This skill names `agent-agents-md` in its workflow and boundaries on purpose: the handoff must be deterministic, and both live in the `agent-*` family, so a rename touches both together.
- **Progressive disclosure.** SKILL.md stays ≤ ~500 lines. Templates, long examples, reference tables → one-level-deep reference files linked from SKILL.md. If SKILL.md grows past 500 lines: extract, do not inline.
- **Keep templates self-informing and in sync.** Templates carry pointer/reminder cues only; full rules stay in SKILL.md. Templates are portable scaffolds, never client-schema authority. If you change a rule in SKILL.md, check inline cues still point correctly. Cues that restate or contradict SKILL.md diverge silently. Swap-test: SKILL.md stands without templates; templates remain useful alone.
- **Final review.** Before shipping a ready non-trivial artifact, delegate a clean-context read-only static evaluation. Give target, intended outcome, scope, governing rules, and target runtime/schema when relevant. It catches evident misalignment, conflict, scope, and ship blockers; it cannot prove intent or execution. Resolve justified findings, then re-verify. Skip only trivial mechanical edits.
- **Goals-vs-form separation.** SKILL.md body = post-load behavior (rules, workflow, output contract). Rationale, token economics, model-routing philosophy → this README. Do not move rationale into SKILL.md.
- **Runtime/maintenance split.** SKILL.md tells an agent WHAT to do and HOW. WHY belongs here for future maintenance; frontmatter may retain routing-relevant rationale.
- **Paired README.** Every skill ships one so maintainer rationale stays off runtime path. Keep HOW, WHEN, boundaries, and verification in `SKILL.md`.
- **Executable asset boundary.** A skill with executable helpers uses `scripts/`; never place them beside `SKILL.md`. Do not create an empty `scripts/` directory for a Markdown-only skill.
- **Reject-first discipline still applies.** This skill is authoring guidance, not a license to add. Check duplicates, evaluate whether an existing artifact can be extended instead.
- **Split trigger (2026-08-06 consolidation decision).** This skill stays one file covering all four forms. Revisit a split only when `SKILL.md` exceeds ~400 lines, OR any single form section exceeds ~120 lines, OR a fifth file form arrives with rules sharing nothing with the existing four. Below those thresholds a split is bloat: it multiplies always-loaded routing surfaces and forces double-loading for near-identical shared rules. Rejected once already (4-way split into per-form skills) on exactly this evidence; re-derive nothing, just check the thresholds.

<!------------------------------------------------------------------------------------------------->
## Reference files (one level deep)
<!------------------------------------------------------------------------------------------------->

- `templates/skill.md`: fillable `SKILL.md` skeleton with inline authoring cues
- `templates/skill-readme.md`: required companion README skeleton
- `templates/primary-agent.md`: fillable primary-agent scaffold, optional `## Scope`, `## Boundaries`, light-touch `## Output contract` reminder
- `templates/subagent.md`: fillable subagent scaffold, optional `## Scope`/`## Input`, `## Boundaries`, `## Output contract` with worked success/refusal fenced examples and the mandatory `status`/`gap` envelope
- `templates/command.md`: fillable slash-command scaffold

<!------------------------------------------------------------------------------------------------->
## See also
<!------------------------------------------------------------------------------------------------->

- `AGENTS.md` (repo-local): "Adding Artifacts" deltas; repo rules this skill implements
- `deploy/AGENTS.md`: places description-driven skill loading in its workflow; routing truth stays in each skill's frontmatter `description`
- `.agent/notes/design-principles.md`: broader ecosystem why (layer model, memory placement, context pollution)
- `../agent-agents-md/`: same-family sibling owning `AGENTS.md` files
- Docs discipline behavior: `.agent/` documentation conventions
