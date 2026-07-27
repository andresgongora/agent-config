---
# Subagent frontmatter — opencode-native map style.
# All fields below are required unless marked optional.

description: >
  <!-- Routing truth. First sentence: exact task this subagent performs.
       Second: when to choose THIS agent over alternatives.
       Third (optional): explicit non-uses. Optimize for correct delegation,
       not brevity. The routing agent reads this verbatim.
       Example: "Read-only code locator. Returns file:line table for where X
       is defined, what calls Y, list all uses of Z. Refuses to suggest fixes." -->

mode: subagent

model: <!-- provider/model-id — pin explicitly. Tier guide:
  cheap (e.g. anthropic/claude-haiku-4-5):  locators, reviewers, narrow structured work
  balanced (e.g. anthropic/claude-sonnet-4-5): general execution
  strong (e.g. anthropic/claude-opus-4-5):  hard reasoning, planning — justify the cost -->

temperature: <!-- 0.1–0.3 for exact bounded output; 0.5–0.7 when useful diversity > variance -->

tools:
  # Default-deny. Enable only what the subagent truly needs.
  read: false    # set true for file reads
  write: false   # set true only if subagent must persist output
  edit: false    # set true only if subagent edits existing files
  bash: false    # set true + narrow allowlist below if shell needed
  glob: false    # set true for file pattern search
  grep: false    # set true for content search
  webfetch: false
  websearch: false
  task: false    # set true ONLY if subagent must spawn further subagents (rare)

permission:
  edit: deny    # tighten to specific paths if write/edit enabled above
  bash:
    "*": deny
    # Add narrow allowlist entries:
    # "git log --oneline*": allow
    # "npm test*": allow
  task:
    # Only if task: true above. Allowlist specific children:
    # "<child-subagent-name>": allow
    "*": ask    # routes unknown delegation requests to root session

---

# <!-- Subagent Name -->

<!-- Body is the output contract + behavior description for the consuming agent.
     Keep short. Define:
     - What the agent does in one paragraph
     - Output shape (structured template, one-line-per-finding, prose block, etc.)
     - Any stopping / refusal conditions

     Output contract example:
       Returns a `## Findings` block: one line per result,
       format `path:line: <finding>`. Returns "None found" if empty.
       Refuses work outside locate/review scope.

     Remove this comment before shipping. -->

## Output contract

<!-- Define the exact shape this subagent returns. Structured output protects main context. -->
