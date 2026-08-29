---
name: no-ai-slop
description: "Improve substantive human-facing prose by removing vague, unsupported, generic, or filler language. Use for drafting, rewriting, editing, or polishing documentation, correspondence, articles, reports, explanations, or copy. Make claims specific, factual, and checkable. Skip for chat, terse operational output, code or configuration, and AI-directed prompts, skills, directives, or rules."
source: "Adapted from [No AI slop skill](https://github.com/realrossmanngroup/no_ai_slop_writing_rules); distilled negative signals for AI slop detection and rewrite alternatives."
---

# No AI slop

## Rule 1: No emdashes

The character is banned. Use a semicolon, a period, a comma, or restructure.

- WRONG: "The policy -- which affected millions -- was later reversed".
- RIGHT: "The policy affected millions of devices. The company reversed it in December 2017".

## Rule 2: No unsourced statistics

Every number must be real and attributable. If you cannot point to where it comes from, do not write it. A made-up figure is worse than no figure.

- WRONG: "Over 70% of users reported frustration with repair restrictions".
- RIGHT: "In a 2021 Consumer Reports survey of 8002 adults, 84% said manufacturers should be required to make repair parts available".

## Rule 3: No parenthetical clarifications in headings

Trust the reader. If the heading needs clarification, the heading is wrong. Rewrite it.

- WRONG: "Serialization (the practice of linking parts to a specific device)"
- RIGHT: "Part serialization"

## Rule 4: No intensifiers

"Significantly", "dramatically", "extremely" and their kin are placeholders for evidence. Replace the word with the number it was standing in for.

- WRONG: "The pricing was significantly higher than the cost of the part".
- RIGHT: "They charged $1,200 for a repair that needed a $5 chip".

## Rule 5: No hollow statements

A sentence that asserts importance without a detail says nothing. End every claim on a concrete fact.

- WRONG: "This practice has had a significant impact on people".
- RIGHT: "The company replaced 11 million batteries in 2018, against the 1 to 2 million it had expected".

## Rule 6: No repeated talking points

Say it once. A point restated in a later paragraph is padding; delete the duplicate, not the original.

- WRONG: Paragraph 2 says "Part serialization locks owners out of independent repair". Paragraph 5 says "As noted above, serialization means only authorized shops can do the work".
- RIGHT: State it once, in the most useful position, and move on.

## Rule 7: No structural slop (repetitive layouts)

Three sections built from the same template read as machine output, even when each fact is true. Vary paragraph count, sentence rhythm, and how each section opens.

- WRONG (three sections, identical shape):
  ```
  In [year], [party] did [thing]. This affected [number] people. [Party] responded by [action].
  In [year], [party] did [thing]. This affected [number] people. [Party] responded by [action].
  In [year], [party] did [thing]. This affected [number] people. [Party] responded by [action].
  ```

- RIGHT (vary the shape):
  ```
  Section one: a detailed narrative with timeline and context across two paragraphs.
  Section two: a two-sentence summary, because the event is thinly documented.
  Section three: opens with the party's stated justification, then the contradicting evidence.
  ```

## Rule 8: Reference without narrating the reference

Make the connection and move on. Do not write "as discussed above", "as mentioned earlier", "as we will see", or "as noted previously".

- WRONG: "As discussed above, part serialization prevents independent repair".
- RIGHT: Just use the fact directly in context. If you need to refer back, restate the relevant detail in one clause, not a meta-pointer.

## Rule 9: No performative urgency without a reason

"Act now", "don't wait", "time is running out" need a concrete consequence in the same sentence or they get cut. A real deadline or a real penalty. Not vibes.

- WRONG: "Act now to protect your right to repair".
- RIGHT: "The FTC comment period closes September 30; comments filed after that date are not considered".

## Rule 10: No scare quotes on normal words

Use quotation marks only for actual quotations from a named source. Putting a common word in quotes to signal skepticism reads as ironic sneer or weaseling.

- WRONG: The company's "authorized" technicians. Their "genuine" parts.
- RIGHT: The company's authorized technicians. Their genuine parts. (Or, if you have evidence the authorization is bogus, say that directly with a fact.)

## Rule 11: No filler phrases

"In today's world", "It's important to note", "When it comes to" add length, not meaning. Open on the fact.

- WRONG: "In today's world, planned obsolescence affects many devices".
- RIGHT: "Apple, Samsung, and Google have each faced lawsuits alleging planned obsolescence".

## Rule 12: Never start a sentence with "Whether you're"

Cut it. The sentence that follows is always generic. Open on the fact or the subject instead.

- WRONG: "Whether you're a DIY enthusiast or a professional technician, repair restrictions affect you".
- RIGHT: "Repair restrictions raise costs for both independent shops and consumers who fix their own devices".

## Rule 13: Write like a researcher, not a copywriter

If a sentence could sit on any advocacy or marketing site without changing a word, it is generic. Anchor it to something checkable.

- WRONG: "People deserve the right to repair their own devices".
- RIGHT: "The FTC voted 5-0 in July 2021 to step up enforcement against illegal repair restrictions".

## Rule 14: No synthetic enthusiasm

No exclamation marks. No cheerleading. State the facts; the evidence carries the weight.

- WRONG: "This is a huge win for consumers! The new law is a major step forward!"
- RIGHT: "The law requires manufacturers to provide parts and tools at fair market prices, starting January 2025".

## Rule 15: No weasel words

"May potentially", "can help to", and "might be able to" can stack uncertainty until a claim says nothing. State the evidence-supported confidence level. Keep uncertainty required by incomplete evidence, forecasts, disputes, permissions, or responsibility.

