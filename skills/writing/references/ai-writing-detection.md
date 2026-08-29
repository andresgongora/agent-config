---
name: ai-writing-detection
description: "Words, phrases, punctuation patterns, structural signals, and statistical measures associated with AI-generated text. Use as editing signals, not authorship proof."
source: "Adapted from [No AI slop skill](https://github.com/realrossmanngroup/no_ai_slop_writing_rules). Sources: Grammarly (2025), Microsoft 365 Life Hacks (2025), GPTHuman (2025), Walter Writes (2025), Textero (2025), Plagiarism Today (2025), Rolling Stone (2025), MDPI Blog (2025), isgpt.org corpus analysis (2025), ACL hedging study (2024), Wikipedia AI content detection project (2025), Segmental entropy research (arxiv, 2025)"
---

# AI writing detection

Editing signals commonly associated with generic machine-written prose. Use them to find weak writing, not to determine authorship. No word, punctuation mark, or construction proves AI use; even clusters are prompts for review, not forensic evidence.

## False positive prevention

- Judge passages by accuracy, semantic coherence, specificity, and usefulness. Do not optimize for passing an AI detector.
- Never call one word, punctuation mark, rhetorical construction, or paragraph shape proof of AI authorship.
- Clusters justify closer reading, not an authorship verdict. Good human prose uses comparison, parentheticals, parallelism, and groups of three; poor human prose also mixes metaphors.
- Model-specific vocabulary changes quickly and can be prompted away. Keep durable quality checks instead of model fingerprint lists.

### Exclusion zones

Lexical scans must NOT flag text inside:

- Direct quotes (`"..."`) from cited sources
- Titles, names, and other verbatim values taken from a source
- Code, configuration, or markup that is being shown as an example

### Context-aware severity

If a banned word appears immediately adjacent to specific named entities (proper nouns, statute numbers, dates, dollar amounts), it is more likely being used with technical meaning than as AI filler. Reduce flag severity.

- **Higher severity:** "a comprehensive examination of the issues" (abstract nouns, no specifics)
- **Lower severity:** "comprehensive audit by the FTC in 2024" (specific entity, specific date)

### Metaphorical vs. literal distinction

These words require bigram context checking. Only flag metaphorical uses:

- ecosystem: "Apple's software ecosystem" (OK) vs. "the repair ecosystem" (flag)
- landscape: "Arizona landscape" (OK) vs. "the regulatory landscape" (flag)
- navigate: "navigate the website" (OK) vs. "navigate the regulatory process" (flag)
- tapestry: "medieval tapestry" (OK) vs. "a tapestry of regulations" (flag)
- symphony: "Beethoven's symphony" (OK) vs. "a symphony of features" (flag)
- beacon: "lighthouse beacon" (OK) vs. "a beacon of hope" (flag)
- testament: "last will and testament" (OK) vs. "a testament to innovation" (flag)

## General AI writing hallmarks

The following elements often add nothing to meaning. Remove them or find specific alternatives.

### Opening phrases

- "In today's fast-paced world..."
- "In today's digital age..."
- "In an era of..."
- "In the ever-evolving landscape of..."
- "In the realm of..."
- "It's important to note that..."
- "Let's delve into..."
- "Imagine a world where..."

### Transitional phrases

- "That being said..."
- "With that in mind..."
- "It's worth mentioning that..."
- "At its core..."
- "To put it simply..."
- "In essence..."
- "This begs the question..."

### Concluding phrases

- "In conclusion..."
- "To sum up..."
- "By [doing X], you can [achieve Y]..."
- "In the final analysis..."
- "All things considered..."
- "At the end of the day..."

### Structural patterns

- "Whether you're a [X], [Y], or [Z]..." (listing three examples after "whether")
- "It's not just [X], it's also [Y]..."
- "Think of [X] as [elaborate metaphor]..."
- Starting sentences with "By" followed by a gerund: "By understanding X, you can Y..."
- Repeated contrasting parallelisms: "It's not X. It's Y." or "It's not about X, it's about Y." Keep one when it states a real distinction; rewrite a sequence used only for punch.

