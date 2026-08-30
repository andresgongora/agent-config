# writing

Guidance for reader-facing prose that is clear, accurate, and useful.

<!------------------------------------------------------------------------------------------------->
## Purpose
<!------------------------------------------------------------------------------------------------->

Write correspondence, public statements, blog posts, proposals, and articles around reader needs.
Lead with the material point. Support claims. Make causes, consequences, requests, and decisions
clear.

Treat readers as capable equals. Use a direct, polite, confident tone. Let facts support emotion and
action.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

Use it for material correspondence, public statements, blog posts, proposals, and articles.

<!------------------------------------------------------------------------------------------------->
## References
<!------------------------------------------------------------------------------------------------->

Use these references as editing aids. Most identify weak patterns to avoid; some give alternatives
and exceptions. They help remove AI slop without losing clarity, evidence, or reader fit. Examples
show how to revise without inventing facts.

- [`ai-writing-detection.md`](./references/ai-writing-detection.md): editing signals, not authorship
  proof. Adapted from the [No AI slop skill][no-ai-slop-source].
- [`no-ai-slop.md`](./references/no-ai-slop.md): vague, unsupported, generic, and filler prose, with
  alternatives. Adapted from the [No AI slop skill][no-ai-slop-source].
- [`patterns-to-minimize.md`](./references/patterns-to-minimize.md): conditional composition
  guidance with signals, costs, rewrites, and exceptions. Repository-authored.
- [`examples.md`](./references/examples.md): fact-preserving revisions for common writing decisions.
  Repository-authored; cited sources appear with the relevant examples.
- [`asd-ste100.md`](./references/asd-ste100.md): simplified technical English for directives.
  Derived from woosal1337's [asd-ste100 skill][asd-ste100-source], which uses ASD-STE100 style.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

Start from known facts, then organise them around the reader's decision or action. Clear prose names
its subject, action, reason, and consequence. It does not use polish to hide missing support or
meaning. Ask for missing mechanism or impact when it changes the reader's action or the message's
conclusion. Do not manufacture urgency, suspense, authority, or precision.

Build substantive paragraphs from an opening idea, development, and consequence or action. Keep one
core idea per paragraph. This structure serves both skimmers and linear readers.

<!------------------------------------------------------------------------------------------------->
## Maintaining this skill
<!------------------------------------------------------------------------------------------------->

- Keep reader-facing prose, peer-level tone, and evidence proportional to stakes.
- Keep `SKILL.md` to runtime rules; record rationale and source context here.
- Keep `asd-ste100.md` directive-only by default. The low-proficiency-reader branch may widen its
  scope.
- Preserve supplied facts in examples. Use questions, omission, narrowed claims, judgments, or
  requested draft markers for missing material.
- Keep `patterns-to-minimize.md` short and conditional. Do not turn it into an exhaustive style
  guide.

<!------------------------------------------------------------------------------------------------->
## See also
<!------------------------------------------------------------------------------------------------->

- [`SKILL.md`](./SKILL.md)
- [`../../agents/writing.md`](../../agents/writing.md)
- [`../../agents/writing-reviewer.md`](../../agents/writing-reviewer.md)

[asd-ste100-source]: https://github.com/woosal1337/blog/tree/main/videos/ep01-the-cure-for-ai-slop/asd-ste100
[no-ai-slop-source]: https://github.com/realrossmanngroup/no_ai_slop_writing_rules
