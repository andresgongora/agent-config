---
name: <!-- skill-name: lowercase-hyphenated, gerund preferred (e.g. "authoring-agents") -->
description: >
  <!-- Third-person description. First sentence: what it does. Second: key trigger phrases the
       routing agent should match. Third (optional): explicit non-triggers so the skill is NOT
       loaded for adjacent work. Keep under 4 sentences; every word is re-read on each trigger
       match — favor precision over completeness.
       Example good description:
         "Workflow for creating, editing, or reviewing skill files, subagent files, and agent
          definitions. Load when user writes or audits a SKILL.md, agents/*.md, or AGENTS.md
          file form. Not for AGENTS.md rule-policy authoring (that is separate behavior)." -->
---

# <!-- Skill Name -->

<!-- ## section rules:
  - Shallow hierarchy only: # title, ## sections, NO ###.
  - Flat bullets for policy/rules. Numbered lists ONLY for ordered workflow steps.
  - ≤ ~500 lines total. Bulky templates/examples → one-level-deep reference files; link here.
  - No trigger phrases in body (frontmatter description owns routing).
  - Body = post-load behavior: workflow, boundaries, decision rules, output contract.
  - References to other skills/subagents: by BEHAVIOR keyword, never hard name.
    Only deploy/AGENTS.md may name skills directly.
  - Remove this comment block before shipping. -->

## Core rules

<!-- Flat bullets. Policy that applies across all uses of this skill. 3-8 bullets. -->

- 
- 

## Workflow

<!-- Numbered steps. Only for sequences where ORDER matters. -->

1. 
2. 

## Boundaries

<!-- What this skill does NOT do. Sharp edges prevent wrong-trigger loads. -->

- Not for: 
- Stop when: 

## Verification

<!-- Checklist an agent runs after completing work under this skill. -->

- [ ] 
- [ ] 