### Inflated symbolism phrases

These phrases often add significance without supplying a fact:

- "provide a valuable insight"
- "left an indelible mark"
- "play a significant role in shaping"
- "an unwavering commitment"
- "open a new avenue"
- "a stark reminder"
- "gain a comprehensive understanding"
- "serves as a testament"
- "watershed moment"
- "deeply rooted"

### Filler words and empty intensifiers

- absolutely
- actually
- basically
- certainly
- clearly
- definitely
- essentially
- extremely
- fundamentally
- incredibly
- interestingly
- naturally
- obviously
- quite
- really
- significantly
- simply
- surely
- truly
- ultimately
- undoubtedly
- very

### Hedging phrases

Clusters of hedges that obscure whether a claim is fact, judgment, forecast, or unknown. Several hedges around one claim warrant scrutiny, especially in sections that report established facts. Calibrated uncertainty names its basis: "The FTC's 2024 enforcement data suggests a 12% increase." Blanket hedging obscures the claim: "It is widely acknowledged that repair restrictions may potentially impact consumers."

- "It is worth noting that..."
- "It should be noted that..."
- "One could argue that..."
- "While X, Y remains..."
- "Though precise thresholds can vary depending on..."
- "It is widely acknowledged that..."
- **Epistemic modals**: may, might, could, potentially
- **Cognitive verbs**: I think, I believe, it seems, it appears
- **Adverbs of limitation**: probably, generally, usually, arguably, likely
- **Explicit uncertainty markers**: unclear, remains to be seen, further research is needed

### Semantic coherence

Generic prose often combines familiar collocations without preserving the relationship between their concepts. This is a stronger quality signal than any pet word because it tests meaning rather than surface style. Signals:

- Verb and object do not form an intelligible action: `point a toolkit at a problem`.
- One metaphor assigns incompatible positions: `overarching pillars that undergird` places the same support above and below.
- Adjacent metaphors use one verb in incompatible senses: `empty containers, a blank slate to be filled` conflates filling a vessel with writing on a surface.
- Abstract nouns and vivid verbs sound plausible but do not name a mechanism.

Examples:

| Weak | Direct |
|---|---|
| Two overarching pillars undergird the framework. | Two principles support the framework. |
| Point the toolkit at the problem and see what it buys you. | Apply the methods to the problem and compare the results. |

## Model-family specific tells

Different AI model families produce distinct stylistic fingerprints based on their training and RLHF tuning.

### GPT-4o / GPT-4.5 (OpenAI)

- Heavy use of bullet-point formatting and structured lists
- Staccato short-sentence contrasting: "It's not X. It's Y." used to simulate punchy copy
- Rhetorical colon abuse: "Here's the thing:", "Think about it:", "The bottom line:", "The reality:"
- Over-structures arguments into numbered steps

### Claude 3.5 / Claude 4 (Anthropic)

- Better sentence length variation than GPT, but still exhibits flat segmental entropy
- Overly polite and conciliatory transitions: "It's worth considering that", "To be fair", "That said"
- Leans toward poetic and metaphorical prose with words like "nuanced," "complexities"
- Loses thread in long documents and resorts to increasingly generic transitions
- Tends toward diplomatic hedging even when stating documented facts

### Common across all models

- Uniform paragraph lengths
- Predictable section ordering (Background > Details > Impact > Response)
- Citation clustering at paragraph ends rather than distributed throughout sentences
- Excessive boldface on concepts, product names, and inline headers

### Hallucinated markup artifacts

Some tools leak internal citation placeholders into generated text.

| Artifact | Origin |
|----------|--------|
| `oaicite` | OpenAI ChatGPT citation placeholder |
| `contentReference` | OpenAI internal reference tag |
| `grok_card` | xAI Grok citation tag |
| `attributableIndex` | AI attribution tracking artifact |
| `turn0search0` | ChatGPT search result placeholder |

## AI writing mitigation

### Overused verbs

