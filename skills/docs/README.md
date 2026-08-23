# docs

Read side of repository knowledge for AI agents. Cheap to discover, cheap to trust. The write side lives in the doc-writing discipline.

## What it does

Guides the agent to consult already-digested repo docs before broad re-exploration. Provides two cheap discovery scripts (`inventory`, `frontmatter`) that scan a whole `.agent/` folder in one bash call instead of many file reads.

## Why discovery-only

This skill loads on nearly every non-trivial repo session, so it must stay lean. Writing rules (frontmatter schema, `.agent/` placement, lifecycle, bootstrap, handoff, bug logs) belong to a separate doc-writing skill that loads only when knowledge is persisted. Discovery is the hot path; writing is the cold, gated path.

Design intent:

- **Cheap discovery first.** One `inventory` call replaces N file reads. If discovery is expensive, agents skip docs; if agents skip docs, docs rot.
- **Route, don't dump.** Frontmatter + `description:` let the agent decide whether to read deeper.
- **Read, don't write.** Persisting knowledge is a separate discipline with its own value gate. This skill never creates or edits docs.
- **Not a subagent.** Discovery is a script the parent runs directly; the writing decisions that would follow need live parent context. Considered and rejected.

## How to invoke

Loads automatically for non-trivial repo work, or when the request mentions consulting docs / `.agent/` folder / architecture notes.

## Structure

- `SKILL.md` — LLM-facing. Discovery workflow, what lives under `.agent/`, when to switch to writing.
- `README.md` — this file. Design intent, maintainer notes.
- `scripts/inventory` — lists all Markdown docs in a tree with frontmatter, sorted by `updated:` desc.
- `scripts/get-frontmatter` — prints the YAML frontmatter block of one Markdown file.

## Scripts

### `scripts/inventory`

```bash
skills/docs/scripts/inventory [dir]
```

- Default dir: `.agent/`
- Lists every `*.md`; projects `title`, `description`, `status`, `updated` from frontmatter
- Aliases: `name`, `summary`, `lastmod`, `date`; unknown keys hidden
- Sorted by `updated:` desc, path asc
- Deps: `bash`, `yq`, `awk`, `find`, `sort`. `yq` parses YAML; no heuristic fallback

### Why `inventory` requires `yq`

Current managed `.agent/` frontmatter is flat scalar metadata, so an `awk` extractor would work
today. It would not preserve this script's supported YAML contract or test coverage:

- Folded multiline `summary: >` values.
- Quoted scalar escapes such as `\t` and `\n`.
- Nested mappings and lists, which `inventory` ignores safely while parsing requested keys.
- Invalid-YAML rejection with a named source file.

| Choice                  | Benefit                                                                                 | Cost                                                                                                                  |
| ----------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| Keep `yq`               | Correct YAML parsing, stable behavior for third-party frontmatter, invalid-YAML errors. | One runtime dependency; unavailable environments cannot run `inventory`.                                              |
| Use `awk`/`sed`         | Only standard shell tools.                                                              | Must restrict and enforce frontmatter to flat single-line scalars; loses current fixture support and YAML validation. |
| Use another YAML parser | Could replace `yq` where a target guarantees it.                                        | Still adds a runtime dependency; changes installation and error behavior.                                             |

Keep `yq` unless the frontmatter contract is intentionally narrowed. Do not silently replace it with
heuristic extraction.

### `scripts/get-frontmatter`

```bash
skills/docs/scripts/get-frontmatter <file.md>
```

- Prints the raw YAML frontmatter block of one file. Purpose: let the agent retrieve routing metadata without reading the file head, which would pull unwanted body context into the session.
- Requires first-line `---` and a matching closing `---`.
- Self-explaining failures for the calling agent: exit 2 = no opening fence, exit 3 = unclosed block, exit 4 = block is not valid YAML (parser reason included in the message). Each message names the file.
- Deps: `bash`, `awk`. `yq` optional — used only to validate YAML and produce the exit-4 message; absent `yq` skips that check and prints the raw block.

## Revising this skill

- **Keep it caveman.** `SKILL.md` is read on nearly every trigger. Verbose prose = permanent token tax.
- **Keep it read-only.** No write/placement/lifecycle rules here — those belong to the doc-writing discipline. If you find yourself documenting how to shape or place a doc, you are in the wrong skill.
- **Do not add a subagent.** Discovery is a script; the parent runs it directly.
- **Keep scripts correct.** `inventory` requires `yq`; never replace real YAML parsing with heuristic field extraction. `get-frontmatter` delimits the raw block and, when `yq` is present, validates it so malformed frontmatter explains itself to the calling agent.
- **Frontmatter is a shared contract.** This skill only reads it; the doc-writing discipline is its authority. Third-party aliases are input compatibility, not an alternate managed schema.
- **Do not couple to a compression skill.** Caveman is a style hint, not a dependency.
- **Do not couple to research or writing skills by name.** Reference by behavior.
- **When adding a new script**: add it to `scripts/`, mark executable, document dependency and tests here.

## See also

- Doc-writing discipline — write side: admission gate, frontmatter schema, placement, lifecycle.
- `../../.agent/notes/design-principles.md` — cross-cutting agent philosophy, memory model.