- WRONG: "Serialization may potentially prevent independent repair".
- RIGHT: "Replacing an iPhone 15 camera module without the manufacturer's calibration software disables optical image stabilization".

## Rule 16: No dramatic headings

A heading names what the section holds. It does not tease, dramatize, or abstract.

- WRONG: "The Hidden Cost of Planned Obsolescence"
- RIGHT: "Economic impact of shortened product lifespans"

## Rule 17: No fabricated case studies or scenarios

Never write narrative scenarios presented as real events unless you are describing a specific, documented incident you can point to. Do not invent outcomes, actions, or stories.

- WRONG: "Consider a small repair shop owner who finds that a replacement screen won't activate because the serial number doesn't match".
- RIGHT: Either cite a real documented case or drop the scenario entirely and make the point with a policy fact.

## Rule 18: No fabricated history or milestones

Do not invent dates for events, launches, founding, or milestones. Every date and event must be real.

- WRONG: "Apple introduced serialization in 2017 as part of its security initiative".
- RIGHT: Only write this if you can point to a real Apple document, press release, or credible report confirming the date and framing.

## Rule 19: No fabricated attributions

Never put a position in a named person's mouth from inference. State only what they actually did or said, with the real source.

- WRONG: "Senator Smith has argued that the right to repair is essential".
- RIGHT: "Senator Smith co-sponsored the Fair Repair Act in January 2024".

## Rule 20: No stock transition phrases

Banned: "Furthermore", "Moreover", "Notwithstanding", "That being said", "At its core", "In essence", "It is worth noting that", "In the landscape of", "To put it simply". Use plain connectors: also, and, but, however, still.

- WRONG: "Furthermore, the policy disproportionately impacts independent repair shops".
- RIGHT: "The policy also hits independent repair shops harder than authorized dealers".

## Rule 21: Use plain verbs

Banned: delve, leverage, utilize, facilitate, foster, bolster, underscore, unveil, navigate (metaphorical), streamline, endeavour, ascertain, elucidate. Use plain equivalents: explore, use, help, encourage, strengthen, highlight, reveal, manage, simplify, try, find out, explain.

- WRONG: "This report seeks to elucidate the mechanisms that bolster manufacturer lock-in".
- RIGHT: "This report explains how manufacturers maintain lock-in".

## Rule 22: No inflated academic phrasing

Banned: "shed light on", "pave the way for", "a myriad of", "a plethora of", "paramount", "pertaining to", "prior to" (use "before"), "subsequent to" (use "after"), "in light of" (use "because of"), "with respect to" (use "about"), "in terms of" (use "about" or "for"), "the fact that" (rewrite the sentence).

- WRONG: "Prior to the ruling, a myriad of issues pertaining to repair access remained unresolved".
- RIGHT: "Before the ruling, repair access had no federal protection".

## Rule 23: Quote sources accurately, and set off the long ones

Every word in quotation marks must match the source exactly. Do not correct grammar, swap pronouns, or clean up wording. Mark changes with square brackets. Name the speaker and medium when introducing a quote. Keep short quotes inline; set off quotes longer than ~15 words as an indented block with a one-sentence attribution clause.

- WRONG: "Apple said that 'independent repairs can compromise device integrity and safety.'" (paraphrased into quotes without a real source)
- RIGHT (short, inline): Apple's 2019 security white paper states that "unauthorized modifications can expose users to data theft".
- RIGHT (long, block):
  > In the complaint filed in the Northern District of California, plaintiffs alleged that Apple "knowingly and intentionally disabled FaceID on devices repaired outside of Apple's authorized service network, without disclosing to consumers that such disabling would occur as a consequence of third-party repair".

## Rule 24: No research-process narration

Report facts you can support; silently omit what you cannot. Do not write "could not be located", "no record was found", "as of <date> this information is not available". Do not enumerate documents you failed to find. Do not add meta-commentary on how the text was assembled. If a fact cannot be supported, delete it.

- WRONG: "No official statement from the company could be located regarding this policy".
- RIGHT: (silence; omit the claim entirely)

## Rule 25: No decorative counting

Do not announce how many items a list or table contains when the reader can see the items. The count restates what is already visible. A count earns its place when the number is the point: "the dataset contains 2.4 million rows" tells the reader something a list cannot.

- WRONG: "This project contains 6 files:" followed by a table listing the files.
- RIGHT: The table listing the files, with no count preamble.
- WRONG: "There are 3 main directories in this repo".
- RIGHT: Name and describe the directories without counting them first.

## Rule 26: No incoherent relationships

Fluent wording can still express an impossible relationship. Check unclear verb-object pairings, modifiers, comparisons, and metaphors. Rewrite figurative language only when its actors, actions, or spatial relationships conflict.

- WRONG: "Two overarching pillars undergird the framework".
- RIGHT: "Two principles support the framework".

## Rule 27: Root-cause differentiation

When you contrast two things, name the concrete difference that separates them. Do not assert that one is exempt, newer, better, or unaffected without saying what specifically makes it so. Whenever you say A differs from B, name the part, the version, the date, the mechanism, or the supply-chain change that makes the difference real. If you do not have that detail, do not imply the difference exists.

- WRONG: "2020+ Leaf models are unaffected and use the MyNISSAN app instead".
- RIGHT: "2020+ Leaf models shipped with 4G/LTE telematics units connected to a newer cloud platform, replacing the 2G/3G units in earlier models. Those vehicles use the MyNISSAN app, which talks to a different backend".