| Avoid | Use Instead |
|-------|-------------|
| delve (into) | explore, examine, investigate, look at |
| leverage | use, apply, draw on |
| optimise | improve, refine, enhance |
| utilise | use |
| facilitate | help, enable, support |
| foster | encourage, support, develop, nurture |
| bolster | strengthen, support, reinforce |
| underscore | emphasise, highlight, stress |
| unveil | reveal, show, introduce, present |
| navigate | manage, handle, work through |
| streamline | simplify, make more efficient |
| enhance | improve, strengthen |
| endeavour | try, attempt, effort |
| ascertain | find out, determine, establish |
| elucidate | explain, clarify, make clear |

### Overused adjectives

| Avoid | Use Instead |
|-------|-------------|
| robust | strong, reliable, thorough, solid |
| comprehensive | complete, thorough, full, detailed |
| pivotal | key, critical, central, important |
| crucial | important, key, essential, critical |
| vital | important, essential, necessary |
| transformative | significant, important, major |
| cutting-edge | new, advanced, recent, modern |
| groundbreaking | new, original, significant |
| innovative | new, original, creative |
| seamless | smooth, easy, effortless |
| intricate | complex, detailed, complicated |
| nuanced | subtle, complex, detailed |
| multifaceted | complex, varied, diverse |
| holistic | complete, whole, comprehensive |

### Generic metaphorical nouns

These nouns often add false gravitas when used metaphorically. Literal uses are fine.

| Avoid (metaphorical) | Acceptable (literal) |
|-------|-------------|
| tapestry ("a tapestry of regulations") | tapestry (actual woven fabric) |
| symphony ("a symphony of features") | symphony (actual musical composition) |
| beacon ("a beacon of hope") | beacon (actual light or signal device) |
| realm ("in the realm of cybersecurity") | realm (actual kingdom or territory) |
| testament ("a testament to innovation") | testament (actual legal document, e.g., last will and testament) |

### Overused transitions and connectors

| Avoid | Use Instead |
|-------|-------------|
| furthermore | also, in addition, and |
| moreover | also, and, besides |
| notwithstanding | despite, even so, still |
| that being said | however, but, still |
| at its core | essentially, fundamentally, basically |
| to put it simply | in short, simply put |
| it is worth noting that | note that, importantly |
| in the realm of | in, within, regarding |
| in the landscape of | in, within |
| in today's [anything] | currently, now, today |

### Heading anti-patterns

Narrative, dramatic, or clickbait headings can read like thriller chapter titles while hiding the section's subject. Headings must describe their content directly. A good heading reads like an entry in a technical manual index: specific, descriptive, and boring to non-specialists.

| Bad Example (pattern) | Good Replacement |
|------------------------|-------------------|
| "The Initialization Trap" ("The [Concept] Trap") | "Import vs. Initialize: DDF Metadata Destruction Risk" |
| "The Hidden Danger" ("The [Adjective] [Noun]" drama) | "Firmware Corruption After Sudden Power Loss" |
| "The Silent Killer" ("The [Noun] [Dramatic Noun]") | "Gradual Bad Sector Growth on Aging Platters" |
| "Why Rebuilding Destroys Everything" ("Why [Action] [Dramatic Verb] [Object]") | "How Forced Rebuilds Overwrite Parity on Degraded Arrays" |
| "Encryption: The Hidden Trap" ("[Noun]: The [Adjective] [Noun]") | "Hardware AES-256 Encryption on WD Passport Bridge Boards" |
| "The Risk You Overlook" ("The [Noun] You [Emotion Verb]") | "Unmonitored SMART Threshold Warnings" |

### Inflated academic phrasing

| Avoid | Use Instead |
|-------|-------------|
| shed light on | clarify, explain, reveal |
| pave the way for | enable, allow, make possible |
| a myriad of | many, numerous, various |
| a plethora of | many, numerous, several |
| paramount | very important, essential, critical |
| pertaining to | about, regarding, concerning |
| prior to | before |
| subsequent to | after |
| in light of | because of, given, considering |
| with respect to | about, regarding, for |
| in terms of | regarding, for, about |
| the fact that | that (or rewrite sentence) |
