---
title: ASD-STE100 Audit of Agent-Directed Prose
summary: Evaluated audit findings and applied only changes that improve AI instruction precision without removing meaningful modality.
status: resolved
updated: 2026-08-05
source: https://asd-ste100.org
---

# deploy/AGENTS.md

🟢:3:Project `AGENTS.md` may narrow/override -> Nearest project `AGENTS.md` narrows or overrides these defaults. <- States inheritance rule as fact and identifies which file wins

# AGENTS.md

🟡:53:any skill may be named directly -> Name skills directly only there. <- Converts permission into scoped imperative
🟡:60:An agent USING the repo should NOT rely on READMEs; an agent MAINTAINING may still read them. -> Agents using the repo: never rely on READMEs. Agents maintaining the repo: use READMEs as optional context. <- Removes stacked modality and makes role split explicit
🟢:86:should absorb the content instead of a new file -> can absorb the content instead of creating a file <- Distinguishes capability test from instruction

# skills/agent-author/SKILL.md

🟡:16:WHY → README, unless ... Routing-relevant why may stay in frontmatter. -> WHY → README. Exception: keep WHY in artifact when needed for correct action; keep routing-relevant WHY in frontmatter. <- Separates two exceptions and gives each a clear condition
🔴:30:WHY/rationale never here -> Frontmatter WHY limited to routing rationale needed for correct loading. <- Removes contradiction with line 16
🟡:133:artifacts in one family ... may name each other -> permit artifacts in one family ... to name each other <- Expresses permission as direct authoring rule

# skills/writing/SKILL.md

🟡:99:It may raise the idea the next paragraph develops. -> When needed, introduce the idea developed in the next paragraph. <- Replaces unclear pronoun and vague possibility with condition plus action

# skills/git/SKILL.md

🟡:13:it may be unstaged and restaged as groups are formed -> Command-specific flow can unstage and restage it while forming groups. <- Names actor and preserves permission; declarative replacement would incorrectly require restaging

# skills/teach/SKILL.md

🟡:14:This should be used to ground all teaching. -> Ground all teaching in this file. <- Replaces ambiguous pronoun and passive recommendation with direct action
🟡:17:These should be used to calculate the zone of proximal development. -> Use these records to calculate the zone of proximal development. <- Names referent and uses active imperative
🟡:30:your focus should be to find high-quality resources which will help -> find high-quality resources that help <- Removes indirect instruction
🟡:36:You should be careful to split between -> Distinguish <- Replaces vague caution with exact action
🟡:51:A lesson should be beautiful ... Think Tufte. -> Use clean, readable typography and layout. <- Removes subjective adjective and cultural reference; keeps observable requirement

# agents/planning.md

🟡:47:Chat may stay readable; file must be dense. -> Chat follows governing output style; plan file uses ultra-compressed style. <- Separates surfaces without exempting chat from governing output rules

# agents/files.md

🟡:38:Metadata/hash tools may read bytes internally -> Permit byte reads only inside metadata/hash tools <- Makes narrow permission explicit and preserves safety boundary

Verdict: Kept 11 material improvements and 4 harmless editorial cleanups. Replaced 1 harmful planning rewrite that exempted chat from governing output rules. Rejected blanket modal removal because `may`, `can`, `should`, and conditionals often encode permission, possibility, or obligation that declarative wording would change.
