# docs-write

Write side of repository knowledge. Turns expensive session knowledge into cheap, discoverable `.agent/` docs for future sessions.

## What it does

Owns admission, shaping, placement, frontmatter schema, update, and prune rules for durable repository documentation. Companion to the doc-discovery discipline (read side).

## Why split from discovery

The discovery skill loads on nearly every non-trivial repo session — it must stay lean. Write rules (schema, placement, lifecycle, bootstrap, handoff, bug logs) are cold-path: consulted only when actually persisting knowledge. Keeping them out of the hot read path removes a per-session token tax. Discovery = hot and small; writing = rare and gated.

## Design intent

- **Two-tier gate.** Frontmatter/placement rules apply to any write. _Creating a new durable note_ additionally requires high-confidence, reuse-worthy knowledge. Handoff and bug logs clear the bar differently — not by being routine, but by being gated on costly-to-lose task state (session boundary, multiple failed attempts, explicit handoff): see "Bug-log and plan ownership" below.
- **No progress narration.** Work-in-flight context stays in the AI session. Persist only what is likely to be retained: settled research, hard-won architecture facts, root causes, decisions.
- **`notes/` is the catch-all.** Architecture, research, philosophy, conventions all live in `.agent/notes/`. Content kind is the doc's job, not a directory's. No `research/`/`architecture/` folder sprawl.
- **Frontmatter is the routing contract.** `description:` decides read-or-skip. Any external-sourced content requires `source:`; `references:` is optional supplementary only and never substitutes for a missing `source:`. No source = unverifiable claim.
- **Not a subagent.** Deciding what to persist needs live parent context (what just happened, what the user asked). A fresh subagent would have to re-carry all of it — negating the isolation benefit.

## Why the gate sits where it does

The gate is an economic trade, not a style choice. Two failure modes bracket it:

- **Over-trigger** (gate too loose): the skill loads on routine sessions and, worse, `.agent/` fills with high-frequency high-noise files (a bug log per trivial bug, a note per passing thought). That destroys the cold-path saving _and_ poisons discovery, which then has to sift noise. A bare documentation gap must **not** trigger writing — a gap is a question, not yet an answer worth keeping.
- **Under-trigger** (gate too tight): a session pays real cost to obtain knowledge (deep exploration, web research, a root cause found after many failed attempts), then throws it away; the next session re-pays. That is the exact waste the skill exists to prevent.

So the admission test is: _was this expensive to obtain, and is it likely to be reused?_ If yes, persisting converts a one-time cost into a cheap future read. If no, it stays in the live session. Routing metadata (frontmatter, sibling switch rule) carries the same value qualifier, because the body gate cannot un-spend the load cost once the skill is already loaded.

Evidence type matches claim type: factual conclusions need proof; accepted decisions need recorded rationale, scope, and owner, not proof. Otherwise a smaller model rejects valuable decision records for lacking "proof" they can never have.

## Bug-log and plan ownership

- **Bug logs are gated, not routine.** Only when attempt state is costly to lose (multiple failed approaches, session boundary, explicit handoff). A bug solved within one session leaves no file. On resolution, the reusable root cause is extracted to `notes/` and the execution-only attempt log is deleted — the noise does not survive.
- **Plans are placed here, authored elsewhere.** The durable-planning capability owns plan shape and template; this skill owns only frontmatter and lifecycle for `.agent/plan/`. Keeps one authority per concern and avoids duplicating the plan contract.

## Trigger summary

Loads when persisting knowledge worth keeping (settled research, architecture/design fact, resolved root cause, cross-session handoff, missing-doc bootstrap), or when any workflow needs the managed-doc frontmatter schema / `.agent/` placement rules. Does not load for reading/discovery.

## Maintainer constraints

- Keep `SKILL.md` caveman-dense; it is not read every session but still pays a token cost when loaded.
- Do not couple to the discovery skill or any research skill by name. Reference by behavior only. The frontmatter schema is the one shared contract; this skill is its authority. Read-only consumers of that contract: the discovery discipline and the durable-planning capability's plan template. They read the schema; they never redefine it.
- Do not add new `.agent/` folders for content kinds without real justification (reject-first).
- Discovery scripts (`inventory`, `get-frontmatter`) live with the discovery skill, not here.
- `scripts/check-frontmatter` validates this skill's managed-doc contract. Silent success; failures list only bad fields.

## See also

- Doc-discovery discipline — read side, inventory scripts.
- `../../.agent/notes/design-principles.md` — memory-placement model and ecosystem failure modes.
