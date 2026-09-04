---
# Creation scaffold only. Edit/audit: preserve existing structure.
name: "<!-- lowercase-hyphenated, gerund preferred -->"
description: "<!-- One physical line. Routing truth: what it does; when to load; adjacent non-triggers. Dense correlated keywords. No stubs/roadmap/other-artifact names. -->"
---

<!-- Replace/remove all placeholders, comments, empty sections, and examples. Use dense, imperative, exact agent-facing prose. Ready non-trivial artifact: clean-context, read-only final evaluation, then re-verify. This scaffold is a pointer only; where a cue and SKILL-authoring rules conflict, the rules govern — fix the artifact, not the rule. Reference other artifacts by behavior, not name, unless both are in a declared same-family group. -->

<!-- Frontmatter description above must stay one physical line. -->

## Admission gate

<!-- Optional checklist of conditions that must hold before running skill. Remove if not needed. -->

## Core rules

<!-- Rules. -->

<!-- Optional delegation prompt template, somewhere in the skill. Example:
    ### Delegation prompt

    Give each minion a bounded mission:

    ```md
    Task: <one bounded outcome>.
    Target: <paths, symbols, supplied diff, or repository area>.
    Scope: <included work and explicit exclusions>.
    Context: <authoritative facts and constraints; `none` if none>.
    Parameters: <tool/access limits, execution constraints, required checks, and acceptance criteria>.
    Return: <evidence focus caller needs next. It will still honor its own output contract>.

    <Optional: any other relevant information deemed useful and appropriate for the mission; free format>.
    ```
-->

## Resources

<!-- If multiple tools, resources, scripts, etc available for this skills, list them here and explain their purpose, how to use them, arguments, etc. Create subsections if needed, or rename if only `Tools` available. Remove entirely if not needed. -->

## Workflow

<!-- Ordered steps only when order matters. Ideally: enumerated list. -->

## Boundaries

<!-- Post-load scope, refusal, and stopping behavior. Put routing non-triggers in description. -->

## Verification

<!-- Concrete completion checks to verify. For example, check against template, lint, unit tests. For longer skills, place a `- [ ]` type checklist that explicitly re-verifies the most important rules and conditions, or expected outcomes. This works well with smaller models to give it a clearer, bounded task. -->
